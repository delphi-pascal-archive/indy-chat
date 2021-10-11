unit UServer;

interface

uses
  StrUtils, ShellApi, Chat_Tools, Contnrs, Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, IdBaseComponent, IdComponent, IdTCPServer,
  StdCtrls, ComCtrls, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  ExtCtrls, Buttons, Jpeg;

type
  {ponteiro para o registro que armazena as informa��es dos clientes.
  Com este ponteiro � feita a aloca��o din�mica dos dados dos clientes
  conectados. Quando um cliente disconecta, as informa��es dele
  que estavam sendo guardadas s�o liberadas dinamicamente da mem�ria.}
  PConexao = ^TConexao;
  TConexao = record
    IP: ShortString;
    ThreadID: Cardinal;
    Connection: TidTCPServerConnection;
    Usuario: ShortString;
  end;

  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    IdAntiFreeze1: TIdAntiFreeze;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    Label1: TLabel;
    cmbUsuario: TComboBox;
    lbEdtMsg: TLabeledEdit;
    btnEnviar: TBitBtn;
    btnDerrubar: TBitBtn;
    mmoIPs: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    btnSobre: TBitBtn;
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure IdTCPServer1Disconnect(AThread: TIdPeerThread);
    procedure btnDerrubarClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure lbEdtMsgChange(Sender: TObject);
    procedure cmbUsuarioChange(Sender: TObject);
    procedure btnSobreClick(Sender: TObject);
    procedure lbEdtMsgKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    cmd: TStrings;
    xUniqueUser: Boolean;
    procedure ShowConnections;
    procedure ListUsers;
    procedure ListIPs;
    procedure SendMsg;
    procedure UsuarioEntrou;
    procedure SendMsgToAll(msg: String);
    {fun��o para verificar se o nome de usu�rio que o cliente escolheu
     n�o existe na sala de chat}
    function UniqueUser(User: ShortString): Boolean;
    function IndexOfUserConnection(User: ShortString): Integer;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;
  conn: TList;

implementation

{$R *.dfm}

procedure TForm1.IdTCPServer1Connect(AThread: TIdPeerThread);
var ConAux: PConexao;
begin
 cmd.text:= AThread.Connection.ReadLn;
 if AnsiSameText(Admin,cmd.Values['nick']) then
    AThread.Connection.Writeln('nick_existente=O nick utilizado � um nick reservado ao administrador do sistema. Utilize outro nick.')
 else
 begin
   xUniqueUser := UniqueUser(cmd.Values['nick']);
   if xUniqueUser then
   begin
     AThread.Connection.Writeln('Welcome to our Chat!'+#10);
     GetMem(ConAux,SizeOf(TConexao));
     try
       ConAux.ThreadID := AThread.ThreadID;
       ConAux.Connection:= AThread.Connection;
       ConAux.IP := AThread.Connection.Socket.Binding.PeerIP;
       ConAux.Usuario := cmd.Values['nick'];

       AThread.Data := TObject(ConAux);
       conn.Add(ConAux);
       UsuarioEntrou;
     finally
       //FreeMem(ConAux);
       ShowConnections;
     end;
   end
   else AThread.Connection.Writeln('nick_existente=J� h� uma pessoa com o Nick escolhido na sala de chat');
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IdTCPServer1.Active := true;
  cmd:= TStringList.Create;
  conn:= TList.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tag:= conn.Count;
  if tag > 0 then
  begin
    action:= caNone;
    Application.MessageBox('Voc� n�o pode fechar o servidor pois existem clientes conectados','Informa��o',mb_iconInformation)
  end
  else
  begin
    cmd.Free;
    Conn.Free;

    IdTCPServer1.Active := false;
  end;
end;

procedure TForm1.IdTCPServer1Execute(AThread: TIdPeerThread);
begin
  try
    cmd.Text:= AThread.Connection.ReadLn;
    if VerificaComando(cmd.text,'msg=',true) then
    begin
       SendMsg;
       memo1.lines.add(ReceiveMsg(cmd.text));
    end;
  except
    on e: Exception do
    begin
      AThread.Connection.WriteLn('server_error='+e.message);
    end;
  end;
end;

procedure TForm1.IdTCPServer1Disconnect(AThread: TIdPeerThread);
var
  ConAux: PConexao;
  aux: string;
begin
  if xUniqueUser then
  begin
    ConAux:= PConexao(AThread.Data);
    try
      conn.Remove(ConAux);
      aux:= ConAux.Usuario + ' saiu da sala.';
      memo1.lines.add(aux);
      SendMsgToAll(aux);
      AThread.Data := nil;
    finally
      FreeMem(ConAux);
    end;
    ListUsers;
    ShowConnections;
  end
  else xUniqueUser:= true;
end;

procedure TForm1.ShowConnections;
begin
    StatusBar1.Panels[0].Text := format('Total connections: %d',[conn.count]);
end;

procedure TForm1.ListUsers;
var
  i: integer;
  aux: String;
  ConAux: PConexao;
begin
  aux:= '';
  for i:= 0 to conn.Count -1 do
  begin
     //GetMem(ConAux, SizeOf(TConexao));
     try
       ConAux:= PConexao(conn[i]);
       aux:= aux + ConAux.Usuario + ';';
     finally
       //FreeMem(ConAux);
     end;
  end;
  if aux <> '' then
     delete(aux,length(aux),1);

  cmbUsuario.Items.clear;
  cmbUsuario.Items.text:= AnsiReplaceText(aux,';',#13);
  if cmbUsuario.Items.Count > 2 then
     aux:= 'Todos;' + aux
  else if cmbUsuario.Items.Count <> 2 then
     aux:= '';


  if cmbUsuario.Items.Count > 1 then
     cmbUsuario.items.Insert(0,'Todos');
  if cmbUsuario.Items.Count > 0 then
     cmbUsuario.ItemIndex := 0;

  cmbUsuarioChange(cmbUsuario);
  SendMsgToAll('list_user=' + aux);
  ListIPs;
end;

procedure TForm1.SendMsg;
var
  i: integer;
  ConAux: PConexao;
  remetente, dest: ShortString;
begin
  //exemplo de comando de envio de msg: msg=manoel#todos#e a� galera

  //enviar msg pra todos da sala
  if not VerificaComando(cmd.text,'#reservado',true) then
     SendMsgToAll(cmd.Text)
  else
  begin
    //se a msg for reservada, ent�o envia a msg pro usu�rio de destino
    dest:= DestinatarioMsg(cmd.text);
    remetente:= RemetenteMsg(cmd.text);
    for i:= 0 to conn.Count -1 do
    begin
       ConAux:= PConexao(conn[i]);
       if (ConAux.Usuario = dest) or (ConAux.Usuario = remetente) then
          ConAux.Connection.WriteLn(cmd.Text);
       //FreeMem(ConAux);
    end;
  end;
end;

procedure TForm1.UsuarioEntrou;
var msg: string;
begin
   msg:= cmd.values['nick'] + ' entering to the chat!';
   Memo1.lines.add(msg);
   SendMsgToAll(msg);
   ListUsers;
end;

procedure TForm1.SendMsgToAll(msg: String);
var
  i: integer;
  ConAux: PConexao;
begin
    if trim(msg) = '' then
       exit;

    for i:= 0 to conn.Count -1 do
    begin
       //GetMem(ConAux, SizeOf(TConexao));
       try
         ConAux:= PConexao(conn[i]);
         ConAux.Connection.WriteLn(msg);
       finally
         //FreeMem(ConAux);
       end;
    end;
end;

function TForm1.UniqueUser(User: ShortString): Boolean;
var i: integer;
begin
  result:= true;
  for i:= 0 to conn.Count -1 do
  begin
     if PConexao(Conn[i]).Usuario = User then
     begin
       result:= false;
       break;
     end;
  end;
end;

function TForm1.IndexOfUserConnection(User: ShortString): Integer;
var i: integer;
begin
  result:= -1;
  for i:= 0 to conn.Count -1 do
  begin
    if PConexao(conn[i]).Usuario = User then
    begin
      result:= i;
      break;
    end;
  end;
end;

procedure TForm1.btnDerrubarClick(Sender: TObject);
begin
  tag:= IndexOfUserConnection(cmbUsuario.Text);
  if tag <> -1 then
  begin
     PConexao(conn[tag]).Connection.WriteLn(
        FormatChatMessage('Voc� ser� desconectado da sala pelo administrador do sistema','Administrador',cmbUsuario.Text,true));
     PConexao(conn[tag]).Connection.Disconnect;
  end
  else  Application.MessageBox('Usu�rio n�o localizado','Informa��o',mb_IconInformation);
end;

procedure TForm1.btnEnviarClick(Sender: TObject);
var msg: string;
begin
  msg:= FormatChatMessage(lbEdtMsg.Text,Admin,cmbUsuario.Text, not AnsiSameText(cmbUsuario.Text,'todos'));
  if AnsiSameText('todos',cmbUsuario.Text) then
     SendMsgToAll(msg)
  else
  begin
    tag:= IndexOfUserConnection(cmbUsuario.Text);
    if tag <> -1 then
       PConexao(conn[tag]).Connection.WriteLn(msg)
    else  Application.MessageBox('Usu�rio n�o localizado','Informa��o',mb_IconInformation);
  end;
  lbEdtMsg.SetFocus;
  lbEdtMsg.SelectAll;
end;

procedure TForm1.lbEdtMsgChange(Sender: TObject);
begin
  btnEnviar.Enabled := (trim(lbEdtMsg.Text) <> '') and (cmbUsuario.ItemIndex <> -1);
end;

procedure TForm1.cmbUsuarioChange(Sender: TObject);
begin
  lbEdtMsgChange(lbEdtMsg);
  btnDerrubar.Enabled:= (cmbUsuario.ItemIndex <> -1) and (not AnsiSameText('todos',cmbUsuario.Text));
end;

procedure TForm1.ListIPs;
var
  i: integer;
  aux: String;
  ConAux: PConexao;
begin
  aux:= '';
  for i:= 0 to conn.Count -1 do
  begin
     //GetMem(ConAux, SizeOf(TConexao));
     try
       ConAux:= PConexao(conn[i]);
       aux:= aux + 'User: ' + ConAux.Usuario + ' (IP: ' + ConAux.IP + ')' + #10#13;
     finally
       //FreeMem(ConAux);
     end;
  end;

  mmoIPs.Lines.Text := trim(aux);
end;

procedure TForm1.btnSobreClick(Sender: TObject);
begin
  Application.MessageBox(pchar('Sistema de Chat desenvolvido por Manoel Campos da Silva Filho'#13+
   'Professor da Escola T�cnica Federal de Palmas - TO'#13 +
   'E-Mail: mcampos@etfto.gov.br')
   ,'MCampos Messenger',mb_IconInformation);
end;

procedure TForm1.lbEdtMsgKeyPress(Sender: TObject; var Key: Char);
begin
  {o usu�rio n�o pode utilizar # pois este � um caracter de controle usado
  nos par�metros das mensagens enviadas e recebidas}
  if key = '#' then
     abort;
end;

end.
