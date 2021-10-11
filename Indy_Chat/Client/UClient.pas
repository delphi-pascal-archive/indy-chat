unit UClient;

interface

uses
  ShellApi, Client_Tools, Chat_Tools, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls, ExtCtrls, Buttons, IdIntercept, IdAntiFreezeBase, IdAntiFreeze, ComCtrls,
  Jpeg;

type
  TForm1 = class(TForm)
    IdTCPClient1: TIdTCPClient;
    IdAntiFreeze1: TIdAntiFreeze;
    StatusBar1: TStatusBar;
    ScrollBox2: TScrollBox;
    btnConecta: TBitBtn;
    lbEdtServidor: TLabeledEdit;
    lbEdtPorta: TLabeledEdit;
    lbEdtNick: TLabeledEdit;
    btnSobre: TBitBtn;
    Panel1: TPanel;
    Memo1: TMemo;
    lbEdtMsg: TLabeledEdit;
    Label1: TLabel;
    cmbUsuario: TComboBox;
    cboxReservado: TCheckBox;
    btnEnviar: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConectaClick(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure lbEdtPortaKeyPress(Sender: TObject; var Key: Char);
    procedure btnEnviarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbEdtNickChange(Sender: TObject);
    procedure cmbUsuarioSelect(Sender: TObject);
    procedure btnSobreClick(Sender: TObject);
    procedure lbEdtMsgKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure ShowReceiveMsg;
    procedure ListUsers;
    procedure UnknowCmd;
    procedure NickExistente;
    procedure ShowServerError;
    procedure SetCaptionAndAppTitle(Text: String);
  public
    { Public declarations }
  end;

  TClientThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
  end;

var
  Form1: TForm1;

implementation

uses Math, StrUtils;

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IdTCPClient1.Disconnect;
end;

procedure TForm1.btnConectaClick(Sender: TObject);
begin
  if IdTCPClient1.Connected then
     IdTCPClient1.Disconnect
  else
  begin
    IdTCPClient1.Host := lbEdtServidor.Text;
    IdTCPClient1.Port := StrToInt(lbEdtPorta.Text);
    IdTCPClient1.Connect(5000);
  end;
end;

procedure TForm1.IdTCPClient1Connected(Sender: TObject);
begin
  IdTCPClient1.WriteLn('nick='+lbEdtNick.Text);
  btnConecta.Caption := 'Dis&connect';
  StatusBar1.Panels[0].text:= 'Connect with server remote';
  TClientThread.Create(false);
  SetCaptionAndAppTitle('MCampos Messenger Client - ' + lbEdtNick.Text);
  Memo1.Lines.Clear;
end;

procedure TForm1.IdTCPClient1Disconnected(Sender: TObject);
begin
  SetCaptionAndAppTitle('MCampos Messenger Client');
  StatusBar1.Panels[0].text:= 'Desconnect from server';
  btnConecta.Caption := '&Connect'
end;

procedure TForm1.lbEdtPortaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
     key:= #0;
     if btnConecta.Enabled then
        btnConecta.Click;
  end;
end;

procedure TForm1.btnEnviarClick(Sender: TObject);
begin
  IdTCPClient1.WriteLn(FormatChatMessage(lbEdtMsg.Text,lbEdtNick.Text,cmbUsuario.Text,cboxReservado.Checked));
  lbEdtMsg.SetFocus;
  lbEdtMsg.SelectAll;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IdTCPClient1Disconnected(IdTCPClient1);
end;

procedure TForm1.ShowReceiveMsg;
begin
  memo1.lines.add(ReceiveMsg(cmd.text));
end;

procedure TForm1.lbEdtNickChange(Sender: TObject);
begin
  btnConecta.Enabled :=
    (trim(lbEdtServidor.Text) <> '') and
    (trim(lbEdtPorta.Text) <> '') and
    (trim(lbEdtNick.Text) <> '');
end;

procedure TForm1.cmbUsuarioSelect(Sender: TObject);
begin
  btnEnviar.Enabled := (cmbUsuario.ItemIndex <> -1) and (trim(lbEdtMsg.Text) <> '');
end;

{ TClientThread }

constructor TClientThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  Priority := tpIdle;
  FreeOnTerminate:= true;
end;

procedure TClientThread.Execute;
begin
  inherited;
  with Form1 do
  begin
    if not IdTCPClient1.Connected then
       exit;
    repeat
      cmd.text:= IdTCPClient1.ReadLn;
      if trim(cmd.text) <> '' then
      begin
        if VerificaComando(cmd.text,'msg=',true) then
           Synchronize(ShowReceiveMsg)
        else if VerificaComando(cmd.text,'list_user=',true) then
           Synchronize(ListUsers)
        else if VerificaComando(cmd.text,'nick_existente=',true) then
           Synchronize(NickExistente)
        else if VerificaComando(cmd.text,'server_error=',true) then
           Synchronize(ShowServerError)
        else Synchronize(UnknowCmd);
      end;
    until not IdTCPClient1.Connected;
  end;
  {if not Terminated then
     Terminate;}
end;

procedure TForm1.ListUsers;
begin
  cmbUsuario.Items.Text := cmd.Values['list_user'];
  cmbUsuario.Items.Text:=AnsiReplaceText(cmbUsuario.Items.Text,';',#13);
  if cmbUsuario.Items.Count > 0 then
  begin
     //deleta o nome do próprio usuário da lista para que ele não mande msg para ele mesmo
     cmbUsuario.Items.Delete(cmbUsuario.Items.IndexOf(lbEdtNick.Text));
     cmbUsuario.ItemIndex := 0;
  end;
end;

procedure TForm1.UnknowCmd;
begin
  Memo1.Lines.add(cmd.text)
end;

procedure TForm1.NickExistente;
var msg: String;
begin
  msg:= copy(cmd.text,16,length(cmd.text));
  Application.messageBox(pchar(msg),'Informação',mb_iconInformation);
  IdTCPClient1.Disconnect;
end;

procedure TForm1.ShowServerError;
var msg: String;
begin
  msg:= copy(cmd.text,14,length(cmd.text));
  memo1.lines.Add('Error num on Server: ' + msg);
end;

procedure TForm1.SetCaptionAndAppTitle(Text: String);
begin
  Caption:= Text;
  Application.Title := Caption;
end;

procedure TForm1.btnSobreClick(Sender: TObject);
begin
  Application.MessageBox(pchar('Sistema de Chat desenvolvido por Manoel Campos da Silva Filho'#13+
   'Professor da Escola Técnica Federal de Palmas - TO'#13 +
   'E-Mail: mcampos@etfto.gov.br')
   ,'MCampos Messenger',mb_IconInformation);
end;

procedure TForm1.lbEdtMsgKeyPress(Sender: TObject; var Key: Char);
begin
  {o usuário não pode utilizar # pois este é um caracter de controle usado
  nos parâmetros das mensagens enviadas e recebidas}
  if key = '#' then
     abort;
end;

end.
