object Fm_VersionEditor: TFm_VersionEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'simpleLauncher 6 | '#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1077#1088#1089#1080#1080' %s'
  ClientHeight = 360
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GB_VersionInfo: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 473
    Height = 137
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1074#1077#1088#1089#1080#1080
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 22
      Width = 80
      Height = 13
      Caption = #1048#1084#1103' (id) '#1074#1077#1088#1089#1080#1080':'
    end
    object Label2: TLabel
      Left = 8
      Top = 49
      Width = 102
      Height = 13
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1088#1077#1083#1080#1079#1072':'
    end
    object Label3: TLabel
      Left = 8
      Top = 76
      Width = 120
      Height = 13
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103':'
    end
    object Label4: TLabel
      Left = 8
      Top = 103
      Width = 60
      Height = 13
      Caption = #1058#1080#1087' '#1074#1077#1088#1089#1080#1080':'
    end
    object Ed_VersionID: TEdit
      Left = 150
      Top = 19
      Width = 313
      Height = 21
      TabOrder = 0
      Text = 'Ed_VersionID'
    end
    object CB_Types: TComboBox
      Left = 150
      Top = 100
      Width = 313
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'release'
      Items.Strings = (
        'release'
        'snapshot'
        'old_beta'
        'old_alpha')
    end
    object Ed_RelDate: TEdit
      Left = 150
      Top = 46
      Width = 313
      Height = 21
      TabOrder = 1
      Text = 'Ed_RelDate'
    end
    object Ed_EdDate: TEdit
      Left = 150
      Top = 73
      Width = 313
      Height = 21
      TabOrder = 2
      Text = 'Ed_EdDate'
    end
  end
  object GB_LaunchSettings: TGroupBox
    Left = 8
    Top = 151
    Width = 473
    Height = 82
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1079#1072#1087#1091#1089#1082#1072
    TabOrder = 1
    object Label17: TLabel
      Left = 8
      Top = 24
      Width = 82
      Height = 13
      Caption = #1043#1083#1072#1074#1085#1099#1081' '#1082#1083#1072#1089#1089': '
    end
    object Label18: TLabel
      Left = 8
      Top = 51
      Width = 60
      Height = 13
      Caption = #1040#1088#1075#1091#1084#1077#1085#1090#1099':'
    end
    object Ed_MainClass: TEdit
      Left = 96
      Top = 21
      Width = 367
      Height = 21
      TabOrder = 0
      Text = 'Ed_MainClass'
    end
    object Ed_Args: TEdit
      Left = 96
      Top = 48
      Width = 367
      Height = 21
      TabOrder = 1
      Text = 'Ed_Args'
    end
  end
  object GB_Compatibility: TGroupBox
    Left = 8
    Top = 239
    Width = 473
    Height = 82
    Caption = #1057#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100' '#1089' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1099#1084' '#1083#1072#1091#1085#1095#1077#1088#1086#1084
    TabOrder = 2
    object Label19: TLabel
      Left = 8
      Top = 24
      Width = 110
      Height = 13
      Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1072#1103' '#1074#1077#1088#1089#1080#1103':'
    end
    object Label20: TLabel
      Left = 8
      Top = 48
      Width = 419
      Height = 26
      Caption = 
        #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1083#1072#1091#1085#1095#1077#1088' '#1074#1077#1088#1089#1080#1080' 1.4.2 '#1080#1084#1077#1077#1090' '#1082#1086#1076#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' 14, '#1084#1086#1081' '#1083#1072#1091 +
        #1085#1095#1077#1088' '#1080#1084#1077#1077#1090' '#1082#1086#1076#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' 14. simpleLauncher '#1085#1077' '#1087#1088#1086#1074#1086#1076#1080#1090' '#1087#1088#1086#1074#1077#1088#1082#1091 +
        ' '#1085#1072' '#1089#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaptionText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Ed_LVersion: TEdit
      Left = 150
      Top = 21
      Width = 313
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NumbersOnly = True
      ParentFont = False
      TabOrder = 0
    end
  end
  object Bt_Cancel: TButton
    Left = 8
    Top = 327
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
  end
  object Bt_OpenVersionsFolder: TButton
    Left = 221
    Top = 327
    Width = 171
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1091' '#1089' '#1074#1077#1088#1089#1080#1103#1084#1080
    TabOrder = 4
    OnClick = Bt_OpenVersionsFolderClick
  end
  object Bt_OK: TButton
    Left = 398
    Top = 327
    Width = 83
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
end
