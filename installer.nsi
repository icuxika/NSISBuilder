Unicode True
ManifestDPIAware true

;-------------------------------- 
; Product info
!define PRODUCT_RESOURCE "SourceDir"
!define PRODUCT_NAME "NSISBuilder"
!define PRODUCT_FILE "ComposeMultiplatformProject"
!define PRODUCT_URI_SCHEME "NSISBuilder"

NAME "${PRODUCT_NAME}"
OutFile "Install ${PRODUCT_NAME}.exe"

;-------------------------------- 
!define UNINSTKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${UNINSTKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME "CurrentUser"
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_INSTDIR "$(^Name)"
!define MULTIUSER_USE_PROGRAMFILES64
!define MULTIUSER_INSTALLMODE_COMMANDLINE

;--------------------------------
;Language Selection Dialog Settings
!define MUI_LANGDLL_ALWAYSSHOW
!define MUI_LANGDLL_REGISTRY_ROOT "HKCU" 
!define MUI_LANGDLL_REGISTRY_KEY "Software\${PRODUCT_NAME}" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!include MultiUser.nsh
!include MUI2.nsh
!include LogicLib.nsh

;RequestExecutionLevel user
InstallDir ""

!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_SHOW addLicense
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_NOTCHECKED
    !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
    !define MUI_FINISHPAGE_SHOWREADME $INSTDIR\readme.txt
    !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
    !define MUI_FINISHPAGE_LINK "https://www.aprillie.com/cache/"
    !define MUI_FINISHPAGE_LINK_LOCATION "https://www.aprillie.com/cache/"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

!include "languages\SimpChinese.nsh"
!include "languages\English.nsh"

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
  !insertmacro MULTIUSER_INIT
  File "/oname=$PluginsDir\License-SimpChinese.txt" "licenses\License-SimpChinese.txt"
  File "/oname=$PluginsDir\License-English.txt" "licenses\License-English.txt"
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
  !insertmacro MULTIUSER_UNINIT
FunctionEnd

;-------------------------------- 
;Installer Sections     

Section "MainSection" 
  SetOutPath $INSTDIR
  File /r "${PRODUCT_RESOURCE}\*.*"
  File readme.txt
  File index.html

  ;create desktop shortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" ""

  ;create start-menu items
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" "" "$INSTDIR\${PRODUCT_FILE}.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Call ${PRODUCT_NAME}.lnk" "$INSTDIR\index.html"

  ;write uninstall information to the registry
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr ShCtx "${UNINSTKEY}" DisplayName "$(^Name)"
  WriteRegStr ShCtx "${UNINSTKEY}" UninstallString '"$INSTDIR\Uninstall.exe"'
  WriteRegStr ShCtx "${UNINSTKEY}" $MultiUser.InstallMode 1

  ;registering the application handling the custom uri scheme
  DeleteRegKey HKCR "${PRODUCT_URI_SCHEME}"
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}" "" "URL:${PRODUCT_NAME} Protocol"
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}" "URL Protocol" ""
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}\DefaultIcon" "" "$INSTDIR\${PRODUCT_FILE}.exe"
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}\shell" "" ""
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}\shell\open" "" ""
  WriteRegStr HKCR "${PRODUCT_URI_SCHEME}\shell\open\command" "" "$INSTDIR\${PRODUCT_FILE}.exe %1"
SectionEnd

;--------------------------------    
;Uninstaller Section  
Section "Uninstall"
 
  ;Delete Files 
  RMDir /r "$INSTDIR\*.*"    
 
  ;Remove the installation directory
  RMDir "$INSTDIR"
 
  ;Delete Start Menu Shortcuts
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  RmDir  "$SMPROGRAMS\${PRODUCT_NAME}"
 
  ;Delete Uninstaller And Unistall Registry Entries
  DeleteRegKey ShCtx "${UNINSTKEY}"

  ;Delete the Custom URI Scheme
  DeleteRegKey HKCR "${PRODUCT_URI_SCHEME}"
SectionEnd

;--------------------------------    
;MessageBox Section

Function .onInstSuccess
  MessageBox MB_OK "$(alreadyInstalled)"
FunctionEnd
 
Function un.onUninstSuccess
  MessageBox MB_OK "$(alreadyUninstalled)"
FunctionEnd

Function LaunchLink
  ExecShell "" "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
FunctionEnd

Function addLicense
  ;use !echo and DetailPrint -> https://nsis.sourceforge.io/Reference/!echo

  ClearErrors

  ${If} $LANGUAGE == "2052"
    ;current language is SimpChinese
    FileOpen $0 "$PluginsDir\License-SimpChinese.txt" r
    IfErrors exit
  ${Else}
    ;current language is English
    FileOpen $0 "$PluginsDir\License-English.txt" r
    IfErrors exit
  ${EndIf}
  ;$R0 is the file content 
  ;$R1 is the line of content read from the file each time
  ;$R2 is the file size
  FileSeek $0 0 END $R2
  FileSeek $0 0 SET
  StrCpy $R0 ""
  ${Do}
    FILEREADUTF16LE $0 $R1
    ${If} $R1 == ""
      ${ExitDo}
    ${EndIf}
    StrCpy $R0 $R0$R1
  ${Loop}
  FileClose $0

  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1000
  SendMessage $0 ${EM_SETLIMITTEXT} $R2 0
  SendMessage $0 ${WM_SETTEXT} 0 "STR:$R0"
exit:
 
FunctionEnd