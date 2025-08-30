﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off

SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
FileEncoding , UTF-8
#SingleInstance, force
#NoTrayIcon

G_ReadLanguage()

V_CurrentVer()
ConfigTitle=Adobe Photoshop assistant v%f_CurrentVer%

V_Trans()

gosub ConfigRead

Github:="https://github.com/millionart/Apssistant"
DeviantArt:="https://www.deviantart.com/deviation/160950828"
Gosub, SetGroupPhotoshop
; ============================================================================
; 添加控件 第一步
Gui, +Toolwindow +E0x40000 ;+LastFound +AlwaysonTop
Gui, Font, S%fontsize%, %fontname%


;						分类列表
Gui, Add, ListBox, x10 y10 w120 h450 vFChoice gFChoicecheck,
Gui Add, Link, xp y+10 wp h20, <a href="%Github%">Github</a>
Gui Add, Link, xp y+5 wp hp, <a href="%DeviantArt%">DeviantArt</a>


;						常规
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_General, %Lang_General%
	Gui, Add, Text, xp+10 yp+20 w200 h25 vGuiTextLang, %Lang_Your_language%
	Gui, Add, DropDownList, x+10 yp w80 vG_Language gLangtip Choose%LangNum%, %gui_Language%
	Gui, Add, Text, x150 y+10 w200 h25 vGuiTextPsVersion, %Lang_Your_Photoshop_version%
	Gui, Add, DropDownList, x+10 yp w80 vPsCSver Choose%PsCSverNo% gVerChoose, %PSCSverList%
	If A_OSVersion not in WIN_2000,WIN_2003,WIN_XP,WIN_VISTA,WIN_7
	{
		Gui, Add, Edit, x150 y+10 w266 h25 vPsPath Readonly, %PsPath%
		Gui, Add, Button, x+0 yp+0 w25 hp vBrowse1 gBrowse1, 🔍
	}
	Else
	{
		Gui, Add, Edit, x150 y+10 w211 h25 vPsPath Readonly, %PsPath%
		Gui, Add, Button, x361 y100 w80 hp vBrowse1 gBrowse1, %Lang_Browse%
	}
	Gui, Add, Checkbox, x150 y+10 w235 hp vCheck4, %Lang_P_I_LaunchPs%
	Gui, Add, Checkbox, xp y+10 wp hp vCheck2, %Lang_P_I_Hidehelptip%


;						拾色器
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_ColorPicker, %Lang_ColorPicker%
	Gui, Add, CheckBox, xp+10 yp+20 w230 h25 vCheck7 gHUDToggle, %Lang_Set_hotkey_HUD_Color_Picker%
		Gui, Add, Hotkey, x+10 yp w40 hp vHUDCP, %HUDCP%
		Gui, Add, Checkbox, x165 y+5 w60 hp vCheck5, %Lang_Set_hotkey_Precise%
		Gui, Add, Checkbox, x+5 yp w60 hp vCheck9, %Lang_Set_hotkey_Center%
		Gui, Add, Radio, x+10 yp w70 hp vhotkeyFastMode -Wrap Group, %Lang_hotkeyFastMode%
		Gui, Add, Radio, x+5 yp w70 hp vhotkeyStableMode -Wrap, %Lang_hotkeyStableMode%

	Gui, Add, CheckBox, x150 y+10 w15 hp vCheck8 gChooseMapAltmode,
		Gui, Add, DropDownList, xp+15 yp+3 w275 vMapAlt Choose%MapAltmode% AltSubmit gChooseMapAltmode,
		Gui, Add, Hotkey, x400 y+5 w40 h25 vFCPk, %FCPk%
		Gui, Add, Text, x167 yp+3 w230 hp vFastColorPickerCS5Tip, %Lang_fastColorPickerCS5Tip%
		Gui, Add, Text, xp y+5 w250 hp vFastColorPickerCS5Tip2, %Lang_fastColorPickerCS5Tip2%


;						快捷键
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Hotkey, %Lang_Hotkey%
	Gui, Add, Checkbox, xp+10 yp+20 w200 h25 vCheck11 gModifyBrushKeyToggle, %Lang_Set_hotkey_ModifyBrushKey%
		Gui, Add, Hotkey, x+10 yp w80 hp vModifyBrushKey, %ModifyBrushKey%

	Gui, Add, Checkbox, x150 y+5 w200 hp vCheck6 gQCLayerToggle, %Lang_Set_hotkey_QCLayer%
		Gui, Add, Hotkey, x+10 yp w80 hp vQCLayer, %QCLayer%

	Gui, Add, Checkbox, x150 y+5 w200 hp vCheck13 gSHLayerToggle, %Lang_Set_hotkey_SHLayer%
		Gui, Add, Hotkey, x+10 yp w80 hp vSHLayer, %SHLayer%

	Gui, Add, Checkbox, x150 y+5 w280 hp vCheck1, %Lang_Set_hotkey_Undo%


;						自动保存
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Autosave, %Lang_Autosave%
	Gui, Add, DropDownList, xp+10 yp+20 w100 vAutosave Choose%Autosavenum% AltSubmit gAScheck, %Lang_Disabled%|%Lang_Autosave_tip%|%Lang_Autosave_yes%
		Gui, Add, Text, xp y+10 w40 h25 vGuiText1, %Lang_Every%
		Gui, Add, Text, x+65 yp w40 hp vGuiText2 Right, %Lang_Min%
		Gui, Add, Edit, xp-55 yp-5 w50 hp vSavesleep Number Center, %Savesleep%
		Gui, Add, Text, x150 y+5 w130 hp vGuiText3, %Lang_Autosave_Optional%
		Gui, Add, Edit, xp y+0 w290 hp vTiptext Limit28, %Tiptext%


;						其他
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Other, %Lang_Other%
	Gui, Add, Checkbox, xp+10 yp+20 w280 h25 vCheck10, %Lang_P_I_DisableAltMenu%
	Gui, Add, Checkbox, xp y+5 wp hp vCheck3, %Lang_P_I_LockIME%
	Gui, Add, Checkbox, xp y+5 wp hp vCheck14, %Lang_C_TempFiles% ;Clean up temporary files
	Gui, Add, Checkbox, xp y+5 wp hp vCheck15, %Lang_Other_3dsMaxSync%


;						高级设置
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_PSUserConfig, %Lang_PSUserConfig%
	Gui, Add, Checkbox, xp+10 yp+20 w235 h25 vAllowAsyncIO, %Lang_AllowAsyncIO%
	Gui, Add, Checkbox, xp+0 y+5 wp hp vReduceUXFriction, %Lang_ReduceUXFriction%
	Gui, Add, Checkbox, xp+0 y+5 wp hp vVMCompressPages, %Lang_VMCompressPages%
	Gui, Add, Checkbox, xp+0 y+5 w200 hp vRecentFilesSlowTimeout gRecentFilesSlowTimeoutCheck, %Lang_RecentFilesSlowTimeout%
		Gui, Add, Edit, xp+240 yp+0 w50 hp vRecentFilesSlowTimeoutEdit Number Center, %RecentFilesSlowTimeout%
	Gui, Add, Checkbox, xp-240 y+5 w200 hp vFullPreviewMaxSize gFullPreviewMaxSizeCheck, %Lang_FullPreviewMaxSize%
		Gui, Add, Edit, xp+240 yp+0 w50 hp vFullPreviewMaxSizeEdit Number Center, %FullPreviewMaxSize%

	Gui, Add, Checkbox, xp-240 y180 w200 hp vOverscrollAlways gOverscrollAlwaysCheck, %Lang_OverscrollAlways%
		Gui, Add, Edit, xp+240 yp+0 w50 hp vOverscrollAlwaysEdit Number Center, %OverscrollAlways%
	Gui, Add, Checkbox, xp-240 y+5 w235 hp vuRTS, %Lang_uRTS%

	Gui, Add, Checkbox, xp+0 y180 wp hp vUseSystemStylus, %Lang_UseSystemStylus%

	Gui, Add, DropDownList, xp+0 y+5 w290 vLegacyHealingBrush161 AltSubmit, %Lang_LegacyHealingBrush160%|%Lang_LegacyHealingBrush161%|%Lang_LegacyHealingBrush162%

	Gui, Add, Text, x150 y240 w290 h25 vGuiText4 Center, %Lang_NeedRestartTip%


;						打赏
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Donate, %Lang_Donate%
	Gui, Add, Picture, xp yp+60 w150 h-1 vDonateAlipay, %A_scriptdir%\Data\Images\alipay.png
	Gui, Add, Picture, x+10 yp wp h-1 vDonateWechat, %A_scriptdir%\Data\Images\wechat.png

	Gui, Add, Picture, x170 yp w246 h-1 vDonatePaypal gDonateNow, %A_scriptdir%\Data\Images\paypal.png
	Gui Add, Button, x150 y+20 w290 h60 vDonateButton gDonateNow, %Lang_Donate%


;						提示
Gui, Add, GroupBox, x140 y270 w310 h250 vHelpTip, %Lang_HelpTip%
	Gui, Add, Text, xp+10 yp+20 wp-20 hp-25 vHelpTipText, %Lang_HelpTip_text%
	Gui, Add, Text, xp yp wp hp vDonateText, %Lang_Donate_text%

;						保存
Gui, Add, Button, x460 y10 w100 h50 vSave gConfigSave, %Lang_Save%
Gui, Add, Button, xp yp wp hp vApply gApplyPSUserConfig, %Lang_Apply%
Gui, Add, Button, xp y+10 wp h30 vCancel gGuiClose, %Lang_Cancel%
Gui, Add, Button, xp yp wp hp vReset gResetPSUserConfig, %Lang_Reset%

Gui Font

Gui Font, s20 Bold q5 c0x0080FF, %Fontname%
GuiControl, Font, DonateButton
Gui Font

Gui Font, Bold cRed, %Fontname%
GuiControl, Font, GuiText4
Gui Font

Gui Add, Picture, x460 y275 w100 h-1 vShareWeibo gShareWeibo,  %A_scriptdir%\Data\Images\Weibo.png

Gui Add, Picture, xp yp wp h-1 vShareTwitter gShareTwitter,  %A_scriptdir%\Data\Images\Twitter.png
Gui Add, Picture, xp y+5 wp h-1 vShareFacebook gShareFacebook,  %A_scriptdir%\Data\Images\Facebook.png
Gui Add, Picture, xp y+5 wp h-1 vShareReddit gShareReddit,  %A_scriptdir%\Data\Images\Reddit.png


;=============================================================
; 添加控件 第二步

If (hotkeyMode=2)
	GuiControl,,hotkeyStableMode,1
Else
	GuiControl,,hotkeyFastMode,1

Loop 15
{
If (Check%A_Index%=1)
	GuiControl,,Check%A_Index%,1
}

Gosub, ModifyBrushKeyToggle

Gosub, QCLayerToggle

Gosub, SHLayerToggle

Gosub, 3dsMaxSyncCheck

Gosub, VerChoose

Gosub, GuiHideGB

If curPsver>=12
{
	Gosub, HUDToggle
	Gui, Show, AutoSize Center,%ConfigTitle%
}
else
{
	GuiControl,Disable,Check5
	GuiControl,Disable,Check7
	GuiControl,Disable,Check9
	GuiControl,Disable,hotkeyFastMode
	GuiControl,Disable,hotkeyStableMode
	GuiControl,Disable,HUDCP
	Gui, Show, AutoSize Center,%ConfigTitle% *** ***%Lang_Config_CS5mark%*** ***
}

If curPsver>=14
	PSUserConfig=%A_AppData%\Adobe\Adobe Photoshop %psSettingsFolderName%\Adobe Photoshop %psSettingsFolderName% Settings\PSUserConfig.txt

; MsgBox, %PSUserConfig%

ReadPSUserConfig()

Gosub, AdvanceCheck

OnMessage(0x200, "WM_MOUSEMOVE")

GuiControl, Choose, FChoice, 1

Gosub, FChoicecheck
Return

OverscrollAlwaysCheck:
	AdvanceControlShowHide("OverscrollAlways")
	Return

RecentFilesSlowTimeoutCheck:
	AdvanceControlShowHide("RecentFilesSlowTimeout")
	Return

FullPreviewMaxSizeCheck:
	AdvanceControlShowHide("FullPreviewMaxSize")
	Return

AdvanceControlShowHide(controlName)
{
	global
	GuiControlGet, %controlName%

	showHide:=%controlName%=0?"Hide":"Show"
	GuiControl, %showHide%, %controlName%Edit
}

AdvanceCheckTransform:
	AllowAsyncIO:=AllowAsyncIO=1?0:1
	ReduceUXFriction:=ReduceUXFriction=1?0:1
	VMCompressPages:=VMCompressPages=1?0:1
	UseSystemStylus:=UseSystemStylus=1?0:1
Return

AdvanceCheck:
	Gosub, AdvanceCheckTransform
	
	GuiControl,,AllowAsyncIO,%AllowAsyncIO%
	GuiControl,,ReduceUXFriction,%ReduceUXFriction%
	GuiControl,,VMCompressPages,%VMCompressPages%
	GuiControl,,UseSystemStylus,%UseSystemStylus%
	GuiControl,,uRTS,%uRTS%

	AdvanceControlCheck("OverscrollAlways")
	AdvanceControlCheck("RecentFilesSlowTimeout")
	AdvanceControlCheck("FullPreviewMaxSize")
Return

AdvanceControlCheck(controlName)
{
	global
	If (%controlName%>0)
	{
		GuiControl,, %controlName%Edit, % %controlName%
		%controlName%=1
		GuiControl, Enable, %controlName%Edit
	}
	GuiControl,, %controlName%, % %controlName%

	AdvanceControlShowHide(controlName)
}

AScheck:
	GuiControlGet,txt,,Autosave, Text
	If (txt=Lang_Disabled)
	{
		GuiControl,Hide,Savesleep
		GuiControl,Hide,GuiText1
		GuiControl,Hide,GuiText2
		GuiControl,Hide,GuiText3
		GuiControl,Hide,Tiptext
	}
	Else If (txt=Lang_Autosave_tip)
	{
		GuiControl,Show,Savesleep
		GuiControl,Show,GuiText1
		GuiControl,Show,GuiText2
		GuiControl,Show,GuiText3
		GuiControl,Show,Tiptext
	}
	Else If (txt=Lang_Autosave_yes)
	{
		GuiControl,Show,Savesleep
		GuiControl,Show,GuiText1
		GuiControl,Show,GuiText2
		GuiControl,Hide,GuiText3
		GuiControl,Hide,Tiptext
	}
	Return

lockAutosaveMinTime:
	GuiControlGet, autoSaveTime,, Savesleep,
	If (autosavetime<2)
	{
		GuiControl,, Savesleep, 2
	}
Return

3dsMaxSyncCheck:
	Return

Browse1:
	GuiControlGet, psPath,, PsPath
	RegRead, psDir, HKLM, SOFTWARE\Adobe\Photoshop\%Regver%.0 , ApplicationPath

	If FileExist(psPath)
	{
		psDir:=StrReplace(psPath, "Photoshop.exe" , "")
		FileSelectFile, psPath, 1, %psDir%\Photoshop.exe, %Lang_PsDir%, Photoshop.exe
		If (psPath!="")
			GuiControl,, PsPath, %psPath%
	}
	Else If FileExist(psDir . "Photoshop.exe")
		GuiControl,, PsPath, %psDir%Photoshop.exe
	Else
	{
		FileSelectFile, psPath, 1, %A_ProgramFiles%\Photoshop.exe, %Lang_PsDir%, Photoshop.exe
		If (psPath!="")
			GuiControl,, PsPath, %psPath%
	}
	Gui, Submit, NoHide
	IniWrite, %psPath%, %A_scriptdir%\Data\Config.ini, Setting, PsPath
	Return

ModifyBrushKeyToggle:
	GuiControlGet, Check11

	If (Check11=1) && (curPsver>10)
	{
		GuiControl, Enable, ModifyBrushKey
	}
	Else
	{
		GuiControl, Disable, ModifyBrushKey
	}
	Return

ChooseMapAltmode:
	GuiControlGet, leftTag, , FChoice,
	GuiControlGet, Check8
	GuiControlGet, mapAltTxt, , MapAlt, Text

	If (Check8=1)
	{
		GuiControl, Enable, MapAlt

		If (leftTag=Lang_ColorPicker)
		{
			GuiControl, Show, FCPk
			If (mapAltTxt=Lang_hotKeyMapCS5Plus)
			{
				GuiControl, Enable, Check10
				GuiControl, Show, FastColorPickerCS5Tip
				GuiControl, Show, FastColorPickerCS5Tip2
			}

			If (mapAltTxt=Lang_Set_hotkey_mapalt_1)
			{
				GuiControl, Enable, Check10
				GuiControl, Move, MapAlt, w230
				GuiControl, Move, FCPk, y98
			}

			If (mapAltTxt=Lang_Set_hotkey_mapalt_3)
			{
				GuiControl, Disable, Check10
				GuiControl, Show, FastColorPickerCS5Tip
				GuiControl, Show, FastColorPickerCS5Tip2
			}
		}
	}
	Else
	{
		GuiControl, Hide, FCPk
		GuiControl, Disable, MapAlt
		GuiControl, Hide, FastColorPickerCS5Tip
		GuiControl, Hide, FastColorPickerCS5Tip2
	}

	If (mapAltTxt=Lang_Set_hotkey_mapalt_2)
	{
		GuiControl, Hide, FCPk
		GuiControl, Disable, Check10
		GuiControl, Hide, FastColorPickerCS5Tip
		GuiControl, Hide, FastColorPickerCS5Tip2
		GuiControl, Move, MapAlt, w275
		GuiControl, Move, FCPk, y125
	}
	Return

HUDToggle:
	GuiControlGet, Check7
	If Check7=0
	{
		GuiControl,Disable,HUDCP
		GuiControl,Disable,Check5
		GuiControl,Disable,Check9
		GuiControl,Disable,hotkeyFastMode
		GuiControl,Disable,hotkeyStableMode
	}
	else If Check7=1
	{
		GuiControl,Enable,HUDCP
		GuiControl,Enable,Check5
		GuiControl,Enable,Check9
		GuiControl,Enable,hotkeyFastMode
		GuiControl,Enable,hotkeyStableMode
	}
	Return

Langtip:
	Gui, Submit
	IniWrite, %Langlist%, %A_scriptdir%\Data\Config.ini, General, langlist
	IniWrite, %Fontsize%, %A_scriptdir%\Data\Config.ini, General, fontsize
	IniWrite, %Fontname%, %A_scriptdir%\Data\Config.ini, General, fontname
	IniWrite, %G_Language%, %A_scriptdir%\Data\Config.ini, Setting, lang
	Process,Close,Apssistant.exe
	If A_IsCompiled=1
		run %A_scriptdir%\Apssistant.exe
	Reload
	return

QCLayerToggle:
	GuiControlGet, Check6
	If Check6=0
	{
		GuiControl,Disable,QCLayer
	}
	else If Check6=1
	{
		GuiControl,Enable,QCLayer
	}
	Return

SHLayerToggle:
	GuiControlGet, Check13
	If Check13=0
	{
		GuiControl,Disable,SHLayer
	}
	else If Check13=1
	{
		GuiControl,Enable,SHLayer
	}
	Return

; 添加控件 第四步
GuiHideGB:
	loop 4
	{
	GuiControl,Hide,GuiText%A_Index%
	}

	GuiControl,Hide,GB_Hotkey
	GuiControl,Hide,Check7
	GuiControl,Hide,HUDCP
	GuiControl,Hide,Check5
	GuiControl,Hide,Check9
	GuiControl,Hide,hotkeyFastMode
	GuiControl,Hide,hotkeyStableMode
	GuiControl,Hide,Check13
	GuiControl,Hide,SHLayer
	GuiControl,Hide,Check8
	GuiControl,Hide,MapAlt
	GuiControl, Hide, FCPk
	GuiControl, Hide, FastColorPickerCS5Tip
	GuiControl, Hide, FastColorPickerCS5Tip2
	GuiControl,Hide,Check11
	GuiControl,Hide,ModifyBrushKey
	GuiControl,Hide,Check6
	GuiControl,Hide,QCLayer
	GuiControl,Hide,Check1

	GuiControl,Hide,GB_Autosave
	GuiControl,Hide,Autosave
	GuiControl,Hide,Savesleep
	GuiControl,Hide,Tiptext

	GuiControl,Hide,GB_ColorPicker
	GuiControl,Hide,Check10
	GuiControl,Hide,Check3
	GuiControl,Hide,Check14

	GuiControl,Hide,GB_Other
	GuiControl,Hide,Check15

	GuiControl, Hide, GB_PSUserConfig
	GuiControl, Hide, AllowAsyncIO
	GuiControl, Hide, ReduceUXFriction
	GuiControl, Hide, VMCompressPages
	GuiControl, Hide, LegacyHealingBrush161
	GuiControl, Hide, UseSystemStylus
	GuiControl, Hide, uRTS
	GuiControl, Hide, OverscrollAlways
	GuiControl, Hide, OverscrollAlwaysEdit
	GuiControl, Hide, RecentFilesSlowTimeout
	GuiControl, Hide, RecentFilesSlowTimeoutEdit
	GuiControl, Hide, FullPreviewMaxSize
	GuiControl, Hide, FullPreviewMaxSizeEdit

	GuiControl, Hide, Apply
	GuiControl, Hide, Reset

	GuiControl, Hide, GB_Donate
	GuiControl, Hide, DonateAlipay
	GuiControl, Hide, DonateWechat
	GuiControl, Hide, DonatePaypal
	GuiControl, Hide, DonateButton
	GuiControl, Hide, DonateText

	GuiControl, Hide, ShareWeibo
	GuiControl, Hide, ShareTwitter
	GuiControl, Hide, ShareFacebook
	GuiControl, Hide, ShareReddit
Return

; 添加控件 第五步
FChoicecheck:
	GuiControlGet,leftTag,,FChoice,

	GuiControl,Hide,GB_General
	GuiControl,Hide,PsCSver
	GuiControl,Hide,G_Language
	GuiControl,Hide,Check4
	GuiControl,Hide,Check2
	GuiControl,Hide,GuiTextLang
	GuiControl,Hide,GuiTextPsVersion
	GuiControl,Hide,PsPath
	GuiControl,Hide,Browse1

	gosub GuiHideGB

	If (leftTag=Lang_General)
	{
		GuiControl,Show,GB_General
		GuiControl,Show,PsCSver
		GuiControl,Show,G_Language
		GuiControl,Show,Check4
		GuiControl,Show,Check2
		GuiControl,Show,GuiTextLang
		GuiControl,Show,GuiTextPsVersion
		GuiControl,Show,PsPath
		GuiControl,Show,Browse1
	}

	If (leftTag=Lang_ColorPicker)
	{
		GuiControl,Show,GB_ColorPicker
		GuiControl,Show,Check7
		GuiControl,Show,HUDCP
		GuiControl,Show,Check5
		GuiControl,Show,Check9
		GuiControl,Show,Check8
		GuiControl,Show,hotkeyFastMode
		GuiControl,Show,hotkeyStableMode

		GuiControl,Show,MapAlt
		GuiControl,Show,FCPk
		Gosub, ChooseMapAltmode
	}

	If (leftTag=Lang_Hotkey)
	{
		GuiControl,Show,GB_Hotkey
		GuiControl,Show,Check11
		GuiControl,Show,ModifyBrushKey
		GuiControl,Show,Check6
		GuiControl,Show,Check13
		GuiControl,Show,SHLayer
		GuiControl,Show,QCLayer
		GuiControl,Show,Check1

		Gosub, ModifyBrushKeyToggle
	}
	
	If (leftTag=Lang_Autosave)
	{
		GuiControl,Show,GB_Autosave
		GuiControl,Show,Autosave
		gosub AScheck
	}
	Else
	Gosub, lockAutosaveMinTime

	If (leftTag=Lang_Other)
	{
		GuiControl,Show,GB_Other
		GuiControl,Show,Check10
		GuiControl,Show,Check15
		GuiControl,Show,Check3
		GuiControl,Show,Check14
	}

	If (leftTag=Lang_PSUserConfig)
	{
		GuiControlGet,GuiGetPsver,,PsCSver, Text
		V_Trans()
		ReadPSUserConfig()
		Gosub, AdvanceCheck
		GuiControl, Show, GB_PSUserConfig
		GuiControl, Show, AllowAsyncIO
		GuiControl, Show, ReduceUXFriction
		GuiControl, Show, VMCompressPages
		GuiControl, Show, RecentFilesSlowTimeout
		GuiControl, Show, FullPreviewMaxSize

		If (curPsver=14)
		{
			GuiControl, Show, OverscrollAlways

			If A_OSVersion in WIN_8
				GuiControl, Show, uRTS
		}
		Else
		{
			GuiControl, Hide, OverscrollAlways
			GuiControl, Hide, uRTS
		}

		If curPsver>14 && A_OSVersion not in WIN_2000,WIN_2003,WIN_XP,WIN_VISTA,WIN_7
			GuiControl, Show, UseSystemStylus
		Else
			GuiControl, Hide, UseSystemStylus

		If (curPsver=16)
		{
			LegacyHealingBrush161v:=LegacyHealingBrush161+1
			GuiControl, Choose, LegacyHealingBrush161, %LegacyHealingBrush161v%
			GuiControl, Show, LegacyHealingBrush161
		}
		Else
			GuiControl, Hide, LegacyHealingBrush161

		GuiControl, Hide, Save
		GuiControl, Hide, Cancel
		GuiControl, Show, Apply
		GuiControl, Show, Reset
	}
	Else
	{
		GuiControl, Show, Save
		GuiControl, Show, Cancel
		GuiControl, Hide, Apply
		GuiControl, Hide, Reset
	}

	If (leftTag=Lang_Donate)
	{
		GuiControl, Show, GB_Donate

		If (G_Language = "简体中文") || (G_Language = "繁体中文") 
		{
			GuiControl, Show, DonateAlipay
			GuiControl, Show, DonateWechat

			GuiControl, Show, ShareWeibo
		}
		else
		{
			GuiControl, Show, DonatePaypal
			GuiControl, Show, DonateButton

			GuiControl, Show, ShareTwitter
			GuiControl, Show, ShareFacebook
			GuiControl, Show, ShareReddit
		}
		GuiControl, Hide, HelpTipText
		GuiControl, Show, DonateText
	}
	Else
	{
		GuiControl, Hide, DonateText
		GuiControl, Show, HelpTipText
	}


Return

VerChoose:
	Gui, Submit, NoHide
	IniWrite, %PsCSver%, %A_scriptdir%\Data\Config.ini, Setting, Psver
	GuiControlGet,GuiGetPsver,,PsCSver, Text
	V_Trans()

	If curPsver>10
	{
		GuiControl, Enable, Check4
		GuiControl, Enable, Check11
	}
	else
	{
		GuiControl, Disable, Check4
		GuiControl, Disable, Check11
	}

	If curPsver>11
	{
		GuiControl,enable,Check5
		GuiControl,enable,Check7
		GuiControl,enable,Check9
		GuiControl,enable,hotkeyFastMode
		GuiControl,enable,hotkeyStableMode

		GuiControl,enable,HUDCP

		GuiControl, Move, MapAlt, w275
		GuiControl, Move, FCPk, y125
		GuiControl,,MapAlt,|%Lang_hotKeyMapCS5Plus%|%Lang_Set_hotkey_mapalt_2%|%Lang_Set_hotkey_mapalt_3%|

		GuiControl, Choose, MapAlt, |%MapAltmode%
		GuiControl,Hide,FastColorPickerCS5Tip
		GuiControl,Hide,FastColorPickerCS5Tip2
		WinSetTitle, %ConfigTitle%
	}
	else
	{
		GuiControl,Disable,Check5
		GuiControl,Disable,Check7
		GuiControl,Disable,Check9
		GuiControl,Disable,hotkeyFastMode
		GuiControl,Disable,hotkeyStableMode

		GuiControl,Disable,HUDCP

		GuiControl, Move, MapAlt, w230
		GuiControl, Move, FCPk, y98
		GuiControl,,MapAlt,|%Lang_Set_hotkey_mapalt_1%|%Lang_Set_hotkey_mapalt_2%|
		
		MapAltmodeNum:=MapAltmode=1?1:2
		GuiControl, Choose, MapAlt, |%MapAltmodeNum%

		WinSetTitle, %ConfigTitle% *** ***%Lang_Config_CS5mark%*** ***
	}

	If (curPsver<14)
	{
		GuiControl, Text, FChoice , |%Lang_General%||%Lang_ColorPicker%|%Lang_Hotkey%|%Lang_Autosave%|%Lang_Other%|%Lang_Donate%
	}
	Else
	{
		GuiControl, Text, FChoice , |%Lang_General%||%Lang_ColorPicker%|%Lang_Hotkey%|%Lang_Autosave%|%Lang_Other%|%Lang_PSUserConfig%|%Lang_Donate%
	}
	Return

DonateNow:
	Run, https://www.paypal.me/millionart
return

ShareTwitter:
	Run, https://twitter.com/intent/tweet?text=%Lang_shareText%&url=%DeviantArt%&hashtags=Photoshop
return

ShareFacebook:
	Run, https://www.facebook.com/sharer/sharer.php?u=%DeviantArt%
return

ShareReddit:
	Run, https://www.reddit.com/submit?url=%DeviantArt%&title=%Lang_shareText%&text=%Lang_shareText%
return

ShareWeibo:
url=%Github%/releases/latest
Lang_shareText:=StrReplace(Lang_shareText, "#", "%23")

If (G_Language = "简体中文")
	langTag=zh_cn
Else
	langTag=zh_tw

	Run, https://service.weibo.com/share/share.php?url=%url%&language=%langTag%&title=%Lang_shareText%
return

; 保存配置
; 添加控件 第三步
ConfigSave:
	Gui, Submit
	Tiptext:=StrReplace(Tiptext, "`r", "\r")
	Tiptext:=StrReplace(Tiptext, "`n", "\n")
	StringUpper, FCPk, FCPk
	Try
	{
		keyboardShortcutsFile=%A_AppData%\Adobe\Adobe Photoshop %GuiGetPsver%\Adobe Photoshop %GuiGetPsver% Settings\Keyboard Shortcuts.psp
		FCPkText := new xml(keyboardShortcutsFile)
		if FCPkText.documentElement
		{
			FCPkText.setText("//photoshop-keyboard-shortcuts/tool[@type=15]", FCPk)
			FCPkText.save(keyboardShortcutsFile)
		}
	}
	IniWrite, %HUDCP%, %A_scriptdir%\Data\Config.ini, Setting, hudcp
	IniWrite, %FCPk%, %A_scriptdir%\Data\Config.ini, Setting, fcp
	IniWrite, %Check1%, %A_scriptdir%\Data\Config.ini, Setting, undo
	IniWrite, %Autosave%, %A_scriptdir%\Data\Config.ini, Setting, autosave
	If (Savesleep<2)
		Savesleep=2
	IniWrite, %Savesleep%, %A_scriptdir%\Data\Config.ini, Setting, savesleep
	IniWrite, %Tiptext%, %A_scriptdir%\Data\Config.ini, Setting, TipText
	IniWrite, %Check2%, %A_scriptdir%\Data\Config.ini, Setting, helptip
	IniWrite, %Check3%, %A_scriptdir%\Data\Config.ini, Setting, lockIME
	IniWrite, %Check4%, %A_scriptdir%\Data\Config.ini, Setting, launchPs
	IniWrite, %Check5%, %A_scriptdir%\Data\Config.ini, Setting, Precisehudcp
	IniWrite, %Check6%, %A_scriptdir%\Data\Config.ini, Setting, enableQCLayer
	IniWrite, %Check7%, %A_scriptdir%\Data\Config.ini, Setting, enablehudcp
	IniWrite, %Check8%, %A_scriptdir%\Data\Config.ini, Setting, enablefcp
	IniWrite, %Check9%, %A_scriptdir%\Data\Config.ini, Setting, Centerhudcp
	IniWrite, %Check10%, %A_scriptdir%\Data\Config.ini, Setting, DisableAltMenu
	IniWrite, %Check11%, %A_scriptdir%\Data\Config.ini, Setting, enableModifyBrushRadius
	hotkeyMode:=hotkeyStableMode=1?2:1
	IniWrite, %hotkeyMode%, %A_scriptdir%\Data\Config.ini, Setting, hotkeyMode
	IniWrite, %Check13%, %A_scriptdir%\Data\Config.ini, Setting, SHLayerToggle
	IniWrite, %Check14%, %A_scriptdir%\Data\Config.ini, Setting, CleanUpTempFiles
	IniWrite, %SHLayer%, %A_scriptdir%\Data\Config.ini, Setting, SHLayer
	IniWrite, %QCLayer%, %A_scriptdir%\Data\Config.ini, Setting, QCLayer
	IniWrite, %ModifyBrushKey%, %A_scriptdir%\Data\Config.ini, Setting, ModifyBrushRadius
	IniWrite, %MapAlt%, %A_scriptdir%\Data\Config.ini, Setting, mapalt
	IniWrite, %Check15%, %A_scriptdir%\Data\Config.ini, Setting, 3dsMaxSync
	If A_IsCompiled
	{
		run %A_scriptdir%\Apssistant.exe
		ExitApp
	}
	Reload
	return

ApplyPSUserConfig:
	Gui, Submit, NoHide
	FileSetAttrib, -R, %PSUserConfig%
	FileDelete, %PSUserConfig%

	Gosub, AdvanceCheckTransform

	FileEncoding, UTF-8-RAW ; <--- 添加此行：临时切换到无BOM的UTF-8编码

	If (AllowAsyncIO=0)
		FileAppend, AllowAsyncIO %AllowAsyncIO%`n, %PSUserConfig%
	If (ReduceUXFriction=0)
		FileAppend, ReduceUXFriction %ReduceUXFriction%`n, %PSUserConfig%
	If (VMCompressPages=0)
		FileAppend, VMCompressPages %VMCompressPages%`n, %PSUserConfig%
	If (LegacyHealingBrush161=1) || (LegacyHealingBrush161=2)
		FileAppend, LegacyHealingBrush161 %LegacyHealingBrush161%`n, %PSUserConfig%
	If (UseSystemStylus=0)
		FileAppend, UseSystemStylus %UseSystemStylus%`n, %PSUserConfig%
	If (uRTS=1)
		FileAppend, uRTS %uRTS%`n, %PSUserConfig%
	
	If (OverscrollAlways=1) && (OverscrollAlwaysEdit>=0)
		FileAppend, OverscrollAlways %OverscrollAlwaysEdit%`n, %PSUserConfig%
	If (RecentFilesSlowTimeout=1) && (RecentFilesSlowTimeoutEdit>=0)
		FileAppend, RecentFilesSlowTimeout %RecentFilesSlowTimeoutEdit%`n, %PSUserConfig%
	If (FullPreviewMaxSize=1) && (FullPreviewMaxSizeEdit>=0)
		FileAppend, FullPreviewMaxSize %FullPreviewMaxSizeEdit%`n, %PSUserConfig%

	FileEncoding, UTF-8 ; <--- 添加此行：恢复脚本默认的编码设置
	
	If WinExist("ahk_group Photoshop")
		GuiFlash("GuiText4",3,100)
	return

ResetPSUserConfig:
	FileSetAttrib, -R, %PSUserConfig%
	FileDelete, %PSUserConfig%

	PSUserConfigDefault()
	Gosub, AdvanceCheck
	If WinExist("ahk_group Photoshop")
		GuiFlash("GuiText4",3,100)
	return

GuiFlash(String,Times,Time)
{
	GuiControlGet,vis, Visible,%String%
	If (vis=1)
		GuiControl, Show, %String%
	Loop, %Times%
	{
		Sleep, %Time%
		GuiControl, Hide, %String%
		Sleep, %Time%
		GuiControl, Show, %String%
	}
}

ReadPSUserConfig()
{
	Global
	Local Name, String
	PSUserConfigDefault()

	Loop, read, %PSUserConfig%
	{
		If (SubStr(A_LoopReadLine, 1, 1) !="#") && (A_LoopReadLine !="")
		{
			f_Split2(A_LoopReadLine,A_Space,Name,String)
			Name=%Name%
			String=%String%

			%Name%:=String
		}
	}
	return
}

PSUserConfigDefault()
{
	Global
	AllowAsyncIO:=1
	ReduceUXFriction:=1
	VMCompressPages:=1
	LegacyHealingBrush161:=0
	UseSystemStylus:=1
	uRTS:=0
	OverscrollAlways:=0
	RecentFilesSlowTimeout:=0
	FullPreviewMaxSize:=0
}

f_Split2(String, Separator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Separator)
	if SplitPos = 0
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}
; 当鼠标移动到控件上，显示帮助提示
WM_MOUSEMOVE()
{
	GuiControlGet,txt,,FChoice,
	If (txt!=Lang_Donate)
	{
		static Lang_HT_, CurrControl, PrevControl, ; HT means Help Tip
		CurrControl := A_GuiControl

		If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
		{
			Try
				GuiControl,,HelpTipText, % Lang_HT_%CurrControl% ; 第一个百分号表示后面是一个表达式
			PrevControl := CurrControl
		}
	}
	return
}

#include %A_scriptdir%\inc\Handle.ahk