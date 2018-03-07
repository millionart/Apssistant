
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

IfExist, %A_scriptdir%\Update.com
{
	FileDelete, %A_scriptdir%\Update.exe
	FileMove, %A_scriptdir%\Update.com, %A_scriptdir%\Update.exe
}

IfExist, %A_scriptdir%\Config.com
{
	FileDelete, %A_scriptdir%\Config.exe
	FileMove, %A_scriptdir%\Config.com, %A_scriptdir%\Config.exe
}

If A_IsCompiled=1
{
	IfExist,%A_scriptdir%\Update.exe
	Run %A_scriptdir%\Update.exe
}
else
	run %A_scriptdir%\Update.ahk

; ===================================================
DetectHiddenText, On
Gosub, SetGroupPhotoshop

SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79

If (A_ScreenWidth>=2000) || (A_ScreenHeight>1200)
	trayIconSize=32
Else
	trayIconSize=16
; 读取界面配置
IniRead, fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI
G_ReadLanguage()
; ================版本号转换
V_Trans()
gosub ConfigRead	; 讀取配置文件
; 托盘菜单
If A_IsCompiled=1
{
	Menu, tray, NoStandard
	Menu, tray, Tip, Adobe Photoshop assistant
}
Menu, Tray, Icon,%A_scriptdir%\Data\tray.ico,, 1

Menu, tray, add

If (Check3=1)
{
	Menu, tray, add, %Lang_tray_LockIMEOn%, LockIMESwitch
	Menu, tray, Check, %Lang_tray_LockIMEOn%
}
else
{
	Menu, tray, add, %Lang_tray_LockIMEOff%, LockIMESwitch
}


Menu, tray, add, %Lang_tray_LaunchPs%, LaunchPs


Menu, tray, add, %Lang_tray_Config%, Config
Menu, tray, add


Menu, tray, add, %Lang_tray_Exit%, WinClose


If A_IsCompiled=1
{
	Menu, tray, Icon, %Lang_tray_Config%, %A_scriptdir%\Config.exe,, %trayIconSize%
}
else
{
	Menu, tray, Icon, %Lang_tray_Config%, %A_scriptdir%\inc\Config.ico,, %trayIconSize%
}
Gui, Add, Text,,

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

SetTimer, setTrayDefault, 1000

If Check3=1
	SetTimer, LockIME, 2000 ; 2秒锁定一次输入法
Gosub Autosave

Hotkey, IfWinActive, ahk_group Photoshop
	If (Regver>=12) and (Check7=1)
		Hotkey, %HUDCP%, HUDCP

	If (Regver<12) and (Check8=1) and (MapAltmode=1)
		Hotkey, %FCPk%, FCPc1

	If Check6=1
		Hotkey, %QCLayer%, QCLayer

	If (Regver>=11) and (Check11=1)
		Hotkey, %ModifyBrushKey%, ModifyBrushKey

	If Check13=1
		Hotkey, %SHLayer%, SHLayer
Hotkey, IfWinActive

Hotkey, IfWinActive, ahk_class PSFloatC, Web
	If (Check8=1) and (MapAltmode=1)
		Hotkey, %FCPk%, FCPs
Hotkey, IfWinActive

gosub CleanUpTempFiles

If Check4=1
	gosub LaunchPsAuto
Return


; ==========================================初始化完毕==========================================

; ==========================================键盘映射==========================================
#IfWinActive ahk_class PSFloatC, Web
~Alt Up::
	If (Check8=1) and (MapAltmode=2)
		gosub FCPs
	else If (Check8=1) and (MapAltmode=3)
		gosub FCPs12
	return
#IfWinActive

; 添加 Illustrator 下禁用 Alt 菜单
#IfWinActive ahk_class Illustrator
~Alt::
	If (Check10=1)
	{
		SendInput, {Ctrl down}{Alt down}{Ctrl up}
		KeyWait, Alt
		SendInput, {Alt up}
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

; 撤銷快捷鍵修改
;$^z::send !^z
$^z::
	If (Check1=1)
		PostMessage, 0x111, 0x7A9,,,ahk_class Photoshop
	Else
		Send,^z
	return

;$^y::send +^z
$^y::
	If (Check1=1)
		PostMessage, 0x111, 0x7AA,,,ahk_class Photoshop
	Else
		Send,^y
	return

$^s::
	PostMessage, 0x111, 30,,,ahk_class Photoshop
	If (Check15=1)
	{
		SetControlDelay -1
		ControlClick, Label1, ahk_class 3dsMax,,,, NA
		WinActivate, ahk_class Photoshop
	}
	return
#IfWInActive

setTrayDefault:
	If FileExist(PsPath) && !WinExist("ahk_class Photoshop")
	{
		try
		Menu, tray, Disable,%Lang_tray_LockIMEOn%
		try
		Menu, tray, Disable,%Lang_tray_LockIMEOff%

		Menu, tray, default, %Lang_tray_LaunchPs%
		try
		Menu, tray, Icon, %Lang_tray_LaunchPs%, %PsPath%,, %trayIconSize%
	}
	Else
	{
		try
		Menu, tray, Enable,%Lang_tray_LockIMEOn%
		try
		Menu, tray, Enable,%Lang_tray_LockIMEOff%

		Menu, tray, default, %Lang_tray_Config%
	}

	If !FileExist(PsPath)
		Menu, tray, Disable, %Lang_tray_LaunchPs%
Return

Autosave:
	If WinExist("ahk_group Photoshop") and (Autosavenum=3)
	{
		PostMessage, 0x111, 30,,,ahk_class Photoshop
		If Check15=1
		{
			SetControlDelay -1
			ControlClick, Label1, ahk_class 3dsMax,,,, NA
			;WinActivate, ahk_class Photoshop
		}
	}
	else If WinExist("ahk_group Photoshop") and (Autosavenum=2)
	{
		text1=%Lang_Savenow%
		text2=%Lang_Ignore%
		Text3=%Tiptext%
		NoticePanel(Text3,500,5000,"2t8","8t2",text1,text2)
	}
	return

ModifyBrushKey:
	gosub, IfTextMode
	If (hotkeyOn=1)
	{
		send, {Alt down}{RButton down}
		keywait, %ModifyBrushKey%
		send, {Alt up}{RButton up}
	}
	Else
		SendInput, %ModifyBrushKey%
	Return

SHlayer:
	gosub, IfTextMode
	If (hotkeyOn=1)
		PostMessage, 0x111, 0x45A,,,ahk_class Photoshop
	Else
		SendInput, %SHLayer%
	Return

IfTextMode:
	ControlGetPos,textDisplayModeComboBoxX,, , , ComboBox46, ahk_class Photoshop
	ControlGet, textDisplayModeComboBox, Visible,, ComboBox46, ahk_class Photoshop
	ControlGet, fontName, Visible,, Edit94, ahk_class Photoshop
	ControlGet, fontMode, Visible,, Edit93, ahk_class Photoshop
	ControlGet, fontSize, Visible,, Edit92, ahk_class Photoshop
	ControlGet, fill, Enabled,, Edit1, ahk_class Photoshop
	ControlGet, layerMode, Enabled,, ComboBox1, ahk_class Photoshop
	If (textDisplayModeComboBox=1) && (fontName=1) && (fontMode=1) && (fontSize=1) && (fill=0) && (layerMode=1) && ((textDisplayModeComboBoxX>1000) || (textDisplayModeComboBoxX<1500)) ; textDisplayModeComboBoxX = 1134 & 1139
		hotkeyOn=0
	Else
		hotkeyOn=1
	return
; ==========================================普通拾色器点击
FCPc1:
	gosub, IfTextMode
	If (hotkeyOn=1)
	{
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
		Gosub FCPc2
	}
	Else
		SendInput, %FCPc1%
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
	gosub, IfTextMode
	If (hotkeyOn=1)
	{
		If Check2=0
			TrayTip, %Lang_Tiptitle%, %Lang_OpenGLtip%, 1, 1

		If Check9=1
		{
			centerw:=VirtualWidth/2
			centerh:=VirtualHeight/2
			MouseMove, %centerw%, %centerh%,0
		}

		If (hotkeyMode=2)
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
		Else
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
	}
	Else
		SendInput, %HUDCP%
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

Config:
	If A_IsCompiled
		Run %A_scriptdir%\Config.exe
	else
		Run %A_scriptdir%\Config.ahk
	return

LaunchPs:
	If FileExist(PsPath) && !WinExist("ahk_class Photoshop")
	{
		Run, % PsPath
	}

	WinwaitActive, ahk_class Photoshop
Return

LaunchPsAuto:
	If FileExist("%PsPath%") && !WinExist("ahk_class Photoshop")
	{
		Run, "%PsPath%"
		WinwaitActive, ahk_class Photoshop
		Reload
	}
	
	If FileExist("%PsPath%")=False
	{
		gosub Config
	}
	return

; 鎖定輸入法1
LockIME:
	#IfWinActive, ahk_group Photoshop
		SetIME("00000409")
	#IfWinActive
	Return

SetKeyState:
	SetCapsLockState ,Off
	Return

QCLayer:
	gosub, IfTextMode
	If (hotkeyOn=1)
	{
		gosub, SetKeyState
		Send, {Ctrl down}{Alt down}{Ctrl up}
		PostMessage, 0x111, 1099,,,ahk_class Photoshop
		sleep, 100
		KeyWait, Alt
		Send, {Alt up}
	}
	Else
		SendInput, %QCLayer%
	Return

LockIMESwitch:
	Check3:=Check3=1?0:1
	IniWrite, %Check3%, %A_scriptdir%\Data\Config.ini, Setting, lockIME
	Reload
	return

; 立即保存提示按鈕
Savenow:
	;WinActivate, ahk_class Photoshop
	PostMessage, 0x111, 30,,,ahk_class Photoshop
	Gui, Cancel

; ==========================================函数==========================================
SetIME(Locale)
{
DllCall("SendMessage", "UInt", (WinActive("ahk_class Photoshop")), "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", Locale, "UInt", "257")))
}

; Thanks to maxspeedwind http://ahk8.com/thread-2486.html

NoticePanel(TextInfo,MotionTime,RemainingTime,InMode,OutMode,text1,text2)
{
	InModeList:="4t60x40001|6t40x40002|8t20x40004|2t80x40008|1t90x40009|9t10x40006|7t30x40005|3t70x4000a|0t10xa0000|5t50x16xxx"
	OutModeList:="4t60x50001|6t40x50002|8t20x50004|2t80x50008|1t90x50009|9t10x50006|7t30x50005|3t70x5000a|1t00x90000|5t50x10010"
	InMode:=SubStr(InModeList,InStr(InModeList,InMode)+3,7)
	OutMode:=SubStr(OutModeList,InStr(OutModeList,OutMode)+3,7)
	DetectHiddenWindows,on
	SysGet,Desk,MonitorWorkArea
	Gui,88:+alwaysontop -caption +owner
	Gui,88:color,efefef
	Gui,88:Margin,15,15
	Gui,88:add,Button,x15 y15 R2 W45 GCancel, %text2%
	Gui,88:add,Button,x65 y15 R2 W125 GSavenow, %text1%
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
