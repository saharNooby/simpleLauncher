object Fm_Settings: TFm_Settings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'simpleLauncher 6 | '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1083#1072#1091#1085#1095#1077#1088#1072
  ClientHeight = 283
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 228
    Width = 208
    Height = 13
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1086#1093#1088#1072#1085#1072#1102#1090#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080'.'
  end
  object PageControlMain: TPageControl
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 408
    Height = 214
    ActivePage = TabSheetMisc
    TabOrder = 0
    object TabSheetMisc: TTabSheet
      Caption = #1054#1073#1097#1077#1077
      object GroupBoxProfiles: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 394
        Height = 78
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103#1084#1080' '#1085#1072#1089#1090#1088#1086#1077#1082
        TabOrder = 0
        object Label2: TLabel
          AlignWithMargins = True
          Left = 12
          Top = 21
          Width = 49
          Height = 13
          Caption = #1055#1088#1086#1092#1080#1083#1100':'
        end
        object Label3: TLabel
          AlignWithMargins = True
          Left = 7
          Top = 48
          Width = 53
          Height = 13
          Caption = #1044#1077#1081#1089#1090#1074#1080#1103':'
        end
        object ComboBoxProfiles: TComboBox
          AlignWithMargins = True
          Left = 67
          Top = 18
          Width = 318
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnSelect = ComboBoxProfilesSelect
        end
        object ButtonPDelete: TButton
          AlignWithMargins = True
          Left = 175
          Top = 45
          Width = 102
          Height = 21
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = ButtonPDeleteClick
        end
        object ButtonPNew: TButton
          AlignWithMargins = True
          Left = 283
          Top = 45
          Width = 102
          Height = 21
          Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1092#1080#1083#1100
          TabOrder = 3
          OnClick = ButtonPNewClick
        end
        object ButtonPRename: TButton
          AlignWithMargins = True
          Left = 67
          Top = 45
          Width = 102
          Height = 21
          Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
          TabOrder = 1
          OnClick = ButtonPRenameClick
        end
      end
      object GroupBoxAdditional: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 87
        Width = 394
        Height = 96
        Caption = #1056#1072#1079#1085#1086#1077
        TabOrder = 1
        object CheckBoxDebug: TCheckBox
          Left = 7
          Top = 41
          Width = 226
          Height = 17
          Caption = 'Debug-'#1088#1077#1078#1080#1084' ('#1085#1077' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' Minecraft)'
          TabOrder = 0
          OnClick = CheckBoxDebugClick
        end
        object DisableAdsCheckBox: TCheckBox
          Left = 7
          Top = 64
          Width = 357
          Height = 17
          Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1088#1077#1082#1083#1072#1084#1099' ('#1090#1088#1077#1073#1091#1077#1090#1089#1103' '#1087#1077#1088#1077#1079#1072#1087#1091#1089#1082' '#1083#1072#1091#1085#1095#1077#1088#1072')'
          TabOrder = 1
          OnClick = DisableAdsCheckBoxClick
        end
        object CheckBoxAutoCheckUpdates: TCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 18
          Width = 296
          Height = 15
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1081' '#1083#1072#1091#1085#1095#1077#1088#1072' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '
          TabOrder = 2
          OnClick = CheckBoxAutoCheckUpdatesClick
        end
      end
    end
    object TabSheetLaunch: TTabSheet
      Caption = #1047#1072#1087#1091#1089#1082' '#1080#1075#1088#1099
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBoxValidation: TGroupBox
        Left = 3
        Top = 83
        Width = 394
        Height = 62
        Caption = #1042#1072#1083#1080#1076#1072#1094#1080#1103' Minecraft'
        TabOrder = 1
        object CheckBoxDontValidLibs: TCheckBox
          Left = 8
          Top = 16
          Width = 254
          Height = 17
          Caption = #1053#1077' '#1087#1088#1086#1074#1077#1088#1103#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1073#1080#1073#1083#1080#1086#1090#1077#1082' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
          TabOrder = 0
          OnClick = CheckBoxDontValidLibsClick
        end
        object CheckBoxDontValidAssets: TCheckBox
          Left = 8
          Top = 39
          Width = 289
          Height = 17
          Caption = #1053#1077' '#1087#1088#1086#1074#1077#1088#1103#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' assets ('#1088#1077#1089#1091#1088#1089#1086#1074') '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
          TabOrder = 1
          OnClick = CheckBoxDontValidAssetsClick
        end
      end
      object GroupBoxVisibility: TGroupBox
        Left = 3
        Top = 3
        Width = 394
        Height = 74
        Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100' '#1083#1072#1091#1085#1095#1077#1088#1072
        TabOrder = 0
        object ComboBoxVisibility: TComboBox
          Left = 8
          Top = 18
          Width = 379
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = #1047#1072#1082#1088#1099#1090#1100' '#1083#1072#1091#1085#1095#1077#1088' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1091#1089#1082#1072' '#1080#1075#1088#1099
          OnClick = ComboBoxVisibilityClick
          Items.Strings = (
            #1047#1072#1082#1088#1099#1090#1100' '#1083#1072#1091#1085#1095#1077#1088' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1091#1089#1082#1072' '#1080#1075#1088#1099
            #1054#1089#1090#1072#1074#1080#1090#1100' '#1083#1072#1091#1085#1095#1077#1088' '#1086#1090#1082#1088#1099#1090#1099#1084' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1091#1089#1082#1072' '#1080#1075#1088#1099
            #1057#1082#1088#1099#1090#1100' '#1086#1082#1085#1086' '#1083#1072#1091#1085#1095#1077#1088#1072' '#1080' '#1086#1090#1082#1088#1099#1090#1100' '#1087#1086#1089#1083#1077' '#1074#1099#1093#1086#1076#1072' '#1080#1079' '#1080#1075#1088#1099
            #1047#1072#1082#1088#1099#1090#1100' '#1083#1072#1091#1085#1095#1077#1088' '#1087#1086#1089#1083#1077' '#1074#1099#1093#1086#1076#1072' '#1080#1079' '#1080#1075#1088#1099)
        end
        object CheckBoxShowTray: TCheckBox
          Left = 8
          Top = 45
          Width = 270
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1080#1082#1086#1085#1082#1091' '#1074' '#1090#1088#1077#1077', '#1077#1089#1083#1080' '#1083#1072#1091#1085#1095#1077#1088' '#1089#1082#1088#1099#1090
          TabOrder = 1
          OnClick = CheckBoxShowTrayClick
        end
      end
    end
    object TabSheetInterface: TTabSheet
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089' '#1080' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1077
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBoxThemes: TGroupBox
        Left = 3
        Top = 3
        Width = 394
        Height = 102
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1083#1072#1091#1085#1095#1077#1088#1072
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 21
          Width = 93
          Height = 13
          Caption = #1058#1077#1084#1072' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103':'
        end
        object Label5: TLabel
          Left = 8
          Top = 71
          Width = 73
          Height = 13
          Caption = #1055#1091#1090#1100' '#1082' '#1089#1090#1080#1083#1102':'
          Enabled = False
        end
        object ButtonBrowseCustomStyle: TButton
          Left = 366
          Top = 68
          Width = 21
          Height = 21
          Caption = '...'
          Enabled = False
          TabOrder = 3
          OnClick = ButtonBrowseCustomStyleClick
        end
        object CheckBoxUseCustStyles: TCheckBox
          Left = 8
          Top = 45
          Width = 419
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1099#1081' '#1092#1072#1081#1083' '#1089#1090#1080#1083#1077#1081' (VCL styles, *.vsf)'
          TabOrder = 1
          OnClick = CheckBoxUseCustStylesClick
        end
        object ComboBoxTheme: TComboBox
          Left = 107
          Top = 18
          Width = 280
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = #1058#1105#1084#1085#1072#1103' (Carbon)'
          OnSelect = ComboBoxThemeSelect
          Items.Strings = (
            #1058#1105#1084#1085#1072#1103' (Carbon)'
            #1057#1074#1077#1090#1083#1072#1103' (Light)'
            #1057#1080#1089#1090#1077#1084#1085#1072#1103' (Windows)')
        end
        object EditCustStylePath: TEdit
          Left = 87
          Top = 68
          Width = 279
          Height = 21
          Enabled = False
          ReadOnly = True
          TabOrder = 2
          OnChange = EditCustStylePathChange
        end
      end
      object RadioGroupEditorAction: TRadioGroup
        Left = 3
        Top = 111
        Width = 394
        Height = 66
        Caption = #1044#1074#1086#1081#1085#1086#1081' '#1082#1083#1080#1082' '#1087#1086' '#1074#1077#1088#1089#1080#1080' '#1074' '#1088#1077#1076#1072#1082#1090#1086#1088#1077'...'
        Items.Strings = (
          '...'#1074#1099#1079#1086#1074#1077#1090' '#1086#1082#1085#1086' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
          '...'#1079#1072#1087#1091#1089#1090#1080#1090' '#1074#1077#1088#1089#1080#1102)
        TabOrder = 1
        OnClick = RadioGroupEditorActionClick
      end
    end
    object TabSheetStats: TTabSheet
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 28
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 3
        Top = 3
        Width = 313
        Height = 13
        Caption = #1055#1088#1080' '#1074#1099#1093#1086#1076#1077' '#1083#1072#1091#1085#1095#1077#1088' '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103':'
      end
      object Label7: TLabel
        Left = 19
        Top = 22
        Width = 90
        Height = 13
        Caption = #1042#1077#1088#1089#1080#1103' '#1083#1072#1091#1085#1095#1077#1088#1072';'
      end
      object Label8: TLabel
        Left = 19
        Top = 41
        Width = 295
        Height = 13
        Caption = #1042#1077#1088#1089#1080#1103' '#1054#1057' (Windows X (Version X.X, Build X, '#1088#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100'));'
      end
      object Label9: TLabel
        Left = 19
        Top = 60
        Width = 146
        Height = 13
        Caption = #1042#1099#1073#1088#1072#1085#1085#1072#1103' '#1074#1077#1088#1089#1080#1103' Minecraft;'
      end
      object Label10: TLabel
        Left = 19
        Top = 79
        Width = 267
        Height = 13
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1083#1080#1082#1086#1074' '#1085#1072' '#1088#1077#1082#1083#1072#1084#1091' '#1080' '#1083#1086#1075#1086#1090#1080#1087' '#1083#1072#1091#1085#1095#1077#1088#1072';'
      end
      object Label11: TLabel
        Left = 19
        Top = 98
        Width = 265
        Height = 13
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1080' '#1091#1076#1095#1072#1085#1099#1093' '#1079#1072#1087#1091#1089#1082#1086#1074' Minecraft.'
      end
      object Label12: TLabel
        Left = 3
        Top = 133
        Width = 325
        Height = 13
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1102#1090#1089#1103' '#1080' '#1089#1086#1093#1088#1072#1085#1103#1102#1090#1089#1103' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077' '#1090#1086#1083#1100#1082#1086' '#1101#1090#1080' '#1076#1072#1085#1085#1099#1077'.  '
      end
      object CheckBoxStats: TCheckBox
        Left = 3
        Top = 166
        Width = 394
        Height = 17
        Caption = #1053#1077' '#1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
        TabOrder = 0
        OnClick = CheckBoxStatsClick
      end
    end
  end
  object ButtonOpenFolder: TButton
    AlignWithMargins = True
    Left = 8
    Top = 247
    Width = 214
    Height = 28
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1091' '#1089' '#1083#1086#1075#1086#1084' '#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1084#1080
    TabOrder = 1
    OnClick = ButtonOpenFolderClick
  end
  object ButtonReset: TButton
    AlignWithMargins = True
    Left = 298
    Top = 247
    Width = 118
    Height = 28
    Caption = #1057#1073#1088#1086#1089' '#1074#1089#1077#1093' '#1085#1072#1089#1090#1088#1086#1077#1082
    TabOrder = 2
    OnClick = ButtonResetClick
  end
end
