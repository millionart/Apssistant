#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force

Process,Close,Ahk2Exe.exe
Process,Close,Apssistant.exe
Process,Close,Config.exe
Process,Close,Update.exe

V_CurrentVer()

Compiler=C:\Program Files\AutoHotkey\Compiler\
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

::====64-bit====
cd /d "%Compiler%"
Ahk2exe.exe /in "%A_ScriptDir%\APssistant.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Config.ahk" /icon "%A_ScriptDir%\inc\Config.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Update.ahk" /icon "%A_ScriptDir%\inc\Update.ico"

:: [新增] 添加短暂延迟，等待编译器释放文件句柄
timeout /t 1 /nobreak >nul

cd /d "%A_ScriptDir%\"
move Update.exe Update.com
move Config.exe Config.com
..\tools\7za.exe a -t7z ..\bin\x64\APssistant.7z @listfile.txt -mx=9 -x!Data\Config.ini -xr!*\.SVN\  -xr!*\_SVN\ -xr!*\inc\ -xr!*\Readme\
copy /b ..\tools\7zsd_LZMA2_x64.sfx + bin.txt + ..\bin\x64\APssistant.7z ..\bin\x64\Setup.exe
del ..\bin\x64\APssistant.7z

mkdir Apssistant
move /y Data Apssistant\Data
move /y APssistant.exe Apssistant\APssistant.exe
move /y Update.com Apssistant\Update.com
move /y Config.com Apssistant\Config.com
del ..\bin\%f_CurrentVer%x64.zip
..\tools\7za.exe a -tzip ..\bin\%f_CurrentVer%x64.zip Apssistant\ -mx=9 -x!APssistant\Data\Config.ini -x!APssistant\Data\Update\APssistant.7z -xr!*\.SVN\  -xr!*\_SVN\ -xr!*\inc\ -xr!*\Readme\
move /y Apssistant\Data Data
move /y Apssistant\APssistant.exe APssistant.exe 
move /y Apssistant\Update.com Update.com
move /y Apssistant\Config.com Config.com
rmdir /s/q Apssistant

move Update.com Update.exe
move Config.com Config.exe
pause

), build.bat

RunWait build.bat
FileDelete, %A_ScriptDir%\build.bat
FileDelete, %A_ScriptDir%\bin.txt
FileDelete, %A_ScriptDir%\listfile.txt

binexex32=%A_scriptdir%\..\bin\x32\Setup.exe
binexex64=%A_scriptdir%\..\bin\x64\Setup.exe

bin7zx32hash=% File_Hash(bin7zx64, "MD5")
binexex32hash=% File_Hash(binexex64, "MD5")
bin7zx64hash=% File_Hash(bin7zx64, "MD5")
binexex64hash=% File_Hash(binexex64, "MD5")

IniWrite, %f_CurrentVer%, %A_scriptdir%\..\bin\x32\Update.ini, Win32, Version
IniWrite, %binexex32hash%, %A_scriptdir%\..\bin\x32\Update.ini, Win32, MD5
IniWrite, %f_CurrentVer%, %A_scriptdir%\..\bin\x64\Update.ini, Win64, Version
IniWrite, %binexex64hash%, %A_scriptdir%\..\bin\x64\Update.ini, Win64, MD5
IniWrite, https://github.com/millionart/Apssistant/raw/master/bin/x64/Setup.exe, %A_scriptdir%\..\bin\x32\Update.ini, Win32, Url
IniWrite, https://github.com/millionart/Apssistant/raw/master/bin/x64/Setup.exe, %A_scriptdir%\..\bin\x64\Update.ini, Win64, Url

IniRead, testMD5, %A_scriptdir%\..\bin\x32\Update.ini, Win32, MD5
IniWrite, %testMD5%,  %A_scriptdir%\..\bin\test\Update.ini, Win32, MD5

FileCopy, %A_scriptdir%\..\bin\x32\*.*, %A_scriptdir%\..\bin\old\*.* ,1

ExitApp

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\FileHelperAndHash.ahk
