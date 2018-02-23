
V_CurrentVer()
{
	Global f_CurrentVer
	f_CurrentVer = 0.9.0.0
	IniDelete, %A_scriptdir%\Data\Config.ini,Setting,Apssistantver
	;IniWrite, %f_CurrentVer%, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver
}

V_Trans()
{
	Global Regver, PsCSver, PSCSverList,PsCSverNo,GuiGetPsver,curPsver
	
	PSCSverList=6|7|CS|CS2|CS3|CS4|CS5|CS6|CC|CC 2014|CC 2015|CC 2015.5|CC 2017|CC 2018
	;GuiGetPsver=%PsCSver%
	;curPsver=%Regver%
	IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CC
	If PsCSver<8
	{
		Regver=%PsCSver%
	}
	else If PsCSver=CS
		Regver=8
	else If PsCSver=CC
		Regver=14
	else If PsCSver=CC 2014
		Regver=15
	else If PsCSver=CC 2015
		Regver=16
	else If PsCSver=CC 2015.5
		Regver=17
	else If PsCSver=CC 2017
		Regver=18
	else If PsCSver=CC 2018
		Regver=19
	else
	{
		RegCSver:=StrReplace(RegCSver, "CS", "")
		Regver:=RegCSver+7
	}
	PsCSverNo:=Regver-5
	
	If GuiGetPsver<8
	{
		curPsver=%GuiGetPsver%
	}
	else If GuiGetPsver=CS
		curPsver=8
	else If GuiGetPsver=CC
		curPsver=14
	else If GuiGetPsver=CC 2014
		curPsver=15
	else If GuiGetPsver=CC 2015
		curPsver=16
	else If GuiGetPsver=CC 2015.5
		curPsver=17
	else If GuiGetPsver=CC 2017
		curPsver=18
	else If GuiGetPsver=CC 2018
		curPsver=19
	else
	{
		curPsCSver:=StrReplace(GuiGetPsver, "CS", "")
		curPsver:=curPsCSver+7
	}
}

G_ReadLanguage()
{
	Global
	Local Name, String
	IniRead, Fontsize, %A_scriptdir%\Data\Config.ini, General, fontsize, 9
	IniRead, Fontname, %A_scriptdir%\Data\Config.ini, General, fontname, Segoe UI
	IniRead, G_Language, %A_scriptdir%\Data\Config.ini, Setting, lang, English

	FileRemoveDir,%A_ScriptDir%\Data\Locales,1 ;Remove old language file.
	CSV_Load(A_ScriptDir . "\Data\Language.csv")
	TotalCols:=CSV_TotalCols(CSV_Identifier)
	LangTotal:=TotalCols-1
	stringStartNum=2

    TotalRows:=CSV_TotalRows(CSV_Identifier)   
	StringCol:=CSV_SearchRow(CSV_Identifier, G_Language, 1, 1)
	LangNum:=StringCol-1

    Row=2
    Loop, %TotalRows%
    {
				;msgbox,%Row%
        Name:=CSV_ReadCell(CSV_Identifier, Row, 1)
        String:=CSV_ReadCell(CSV_Identifier, Row, StringCol)
		
		String:=StrReplace(String, "\n", "`n")
		String:=StrReplace(String, "\t", "	")

        Name   = %Name%
		String = %String%

		If (A_IsCompiled)
		{
			Try
				lang_%Name% := String
			Catch, e
			{
				MsgBox, Language file Error!`nPlease download Apssistant again!
				Run, https://github.com/millionart/Apssistant/releases/latest
				ExitApp
			}
		}
		Else
		{
			lang_%Name% := String
		}


        Row:=++Row
    }
}

#include %A_scriptdir%\inc\csv.ahk