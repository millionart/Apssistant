

; ==========================================自動保存判斷
/* 
#Persistent
SetTimer,ClsEvthn,1000
return

ClsEvthn:
IfWinExist,ahk_class EVERYTHING
        IfWinNotActive
                WinClose
return
 */


; ==========================================配置界面初始化


/* 
Debug:
	msgbox,DPI %%VirtualWidth%% %%VirtualHeight%%`n%VirtualWidth% %VirtualHeight% `n fcp %fcX% %fcY% `n MapAltmode=%MapAltmode%
	;msgbox, %Precisehudcp%
	;msgbox, %centerw% %centerh% 
	;msgbox ,%FCPk%
	Return
 */

Browse2:
	;PsPath=NULL
	ProgramFilesDir:="A_ProgramFiles"
	SSF:="Lang_PsDir"
	Dir := Dlg_Open(hGui, %SSF%, "Photoshop (Photoshop.exe; *.exe; *.lnk)", 1, %ProgramFilesDir%, "", "filemustexist")
	StringReplace, Dir, Dir, `n, `r`n, A
;	If (PsPath<>NULL) && IfExist "%PsPath%"
;	{
		IniWrite, %Dir%, %A_scriptdir%\Data\Config.ini, Setting, PsPath
		run "%Dir%"
;	}
;	else
	Return

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


; 添加控件 第六步
ConfigRead:
	IniRead, HUDCP, %A_scriptdir%\Data\Config.ini, Setting, hudcp, ``
	IniRead, FCPk, %A_scriptdir%\Data\Config.ini, Setting, fcp, n
	IniRead, Check1, %A_scriptdir%\Data\Config.ini, Setting, undo, 0
	IniRead, Autosavenum, %A_scriptdir%\Data\Config.ini, Setting, autosave, 1
	IniRead, Savesleep, %A_scriptdir%\Data\Config.ini, Setting, savesleep, 5
	IniRead, Check2, %A_scriptdir%\Data\Config.ini, Setting, helptip, 0
	IniRead, Check3, %A_scriptdir%\Data\Config.ini, Setting, lockIME, 0
	IniRead, Check4, %A_scriptdir%\Data\Config.ini, Setting, launchPs, 1
	IniRead, Check5, %A_scriptdir%\Data\Config.ini, Setting, Precisehudcp, 1
	IniRead, Check6, %A_scriptdir%\Data\Config.ini, Setting, enableQCLayer, 1
	IniRead, Check7, %A_scriptdir%\Data\Config.ini, Setting, enablehudcp, 1
	IniRead, Check8, %A_scriptdir%\Data\Config.ini, Setting, enablefcp, 1
	IniRead, Check9, %A_scriptdir%\Data\Config.ini, Setting, Centerhudcp, 0
	IniRead, Check10, %A_scriptdir%\Data\Config.ini, Setting, DisableAltMenu, 1
	IniRead, Check11, %A_scriptdir%\Data\Config.ini, Setting, enableModifyBrushRadius, 1
	IniRead, Check12, %A_scriptdir%\Data\Config.ini, Setting, CPThudcp, 1
	IniRead, Check13, %A_scriptdir%\Data\Config.ini, Setting, SHLayerToggle, 1
	IniRead, Check14, %A_scriptdir%\Data\Config.ini, Setting, CleanUpTempFiles, 1
	IniRead, SHLayer, %A_scriptdir%\Data\Config.ini, Setting, SHLayer, H
	IniRead, QCLayer, %A_scriptdir%\Data\Config.ini, Setting, QCLayer, F1
	IniRead, ModifyBrushKey, %A_scriptdir%\Data\Config.ini, Setting, ModifyBrushRadius, F2
	IniRead, MapAltmode, %A_scriptdir%\Data\Config.ini, Setting, mapalt, 1
	IniRead, PsPath, %A_scriptdir%\Data\Config.ini, Setting, PsPath, NULL
	IniRead, Check15, %A_scriptdir%\Data\Config.ini, Setting, 3DsMaxSync, 0
	If PsPath=NULL
	{
		PsDir:=RegRead64("HKEY_LOCAL_MACHINE", "SOFTWARE\Adobe\Photoshop\" . Regver . ".0", "ApplicationPath")
		If ErrorLevel
			PsPath=NULL
		else
			PsPath=%PsDir%Photoshop.exe
	}

	IniRead, Tiptext, %A_scriptdir%\Data\Config.ini, Setting, tiptext, %Lang_tiptext%
	stringreplace, Tiptext, Tiptext, \n, `n, All
	stringreplace, Tiptext, Tiptext, \r, `r, All
	Return
/* 

; 讀取時替換
StringReplaceRead:
	stringreplace, Tiptext, Tiptext, \n, `n, All
	stringreplace, Tiptext, Tiptext, \r, `r, All
	Return

; 保存時替換
StringReplaceWrite:
	stringreplace, Tiptext, Tiptext, `n, \n, All
	stringreplace, Tiptext, Tiptext, `r, \r, All
	Return
 */
/* 
VerTrans:
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
	Return
 */
; V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V links V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V

/* 
Update:
	IfExist %A_scriptdir%\Update.ahk
	run Update.ahk
	else
	run Update.exe
	return
 */

Website:
	; please retain the original links and related notes.
	run http://www.deviantart.com/deviation/160950828
	return

Blog:
	; please retain the original links and related notes.
	run http://done.is.com
	return



; A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A links A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A

WinClose:
	Process, Close, Config.exe
	gosub CleanUpTempFiles
GuiClose:
GuiEscape:
Cancel:
;	Gui, Cancel
	ExitApp
	return

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\reg64.ahk
#include %A_scriptdir%\inc\Dlg.ahk