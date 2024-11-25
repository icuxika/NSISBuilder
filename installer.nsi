Unicode True
ManifestDPIAware true

;-------------------------------- 
; Product info
!define PRODUCT_RESOURCE "SourceDir"
!define PRODUCT_NAME "NSISBuilder"
!define PRODUCT_FILE "ComposeMultiplatformProject"

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

;RequestExecutionLevel user
InstallDir ""

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
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

  ;create desktop shortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" ""

  ;create start-menu items
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" "" "$INSTDIR\${PRODUCT_FILE}.exe" 0

  ;write uninstall information to the registry
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr ShCtx "${UNINSTKEY}" DisplayName "$(^Name)"
  WriteRegStr ShCtx "${UNINSTKEY}" UninstallString '"$INSTDIR\Uninstall.exe"'
  WriteRegStr ShCtx "${UNINSTKEY}" $MultiUser.InstallMode 1
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
SectionEnd

;--------------------------------    
;MessageBox Section

Function .onInstSuccess
  MessageBox MB_OK "$(alreadyInstalled)"
FunctionEnd
 
Function un.onUninstSuccess
  MessageBox MB_OK "$(alreadyUninstalled)"
FunctionEnd