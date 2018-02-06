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
;msgbox % VerToNum("" . f_CurrentVer . "") > VerToNum("" . LatestVer . "")

IniRead, f_CurrentVer, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver,1
if f_CurrentVer=0
ExitApp

G_ReadLanguage()
Downloadtimes=0

if A_Is64bitOS=1
	OSbit=64
else
	OSbit=32

WinBit=Win%OSbit%
VerFileName=%A_Temp%\Apssistant_version.tmp
UpdateFileName = %A_scriptdir%\Data\Update\Setup.exe

f_CheckVersion()

ExitApp

DownloadUpdateStart:
	Downloadtimes:=Downloadtimes+1
	If Downloadtimes=5
		ExitApp ; 避免进入下载死循环

	;IniRead, DownloadUrlmax, %VerFileName%, %WinBit%, Url, 1
	;Random, randnum, 1, %DownloadUrlmax% ; 下载地址总数
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
		StringReplace, NewVerAvailable, lang_NewVerAvailable, `%LatestVer`%, %LatestVer%
		MsgBox, 36, %lang_NewVer%, %NewVerAvailable%
		IfMsgBox Yes
		{
			Process,Close,Apssistant.exe
			run %A_scriptdir%\Data\Update\Setup.exe, %A_scriptdir%
			StringReplace, NewVerNotAvailable, lang_NewVerNotAvailable, v`%CurrentVer`%,
			;if !Quiet
			MsgBox, 64, Apssistant, %NewVerNotAvailable%, 30
		}
		;IfMsgBox No
		;	Gosub, Website
	}
	else
	{
		gosub DownloadUpdateStart
	}
	return

; ==========================================函数==========================================

;Update function thanks to http://www.autohotkey.net/~rexx/FolderMenu/
f_CheckVersion(Quiet=0)
{
	Global VerFileName, LatestVer,WinBit,OSbit
	FileDelete, %VerFileName%
	UrlDownloadToFile, https://github.com/millionart/Apssistant/raw/master/bin/x%OSbit%/Update.ini, %VerFileName%
	IniRead, LatestVer, %VerFileName%, %WinBit%, Version,CannotConnect
	Process, Exist, Apssistant.exe
	pc1:=ErrorLevel

	if LatestVer =CannotConnect
	{
		if (pc1=0)
			MsgBox, 16, %lang_Error%, %lang_CannotConnect%
		else
			ExitApp
	}
	else
	{
		if VerToNum("" . f_CurrentVer . "") < VerToNum("" . LatestVer . "")
		{
			If FileExist(UpdateFileName)  ;存在升级文件
				gosub UpdateStart
			else
				gosub DownloadUpdateStart
		}
		else if (pc1=0)
		{
			;StringReplace, NewVerNotAvailable, lang_NewVerNotAvailable, `%f_CurrentVer`%, %CurrentVer%
			;if !Quiet
			MsgBox, 64, Apssistant, %NewVerNotAvailable%, 30
		}
		else
		ExitApp

	}
	return
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
