
CleanUpTempFiles:
	If Check14=1
	{
		DriveGet, OutputVar, list
		Loop, Parse, OutputVar,,
		{
			Ifexist %A_LoopField%:\Photoshop Temp*
				FileDelete %A_LoopField%:\Photoshop Temp*
			Ifexist %A_LoopField%:\*_*_MVM_*.tmp
				FileDelete %A_LoopField%:\*_*_MVM_*.tmp
		}
	}
	Return

; 读取配置信息
ConfigRead:
	IniRead, HUDCP, %A_scriptdir%\Data\Config.ini, Setting, hudcp, ``
	
	Try
	{
		Loop, Files, %A_AppData%\Adobe\Adobe Photoshop *, D
		{
			psConfigFileVer:=StrReplace(A_LoopFileName, "Adobe Photoshop " ,"")
			keyboardShortcutsFile=%A_AppData%\Adobe\Adobe Photoshop %psConfigFileVer%\Adobe Photoshop %psConfigFileVer% Settings\Keyboard Shortcuts.psp
		}

		If FileExist(keyboardShortcutsFile)
		{
			FCPkText := new xml(keyboardShortcutsFile)
			if FCPkText.documentElement
			{
				FCPkText:=FCPkText.selectSingleNode("/photoshop-keyboard-shortcuts/tool[@type=""15""]").text
			}
		}
	}

	If (FCPkText="")
		FCPk=N
	Else
		FCPk=%FCPkText%

	IniRead, FCPk, %A_scriptdir%\Data\Config.ini, Setting, fcp, %FCPk%
	IniRead, Check1, %A_scriptdir%\Data\Config.ini, Setting, undo, 0
	IniRead, Autosavenum, %A_scriptdir%\Data\Config.ini, Setting, autosave, 1
	IniRead, Savesleep, %A_scriptdir%\Data\Config.ini, Setting, savesleep, 5
	IniRead, Check2, %A_scriptdir%\Data\Config.ini, Setting, helptip, 1
	IniRead, Check3, %A_scriptdir%\Data\Config.ini, Setting, lockIME, 0
	IniRead, Check4, %A_scriptdir%\Data\Config.ini, Setting, launchPs, 1
	IniRead, Check5, %A_scriptdir%\Data\Config.ini, Setting, Precisehudcp, 1
	IniRead, Check6, %A_scriptdir%\Data\Config.ini, Setting, enableQCLayer, 0
	IniRead, Check7, %A_scriptdir%\Data\Config.ini, Setting, enablehudcp, 1
	IniRead, Check8, %A_scriptdir%\Data\Config.ini, Setting, enablefcp, 1
	IniRead, Check9, %A_scriptdir%\Data\Config.ini, Setting, Centerhudcp, 0
	IniRead, Check10, %A_scriptdir%\Data\Config.ini, Setting, DisableAltMenu, 1
	IniRead, Check11, %A_scriptdir%\Data\Config.ini, Setting, enableModifyBrushRadius, 0
	IniRead, hotkeyMode, %A_scriptdir%\Data\Config.ini, Setting, CPThudcp, 1
		IniRead, hotkeyMode, %A_scriptdir%\Data\Config.ini, Setting, hotkeyMode, %hotkeyMode%
		IniDelete, %A_scriptdir%\Data\Config.ini, Setting, CPThudcp
	IniRead, Check13, %A_scriptdir%\Data\Config.ini, Setting, SHLayerToggle, 0
	IniRead, Check14, %A_scriptdir%\Data\Config.ini, Setting, CleanUpTempFiles, 1
	IniRead, SHLayer, %A_scriptdir%\Data\Config.ini, Setting, SHLayer, H
	IniRead, QCLayer, %A_scriptdir%\Data\Config.ini, Setting, QCLayer, F1
	IniRead, ModifyBrushKey, %A_scriptdir%\Data\Config.ini, Setting, ModifyBrushRadius, F2
	IniRead, MapAltmode, %A_scriptdir%\Data\Config.ini, Setting, mapalt, 1
	IniRead, PsPath, %A_scriptdir%\Data\Config.ini, Setting, PsPath, NULL
	IniRead, Check15, %A_scriptdir%\Data\Config.ini, Setting, 3dsMaxSync, 0
	IniRead, Tiptext, %A_scriptdir%\Data\Config.ini, Setting, tiptext, %Lang_tiptext%
	IniRead, fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI
	stringreplace, Tiptext, Tiptext, \n, `n, All
	stringreplace, Tiptext, Tiptext, \r, `r, All
	Return

Website:
	run http://www.deviantart.com/deviation/160950828
	return

WinClose:
	Process, Close, Config.exe
	gosub CleanUpTempFiles
GuiClose:
GuiEscape:
Cancel:
	ExitApp
	return

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\xml.ahk