
V_CurrentVer()
{
	Global f_CurrentVer
	f_CurrentVer = 0.8.4.0
	IniDelete, %A_scriptdir%\Data\Config.ini,Setting,Apssistantver
	;IniWrite, %f_CurrentVer%, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver
}

V_Trans()
{
	Global Regver, PsCSver, PSCSverList,PsCSverNo,GuiGetPsver,curPsver
	
	PSCSverList=6|7|CS|CS2|CS3|CS4|CS5|CS6|CC
	;GuiGetPsver=%PsCSver%
	;curPsver=%Regver%
	IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, CS5
	If PsCSver<8
	{
		Regver=%PsCSver%
	}
	else If PsCSver=CS
		Regver=8
	else If PsCSver=CC
		Regver=14
	else
	{
		stringreplace, RegCSver, PsCSver, CS,, All
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
	else
	{
		stringreplace, curPsCSver, GuiGetPsver, CS,, All
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
        Name   = %Name%
		String = %String%

		StringReplace, String, String, \n, `n, All
		StringReplace, String, String, \t, % "	", All

        lang_%Name% := String

        Row:=++Row
    }

	return
}

#include %A_scriptdir%\inc\csv.ahk