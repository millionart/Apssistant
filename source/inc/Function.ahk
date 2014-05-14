
V_CurrentVer()
{
	Global f_CurrentVer
	f_CurrentVer = 0.8.0.5
	IniWrite, %f_CurrentVer%, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver
}

V_Trans()
{
	Global Regver, PsCSver, PSCSverList,PsCSverNo,GuiGetPsver,curPsver

	PSCSverList=6|7|CS|CS2|CS3|CS4|CS5
	;GuiGetPsver=%PsCSver%
	;curPsver=%Regver%
	IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CS5
	If PsCSver<8
	{
	Regver=%PsCSver%
	}
	else If PsCSver=CS
	Regver=8
	else
	{
	stringreplace, RegCSver, PsCSver, CS,, All
	Regver:=RegCSver+7
	}
	PsCSverNo:=Regver-5

	;return
;===========================================

	If GuiGetPsver<8
	{
	curPsver=%GuiGetPsver%
	}
	else If GuiGetPsver=CS
	curPsver=8
	else
	{
	stringreplace, curPsCSver, GuiGetPsver, CS,, All
	curPsver:=curPsCSver+7
	}

;===========================================

}


/* 
; Thanks to jronrun http://www.benayn.com/ahki18n
i18n(msg_key, p0="-0", p1="-0", p2="-0", p3="-0", p4="-0", p5="-0", p6="-0", p7="-0", p8="-0", p9="-0")
{
	global _jron_locale_
	global _jron_locale_file_
	IniRead, msg, % _jron_locale_file_, % _jron_locale_, % msg_key, % msg_key
	If (msg="ERROR" OR msg="")
		Return % msg_key
	StringReplace, msg, msg, `\n, `r`n, ALL
	StringReplace, msg, msg, `\t, % A_Tab, ALL
	Loop 10
	{
	idx := A_Index - 1
	IfNotEqual, p%idx%, -0
		msg := RegExReplace(msg, "\{" . idx . "\}", p%idx%)
	}
	Return % msg
}
 */


;Language function thanks to http://www.autohotkey.net/~rexx/FolderMenu/
G_ReadLanguage()
{
	Global
	Local Name, String, LangFile
	IniRead, Fontsize, %A_scriptdir%\Data\Config.ini, General, fontsize, 9
	IniRead, Fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI
	IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English
	G_ReadLanguageDefault()
	;msgbox, %G_Language%|%G_Language%
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
	Lang_Your_language:="Your language:"
	Lang_Your_Photoshop_version:="Your Photoshop version:"
	;Lang_Autosave_Every:="Every"
	Lang_Autosave_Min:="Min."
	Lang_Autosave_no:="Disabled"
	Lang_Autosave_Optional:="Tip text (Optional)"
	Lang_Autosave_tip:="Prompt to save. Every:"
	Lang_Autosave_yes:="Autosave. Every:"
	Lang_Autosave:="Autosave"
	Lang_Blog:="Author's blog"
	Lang_Check_Update:="Check Update"
	Lang_Config_Cancel:="Cancel"
	Lang_Config_CS5mark:="Gray items only used for CS5"
	Lang_Config_Save:="Save"
	Lang_Msg_Debug:="Error: Missing coordinates, Please try the following solution:`n - Set correctly in the program you are currently using Photoshop version`n - set The system themen to the default`n  - A front window of influence, maybe need to turn it off`n - Check the Photoshop version of the file folder picture is consistently (see note)"
	Lang_Hotkey:="keyboard shortcut"
	Lang_P_I_Hidehelptip:="Disable tray notificaion"
	Lang_P_I_LaunchPs:="Double click tray / Auto launch Photoshop"
	Lang_P_I_LockIME:="Lock input method to English"
	Lang_P_I:="Interference prevention"
	Lang_P_I_DisableAltMenu:="Disable Alt menu"
	Lang_P_I_DisableShutdown:="Disable Shoutdown"
	Lang_Set_hotkey_HUD_Color_Picker:="Enhanced HUD color picker:"
	Lang_Set_hotkey_Undo:="Exchange Step Forward / Backward shortcut"
	Lang_tiptext:="It's time to save!"
	Lang_tray_LaunchPs:="Launch Photoshop"
	Lang_tray_Config:="Config"
	Lang_tray_Exit:="Exit"
	Lang_Savenow:="Save now!"
	Lang_dontsavenow:="Hide"
	Lang_Langtip:="Language has been changed now!"
	Lang_Set_hotkey_ModifyBrushKey:="Modify brush radius:"
	Lang_Set_hotkey_QCLayer:="Creat a new layer:"
	Lang_Set_hotkey_Precise:="Precise"
	Lang_Set_hotkey_Center:="Center"
	Lang_Set_hotkey_CPT:="Compatibility"
	Lang_Foreground_color_picker:="Foreground Color Picker:"
	Lang_Set_hotkey_mapalt_1:="Foreground Color Picker shortcut to"
	Lang_Set_hotkey_mapalt_2:="Foreground Color Picker map Alt"
	Lang_Set_hotkey_mapalt_3:="Foreground Color Picker map Alt to"
	Lang_Set_hotkey_SHLayer:="Show/Hide current layer"
	Lang_Tiptitle:="Tip"
	Lang_LockIMEtip:="Your input method has been locked to English by Photoshop CS5++"
	Lang_OpenGLtip:="a.Please enable Preferences>>Enable OpenGL Drawing`nb.Hold on/off space to change hue at the same time"
	Lang_Undotip:="The following LSide hotkeys have been changed to RSide:"

	lang_Error  := "Error"
	lang_CannotConnect    := "Cannot connect to the Internet."
	lang_NewVer            := "New Version!"
	lang_NewVerAvailable   := "There's a new version v%LatestVer% available.`n`nClikc Yes to Auto Update now!`n`nClick No to go to website."
	lang_NewVerNotAvailable:= "You are using the latest version v%CurrentVer%."

	Lang_PsDir:="Select Photoshop location"
	Lang_Config_Browse:= "Browse..."
	Lang_HelpTip:= "Help"
	;Lang_HelpTip_text:=""
	;Lang_HT_PsCSver:= "当前PS版本"
	Lang_HT_G_Language:= "The software interface will change to your language.`n`nLanguage files are located:`n`tData\Locales\language name.lng`nAdd or modify the language files should be sent to millionart@gmail.com"
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


/*
Aero style start
; http://www.autohotkey.com/forum/topic31236.html
WM_LBUTTONDOWN()
	{
		If A_Gui = 1
			PostMessage, 0xA1, 2 ; WM_NCLButtonDOWN
	}


WM_PAINT(wParam, lParam, msg, hwnd)
	{
		global pImage, nW, nH
		Critical 500
		If A_Gui = 1
		{
			VarSetCapacity(PaintStruct, 64)
			If !hdc := DllCall("BeginPaint", "uint", hwnd, "uint", &PaintStruct)
				Return

			VarSetCapacity(rcClient, 16, 0)          ; rcClient Structure
			DllCall("user32\GetClientRect","uint", hWnd
				,"uint",&rcClient)                       ; Get the Client Rectangle
			wStr(wClass,"WINDOW")
			FileRead, Text, %A_ScriptFullPath%
			;WSTR(wText,"This was drawn with the UxTheme API.")

			If hTheme := DllCall("uxTheme\OpenThemeData"
				, "uint", hwnd, "uint", &wClass)         ; Open Theme Data
			{
				If hdcPaint := DllCall("gdi32\CreateCompatibleDC"
					, "Uint", hdc)                        ; Create Compatible DC
				{
					cx := RECTWIDTH(rcCLient)
					cy := -RECTHEIGHT(rcClient)

					VarSetCapacity(dib, 40, 0)          ; BITMAPINFO Structure
					NumPut(40, dib,  0)                 ; size of (BITMAPINFOHEADER)
					NumPut(cx, dib,  4)                 ; biWidth
					NumPut(cy, dib,  8)                 ; biHeight
					NumPut(1,  dib,  12, "UShort")      ; biPlanes
					NumPut(32, dib,  14, "UShort")      ; BIT_Count
					NumPut(0,  dib,  16)                ; BI_RGB

					If hbm := DllCall("Gdi32\CreateDIBSection"  ; Create the DIB
						, "UInt", hdc, "UInt" , &dib, "UInt"
						, 0, "UIntP", "", "UInt" , 0, "UInt" , 0)
					{
						hbmOld := DllCall("Gdi32\SelectObject"   ; Select object into CDC
							,"UInt", hdcPaint,"UInt",hbm)

						VarSetCapacity(dttopts,  64, 0)     ; DTTOPTS Structure
						NumPut(64,      dttOpts, 0, "UInt") ; sizeof(DTTOPTS)

						NumPut(1<<11|1<<13, dttOpts, 4)
						NumPut(7, dttOpts, 52, "Int") ; DttOpts_iGlowSize

						VarSetCapacity(lgfont, 60, 0)      ; LOGFONT Structure
						If ! DllCall("uxTheme\GetThemeSysFont"        ; Get the font
							, "int", hTheme, "int", 801, "uint", &lgfont)
						{
							hFont := DllCall("CreateFontIndirect", "uint", &lgFont)
							hFontOld := DllCall("SelectObject"
								, "int", hdcPaint,  "int", hFont)
						}
						VarSetCapacity(rcPaint, 64, 0)

						DllCall("RtlMoveMemory", "uint", &rcPaint, "uint", &rcClient, "uint", 16)

						NumPut(NumGet(rcPaint, 8, "Int")+8, rcPaint, 8)
						NumPut(NumGet(rcPaint, 12, "Int")+8, rcPaint, 12)

						DllCall("uxTheme\DrawThemeTextEx"
							, "int", hTheme, "uint", hdcPaint, "int", 0
							, "int", 0,"uint", &wText, "int", -1
							, "uint", (DT_WORD_ELLIPSIS:=0x40000)|(DT_LEFT:=0x0)
							, "uint", &rcPaint, "uint", &dttOpts)
						DllCall("BitBlt","int",hdc,"int",0,"int",0   ; BitBlt the image
							,"int",cx,"int",Abs(cy),"UInt",hdcPaint,"int",0
							,"int",0,"uInt",0x00CC0020)
						DllCall("SelectObject","uint", hdcPaint,"uint",hbmOld)
						If hFontOld
						{
							DllCall("SelectObject","UInt", hdcPaint,"UInt",hFontOld)
						}
						DllCall("DeleteObject", "int" hbm)
					}
					DllCall("DeleteDC", "int", hdcPaint)
				}
				DllCall("uxTheme\CloseThemeData", "int" hTheme)
			}
			DllCall("EndPaint", "uint", hwnd, "uint", &PaintStruct)
		}
	}


WSTR(ByRef w, s)
	{
		VarSetCapacity(w, StrLen(s)*2+1)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "str", s, "int", -1, "uint", &w, "int", StrLen(s)+1)
		Return &w
	}

RECTWIDTH(ByRef rcCLient)
	{
		Return NumGet(rcClient, 8)-NumGet(rcClient, 0)  ; Right-left
	}

RECTHEIGHT(ByRef rcClient)
	{
		Return NumGet(rcClient, 12)-NumGet(rcCLient, 4) ; Bottom-top
	}

Aero style end
*/