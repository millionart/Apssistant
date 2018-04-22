#NoEnv
#SingleInstance, force
#NoTrayIcon
SendMode Input

#Include Lib\Webapp.ahk
__Webapp_AppStart:
;<< Header End >>

;Get our HTML DOM object
appWeb := getDOM()

Initialization()
I18n(G_Language,0)

Try {
    ; thanks to https://autohotkey.com/boards/viewtopic.php?t=23167
    OLECMDID_OPTICAL_ZOOM        :=63
    OLECMDEXECOPT_DONTPROMPTUSER :=2
    wepDPIScale :=Round(A_ScreenDPI/96*100*(appWeb.document.frames.screen.systemXDPI/96))
    appWeb.ExecWB(OLECMDID_OPTICAL_ZOOM,OLECMDEXECOPT_DONTPROMPTUSER,wepDPIScale)
}
;Change App name on run-time
setAppName("APssistant")

; cut auto run main thread.
;OnMessage(0x201, "WM_LBUTTONDOWN")

Return

WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}

; Webapp.ahk-only Sensitive hotkeys
#IfWinActive, ahk_group __Webapp_windows
Tab::
Return
/*
LButton Up::
Click
Return
*/
!Enter::
	;!toggle
	setFullscreen(!__Webapp_FullScreen)
Return
#IfWinActive

; Our custom protocol's url event handler
app_call(args) {
	if InStr(args,"exit")
		ExitApp
	else if InStr(args,"soundplay/ding")
		SoundPlay, %A_WinDir%\Media\ding.wav
}

SaveAndExit() {
	ExitApp
}

; function to run when page is loaded
app_page(NewURL) {
	appWeb := getDOM()
	if InStr(NewURL,"Config.html") {
		;disp_info()
	}
}

Run(ByRef t) {
	global
	If (t="paypal")
		t:="https://www.paypal.me/millionart"

	If (t="twitter")
		t:="https://twitter.com/intent/tweet?text=" . Lang_shareText . "&url=" . DeviantArt . "&hashtags=Photoshop"

	If (t="facebook")
		t:="https://www.facebook.com/sharer/sharer.php?u=" . DeviantArt

	If (t="reddit")
		t:="https://www.reddit.com/submit?url=" . DeviantArt . "&title=" . Lang_shareText . "&text=" . Lang_shareText

	If (t="github")
		t:="https://github.com/millionart/Apssistant"

	If (t="weibo")
	{
		url=%Github%/releases/latest
		Lang_shareText:=StrReplace(Lang_shareText, "#", "%23")

		If (G_Language = "简体中文")
			langTag:="zh_cn"
		Else
			langTag:="zh_tw"

		t:="https://service.weibo.com/share/share.php?url=" . url . "&language=" . langTag . "&title=" . Lang_shareText
	}

	Run, %t%
}

Initialization(){
	global
	local wp,langId,elementId
	IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English
	IniRead, psPublicVer, %A_scriptdir%\Data\Config.ini, Setting, Psver, %psMaxVer%	
	Gosub, ConfigRead

	Github:="https://github.com/millionart/Apssistant"
	DeviantArt:="https://www.deviantart.com/deviation/160950828"
	psMaxVer:="CC 2018"
	maxVerNum:=PsVerConvert(psMaxVer)
	ShowPsVer()

	psPathID := appWeb.document.getElementById("photoshopPath")
	psPathID.innerText:=psPath

	hotkeysIDList:="foregroundColorPickerKey|hudColorPickerKey|showHideLayerKey|quicklyNewLayerKey|brushRangeKey"
	hotkeysIDListArray:=StrSplit(hotkeysIDList, "|")
	hotkeysStringList:="FCPk|HUDCP|SHLayer|QCLayer|ModifyBrushKey"
	hotkeysStringListArray:=StrSplit(hotkeysStringList, "|")
	
	Loop, % hotkeysIDListArray.MaxIndex()
	{
		hotkeyID:=hotkeysIDListArray[a_index]
		hotKeyParameter:=hotkeysStringListArray[a_index]
		hotKey:=%hotKeyParameter%
		element := appWeb.document.getElementById(hotkeyID)
		element.innerHTML:="<kbd>" . hotKey . "</kbd>"		
	}

	FileRemoveDir,%A_ScriptDir%\Data\Locales,1 ;Remove old language file.
	CSV_Load(A_ScriptDir . "\Data\Lang.csv")
	TotalCols:=CSV_TotalCols(CSV_Identifier)
    TotalRows:=CSV_TotalRows(CSV_Identifier)
	LangTotal:=TotalCols-1

	langArray:=[]
	langId := appWeb.document.getElementById("langChoose")

	loop,%LangTotal%
	{
		LangName:=CSV_ReadCell(CSV_Identifier, 1, A_Index+1)

		If (G_Language=LangName)
			activeClass:=" class=""langList curLang"""
		Else
			activeClass:=" class=""langList"""

		langList.="<li" . activeClass . "><a href=""#"" onclick=""AHK('I18n','" . LangName . "');"">" . LangName . "</a></li>"

		langArray.Push(LangName)

	}
	langId.innerHTML:=langList

	loop,%LangTotal%
	{
		If (G_Language=langArray[a_index])
		{
			StringCol:=CSV_SearchRow(CSV_Identifier, G_Language, 1, 1)
			Break
		}
		Else
			StringCol:=2
	}
	langTag:=G_Language
}

I18n(langTag,initialization:=1){
	global
	local wp,i18nTag, langText, Name, String

	i18nTag := appWeb.document.getElementsByName("i18n")

	If (initialization>0)
	{
		langId := appWeb.document.getElementById("langChoose")
		langList:=""
		loop,%LangTotal%
		{
			LangName:=CSV_ReadCell(CSV_Identifier, 1, A_Index+1)

			If (langTag=LangName)
				activeClass:=" class=""langList curLang"""
			Else
				activeClass:=" class=""langList"""

			langList.="<li" . activeClass . "><a href=""#"" onclick=""AHK('I18n','" . LangName . "');"">" . LangName . "</a></li>"
		}
		newLangStyle=
		(
			<link rel="stylesheet" type="text/css" href="css/chooselang.css" />
		)
		langId.innerHTML:=newLangStyle . langList

		IniWrite, %langTag%, %A_scriptdir%\Data\Config.ini, Setting, lang

	}

	StringCol:=CSV_SearchRow(CSV_Identifier, langTag, 1, 1)
	If (StringCol=0)
		StringCol:=2 ; 找不到语言字符串或语言文件出错

    Loop, %TotalRows%
    {
        Name:=CSV_ReadCell(CSV_Identifier, A_Index+1, 1)
        String:=CSV_ReadCell(CSV_Identifier, A_Index+1, StringCol)
			String:=StrReplace(String, "\n", "`n")
		String:=StrReplace(String, "\t", "	")

		Try
		{
			Loop, % i18nTag.length
			{
				langText:=i18nTag[A_Index-1].lang
				If (langText=Name) && (langText!="")
				{
					i18nTag[A_Index-1].innerText:=String
					lang_%Name% := String
				}

			}
		}
		Catch, e
		{
			If (A_IsCompiled)
			{
				MsgBox, Language file Error!`nPlease download Apssistant again!
				Run, https://github.com/millionart/Apssistant/releases/latest
				ExitApp
			}
		}
    }

	Lang_shareTextRow:=CSV_SearchColumn(CSV_Identifier, "shareText", 1, 1)
	Lang_shareText:=CSV_ReadCell(CSV_Identifier, Lang_shareTextRow, StringCol)
	ShowPsVer()
}

PsNumToVer(ByRef n){
	global maxVerNum
	If (n<6) || (n>maxVerNum)
		n:=maxVerNum

	If n>14
	{
		v:=n-1
		v:="CC 20" . v
	}

	If n=14
		v:="CC"

	If n=17
		v:="CC 2015.5"

	If (n>8) && (n<14)
	{
		v:=n-7
		v:="CS" . v
	}

	If n=8
		v:="CS"

	If n<8
		v:=% n . ".0"

	Return v
}

PsVerConvert(v,r:="n"){
	v:=StrReplace(v, " ", "")
	v:=StrReplace(v, ".", "")

	ccOrCs:=SubStr(v, 1 , 2)

	If (ccOrCs="CC")
	{
		n:=StrReplace(v, "CC20", "")
		n:=n+1
		regVer:=(n-7)*10
	}

	If (ccOrCs="CS")
	{
		n:=StrReplace(v, "CS", "")
		n:=n+7
		regVer:=n
	}

	If v<8
	{
		n:=v
	}

	If v=CS
	{
		n:=8
	}

	If v=CS6
	{
		regVer:=60
	}

	If v=CC
	{
		n:=14
	}

	If v=CC20155
	{
		n:=17
	}

	If (r="r")
		result:=regVer
	else
		result:=n
	return result
}

ShowPsList()
{
	global
	IniRead, psPublicVer, %A_scriptdir%\Data\Config.ini, Setting, Psver, %psMaxVer%
	n:=PsVerConvert(psPublicVer)

	psCCList:= appWeb.document.getElementById("psCCList")
	psCCListHTML:=""
	ccNum:=maxVerNum-13
	loop,%ccNum%
	{
		psNum:=abs(a_index-maxVerNum-1)
		psVer:=% PsNumToVer(psNum)
		psVerCut:=StrReplace(psVer, "CC ", "")
		If (psVerCut="")
			psVerCut:="CC"

		If (psVer=psPublicVer)
			psCCListHTML.="<label class=""curPsVer"">" . psVerCut . "</label>"
		Else
			psCCListHTML.="<label for=""psVerCheck"" onclick=""AHK('SetPsVer','" . psNum . "')"">" . psVerCut . "</label>"
	}
	psCCList.innerHTML:=psCCListHTML

	psCSList:= appWeb.document.getElementById("psCSList")
	psCSListHTML:=""
	Loop, 6
	{
		psNum:=abs(a_index-14)
		psVer:=% PsNumToVer(psNum)
		psVerCut:=StrReplace(psVer, "CS", "")
		If (psVerCut="")
			psVerCut:="CS"

		If (psVer=psPublicVer)
			psCSListHTML.="<label class=""curPsVer"">" . psVerCut . "</label>"
		Else
			psCSListHTML.="<label for=""psVerCheck"" onclick=""AHK('SetPsVer','" . psNum . "')"">" . psVerCut . "</label>"
	}
	psCSList.innerHTML:=psCSListHTML

	psOLDList:= appWeb.document.getElementById("psOLDList")
	psOLDListHTML:=""
	loop,2
	{
		psNum:=abs(a_index-8)
		psVer:=% PsNumToVer(psNum)

		If (psVer=psPublicVer)
			psOLDListHTML.="<label class=""curPsVer"">" . psVer . "</label>"
		Else
			psOLDListHTML.="<label for=""psVerCheck"" onclick=""AHK('SetPsVer','" . psNum . "')"">" . psVer . "</label>"
	}
	psOLDList.innerHTML:=psOLDListHTML
}

SetPsVer(n)
{
	global
	psVer:=PsNumToVer(n)
	psPublicVer:=psVer
	IniWrite, %psVer%, %A_scriptdir%\Data\Config.ini, Setting, Psver
	ShowPsVer()
}

ShowPsVer()
{
	global
	local element
	; psVer:=psPublicVer
	element := appWeb.document.getElementById("choosePsVerButton")
	element.innerText:="Photoshop " . psPublicVer
}

SetHotkey(elementId)
{
	global
	;IniRead, hotkeysData, %A_scriptdir%\Data\Config.ini, Hotkeys
	;msgbox,%hotkeysData%

	if (A_PriorHotkey <> "~LButton" or A_TimeSincePriorHotkey > 800)
	{
		; 获得当前设置按键
		IniRead, FCPk, %A_scriptdir%\Data\Config.ini, Hotkeys, foregroundColorPickerKey
		IniRead, HUDCP, %A_scriptdir%\Data\Config.ini, Hotkeys, hudColorPickerKey
		IniRead, SHLayer, %A_scriptdir%\Data\Config.ini, Hotkeys, showHideLayerKey
		IniRead, QCLayer, %A_scriptdir%\Data\Config.ini, Hotkeys, quicklyNewLayerKey
		IniRead, ModifyBrushKey, %A_scriptdir%\Data\Config.ini, Hotkeys, brushRangeKey

		IniRead, perHotkey, %A_scriptdir%\Data\Config.ini, Hotkeys, %elementId%
		; 显示设置按键提示文字
		element := appWeb.document.getElementById(elementId)
		element.innerHTML:="请按下任意键"


		endKeys={Escape}{Enter}{LControl}{Tab}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Space}
		;matchKeys=
		start:
		; 等待按下任意键
		Input, hotKey, B I L1 E,%endKeys%

		If (InStr(ErrorLevel, "EndKey:")) && (WinActive("ahk_group __Webapp_windows"))
		{
			errorKeys:=StrReplace(ErrorLevel, "EndKey:", "")
			; msgbox, %errorKeys%
			; 如果按键是辅助键，忽略
			;msgbox,%errorKeys%
			If errorKeys in Space,Del,CapsLock,Enter,LAlt,RAlt,LShift,RShift,LWin,RWin,LControl,RControl
				Gosub, start

			If errorKeys in F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12
				hotkey:=errorKeys

			If (errorKeys = "BackSpace")
				element.innerHTML:="Null"

			If (errorKeys = "Escape")
				hotkey:=perHotkey
		}

		If hotkey in %FCPk%,%HUDCP%,%SHLayer%,%QCLayer%,%ModifyBrushKey%
		{
			; msgbox,%hotkey% || %FCPk% | %HUDCP% | %SHLayer% | %QCLayer% | %ModifyBrushKey%
			Loop, % hotkeysIDListArray.MaxIndex()
			{
				perHotkeyParameter:=hotkeysStringListArray[a_index]
			}Until elementId=hotkeysIDListArray[a_index]
			
			If (hotKey=%perHotkeyParameter%)
			{
				element.innerHTML:="<kbd>" . perHotkey . "</kbd>"						
			}
			else
			{
				msgbox,error
				Gosub, start
			}
		}
		Else
		{
			element.innerHTML:="<kbd>" . hotKey . "</kbd>"
			IniWrite, %hotKey%, %A_scriptdir%\Data\Config.ini, Hotkeys, %elementId%
		}
		Return
	}
}

FindPhotoshopPath()
{
	global
	regVer:=PsVerConvert(psPublicVer,"r")
	RegRead, psDir, HKLM, SOFTWARE\Adobe\Photoshop\%regVer%.0 , ApplicationPath

	fileSelectFile:=1
	If FileExist(psPath)
		psDir:=StrReplace(psPath, "Photoshop.exe" , "")
	Else If FileExist(psDir . "Photoshop.exe")
	{
		psPath:=psDir . "Photoshop.exe"
		fileSelectFile:=0
	}
	Else
		psDir:=A_ProgramFiles

	If (fileSelectFile=1)
		FileSelectFile, psPath, 1, %psDir%\Photoshop.exe, %Lang_PsDir%, Photoshop.exe	

	If (psPath!="")
	{
		psPathID.innerText:=psPath
		IniWrite, %psPath%, %A_scriptdir%\Data\Config.ini, Setting, PsPath		
	}
}

#include %A_scriptdir%\inc\Function.ahk
#include %A_scriptdir%\inc\Handle.ahk