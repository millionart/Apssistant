
V_CurrentVer()
{
	Global f_CurrentVer
	f_CurrentVer = 0.9.3.1
	IniDelete, %A_scriptdir%\Data\Config.ini,Setting,Apssistantver
	;IniWrite, %f_CurrentVer%, %A_scriptdir%\Data\Config.ini, Setting, Apssistantver
}

V_Trans()
{
	/*
	CC 2018		120.0
	CC 2017		110.0
	CC 2015.5	100.0
	CC 2015		90.0
	CC 2014		80.0
	CC			70.0

	CS6			60.0
	CS5.1		55.0
	CS5			12.0
	CS4			11.0
	CS3			10.0
	CS2			9.0
	CS			8.0

	7			7.0
	6			6.0
	*/
	Global
	PSCSverList:="CC 2019|CC 2018|CC 2017|CC 2015.5|CC 2015|CC 2014|CC|CS6|CS5|CS4|CS3|CS2|CS|7|6"
	psVerArray:=StrSplit(PSCSverList, "|")

	IniRead, PsCSver, %A_scriptdir%\Data\Config.ini, Setting, Psver, % psVerArray[1]

	Loop, % psVerArray.MaxIndex()
	{
		If (PsCSver=psVerArray[a_index])
		{
			PsCSverNo=%a_index%
			Break
		}
		Else
			PsCSverNo=1
	}

	ccOrCs:=SubStr(PsCSver, 1 , 2)

	If (ccOrCs="CC")
	{
		curPsver:=StrReplace(PsCSver, "CC 20", "")
		curPsver:=curPsver+1
		Regver:=(curPsver-7)*10
	}
	If (ccOrCs="CS")
	{
		curPsver:=StrReplace(PsCSver, "CS", "")
		curPsver:=curPsver+7
		Regver:=curPsver
	}

	If GuiGetPsver<8
	{
		curPsver=%GuiGetPsver%
	}
	If GuiGetPsver=CS
	{
		curPsver=8
	}
	If GuiGetPsver=CS6
	{
		Regver=60
	}
	If GuiGetPsver=CC
	{
		curPsver=14
	}
	If GuiGetPsver=CC 2015.5
	{
		curPsver=17
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
    TotalRows:=CSV_TotalRows(CSV_Identifier)
	LangTotal:=TotalCols-1

	gui_Language:= 
	langArray:=[]

	loop,%LangTotal%
	{
		LangName:=CSV_ReadCell(CSV_Identifier, 1, A_Index+1)
		gui_Language .=LangName . "|"

		langArray.Push(LangName)
	}

	loop,%LangTotal%
	{
		If (G_Language=langArray[a_index])
		{
			StringCol:=CSV_SearchRow(CSV_Identifier, G_Language, 1, 1)
			Break
		}
		Else
			StringCol=2
	}

	LangNum:=StringCol-1



    Row=2
    Loop, %TotalRows%
    {
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

#include %A_scriptdir%\Lib\csv.ahk