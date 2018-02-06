#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force

Process,Close,Ahk2Exe.exe
Process,Close,Apssistant.exe
Process,Close,Config.exe
Process,Close,Update.exe

Compiler=C:\Program Files\AutoHotkey\Compiler\
;source=%~dp0

FileAppend,
(
@echo on

cd "%Compiler%"
copy /y "Unicode 32-bit.bin" AutoHotkeySC.bin
Ahk2exe.exe /in "%A_ScriptDir%\APssistant.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Config.ahk" /out "%A_ScriptDir%\Config.exe" /icon "%A_ScriptDir%\inc\Config.ico"
Ahk2exe.exe /in "%A_ScriptDir%\Update.ahk" /out "%A_ScriptDir%\Update.exe" /icon "%A_ScriptDir%\inc\Update.ico"

), build.bat


Process,Close,Ahk2Exe.exe
Process,Close,Apssistant.exe
Process,Close,Config.exe
Process,Close,Update.exe

RunWait build.bat

FileDelete, %A_ScriptDir%\build.bat
return
