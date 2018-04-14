#NoEnv
#SingleInstance, force
#NoTrayIcon
SendMode Input



#Include Lib\Webapp.ahk
__Webapp_AppStart:
;<< Header End >>
Initialization()
I18n(G_Language,0)

;Get our HTML DOM object
iWebCtrl := getDOM()

;Change App name on run-time
setAppName("APssistant")

; cut auto run main thread.
OnMessage(0x201, "WM_LBUTTONDOWN")

Return

WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}

; Webapp.ahk-only Sensitive hotkeys
#IfWinActive, ahk_group __Webapp_windows

LButton Up::
Click
Return

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


; function to run when page is loaded
app_page(NewURL) {
	wb := getDOM()
	
	if InStr(NewURL,"Config.html") {
		disp_info()
	}
}

disp_info() {
	wb := getDOM()
	Sleep, 10
	x := wb.document.getElementById("ahk_info")
	x.innerHTML := "<i>Webapp.ahk is currently running on " . GetAHK_EnvInfo() . ".</i>"
}

Run(t) {
	global
	If (t="paypal")
		Run, https://www.paypal.me/millionart


	If (t="twitter")
		Run, https://twitter.com/intent/tweet?text=%Lang_shareText%&url=%DeviantArt%&hashtags=Photoshop


	If (t="facebook")
		Run, https://www.facebook.com/sharer/sharer.php?u=%DeviantArt%


	If (t="reddit")
		Run, https://www.reddit.com/submit?url=%DeviantArt%&title=%Lang_shareText%&text=%Lang_shareText%


	If (t="github")
		Run, https://github.com/millionart/Apssistant

	If (t="weibo")
	{
		url=%Github%/releases/latest
		Lang_shareText:=StrReplace(Lang_shareText, "#", "%23")		
		If (G_Language = "简体中文")
			langTag:="zh_cn"
		Else
			langTag:="zh_tw"

		Run, https://service.weibo.com/share/share.php?url=%url%&language=%langTag%&title=%Lang_shareText%
	}
	else
		Run, %t%
}

Initialization(){
	global
	local wp,langId
	Github:="https://github.com/millionart/Apssistant"
	DeviantArt:="https://www.deviantart.com/deviation/160950828"

	IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English

	FileRemoveDir,%A_ScriptDir%\Data\Locales,1 ;Remove old language file.
	CSV_Load(A_ScriptDir . "\Data\Lang.csv")
	TotalCols:=CSV_TotalCols(CSV_Identifier)
    TotalRows:=CSV_TotalRows(CSV_Identifier)
	LangTotal:=TotalCols-1

	langArray:=[]
	wb := getDOM()
	langId := wb.document.getElementById("langChoose")

	loop,%LangTotal%
	{
		LangName:=CSV_ReadCell(CSV_Identifier, 1, A_Index+1)

		If (G_Language=LangName)
			activeClass:=" class=""langLi curLang"""
		Else
			activeClass:=" class=""langLi"""

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

	wb := getDOM()

	i18nTag := wb.document.getElementsByName("i18n")

	If (initialization>0)
	{
		langId := wb.document.getElementById("langChoose")
		langList:=""
		loop,%LangTotal%
		{
			LangName:=CSV_ReadCell(CSV_Identifier, 1, A_Index+1)

			If (langTag=LangName)
				activeClass:=" class=""langLi curLang"""
			Else
				activeClass:=" class=""langLi"""

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
	Lang_shareTextRow:=CSV_SearchColumn(CSV_Identifier, "shareText", 1, 1)
	Lang_shareText:=CSV_ReadCell(CSV_Identifier, Lang_shareTextRow, StringCol)

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
}

GetAHK_EnvInfo(){
	return "AutoHotkey v" . A_AhkVersion . " " . (A_IsUnicode?"Unicode":"ANSI") . " " . (A_PtrSize*8) . "-bit"
}
Multiply(a,b) {
	;MsgBox % a " * " b " = " a*b
	return a * b
}
MyButton1() {
	wb := getDOM()
	MsgBox % wb.Document.getElementById("MyTextBox").Value
}
MyButton2() {
	wb := getDOM()
	FormatTime, TimeString, %A_Now%, dddd MMMM d, yyyy HH:mm:ss
    Random, x, %min%, %max%
	data := "AHK Version " A_AhkVersion " - " (A_IsUnicode ? "Unicode" : "Ansi") " " (A_PtrSize == 4 ? "32" : "64") "bit`nCurrent time: " TimeString "`nRandom number: " x
	wb.Document.getElementById("MyTextBox").value := data
}

#include %A_scriptdir%\inc\Handle.ahk