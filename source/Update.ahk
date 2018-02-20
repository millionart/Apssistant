#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FileEncoding , UTF-8
#SingleInstance, force
#NoTrayIcon

IfExist %A_scriptdir%\APssistant.com
{
	FileDelete, %A_scriptdir%\APssistant.exe
	FileMove, %A_scriptdir%\APssistant.com, %A_scriptdir%\APssistant.exe
}

G_ReadLanguage()
Downloadtimes=0

if A_Is64bitOS=1
	OSbit=64
else
	OSbit=32

WinBit=Win%OSbit%
VerFileName=%A_Temp%\Apssistant_version.tmp
UpdateFileName = %A_scriptdir%\Data\Update\Setup.exe

V_CurrentVer()
f_CheckVersion()

ExitApp

DownloadUpdateStart:
Downloadtimes:=Downloadtimes+1
If Downloadtimes=5
	ExitApp ; 避免进入下载死循环

;IniRead, DownloadUrlmax, %VerFileName%, %WinBit%, Url, 1
;Random , randnum , 1 , %DownloadUrlmax% ; 下载地址总数
IniRead, UpdateUrl, %VerFileName%, %WinBit%, Url, about:blank
FileDelete, %UpdateFileName%
UrlDownloadToFile, %UpdateUrl%, %UpdateFileName%
gosub UpdateStart
return

UpdateStart:
IniRead, UpdatefileMD5, %VerFileName%, %WinBit%, MD5, 0
If UpdatefileMD5=% File_Hash(UpdateFileName, "MD5")
{
	IniRead, LatestVer, %VerFileName%, %WinBit%, Version,0
	NewVerAvailable:=StrReplace(lang_NewVerAvailable, "`%LatestVer`%", "%LatestVer%")
	
	OnMessage(0x44, "OnMsgBox")
	MsgBox 0x184, %lang_NewVer%, %NewVerAvailable%
	OnMessage(0x44, "")
	
	IfMsgBox No
	{
		Process,Close,Apssistant.exe
		run %A_scriptdir%\Data\Update\Setup.exe, %A_scriptdir%
		NewVerNotAvailable:=StrReplace(lang_NewVerNotAvailable, "v`%CurrentVer`%", "")
	}
	Else IfMsgBox Yes
	{
		run https://github.com/millionart/Apssistant/releases
	}
}
Else
{
	gosub DownloadUpdateStart
}
return

; ==========================================函数==========================================

;msgbox custom thanks to https://sourceforge.net/projects/magicbox-factory
OnMsgBox() {
	Global
	DetectHiddenWindows, On
	Process, Exist
	If (WinExist("ahk_class #32770 ahk_pid " . ErrorLevel)) {
		hIcon := LoadPicture("" . A_ScriptDir . "\Update.exe", "w32 Icon1", _)
		SendMessage 0x172, 1, %hIcon% , Static1 ;STM_SETIMAGE
		ControlSetText Button1, %lang_ChangeLog%
		ControlSetText Button2, %lang_Update%
	}
}

;Update function thanks to http://www.autohotkey.net/~rexx/FolderMenu/
f_CheckVersion()
{
	Global
	If (A_IsCompiled)
	{
		FileDelete, %VerFileName%
		UrlDownloadToFile, https://github.com/millionart/Apssistant/raw/master/bin/x%OSbit%/Update.ini, %VerFileName%
		IniRead, LatestVer, %VerFileName%, %WinBit%, Version,CannotConnect
		FileDelete, %VerFileName%
	}
	else
	{
		WinBit=Win32
		;UrlDownloadToFile, https://github.com/millionart/Apssistant/raw/master/bin/test/Update.ini, %VerFileName%
		IniRead, LatestVer, %VerFileName%, %WinBit%, Version,CannotConnect
	}
	
	Process, Exist, Apssistant.exe
	if (ErrorLevel = 0) ;如果找不到 Apssistant 进程
	{
		If (LatestVer = "CannotConnect")
		{
			MsgBox, 16, %lang_Error%, %lang_CannotConnect%
			ExitApp
		}
		
		if VerToNum("" . f_CurrentVer . "") < VerToNum("" . LatestVer . "")
		{
			If FileExist(UpdateFileName)  ;存在升级文件
				gosub UpdateStart
			else
				gosub DownloadUpdateStart
			
			MsgBox, 64, Apssistant, %lang_UpdateSuccessful%, 30
		}
		else
			MsgBox, 64, Apssistant, %lang_NewVerNotAvailable%, 30
	}
}

;Thanks to 彪悍的小玄
VerToNum(ver)
{
	Loop, Parse,ver,.
	{
		num += A_LoopField
		num *= 100
	}
	return num
}
;#include %A_scriptdir%\inc\Handle.ahk
#include %A_scriptdir%\inc\FileHelperAndHash.ahk
#include %A_scriptdir%\inc\Function.ahk
