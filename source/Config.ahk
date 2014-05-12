#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
FileEncoding , UTF-8
#SingleInstance, force
#NoTrayIcon


;IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CS5

G_ReadLanguage()

V_CurrentVer()
V_Trans()

gosub ConfigRead
;Gosub StringReplaceRead



; ============================================================================
; 添加控件 第一步
Gui, +LastFound +Toolwindow +AlwaysonTop
Gui, Font, S%fontsize%, %fontname%

Gui, Add, ListBox, x10 y10 w120 h450 vFChoice Choose1 gFChoicecheck, %Lang_General%|%Lang_Hotkey%|%Lang_Autosave%|%Lang_P_I%|%Lang_Other%

Gui, Add, GroupBox, x140 y10 w310 h250 vGB_General, %Lang_General%
	Gui, Add, Text, x150 y40 w200 h25 vGuiText4, %Lang_Your_language%
		gui_Language = %G_Language%||
		Loop, %A_ScriptDir%\Data\Locales\*.lng
		{
			SplitPath, A_LoopFileName, , , , A_LoopFileNameNoExt
			gui_Language .= A_LoopFileNameNoExt . "|"
		}
	Gui, Add, DropDownList, x361 y40 w80 vG_Language gLangtip, %gui_Language%
	Gui, Add, Text, x150 y70 w200 h25 vGuiText5, %Lang_Your_Photoshop_version%
	Gui, Add, DropDownList, x361 y70 w80 vPsCSver Choose%PsCSverNo% gVerChoose, %PSCSverList%
	Gui, Add, Edit, x150 y100 w211 h25 vPsPath Readonly, %PsPath%
	Gui, Add, Button, x361 y100 w80 h25 vBrowse1 gBrowse1, %Lang_Config_Browse%
	Gui, Add, Checkbox, x150 y130 w200 h25 vCheck4 %Checkd4% %psexist%, %Lang_P_I_LaunchPs%
	Gui, Add, Checkbox, x150 y160 w190 h25 vCheck2 %Checkd2%, %Lang_P_I_Hidehelptip%

;===========================

Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Hotkey, %Lang_Hotkey%
	Gui, Add, CheckBox, x150 y40 w230 h25 vCheck7 %Checkd7% gHUDToggle, %Lang_Set_hotkey_HUD_Color_Picker%
		Gui, Add, Hotkey, x400 y40 w40 h25 vHUDCP %enableHUDCP%, %HUDCP%
		Gui, Add, Checkbox, x165 y60 w60 h25 vCheck5 %Checkd5%, %Lang_Set_hotkey_Precise%
		Gui, Add, Checkbox, x225 y60 w60 h25 vCheck9 %Checkd9%, %Lang_Set_hotkey_Center%
		Gui, Add, Checkbox, x285 y60 w100 h25 vCheck12 %Checkd12%, %Lang_Set_hotkey_CPT%

	Gui, Add, CheckBox, x150 y100 w150 h25 vCheck8 %Checkd8% gFCPToggle, %Lang_Foreground_color_picker%
		Gui, Add, DropDownList, x300 y100 w100 vMapAlt Choose%MapAltmode% AltSubmit gChooseMapAltmode, ;%Lang_Set_hotkey_mapalt_1%|%Lang_Set_hotkey_mapalt_2%|%Lang_Set_hotkey_mapalt_3%
		Gui, Add, Hotkey, x400 y100 w40 h25 vFCPk %enableFCP%, %FCPk%

	Gui, Add, Checkbox, x150 y130 w240 h25 vCheck11 %Checkd11% gModifyBrushKeyToggle, %Lang_Set_hotkey_ModifyBrushKey%
		Gui, Add, Hotkey, x401 y130 w40 h25 vModifyBrushKey %enableModifyBrushKey%, %ModifyBrushKey%

	Gui, Add, Checkbox, x150 y160 w240 h25 vCheck6 %Checkd6% gQCLayerToggle, %Lang_Set_hotkey_QCLayer%
		Gui, Add, Hotkey, x401 y160 w40 h25 vQCLayer %enableQCLayer%, %QCLayer%

	Gui, Add, Checkbox, x150 y190 w240 h25 vCheck13 %Checkd13% gSHLayerToggle, %Lang_Set_hotkey_SHLayer%
		Gui, Add, Hotkey, x401 y190 w40 h25 vSHLayer %enableSHLayer%, %SHLayer%

	Gui, Add, Checkbox, x150 y220 w280 h25 vCheck1 %Checkd1%, %Lang_Set_hotkey_Undo%

;===========================
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Autosave, %Lang_Autosave%
	Gui, Add, DropDownList, x150 y40 w190 vAutosave Choose%Autosavenum% AltSubmit gAScheck, %Lang_Autosave_no%|%Lang_Autosave_tip%|%Lang_Autosave_yes%
		;Gui, Add, Text, x310 y40 w40 vGuiText1, %Lang_Autosave_Every%
		Gui, Add, Edit, x345 y40 w50 h25 vSavesleep, %Savesleep%
		Gui, Add, Text, x401 y40 w40 h25 vGuiText2, %Lang_Autosave_Min%
		Gui, Add, Text, x150 y70 w130 h25 vGuiText3, %Lang_Autosave_Optional%
		Gui, Add, Edit, x271 y70 w160 h40 vTiptext, %Tiptext%

;===========================
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_P_I, %Lang_P_I%
	Gui, Add, Checkbox, x150 y40 w190 h25 vCheck10 %Checkd10%, %Lang_P_I_DisableAltMenu%
	Gui, Add, Checkbox, x150 y70 w190 h25 vCheck3 %Checkd3%, %Lang_P_I_LockIME%
	Gui, Add, Checkbox, x150 y100 w280 h25 vCheck14 %Checkd14%, %Lang_C_TempFiles% ;Clean up temporary files
;	Gui, Add, Checkbox, x150 y100 w190 h25 vCheck14 %Checkd14%, %Lang_P_I_DisableShutdown%
;===========================
Gui, Add, GroupBox, x140 y10 w310 h250 vGB_Other, %Lang_Other%
	Gui, Add, Checkbox, x150 y40 w190 h25 vCheck15 %Checkd15%, %Lang_Other_3DsMaxSync%
;===========================
Gui, Add, GroupBox, x140 y270 w310 h250 vHelpTip, %Lang_HelpTip%
	Gui, Add, Text, x150 y290 w290 h180 vHelpTipText,%Lang_HelpTip_text%

;=============|||||||||||||||||||||||||||||||||||||||||||||||||========old
/* 
If Check2=0
{
URL = %A_scriptdir%\Data\Readme\%G_Language%.html
;Gui, +LastFound -Caption +Resize MinSize MaxSize

COM_AtlAxWinInit() ; 初始化 AtlAxWin
; 生成IE控件, 获得 Iwebborwser 对象
pweb:=COM_AtlAxGetControl(pctn:=COM_AtlAxCreateContainer(windowsid:=WinExist(),332,6,311,539,"Shell.Explorer"))
COM_Invoke(pweb, "Navigate", URL)

Gui, Add, GroupBox, x332 y5 w310 h540,
}
 */


;Gui, Add, DropDownList, x239 y10 w80 vGuilang Choose1 gLangtip, %Guilang%|%Langlist%

;Gui, Add, Text, x140 y215 w240 cred vMarktip, %Lang_Config_CS5mark%

;Gui, Add, Text, y220 

;Gui, Add, Button, x221 y460 w100 h50 gConfigSave, %Lang_Config_Save%
Gui, Add, Button, x460 y10 w100 h50 vCSave gConfigSave, %Lang_Config_Save%
Gui, Add, Button, x460 y70 w100 h30 vCCancel gGuiClose, %Lang_Config_Cancel%
;Gui, Font, Cblue Underline,
;font := "%Fontname%"
;hFont := Font(h, font)
;hLink := HLink_Add()
hGui := WinExist() +0
hFont := Font("", "s" . Fontsize . " , " . Fontname , 1)
Link1 := HLink_Add(hGui, 460, 150, 100, 20 , "OnLink", "'" . Lang_Website . "':Website")
SendMessage, 0x30, %hFont%, 1,, ahk_id %Link1% ;WM_SETFONT = 0x30
Link2 := HLink_Add(hGui, 460, 180, 100, 20 , "OnLink", "'" . Lang_Blog . "':Blog")
SendMessage, 0x30, %hFont%, 1,, ahk_id %Link2% ;WM_SETFONT = 0x30

;Gui, Add, Text, x11 y530 w100 Gf_CheckVersionButton, %Lang_Website%
;Gui, Add, Text, x121 y440 w100 GBlog, %Lang_Blog%
; Generated using SmartGUI Creator 4.0
;=============================================================


/*
Aero style start

DllCall("InvalidateRect", "uint", hGui, "uint", 0, "int", 0)

Aero style end
*/
; 添加控件 第二步
Loop 15
{
If (Check%A_Index%=1)
	GuiControl,,Check%A_Index%,1
}

If Regver>=12
{
	;GuiControl,hide,Marktip
	Gosub HUDToggle
}
else
{
	;GuiControl,show,Marktip
	;GuiControl,Text,GuiTitle,1
	GuiControl,Disable,Check5
	GuiControl,Disable,Check7
	GuiControl,Disable,Check9
	GuiControl,Disable,Check12
	GuiControl,Disable,HUDCP
}



gosub FCPToggle

gosub ModifyBrushKeyToggle

gosub QCLayerToggle

gosub SHLayerToggle

gosub AScheck

gosub 3DsMaxSyncCheck

gosub GuiHideGB

gosub VerChoose

ConfigTitle=Adobe Photoshop assistant v%f_CurrentVer%
If Regver>=12
{
	Gui, Show, AutoSize Center,%ConfigTitle%
}
else
{
	Gui, Show, AutoSize Center,%ConfigTitle% *** ***%Lang_Config_CS5mark%*** ***
}

;WinSetTitle, %ConfigTitle%


OnMessage(0x200, "WM_MOUSEMOVE")
Return

enter::
	gosub ConfigSave
	Return

AScheck:
	GuiControlGet,txt,,Autosave, Text
	If txt=%Lang_Autosave_no%
	{
	  GuiControl,Disable,Savesleep
	  ;GuiControl,Disable,GuiText1
	  GuiControl,Disable,GuiText2
	  GuiControl,Disable,GuiText3
	  GuiControl,Disable,Tiptext
	}
	Else If txt=%Lang_Autosave_tip%
	{
	  GuiControl,Enable,Savesleep
	  ;GuiControl,Enable,GuiText1
	  GuiControl,Enable,GuiText2
	  GuiControl,Enable,GuiText3
	  GuiControl,Enable,Tiptext
	}
	Else If txt=%Lang_Autosave_yes%
	{
	  GuiControl,Enable,Savesleep
	  ;GuiControl,Enable,GuiText1
	  GuiControl,Enable,GuiText2
	  GuiControl,Disable,GuiText3
	  GuiControl,Disable,Tiptext
	}
	Return

3DsMaxSyncCheck:
	Return

Browse1:
	If PsPath=NULL
		ProgramFilesDir:="A_ProgramFiles"
	else
		ProgramFilesDir:="PsDir"
	SSF:="Lang_PsDir"
	Dir := Dlg_Open(hGui, %SSF%, "Photoshop (Photoshop.exe; *.exe; *.lnk)", 1, %ProgramFilesDir%, "", "filemustexist")
	StringReplace, Dir, Dir, `n, `r`n, A
	If dir<>
		ControlSetText,Edit1,%Dir%
	Return

ModifyBrushKeyToggle:
	GuiControlGet, Check11
	If Check11=0
	{
		GuiControl,Disable,ModifyBrushKey
	}
	else If Check11=1
	{
		GuiControl,Enable,ModifyBrushKey
	}
	Return

ChooseMapAltmode:
	GuiControlGet,txt,,MapAlt, Text
	If txt=%Lang_Set_hotkey_mapalt_1%
	{
		GuiControl,Enable,FCPk
		GuiControl,Enable,Check10
		gosub FCPToggle
	}
	Else If txt=%Lang_Set_hotkey_mapalt_2%
	{
		GuiControl,Disable,FCPk
		GuiControl,Disable,Check10
	}
	Else If txt=%Lang_Set_hotkey_mapalt_3%
	{
		GuiControl,Enable,FCPk
		gosub FCPToggle
		GuiControl,Disable,Check10
	}
	Return

FCPToggle:
	GuiControlGet, Check8
	If Check8=0
	{
		GuiControl,Disable,FCPk
		;GuiControl,Disable,Check6
		GuiControl,Disable,MapAlt
	}
	else If Check8=1
	{
		GuiControl,Enable,FCPk
		;GuiControl,Enable,Check6
		GuiControl,Enable,MapAlt
		;gosub ChooseMapAltmode
	}

	GuiControlGet,txt,,MapAlt, Text
	If txt=%Lang_Set_hotkey_mapalt_2%
	{
		GuiControl,Disable,FCPk
		;GuiControl,Disable,Check6
	}
	Return

HUDToggle:
	GuiControlGet, Check7
	If Check7=0
	{
		GuiControl,Disable,HUDCP
		GuiControl,Disable,Check5
		GuiControl,Disable,Check9
		GuiControl,Disable,Check12
	}
	else If Check7=1
	{
		GuiControl,Enable,HUDCP
		GuiControl,Enable,Check5
		GuiControl,Enable,Check9
		GuiControl,Enable,Check12
	}
	Return

Langtip:
	Gui, Submit
	IniWrite, %Langlist%, %A_scriptdir%\Data\Config.ini, General, langlist
	IniWrite, %Fontsize%, %A_scriptdir%\Data\Config.ini, General, fontsize
	IniWrite, %Fontname%, %A_scriptdir%\Data\Config.ini, General, fontname
	IniWrite, %G_Language%, %A_scriptdir%\Data\Config.ini, Setting, lang
	;IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English
	;IniRead, Langtip, %A_scriptdir%\Data\Locales\%G_Language%.ini, %G_Language%, L_Langtip, opps
	;G_Language=%G_Language%
	G_ReadLanguage()
	Process,Close,Apssistant.exe
	MsgBox, 0,, %Lang_Langtip%
	If A_IsCompiled=1
		run %A_scriptdir%\Apssistant.exe
	Reload
	return

QCLayerToggle:
	GuiControlGet, Check6
	If Check6=0
	{
		GuiControl,Disable,QCLayer
		Return
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
		Return
	}
	else If Check13=1
	{
		GuiControl,Enable,SHLayer
	}
	Return
; 保存配置
; 添加控件 第三步
ConfigSave:
	Gui, Submit
	stringreplace, Tiptext, Tiptext, `n, \n, All
	stringreplace, Tiptext, Tiptext, `r, \r, All
	IniWrite, %PsPath%, %A_scriptdir%\Data\Config.ini, Setting, PsPath
	IniWrite, %PsCSver%, %A_scriptdir%\Data\Config.ini, Setting, Psver
	IniWrite, %HUDCP%, %A_scriptdir%\Data\Config.ini, Setting, hudcp
	IniWrite, %FCPk%, %A_scriptdir%\Data\Config.ini, Setting, fcp
	IniWrite, %Check1%, %A_scriptdir%\Data\Config.ini, Setting, undo
	IniWrite, %Autosave%, %A_scriptdir%\Data\Config.ini, Setting, autosave
	IniWrite, %Savesleep%, %A_scriptdir%\Data\Config.ini, Setting, savesleep
	IniWrite, %Tiptext%, %A_scriptdir%\Data\Config.ini, Setting, tiptext
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
	IniWrite, %Check12%, %A_scriptdir%\Data\Config.ini, Setting, CPThudcp
	IniWrite, %Check13%, %A_scriptdir%\Data\Config.ini, Setting, SHLayerToggle
	IniWrite, %Check14%, %A_scriptdir%\Data\Config.ini, Setting, CleanUpTempFiles
	;IniWrite, %Check14%, %A_scriptdir%\Data\Config.ini, Setting, DisableShotdown
	IniWrite, %SHLayer%, %A_scriptdir%\Data\Config.ini, Setting, SHLayer
	IniWrite, %QCLayer%, %A_scriptdir%\Data\Config.ini, Setting, QCLayer
	IniWrite, %ModifyBrushKey%, %A_scriptdir%\Data\Config.ini, Setting, ModifyBrushRadius
	IniWrite, %MapAlt%, %A_scriptdir%\Data\Config.ini, Setting, mapalt
	IniWrite, %Check15%, %A_scriptdir%\Data\Config.ini, Setting, 3DsMaxSync
	;Gui, Cancel
	;Reload
	If A_IsCompiled=1
		;Process,Close,Apssistant.exe
		run %A_scriptdir%\Apssistant.exe
	else
		run %A_scriptdir%\Config.ahk
	ExitApp
	return

; 添加控件 第四步
GuiHideGB:
	;Groupbox change
	loop 3
	{
	GuiControl,Hide,GuiText%A_Index%
	}

	GuiControl,Hide,GB_Hotkey
	GuiControl,Hide,Check7
	GuiControl,Hide,HUDCP
	GuiControl,Hide,Check5
	GuiControl,Hide,Check9
	GuiControl,Hide,Check12
	GuiControl,Hide,Check13
	GuiControl,Hide,SHLayer
	GuiControl,Hide,Check8
	GuiControl,Hide,MapAlt
	GuiControl,Hide,FCPk
	GuiControl,Hide,Check11
	GuiControl,Hide,ModifyBrushKey
	GuiControl,Hide,Check6
	GuiControl,Hide,QCLayer
	GuiControl,Hide,Check1

	GuiControl,Hide,GB_Autosave
	GuiControl,Hide,Autosave
	GuiControl,Hide,Savesleep
	GuiControl,Hide,Tiptext

	GuiControl,Hide,GB_P_I
	GuiControl,Hide,Check10
	GuiControl,Hide,Check3
	GuiControl,Hide,Check14

	GuiControl,Hide,GB_Other
	GuiControl,Hide,Check15
Return

; 添加控件 第五步
FChoicecheck:
	GuiControlGet,txt,,FChoice,

	GuiControl,Hide,GB_General
	GuiControl,Hide,PsCSver
	GuiControl,Hide,G_Language
	GuiControl,Hide,Check4
	GuiControl,Hide,Check2
	GuiControl,Hide,GuiText4
	GuiControl,Hide,GuiText5
	GuiControl,Hide,PsPath
	GuiControl,Hide,Browse1

	gosub GuiHideGB

	;msgbox,%txt%
	If txt=%Lang_General%
	{
		GuiControl,Show,GB_General
		GuiControl,Show,PsCSver
		GuiControl,Show,G_Language
		GuiControl,Show,Check4
		GuiControl,Show,Check2
		GuiControl,Show,GuiText4
		GuiControl,Show,GuiText5
		GuiControl,Show,PsPath
		GuiControl,Show,Browse1
	}
	Else If txt=%Lang_Hotkey%
	{
		GuiControl,Show,GB_Hotkey
		GuiControl,Show,Check7
		GuiControl,Show,HUDCP
		GuiControl,Show,Check5
		GuiControl,Show,Check9
		GuiControl,Show,Check8
		GuiControl,Show,Check12
		GuiControl,Show,Check13
		GuiControl,Show,SHLayer
		GuiControl,Show,MapAlt
		GuiControl,Show,FCPk
		GuiControl,Show,Check11
		GuiControl,Show,ModifyBrushKey
		GuiControl,Show,Check6
		GuiControl,Show,QCLayer
		GuiControl,Show,Check1
	}
	Else If txt=%Lang_Autosave%
	{
		GuiControl,Show,GB_Autosave
		GuiControl,Show,Autosave
		;GuiControl,Show,GuiText1
		GuiControl,Show,Savesleep
		GuiControl,Show,GuiText2
		GuiControl,Show,GuiText3
		GuiControl,Show,Tiptext
	}
	Else If txt=%Lang_P_I%
	{
		GuiControl,Show,GB_P_I
		GuiControl,Show,Check10
		GuiControl,Show,Check3
		GuiControl,Show,Check14
	}
	Else If txt=%Lang_Other%
	{
		GuiControl,Show,GB_Other
		GuiControl,Show,Check15
	}
Return

VerChoose:
	GuiControlGet,GuiGetPsver,,PsCSver, Text
	;gosub VerTrans
	V_Trans()
/* 
	While curPsver<12
	{
	WinSetTitle, %ConfigTitle% %Lang_Config_CS5mark%
	sleep 300
	WinSetTitle, %ConfigTitle%
	sleep 300
	}
 */

	If curPsver>=12
	{
		GuiControl,enable,Check4
		GuiControl,enable,Check5
		GuiControl,enable,Check7
		GuiControl,enable,Check9
		GuiControl,enable,Check11
		GuiControl,enable,Check12
		GuiControl,enable,ModifyBrushKey
		GuiControl,enable,HUDCP
		GuiControl,,MapAlt,|%Lang_Set_hotkey_mapalt_1%|%Lang_Set_hotkey_mapalt_2%|%Lang_Set_hotkey_mapalt_3%|
		GuiControl, Choose, MapAlt, |%MapAltmode%

		WinSetTitle, %ConfigTitle%
	}
	else
	{
		GuiControl,Disable,Check5
		GuiControl,Disable,Check7
		GuiControl,Disable,Check9
		GuiControl,Disable,Check12

		GuiControl,Disable,HUDCP
		GuiControl,,MapAlt,|%Lang_Set_hotkey_mapalt_1%|%Lang_Set_hotkey_mapalt_2%|
		if MapAltmode=1
			GuiControl, Choose, MapAlt, |1
		else
			GuiControl, Choose, MapAlt, |2

		WinSetTitle, %ConfigTitle% *** ***%Lang_Config_CS5mark%*** ***

		If curPsver=11
		{
			;GuiControl,show,Marktip
			GuiControl,enable,Check4		;enable
			GuiControl,enable,Check11		;enable
			GuiControl,enable,ModifyBrushKey	;enable
		}
		else
		{
			;GuiControl,show,Marktip
			GuiControl,Disable,Check4		;Disable
			GuiControl,Disable,Check11		;Disable
			GuiControl,Disable,ModifyBrushKey	;Disable
		}
	}

	Return


; ==========================================函数==========================================

OnLink(hCtrl, Text, Link){
	if Link = Website
		gosub Website
	else if Link = Blog
		gosub Blog
	else return 1
}

; 当鼠标移动到控件上，显示帮助提示
WM_MOUSEMOVE()
{
	static Lang_HT_, CurrControl, PrevControl, ; HT means Help Tip
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
		SetTimer, DisplayToolTip, 0
		PrevControl := CurrControl
		;GuiControl,,HelpTipText, %Lang_HelpTip_text% ; 关闭之前的 tooltip.
	}
	return

	DisplayToolTip:
	SetTimer, DisplayToolTip, Off
	GuiControl,,HelpTipText, % Lang_HT_%CurrControl% ; 第一个百分号表示后面是一个表达式
	;SetTimer, RemoveToolTip, 9999999
	return
/* 
	RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	GuiControl,,HelpTipText,
	return
 */
}


/* 
GUI_init() ; 生成窗口，并返回:pctn pweb pwin windowsid
{
	global pctn, pweb, pwin, windowsid
	GUi, +LastFound +Resize ; 创建 GUI
	COM_AtlAxWinInit() ; 初始化 AtlAxWin
	; 生成IE控件, 获得 Iwebborwser 对象
	pweb:=COM_AtlAxGetControl(pctn:=COM_AtlAxCreateContainer(windowsid:=WinExist(),0,0,555,400,"Shell.Explorer"))
	; 获得 IHTMLWindow2 对象
	IID_IHTMLWindow2 := "{332C4427-26CB-11D0-B483-00C04FD90119}" 
	pwin := COM_QueryService(pweb,IID_IHTMLWindow2,IID_IHTMLWindow2)
	COM_Invoke(pweb, "Navigate", "about:blank") ; 跳转到 空白页
	gui,show, w555 h400, %biaoti% ; 显示 GUI
}
 */
#include %A_scriptdir%\inc\Font.ahk
#include %A_scriptdir%\inc\HLink.ahk
#include %A_scriptdir%\inc\Handle.ahk
