object Form1: TForm1
  Left = 217
  Top = 137
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MCampos Messenger Client'
  ClientHeight = 477
  ClientWidth = 732
  Color = clBtnFace
  Constraints.MinHeight = 270
  Constraints.MinWidth = 683
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 458
    Width = 732
    Height = 19
    Panels = <
      item
        Width = 250
      end
      item
        Width = 50
      end>
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 732
    Height = 65
    Align = alTop
    BorderStyle = bsNone
    TabOrder = 1
    object btnConecta: TBitBtn
      Left = 368
      Top = 24
      Width = 102
      Height = 25
      Caption = 'Connect'
      Enabled = False
      TabOrder = 4
      OnClick = btnConectaClick
    end
    object lbEdtServidor: TLabeledEdit
      Left = 12
      Top = 24
      Width = 129
      Height = 24
      EditLabel.Width = 43
      EditLabel.Height = 16
      EditLabel.Caption = '&Server:'
      MaxLength = 15
      TabOrder = 0
      Text = '127.0.0.1'
      OnChange = lbEdtNickChange
      OnKeyPress = lbEdtPortaKeyPress
    end
    object lbEdtPorta: TLabeledEdit
      Left = 307
      Top = 24
      Width = 52
      Height = 24
      EditLabel.Width = 27
      EditLabel.Height = 16
      EditLabel.Caption = '&Port:'
      MaxLength = 4
      TabOrder = 2
      Text = '1024'
      Visible = False
      OnChange = lbEdtNickChange
      OnKeyPress = lbEdtPortaKeyPress
    end
    object lbEdtNick: TLabeledEdit
      Left = 150
      Top = 24
      Width = 148
      Height = 24
      EditLabel.Width = 30
      EditLabel.Height = 16
      EditLabel.Caption = '&Nick:'
      MaxLength = 20
      TabOrder = 1
      OnChange = lbEdtNickChange
      OnKeyPress = lbEdtPortaKeyPress
    end
    object btnSobre: TBitBtn
      Left = 480
      Top = 24
      Width = 73
      Height = 25
      Caption = 'About ...'
      TabOrder = 3
      TabStop = False
      OnClick = btnSobreClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 65
    Width = 732
    Height = 393
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 20
      Top = 288
      Width = 47
      Height = 16
      Caption = '&Usuario'
      FocusControl = cmbUsuario
    end
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 732
      Height = 303
      TabStop = False
      Align = alTop
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object lbEdtMsg: TLabeledEdit
      Left = 8
      Top = 360
      Width = 555
      Height = 24
      EditLabel.Width = 60
      EditLabel.Height = 16
      EditLabel.Caption = '&Message:'
      TabOrder = 1
      OnChange = cmbUsuarioSelect
      OnKeyPress = lbEdtMsgKeyPress
    end
    object cmbUsuario: TComboBox
      Left = 8
      Top = 312
      Width = 182
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
      OnSelect = cmbUsuarioSelect
    end
    object cboxReservado: TCheckBox
      Left = 204
      Top = 315
      Width = 99
      Height = 21
      Caption = '&Reservado'
      TabOrder = 3
    end
    object btnEnviar: TBitBtn
      Left = 576
      Top = 360
      Width = 145
      Height = 25
      Caption = 'Send message'
      Enabled = False
      TabOrder = 4
      OnClick = btnEnviarClick
    end
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineLength = 1024
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = IdTCPClient1Disconnected
    Host = '127.0.0.1'
    OnConnected = IdTCPClient1Connected
    Port = 1024
    Left = 96
    Top = 144
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 184
    Top = 144
  end
end
