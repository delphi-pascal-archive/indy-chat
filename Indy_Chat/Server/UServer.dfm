object Form1: TForm1
  Left = 229
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MCampos Messenger Server'
  ClientHeight = 509
  ClientWidth = 704
  Color = clBtnFace
  Constraints.MinHeight = 375
  Constraints.MinWidth = 544
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC8888CCCCCCC0000CCCC00000000CCCC8888CCCCCCCC
    C0000CCCCCCCCCCCCCC8888CCCCC0CCCCC0000CCCCCCCCCCCC8888CCCCC800CC
    C00CCCC0000000000CCCC88CCC88000C0000CCCC00000000CCCC8888C8880000
    00000CCCC000000CCCC888888888C000C00000CCCC0000CCCC88888C888CCC00
    CC00000CCCCCCCCCC88888CC88CCCCC0CCC000CCCCC00CCCCC888CCC8CCCCCCC
    CCCC0CCCCCCCCCCCCCC8CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC8CCC80CCC
    00CCCCCCCC0CC0CCCCCCCC88CC8800CC000CCCCCC000000CCCCCC888CC8800CC
    0000CCCC00000000CCCC8888CC8800CC0000C0CCC000000CCC8C8888CC8800CC
    0000C0CCC000000CCC8C8888CC8800CC0000CCCC00000000CCCC8888CC8800CC
    000CCCCCC000000CCCCCC888CC8800CC00CCCCCCCC0CC0CCCCCCCC88CC880CCC
    0CCCCCCCCCCCCCCCCCCCCCC8CCC8CCCCCCCC0CCCCCCCCCCCCCC8CCCCCCCCCCC0
    CCC000CCCCC00CCCCC888CCC8CCCCC00CC00000CCCCCCCCCC88888CC88CCC000
    C00000CCCC0000CCCC88888C888C000000000CCCC000000CCCC888888888000C
    0000CCCC00000000CCCC8888C88800CCC00CCCC0000000000CCCC88CCC880CCC
    CC0000CCCCCCCCCCCC8888CCCCC8CCCCC0000CCCCCCCCCCCCCC8888CCCCCCCCC
    0000CCCC00000000CCCC8888CCCCCCC0000CCCC0000000000CCCC8888CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 77
    Height = 16
    Caption = 'Connections:'
    FocusControl = cmbUsuario
  end
  object Label2: TLabel
    Left = 8
    Top = 99
    Width = 92
    Height = 16
    Caption = 'Connections IP:'
    FocusControl = mmoIPs
  end
  object Label3: TLabel
    Left = 208
    Top = 99
    Width = 67
    Height = 16
    Caption = 'Messages:'
    FocusControl = Memo1
  end
  object Memo1: TMemo
    Left = 208
    Top = 120
    Width = 489
    Height = 481
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 490
    Width = 704
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object cmbUsuario: TComboBox
    Left = 8
    Top = 64
    Width = 193
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 0
    OnChange = cmbUsuarioChange
  end
  object lbEdtMsg: TLabeledEdit
    Left = 208
    Top = 64
    Width = 345
    Height = 24
    EditLabel.Width = 60
    EditLabel.Height = 16
    EditLabel.Caption = 'Message:'
    TabOrder = 1
    OnChange = lbEdtMsgChange
    OnKeyPress = lbEdtMsgKeyPress
  end
  object btnEnviar: TBitBtn
    Left = 560
    Top = 64
    Width = 137
    Height = 25
    Caption = 'Send message'
    Enabled = False
    TabOrder = 2
    OnClick = btnEnviarClick
  end
  object btnDerrubar: TBitBtn
    Left = 560
    Top = 14
    Width = 137
    Height = 27
    Caption = 'Disconnect'
    Enabled = False
    TabOrder = 3
    OnClick = btnDerrubarClick
  end
  object mmoIPs: TMemo
    Left = 8
    Top = 120
    Width = 193
    Height = 369
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object btnSobre: TBitBtn
    Left = 8
    Top = 8
    Width = 97
    Height = 25
    Caption = 'About ...'
    TabOrder = 7
    TabStop = False
    OnClick = btnSobreClick
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 1024
      end>
    CommandHandlers = <>
    DefaultPort = 1024
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = IdTCPServer1Connect
    OnExecute = IdTCPServer1Execute
    OnDisconnect = IdTCPServer1Disconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = IdThreadMgrDefault1
    Left = 280
    Top = 32
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 344
    Top = 32
  end
  object IdThreadMgrDefault1: TIdThreadMgrDefault
    Left = 312
    Top = 32
  end
end
