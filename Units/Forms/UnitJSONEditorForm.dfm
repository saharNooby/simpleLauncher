object JSONEditorForm: TJSONEditorForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' json '#1074#1077#1088#1089#1080#1080' %s'
  ClientHeight = 474
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 449
    Height = 26
    Caption = 
      #1042#1085#1080#1084#1072#1085#1080#1077'! '#1055#1088#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1080' '#1085#1077#1082#1086#1090#1086#1088#1099#1093' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1080#1075#1088#1072' '#1084#1086#1078#1077#1090' '#1087#1077#1088#1077#1089#1090#1072#1090 +
      #1100' '#1079#1072#1087#1091#1089#1082#1072#1090#1100#1089#1103'. '#1048#1079#1084#1077#1085#1103#1081#1090#1077' '#1095#1090#1086'-'#1083#1080#1073#1086', '#1090#1086#1083#1100#1082#1086' '#1077#1089#1083#1080' '#1074#1099' '#1079#1085#1072#1077#1090#1077', '#1095#1090#1086' '#1076#1077 +
      #1083#1072#1077#1090#1077'.'
    WordWrap = True
  end
  object Memo: TMemo
    Left = 8
    Top = 40
    Width = 449
    Height = 395
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object SaveButton: TButton
    Left = 382
    Top = 441
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 1
    OnClick = SaveButtonClick
  end
  object CancelButton: TButton
    Left = 301
    Top = 441
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
