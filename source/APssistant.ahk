#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FileEncoding , UTF-8
#SingleInstance, force
Process, Priority, , High
SetKeyDelay,-1,-1
/* 
Visit https://github.com/millionart/apssistant for more
*/

; ===================================================
V_CurrentVer()

IfExist %A_scriptdir%\Update.com
{
	FileDelete, %A_scriptdir%\Update.exe
	FileMove, %A_scriptdir%\Update.com, %A_scriptdir%\Update.exe
}

IfExist %A_scriptdir%\Config.com
{
	FileDelete, %A_scriptdir%\Config.exe
	FileMove, %A_scriptdir%\Config.com, %A_scriptdir%\Config.exe
}

If A_IsCompiled=1
{
	IfExist %A_scriptdir%\Update.exe
	Run %A_scriptdir%\Update.exe
}
else
	run %A_scriptdir%\Update.ahk

; ===================================================
DetectHiddenText, On
;DetectHiddenWindows, On
GroupAdd, Photoshop, ahk_class Photoshop
GroupAdd, Photoshop, ahk_class OWL.DocumentWindow ;CS5+画布
GroupAdd, Photoshop, ahk_class PSDocC ;CS2画布

SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79
;%VirtualWidth%
;%VirtualHeight%
; 讀取界面配置
IniRead, fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI

;IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English
;IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CS5
;IniRead, Regver, %A_scriptdir%\Data\Config.ini, General, regver, 12
;FileRead, readme, Pssistant\%G_Language%.txt
;G_Language:=%G_Language%

G_ReadLanguage()
;_jron_locale_=%G_Language%
;_jron_locale_file_=%A_scriptdir%\Data\Locales\%G_Language%.ini

; ================版本号转换

V_Trans()
;GuiGetPsver=%Regver%

; ================读取Photoshop CS4 CS5安装位置
;msgbox, %PsCSver%
;PsCSver:=Regver-7

gosub ConfigRead	; 讀取配置文件

;Gosub StringReplaceRead	; 替換特殊符號

;Lang_Set_hotkey_mapalt_1=%Lang_Set_hotkey_mapalt_1%
;Lang_Set_hotkey_mapalt_2=%Lang_Set_hotkey_mapalt_2%
;Lang_Set_hotkey_mapalt_3=%Lang_Set_hotkey_mapalt_3%
;Lang_Set_hotkey_mapalt_4=%Lang_Set_hotkey_mapalt_4%

; 托盤菜單
If A_IsCompiled=1
{
	Menu, tray, NoStandard
	Menu, tray, Tip, Adobe Photoshop assistant
}
Menu, Tray, Icon,%A_scriptdir%\Data\tray.ico,, 1
Menu, tray, add, %Lang_Website%, Website
Menu, tray, add
Menu, tray, add, %Lang_tray_LaunchPs%, LaunchPs
Menu, tray, add, %Lang_tray_Config%, Config

/* 
IfnotExist %PsDir%Photoshop.exe
{
	Menu, tray, disable, %Lang_tray_LaunchPs%
	psexist=disabled
	Checkd4=
	;Menu, tray, default, %Lang_tray_Config%
}
 */

Menu, tray, add, %Lang_tray_Exit%, WinClose

If Check4=0
	Menu, tray, default, %Lang_tray_Config%
;else If Check4<>0 and IfExist %PsPath%
else IfExist %PsPath%
{
	Menu, tray, default, %Lang_tray_LaunchPs%
	Menu, tray, Icon, %Lang_tray_LaunchPs%, %PsPath%,, 16
}
If A_IsCompiled=1
{
	Menu, tray, Icon, %Lang_Website%, %A_scriptdir%\APssistant.exe,, 16
	Menu, tray, Icon, %Lang_tray_Config%, %A_scriptdir%\Config.exe,, 16
}
else
{
	Menu, tray, Icon, %Lang_Website%, %A_scriptdir%\Data\tray.ico,, 16
	Menu, tray, Icon, %Lang_tray_Config%, %A_scriptdir%\inc\Config.ico,, 16
}
Gui, Add, Text,,


/*
Aero style start

OnMessage(0xF, "WM_PAINT")
OnMessage(0x201, "WM_LBUTTONDOWN")
Gui, +LastFound -Caption +Resize MinSize MaxSize
hWnd := WinExist()
Gui, Color, 000000

VarSetCapacity(rect, 16, 0xff) ; This is the same as setting all fields to -1.
DllCall("dwmapi\DwmExtendFrameIntoClientArea", "uint", hWnd, "uint", &rect)

Aero style end
*/


if Regver=10
{
	CoordMode, Mouse,Screen
	CoordMode, Pixel,Screen
}
else
{
	CoordMode, Mouse,Relative
	CoordMode, Pixel,Relative
}

Time:= Savesleep*60000
SetTimer, Autosave, %Time% ; 自动保存计时器

If Check3=1
SetTimer, LockIME, 2000 ; 2秒锁定一次输入法
/* 
; 撤銷快捷鍵修改提示
If Check1=1
Gosub Undotip
 */
Gosub Autosave

Hotkey, IfWinActive, ahk_group Photoshop

	If (Regver>=12) and (Check7=1)
	{
	Hotkey, %HUDCP%, HUDCP
	}

	If (Regver<12) and (Check8=1) and (MapAltmode=1)
	{
	Hotkey, %FCPk%, FCPc1
	}
/* 
	;兼容模式alt拾色器
	else If (Check8=1) and (MapAltmode=2)
	{
	Hotkey, Alt, FCPc2
	}
	;CS5模式alt拾色器
	else If (Check8=1) and (MapAltmode=3)
	{
	Hotkey, Alt, FCPc12
	}
 */
	If Check6=1
	Hotkey, %QCLayer%, QCLayer

;	If (Check10=1) and (MapAltmode=1)
;	Hotkey, Alt, DisableAltMenu

	If (Regver>=11) and (Check11=1)
	Hotkey, %ModifyBrushKey%, ModifyBrushKey
/* 
	If (Regver>=12) and (Check8=1) and (MapAltmode=2)
	Hotkey, ~alt, FCPc
 */

	If Check13=1
	Hotkey, %SHLayer%, SHLayer
Hotkey, IfWinActive

Hotkey, IfWinActive, ahk_class PSFloatC, Web
	If (Check8=1) and (MapAltmode=1)
	Hotkey, %FCPk%, FCPs
/* 
	else If (Check8=1) and (MapAltmode=2)
	{
	FCPk=Alt
	Hotkey, %FCPk%, FCPs
	}
	else If (Check8=1) and (MapAltmode=3)
	{
	Hotkey, Alt, FCPs12
	}
 */
Hotkey, IfWinActive

If Check14=1
gosub CleanUpTempFiles

If Check4=1
gosub LaunchPsAuto
Return


; ==========================================初始化完毕==========================================

; ==========================================键盘映射==========================================
#IfWinActive ahk_class PSFloatC, Web
~Alt Up::
	If (Check8=1) and (MapAltmode=2)
	{
		gosub FCPs
	}
	else If (Check8=1) and (MapAltmode=3)
	{
		gosub FCPs12

	}
return
#IfWinActive

#IfWinActive ahk_group Photoshop
~Alt::
	If (Check10=1) and (MapAltmode=1)
	{
		SendInput, {Ctrl down}{Alt down}{Ctrl up}
		KeyWait, Alt
		SendInput, {Alt up}
	}

	If (Check8=1) and (MapAltmode=2)
	{
		FCPk=Alt
		gosub FCPc2
	}
	else If (Check8=1) and (MapAltmode=3)
	{
		gosub FCPc12
	}
return

/* 
$LButton::
If ((A_PriorHotkey = A_ThisHotkey) and (A_TimeSincePriorHotkey < 200))
{
;msgbox 3 times Alt have been pressed
    times := 0
}
else

send, {LButton down}
keywait, LButton
send, {LButton up}

Return 

 */
/* 
; 鎖定輸入法按键
;~^Shift::
$^Space::
	If (Check3=1)
	{
	SetIME("00000409")
	If Check2=0
	TrayTip, %Lang_Tiptitle%, %Lang_LockIMEtip%, 1, 1
	}
	else
	{
	If instr(A_ThisHotkey, "space")
		send, ^{space}
	;If instr(A_ThisHotkey, "shift")
	;	send, ^{shift}
	}
	Return

 */
; 撤銷快捷鍵修改
;$^z::send !^z
$^z::
	If (Check1=1)
	{
		;Gosub Undotip
		;send !^z
		PostMessage, 0x111, 0x7A9,,,ahk_class Photoshop
	}
	Else
	{
		Send,^z
	}
	return

;$^y::send +^z
$^y::
	If (Check1=1)
	{
		;Gosub Undotip
		;send +^z
		PostMessage, 0x111, 0x7AA,,,ahk_class Photoshop
	}
	Else
	{
		Send,^y
	}
	return

$^s::
	PostMessage, 0x111, 30,,,ahk_class Photoshop
	If (Check15=1)
	{
	SetControlDelay -1
	ControlClick, Label1, ahk_class 3dsMax,,,,
	WinActivate, ahk_class Photoshop
	}
return
/* 
;$!^z::send ^y
$!^z::
	If (Check1=1)
	{
		Gosub Undotip
		send ^y
	}
	Else
	{
		Send,!^z
	}
	return

;$+^z::send ^z
$+^z::
	If (Check1=1)
	{
		Gosub Undotip
		send ^z
	}
	Else
	{
		Send,+^z
	}
	return
 */
#IfWInActive


Autosave:
	If WinExist("ahk_class Photoshop") and (Autosavenum=3)
		PostMessage, 0x111, 30,,,ahk_class Photoshop
		If Check15=1
		{
		SetControlDelay -1
		ControlClick, Label1, ahk_class 3dsMax,,,,
		WinActivate, ahk_class Photoshop
		}
	else If WinExist("ahk_class Photoshop") and (Autosavenum=2)
	{
		text1=%Lang_Savenow%
		text2=%Lang_dontsavenow%
		Text3=%Tiptext%
		NoticePanel(Text3,500,5000,"2t8","8t2",text1,text2)
	}
	return

ModifyBrushKey:
	send, {Alt down}{RButton down}
	keywait, %ModifyBrushKey%
	send, {Alt up}{RButton up}
	Return

SHlayer:
	PostMessage, 0x111, 0x45A,,,ahk_class Photoshop
	Return
; ==========================================普通拾色器点击
FCPc1:
;	If (MapAltmode>1) and (Regver<12)
;	{
		ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\brush.png
		if ErrorLevel=1
		{
			ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\pencil.png
			if (ErrorLevel=1) and (Regver>=9)
			{
				ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\ColorReplacement.png
				if ErrorLevel=1
					return
			}
			else if (ErrorLevel=1)
			return
		}
;	}
	Gosub FCPc2
	Return

FCPc2:
	Gosub FCPsearch
	CoordMode, Pixel,Screen
	if Regver=10
	{
		MouseGetPos, cX, cY
		MouseClick, left, %fcX%, %fcY%,,0
		MouseMove, %cX%, %cY%,0
	}
	else
	{
		ControlClick, x%fcX% y%fcY%, ahk_class Photoshop
		gosub FCPs
	}

	Return

FCPc12:
	;CoordMode, Mouse
	CoordMode, Pixel,Screen
	WinActivate, ahk_class Photoshop

	ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\brush.png
	if ErrorLevel=1
	{
		ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\pencil.png
		if ErrorLevel=1
		{
		;send, {%FCPk%}
		return
		}
	}
	send, {%FCPk%}
	gosub FCPs12
	return

FCPs:
	KeyWait, %FCPk%
	send, {enter}
	Return


FCPs12:
	KeyWait, Alt
	send, {enter}
	Return

/* 
FCPs2:
	KeyWait, alt
	IfWinActive, ahk_class PSFloatC
	send, {enter}
	Return
 */
/* 

	Gosub FCPsearch
	;ControlClick, x%fcX% y%fcY%, ahk_class Photoshop
	MouseGetPos, cX, cY
	MouseClick, left, %fcX%, %fcY%,,0
	MouseMove, %cX%, %cY%,0
	If Check6=1
	{
		IfWinActive, ahk_class PSFloatC
		KeyWait, %FCPk%

		send,{Enter}
	}
	return
 */
FCPsearch:
	If (Regver>12)
	{
	CoordMode, Pixel, Window
	PixelGetColor, PSGUIColor, 20, 33,RGB
	ImageSearch, fbcsX, fbcsY, 0, 295, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\%PSGUIColor%\fbcswitch.png
	}
	else
	ImageSearch, fbcsX, fbcsY, 0, 295, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\fbcswitch.png
	if ErrorLevel=1
	{
		WinActivate, ahk_class Photoshop
		msgbox, %Lang_Msg_Debug%
		return
	}
	fcX := fbcsX - 12
	fcY := fbcsY + 22
	return

; HUD 拾色器快捷鍵設置
HUDCP:
	Hotkey, IfWinActive, ahk_group Photoshop
		If Check2=0
			TrayTip, %Lang_Tiptitle%, %Lang_OpenGLtip%, 1, 1

		If Check9=1
		{
			centerw:=VirtualWidth/2
			centerh:=VirtualHeight/2
			MouseMove, %centerw%, %centerh%,0
		}
		;ControlSend,, {Alt down}, ahk_class Photoshop
		;ControlSend,, {Shift down}, ahk_class Photoshop
	;	send, {RButton down}
		If Check12=1
		{
			send,{Shift down}{Alt down}{RButton down}

			If check5=1
			{
				send,{Shift up}{Alt up}
				send,{space down}
				Hotkey, LButton, LButtondown1
				Hotkey, LButton, on
				KeyWait, %HUDCP%
				send,{RButton up}{space up}
				Hotkey, LButton, off
			}
			else
			{
				KeyWait, %HUDCP%
				send,{Shift up}{Alt up}{RButton up}
			}
		}
		else
		{
			BlockInput,MouseMove
			send,{Alt down}{Shift down}{RButton down}

			If Check5=1
			{
				sleep, 100
				BlockInput,MouseMoveOff
				MouseGetPos, cX, cY
				send,{space down}{Shift up}{Alt up}
				Hotkey, LButton, LButtondown0
				Hotkey, LButton, on
				KeyWait, %HUDCP%
				MouseGetPos, cX2, cY2
				BlockInput,MouseMove
				MouseMove, %cX%, %cY%,0
				sleep, 100
				send,{space up}{RButton up}
				BlockInput,MouseMoveOff
				Hotkey, LButton, off
				MouseMove, %cX2%, %cY2%,0
			}
			else
			{
				BlockInput,MouseMoveOff
				KeyWait, %HUDCP%
				send,{Shift up}{Alt up}{RButton up}
			}
		}
	Hotkey, IfWinActive
	Return

LButtondown0:
	send,{space up}
	KeyWait, LButton
	MouseGetPos, cX, cY
	send,{space down}
	Return

LButtondown1:
	send,{space up}
	KeyWait, LButton
	send,{space down}
	Return

LaunchPs:
	If not WinExist("ahk_class Photoshop")
	{
		;msgbox,%PsPath%
		If PsPath=NULL
			gosub Browse2
		else If (PsPath<>NULL) && IfExist "%PsPath%"
			run "%PsPath%"
		else
			gosub Browse2
	}
	else
	{
		run "%PsPath%"
		WinwaitActive, ahk_class Photoshop
		gosub Config
	}
	return

Config:
	If A_IsCompiled=1
		Run %A_scriptdir%\Config.exe
	else
		run %A_scriptdir%\Config.ahk
	return

LaunchPsAuto:
	If not WinExist("ahk_class Photoshop")
	{
		;msgbox,%PsPath%
		If PsPath=NULL
			gosub Browse2
		else If (PsPath<>NULL) && IfExist "%PsPath%"
			run "%PsPath%"
		else
			gosub Browse2
	}
	return

; 鎖定輸入法1
LockIME:
	#IfWinActive, ahk_group Photoshop
		SetIME("00000409")
	#IfWinActive
	Return
/* 
MAPAlt11c:
	CoordMode, Mouse,Screen
	CoordMode, Pixel,Screen
	WinActivate, ahk_class Photoshop
	ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\brush.png
	if ErrorLevel=1
	{
		ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\pencil.png
		if ErrorLevel=1
		{
		return
		}
	}
	Gosub FCPsearch
	MouseGetPos, cX, cY
	MouseClick, left, %fcX%, %fcY%,,0
	MouseMove, %cX%, %cY%,0
	KeyWait, alt
	IfWinActive, ahk_class PSFloatC
	send,{Enter}

	return
 */
/* 
MAPAlt11:

	if (Regver=10)
	{
	CoordMode, Mouse,Screen
	CoordMode, Pixel,Screen
	}
	else
	{
	CoordMode, Mouse,Relative
	CoordMode, Pixel,Relative
	}

	WinActivate, ahk_class Photoshop
	ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\brush.png
	if ErrorLevel=1
	{
		ImageSearch, , , 0, 0, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\pencil.png
		if ErrorLevel=1
		{
		return
		}
	}
	Gosub FCPsearch

	if (Regver=10)
	{
	MouseGetPos, cX, cY
	MouseClick, left, %fcX%, %fcY%,,0
	MouseMove, %cX%, %cY%,0
	}
	else
	ControlClick, x%fcX% y%fcY%, ahk_class Photoshop

	gosub FCPs2
	Return
 */
/* 
QCLayer:
	WinActivate, ahk_class Photoshop
	ImageSearch, Layer1X, Layer1Y, 0, 295, %VirtualWidth%, %VirtualHeight%, %A_scriptdir%\Data\Imagesearch\%PsCSver%\Layer1.png
	if ErrorLevel=1
	{
	msgbox, %Lang_Msg_Debug%
	return
	}
	QCLX := Layer1X + 65
	QCLY := Layer1Y + 5

	MouseGetPos, cX, cY
	MouseClick, left, %QCLX%, %QCLY%,,0
	MouseMove, %cX%, %cY%,0
 */
SetKeyState:
	SetCapsLockState ,Off
	;SetNumLockState ,On
	;SetScrollLockState ,Off
	Return

QCLayer:
	gosub, SetKeyState
	Send, {Ctrl down}{Alt down}{Ctrl up}
	PostMessage, 0x111, 1099,,,ahk_class Photoshop
	sleep, 100
	KeyWait, Alt
	Send, {Alt up}
/* 
	send, {Ctrl down}{Alt down}{Shift down}n
	send, {Ctrl up}{Alt up}{Shift up}
 */
	Return

; 立即保存提示按鈕
Savenow:
	WinActivate, ahk_class Photoshop
	PostMessage, 0x111, 30,,,ahk_class Photoshop
	Gui, Cancel
/* 
; 修改撤销快捷键提示
Undotip:
	If Check2=0
	{
	TrayTip, %Lang_Tiptitle%, %Lang_Undotip% . "`nCtrl+z`t`tAlt+Ctrl+z`nAlt+Ctrl+z`tCtrl+y`nCtrl+y`t`tShift+Ctrl+z`nShift+Ctrl+z`tCtrl+z", 30, 1
	}
	Return
 */
; ==========================================函数==========================================
SetIME(Locale)
{
DllCall("SendMessage", "UInt", (WinActive("ahk_class Photoshop")), "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", Locale, "UInt", "257")))
}

; Thanks to maxspeedwind http://ahk.5d6d.com/thread-2795-1-1.html
NoticePanel(TextInfo,MotionTime,RemainingTime,InMode,OutMode,text1,text2)
{
	;G_ReadLanguage()
	InModeList:="4t60x40001|6t40x40002|8t20x40004|2t80x40008|1t90x40009|9t10x40006|7t30x40005|3t70x4000a|0t10xa0000|5t50x16xxx"
	OutModeList:="4t60x50001|6t40x50002|8t20x50004|2t80x50008|1t90x50009|9t10x50006|7t30x50005|3t70x5000a|1t00x90000|5t50x10010"
	InMode:=SubStr(InModeList,InStr(InModeList,InMode)+3,7)
	OutMode:=SubStr(OutModeList,InStr(OutModeList,OutMode)+3,7)
	DetectHiddenWindows,on
	SysGet,Desk,MonitorWorkArea
	Gui,88:+alwaysontop -caption +owner
	Gui,88:color,efefef
	Gui,88:Margin,15,15
	Gui,88:add,Button,x15 y15 R2 W125 GSavenow, %text1%
	Gui,88:add,Button,x145 y15 R2 W45 GCancel, %text2%
	Gui,88:font, S10 c555555, %fontname%
	Gui,88:add,text,x15 y65,%TextInfo%
	Gui,88:Show,NA AutoSize Hide,NoticePanel
	Gui_ID:=WinExist("NoticePanel")
	WinGetPos,,,NoticePanel_W,NoticePanel_H,ahk_id %Gui_ID%
	NoticePanel_X:=DeskRight-NoticePanel_W-2
	NoticePanel_Y:=DeskBottom-NoticePanel_H-2
	WinMove,NoticePanel,,NoticePanel_X,NoticePanel_Y
	Gui_ID:=WinExist("NoticePanel")
	DllCall("AnimateWindow","UInt",Gui_ID,"Int",MotionTime,"UInt",InMode)
	sleep %RemainingTime%
	DllCall("AnimateWindow","UInt",Gui_ID,"Int",MotionTime,"UInt",OutMode)
	Gui,88:destroy
	DetectHiddenWindows,off
}

#include %A_scriptdir%\inc\Handle.ahk

