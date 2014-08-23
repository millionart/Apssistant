
V_CurrentVer()
{
	Global f_CurrentVer
	f_CurrentVer = 0.8.1.0
	IniWrite, %f_CurrentVer%, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver
}

V_Trans()
{
	Global Regver, PsCSver, PSCSverList,PsCSverNo,GuiGetPsver,curPsver

	PSCSverList=6|7|CS|CS2|CS3|CS4|CS5|CS6|CC
	;GuiGetPsver=%PsCSver%
	;curPsver=%Regver%
	IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CS5
	If PsCSver<8
	{
	Regver=%PsCSver%
	}
	else If PsCSver=CS
	Regver=8
	else If PsCSver=CC
	Regver=14
	else
	{
	stringreplace, RegCSver, PsCSver, CS,, All
	Regver:=RegCSver+7
	}
	PsCSverNo:=Regver-5

	If GuiGetPsver<8
	{
	curPsver=%GuiGetPsver%
	}
	else If GuiGetPsver=CS
	curPsver=8
	else If GuiGetPsver=CC
	curPsver=14
	else
	{
	stringreplace, curPsCSver, GuiGetPsver, CS,, All
	curPsver:=curPsCSver+7
	}
}


;Language function thanks to http://www.autohotkey.net/~rexx/FolderMenu/
G_ReadLanguage()
{
	Global
	Local Name, String, LangFile
	IniRead, Fontsize, %A_scriptdir%\Data\Config.ini, General, fontsize, 9
	IniRead, Fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI
	IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English
	G_ReadLanguageDefault()
	LangFile := A_ScriptDir . "\Data\Locales\" . G_Language . ".lng"
	Loop, Read, %LangFile%
	{
		if SubStr(A_LoopReadLine, 1, 1) != ";" && A_LoopReadLine != ""
		{
			f_Split2(A_LoopReadLine, "=", Name, String)
			Name   = %Name%
			String = %String%
			StringReplace, String, String, \n, `n, All
			StringReplace, String, String, \t, % "	", All

			lang_%Name% := String

		}
	}
	return
}

G_ReadLanguageDefault()
{
	Global
	Lang_General:="General"
	Lang_Autosave_Min:="Min."
	Lang_Autosave_no:="Disabled"
	Lang_Autosave_Optional:="Tip text (Optional)"
	Lang_Autosave_tip:="Prompt to save. Every:"
	Lang_Autosave_yes:="Autosave. Every:"
	Lang_Autosave:="Autosave"
	Lang_Blog:="Author's blog"
	Lang_Website:="Website"
	Lang_Config_Cancel:="Cancel"
	Lang_Config_CS5mark:="Gray items only used for CS5"
	Lang_Config_Save:="Save"
	Lang_Config_Browse:="Browse..."
	Lang_HelpTip:="Help"
	Lang_dontsavenow:="Hide"
	Lang_ColorPicker:="Color Picker"
	Lang_Hotkey:="Hotkey"
	Lang_PsDir:="Browse to the location of Photoshop"
	Lang_Langtip:="Language has been changed now!"
	Lang_LockIMEtip:="Your input method has been locked to English by Photoshop CS5++"
	Lang_Msg_Debug:="Error: Missing coordinates, Please try the following solution:`n - Set correctly in the program you are currently using Photoshop version`n - set The system themen to the default`n  - A front window of influence, maybe need to turn it off`n - Check the Photoshop version of the file folder picture is consistently (see note)"
	Lang_OpenGLtip:="a.Please enable Preferences>>Enable OpenGL Drawing`nb.Hold on/off space to change hue at the same time"
	Lang_P_I_DisableAltMenu:="Disable Alt menu"
	Lang_P_I_Hidehelptip:="Disable tray notificaion"
	Lang_P_I_LaunchPs:="Double click tray / Auto launch Photoshop"
	Lang_P_I_LockIME:="Lock input method to English"
	Lang_P_I:="Anti-disturb"
	Lang_Other:="Other"
	Lang_Other_3dsMaxSync:="3ds Max Sync"
	Lang_C_TempFiles:="Automatically clean up temporary files after exit"
	Lang_Savenow:="Save now!"
	Lang_Set_hotkey_Center:="Center"
	Lang_Set_hotkey_CPT:="Compatibility"
	Lang_Set_hotkey_HUD_Color_Picker:="Enhanced HUD color picker:"
	Lang_Foreground_color_picker:="Foreground Color Picker:"
	Lang_Set_hotkey_mapalt_1:="shortcut to"
	Lang_Set_hotkey_mapalt_2:="map to Alt"
	Lang_Set_hotkey_mapalt_3:="map Alt to"
	Lang_Set_hotkey_ModifyBrushKey:="Modify brush radius:"
	Lang_Set_hotkey_Precise:="Precise"
	Lang_Set_hotkey_QCLayer:="Creat a new layer:"
	Lang_Set_hotkey_Undo:="Exchange Step Forward / Backward shortcuts"
	Lang_Set_hotkey_SHLayer:="Show/Hide current layer:"
	Lang_tiptext:="It's time to save!"
	Lang_Tiptitle:="Tip"
	Lang_tray_Config:="Preferences"
	Lang_tray_Exit:="Exit"
	Lang_tray_LaunchPs:="Launch Photoshop"
	Lang_Undotip:="The following LSide hotkeys have been changed to RSide:"
	Lang_Error:="Error"
	Lang_CannotConnect:="Cannot connect to the Internet."
	Lang_NewVer:="New Version!"
	Lang_NewVerAvailable :="There's a new version v%LatestVer% available.`n`nClikc Yes to Auto Update now!`n`nClick No to go to website."
	Lang_NewVerNotAvailable:="Updated successfully!"
	return
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
