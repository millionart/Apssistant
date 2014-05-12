#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force

Process,Close,Ahk2Exe.exe
Process,Close,Apssistant.exe
Process,Close,Config.exe
Process,Close,Update.exe

V_CurrentVer()

Compiler=D:\Program Files\AutoHotkey\Compiler\
;source=%~dp0

FileAppend,
(
;!@Install@!UTF-8!
InstallPath="`%CD`%\\.."
GUIMode="2"
RunProgram="APssistant.exe"
;!@InstallEnd@!
),bin.txt

FileAppend,
(
"..\source\Data\"
"..\source\APssistant.exe"
"..\source\Update.com"
"..\source\Config.com"
),listfile.txt

FileAppend,
(
@echo on

cd "%Compiler%"
move mpress.exe mpress_exe
move upx.exe upx_exe
Ahk2exe.exe /in "%A_ScriptDir%\APssistant.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Config.ahk" /out "%A_ScriptDir%\Config.com" /icon "%A_ScriptDir%\inc\Config.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Update.ahk" /out "%A_ScriptDir%\Update.com" /icon "%A_ScriptDir%\inc\Update.ico"
move mpress_exe  mpress.exe
move upx_exe upx.exe

cd "%A_ScriptDir%\"
del Data\Update\APssistant.7z
del Data\Update\Latest.exe
del ..\bin\APssistant.7z
del ..\bin\Latest.exe
..\tools\7za.exe a -t7z ..\bin\APssistant.7z @listfile.txt -mx=9 -x!Data\Config.ini -xr!*\.SVN\  -xr!*\_SVN\ -xr!*\inc\ -xr!*\Readme\ 
copy /b ..\tools\APssistant.sfx + bin.txt + ..\bin\APssistant.7z ..\bin\Latest.exe
move ..\bin\APssistant.7z Data\Update\APssistant.7z
move Update.com Update.exe
move Config.com Config.exe

), build.bat

RunWait build.bat
;msgbox,
FileDelete, %A_ScriptDir%\build.bat
FileDelete, %A_ScriptDir%\bin.txt
FileDelete, %A_ScriptDir%\listfile.txt

bin7z=Data\Update\APssistant.7z
binexe=..\bin\Latest.exe

bin7zhash=% File_Hash(bin7z, "MD5")
binexehash=% File_Hash(binexe, "MD5")

IniWrite, %f_CurrentVer%, %A_scriptdir%\APssistant.ahk.ini, VERSION, File_Version
IniWrite, %bin7zhash%, %A_scriptdir%\APssistant.ahk.ini, VERSION, MD5
IniWrite, %f_CurrentVer%, %A_scriptdir%\..\..\wiki\Update.wiki, Win32, Version
IniWrite, %binexehash%, %A_scriptdir%\..\..\wiki\Update.wiki, Win32, MD5

return

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\FileHelperAndHash.ahk
