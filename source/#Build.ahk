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


::====32-bit====
cd "%Compiler%"
copy /y "Unicode 32-bit.bin" AutoHotkeySC.bin
Ahk2exe.exe /in "%A_ScriptDir%\APssistant.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Config.ahk" /out "%A_ScriptDir%\Config.com" /icon "%A_ScriptDir%\inc\Config.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Update.ahk" /out "%A_ScriptDir%\Update.com" /icon "%A_ScriptDir%\inc\Update.ico"
copy /y "Unicode 64-bit.bin" AutoHotkeySC.bin

cd "%A_ScriptDir%\"
del Data\Update\APssistant.7z
del Data\Update\Setup.exe
del ..\bin\x32\APssistant.7z
del ..\bin\x32\Setup.exe
del ..\bin\x64\APssistant.7z
del ..\bin\x64\Setup.exe

..\tools\7za.exe a -t7z ..\bin\x32\APssistant.7z @listfile.txt -mx=9 -x!Data\Config.ini -xr!*\.SVN\  -xr!*\_SVN\ -xr!*\inc\ -xr!*\Readme\ 
copy /b ..\tools\7zsd_LZMA2.sfx + bin.txt + ..\bin\x32\APssistant.7z ..\bin\x32\Setup.exe
move ..\bin\x32\APssistant.7z Data\Update\APssistant.7z
del ..\bin\x32\APssistant.7z

::====64-bit====
Ahk2exe.exe /in "%A_ScriptDir%\APssistant.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Config.ahk" /out "%A_ScriptDir%\Config.com" /icon "%A_ScriptDir%\inc\Config.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Update.ahk" /out "%A_ScriptDir%\Update.com" /icon "%A_ScriptDir%\inc\Update.ico"


..\tools\7za.exe a -t7z ..\bin\x64\APssistant.7z @listfile.txt -mx=9 -x!Data\Config.ini -xr!*\.SVN\  -xr!*\_SVN\ -xr!*\inc\ -xr!*\Readme\ 
copy /b ..\tools\7zsd_LZMA2_x64.sfx + bin.txt + ..\bin\x64\APssistant.7z ..\bin\x64\Setup.exe
del ..\bin\x64\APssistant.7z


move Update.com Update.exe
move Config.com Config.exe

), build.bat

RunWait build.bat
FileDelete, %A_ScriptDir%\build.bat
FileDelete, %A_ScriptDir%\bin.txt
FileDelete, %A_ScriptDir%\listfile.txt

binexex32=%A_scriptdir%\..\bin\x32\Setup.exe
binexex64=%A_scriptdir%\..\bin\x64\Setup.exe

bin7zx32hash=% File_Hash(bin7zx32, "MD5")
binexex32hash=% File_Hash(binexex32, "MD5")
bin7zx64hash=% File_Hash(bin7zx64, "MD5")
binexex64hash=% File_Hash(binexex64, "MD5")

IniWrite, %f_CurrentVer%, %A_scriptdir%\..\bin\x32\Update.ini, Win32, Version
IniWrite, %binexex32hash%, %A_scriptdir%\..\bin\x32\Update.ini, Win32, MD5
IniWrite, %f_CurrentVer%, %A_scriptdir%\..\bin\x64\Update.ini, Win64, Version
IniWrite, %binexex64hash%, %A_scriptdir%\..\bin\x64\Update.ini, Win64, MD5
IniWrite, https://github.com/millionart/Apssistant/raw/master/bin/x32/Setup.exe, %A_scriptdir%\..\bin\x32\Update.ini, Win32, Url
IniWrite, https://github.com/millionart/Apssistant/raw/master/bin/x64/Setup.exe, %A_scriptdir%\..\bin\x64\Update.ini, Win64, Url

return

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\FileHelperAndHash.ahk
