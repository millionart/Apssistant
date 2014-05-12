; _reg64.ahk ver 0.1 by tomte
; Script for AutoHotkey   ( http://www.autohotkey.com/ )
;
; Provides RegRead64() and RegWrite64() functions that do not redirect to Wow6432Node on 64-bit machines
; RegRead64() and RegWrite64() takes the same parameters as regular AHK RegRead and RegWrite commands, plus one optional DataMaxSize param for RegRead64()
;
; RegRead64() can handle the same types of values as AHK RegRead:
; REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ, REG_DWORD, and REG_BINARY
; (values are returned in same fashion as with RegRead - REG_BINARY as hex string, REG_MULTI_SZ split with linefeed etc.)
;
; RegWrite64() can handle REG_SZ, REG_EXPAND_SZ and REG_DWORD only
;
; Usage:
; myvalue := RegRead64("HKEY_LOCAL_MACHINE", "SOFTWARE\SomeCompany\Product\Subkey", "valuename")
; RegWrite64("REG_SZ", "HKEY_LOCAL_MACHINE", "SOFTWARE\SomeCompany\Product\Subkey", "valuename", "mystring")
; If the value name is blank/omitted the subkey's default value is used, if the value is omitted with RegWrite64() a blank/zero value is written
;

RegRead64(sRootKey, sKeyName, sValueName = "", DataMaxSize=1024) {
   HKEY_CLASSES_ROOT   := 0x80000000   ; http://msdn.microsoft.com/en-us/library/aa393286.aspx
   HKEY_CURRENT_USER   := 0x80000001
   HKEY_LOCAL_MACHINE   := 0x80000002
   HKEY_USERS         := 0x80000003
   HKEY_CURRENT_CONFIG   := 0x80000005
   HKEY_DYN_DATA      := 0x80000006
   HKCR := HKEY_CLASSES_ROOT
   HKCU := HKEY_CURRENT_USER
   HKLM := HKEY_LOCAL_MACHINE
   HKU    := HKEY_USERS
   HKCC := HKEY_CURRENT_CONFIG
   
   REG_NONE             := 0   ; http://msdn.microsoft.com/en-us/library/ms724884.aspx
   REG_SZ                := 1
   REG_EXPAND_SZ         := 2
   REG_BINARY            := 3
   REG_DWORD            := 4
   REG_DWORD_BIG_ENDIAN   := 5
   REG_LINK            := 6
   REG_MULTI_SZ         := 7
   REG_RESOURCE_LIST      := 8

   KEY_QUERY_VALUE := 0x0001   ; http://msdn.microsoft.com/en-us/library/ms724878.aspx
   KEY_WOW64_64KEY := 0x0100   ; http://msdn.microsoft.com/en-gb/library/aa384129.aspx (do not redirect to Wow6432Node on 64-bit machines)
   KEY_SET_VALUE   := 0x0002
   KEY_WRITE      := 0x20006

   myhKey := %sRootKey%      ; pick out value (0x8000000x) from list of HKEY_xx vars
   IfEqual,myhKey,, {      ; Error - Invalid root key
      ErrorLevel := 3
      return ""
   }
   
   RegAccessRight := KEY_QUERY_VALUE + KEY_WOW64_64KEY
   
   DllCall("Advapi32.dll\RegOpenKeyEx", "uint", myhKey, "str", sKeyName, "uint", 0, "uint", RegAccessRight, "uint*", hKey)   ; open key
   DllCall("Advapi32.dll\RegQueryValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint*", sValueType, "uint", 0, "uint", 0)      ; get value type
   If (sValueType == REG_SZ or sValueType == REG_EXPAND_SZ) {
      VarSetCapacity(sValue, vValueSize:=DataMaxSize)
      DllCall("Advapi32.dll\RegQueryValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", 0, "str", sValue, "uint*", vValueSize)   ; get string or string-exp
   } Else If (sValueType == REG_DWORD) {
      VarSetCapacity(sValue, vValueSize:=4)
      DllCall("Advapi32.dll\RegQueryValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", 0, "uint*", sValue, "uint*", vValueSize)   ; get dword
   } Else If (sValueType == REG_MULTI_SZ) {
      VarSetCapacity(sTmp, vValueSize:=DataMaxSize)
      DllCall("Advapi32.dll\RegQueryValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", 0, "str", sTmp, "uint*", vValueSize)   ; get string-mult
      sValue := ExtractData(&sTmp) "`n"
      Loop {
         If (errorLevel+2 >= &sTmp + vValueSize)
            Break
         sValue := sValue ExtractData( errorLevel+1 ) "`n"
      }
   } Else If (sValueType == REG_BINARY) {
      VarSetCapacity(sTmp, vValueSize:=DataMaxSize)
      DllCall("Advapi32.dll\RegQueryValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", 0, "str", sTmp, "uint*", vValueSize)   ; get binary
      sValue := ""
      SetFormat, integer, h
      Loop %vValueSize% {
         hex := SubStr(Asc(SubStr(sTmp,A_Index,1)),3)
         StringUpper, hex, hex
         sValue := sValue hex
      }
      SetFormat, integer, d
   } Else {            ; value does not exist or unsupported value type
      DllCall("Advapi32.dll\RegCloseKey", "uint", hKey)
      ErrorLevel := 1
      return ""
   }
   DllCall("Advapi32.dll\RegCloseKey", "uint", hKey)
   return sValue
}

RegWrite64(sValueType, sRootKey, sKeyName, sValueName = "", sValue = "") {
   HKEY_CLASSES_ROOT   := 0x80000000   ; http://msdn.microsoft.com/en-us/library/aa393286.aspx
   HKEY_CURRENT_USER   := 0x80000001
   HKEY_LOCAL_MACHINE   := 0x80000002
   HKEY_USERS         := 0x80000003
   HKEY_CURRENT_CONFIG   := 0x80000005
   HKEY_DYN_DATA      := 0x80000006
   HKCR := HKEY_CLASSES_ROOT
   HKCU := HKEY_CURRENT_USER
   HKLM := HKEY_LOCAL_MACHINE
   HKU    := HKEY_USERS
   HKCC := HKEY_CURRENT_CONFIG
   
   REG_NONE             := 0   ; http://msdn.microsoft.com/en-us/library/ms724884.aspx
   REG_SZ                := 1
   REG_EXPAND_SZ         := 2
   REG_BINARY            := 3
   REG_DWORD            := 4
   REG_DWORD_BIG_ENDIAN   := 5
   REG_LINK            := 6
   REG_MULTI_SZ         := 7
   REG_RESOURCE_LIST      := 8

   KEY_QUERY_VALUE := 0x0001   ; http://msdn.microsoft.com/en-us/library/ms724878.aspx
   KEY_WOW64_64KEY := 0x0100   ; http://msdn.microsoft.com/en-gb/library/aa384129.aspx (do not redirect to Wow6432Node on 64-bit machines)
   KEY_SET_VALUE   := 0x0002
   KEY_WRITE      := 0x20006
   
   myhKey := %sRootKey%         ; pick out value (0x8000000x) from list of HKEY_xx vars
   myValueType := %sValueType%      ; pick out value (0-8) from list of REG_SZ,REG_DWORD etc. types
   IfEqual,myhKey,, {      ; Error - Invalid root key
      ErrorLevel := 3
      return ErrorLevel
   }
   IfEqual,myValueType,, {   ; Error - Invalid value type
      ErrorLevel := 2
      return ErrorLevel
   }
   
   RegAccessRight := KEY_QUERY_VALUE + KEY_WOW64_64KEY + KEY_WRITE
   
   DllCall("Advapi32.dll\RegCreateKeyEx", "uint", myhKey, "str", sKeyName, "uint", 0, "uint", 0, "uint", 0, "uint", RegAccessRight, "uint", 0, "uint*", hKey)   ; open/create key
   If (myValueType == REG_SZ or myValueType == REG_EXPAND_SZ) {
      vValueSize := StrLen(sValue) + 1
      DllCall("Advapi32.dll\RegSetValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", myValueType, "str", sValue, "uint", vValueSize)   ; write string
   } Else If (myValueType == REG_DWORD) {
      vValueSize := 4
      DllCall("Advapi32.dll\RegSetValueEx", "uint", hKey, "str", sValueName, "uint", 0, "uint", myValueType, "uint*", sValue, "uint", vValueSize)   ; write dword
   } Else {      ; REG_MULTI_SZ, REG_BINARY, or other unsupported value type
      ErrorLevel := 2
   }
   DllCall("Advapi32.dll\RegCloseKey", "uint", hKey)
   return ErrorLevel
}

ExtractData(pointer) {  ; http://www.autohotkey.com/forum/viewtopic.php?p=91578#91578 SKAN
   Loop {
         errorLevel := ( pointer+(A_Index-1) )
         Asc := *( errorLevel )
         IfEqual, Asc, 0, Break ; Break if NULL Character
         String := String . Chr(Asc)
      }
   Return String
}

; Thanks Chris, Lexikos and SKAN
; http://www.autohotkey.com/forum/topic37710-15.html
; http://www.autohotkey.com/forum/viewtopic.php?p=235522