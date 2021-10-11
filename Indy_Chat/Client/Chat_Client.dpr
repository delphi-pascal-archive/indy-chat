program Chat_Client;

uses
  Forms,
  UClient in 'UClient.pas' {Form1},
  Chat_Tools in '..\Chat_Tools.pas',
  Client_Tools in '..\Client_Tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
