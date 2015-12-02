object LoginForm: TLoginForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'simpleLauncher 6 | '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 207
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 79
    Width = 281
    Height = 89
  end
  object Label1: TLabel
    Left = 16
    Top = 90
    Width = 86
    Height = 13
    Caption = #1051#1086#1075#1080#1085' '#1080#1083#1080' e-mail:'
  end
  object Label2: TLabel
    Left = 61
    Top = 128
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 278
    Height = 65
    Caption = 
      #1048#1089#1087#1086#1083#1100#1079#1091#1081#1090#1077' '#1101#1090#1091' '#1092#1086#1088#1084#1091', '#1077#1089#1083#1080' '#1074#1099' '#1080#1084#1077#1077#1090#1077' '#1072#1082#1082#1072#1091#1085#1090' '#1085#1072' minecraft.net (' +
      'mojang.com). '#1042#1099' '#1089#1084#1086#1078#1077#1090#1077' '#1080#1075#1088#1072#1090#1100' '#1085#1072' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1093' '#1089#1077#1088#1074#1077#1088#1072#1093' '#1089' simple' +
      'Launcher, '#1077#1089#1083#1080' '#1091' '#1074#1072#1089' '#1082#1091#1087#1083#1077#1085' Minecraft. simpleLauncher '#1085#1077' '#1089#1086#1093#1088#1072#1085#1103 +
      #1077#1090' '#1083#1086#1075#1080#1085#1099' '#1080' '#1087#1072#1088#1086#1083#1080' '#1080' '#1075#1072#1088#1072#1085#1090#1080#1088#1091#1077#1090' '#1080#1093' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100'.'
    WordWrap = True
  end
  object Login: TEdit
    Left = 108
    Top = 87
    Width = 173
    Height = 21
    TabOrder = 0
    OnChange = FieldChange
  end
  object ButtonOK: TButton
    Left = 183
    Top = 174
    Width = 106
    Height = 25
    Caption = #1040#1074#1090#1086#1088#1080#1079#1086#1074#1072#1090#1100#1089#1103
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 5
  end
  object Pass: TEdit
    Left = 108
    Top = 127
    Width = 173
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnChange = FieldChange
  end
  object LinkLabel1: TLinkLabel
    Left = 194
    Top = 109
    Width = 87
    Height = 15
    Caption = '<a>'#1063#1090#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100'?</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnLinkClick = LinkLabel1LinkClick
  end
  object LinkLabel2: TLinkLabel
    Left = 209
    Top = 150
    Width = 72
    Height = 15
    Caption = '<a>'#1047#1072#1073#1099#1083#1080' '#1087#1072#1088#1086#1083#1100'?</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnLinkClick = LinkLabel2LinkClick
  end
  object RegButton: TButton
    Left = 8
    Top = 174
    Width = 121
    Height = 25
    Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100#1089#1103
    TabOrder = 4
    OnClick = RegButtonClick
  end
end
