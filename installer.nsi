Unicode True
ManifestDPIAware true

!include MUI2.nsh

!define APPLICATION_SOURCE "SourceDir"

!define PRODUCT_NAME "NSISBuilder"
!define PRODUCT_FILE "ComposeMultiplatformProject"

NAME "${PRODUCT_NAME}"
OutFile "Install ${PRODUCT_NAME}.exe"

RequestExecutionLevel user

InstallDir ""

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"



Function .onInit
  SetShellVarContext Current

  ${If} $INSTDIR == "" ; No /D= nor InstallDirRegKey?
    GetKnownFolderPath $INSTDIR ${FOLDERID_UserProgramFiles} ; This folder only exists on Win7+
    StrCmp $INSTDIR "" 0 +2 
    StrCpy $INSTDIR "$LocalAppData\Programs" ; Fallback directory

    StrCpy $INSTDIR "$INSTDIR\$(^Name)"
  ${EndIf}
FunctionEnd

Function un.onInit
  SetShellVarContext Current
FunctionEnd

;-------------------------------- 
;Installer Sections     

Section "MainSection" 
    SetOutPath $INSTDIR
    File /r "${APPLICATION_SOURCE}\*.*"

    ;create desktop shortcut
    CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" ""
 
    ;create start-menu items
    CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_FILE}.exe" "" "$INSTDIR\${PRODUCT_FILE}.exe" 0
 
    ;write uninstall information to the registry
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME} (remove only)"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"
 
    WriteUninstaller "$INSTDIR\Uninstall.exe"
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
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${PRODUCT_NAME}"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"  
 
SectionEnd

;--------------------------------    
;MessageBox Section

Function .onInstSuccess
  MessageBox MB_OK "You have successfully installed ${PRODUCT_NAME}. Use the desktop icon to start the program."
FunctionEnd
 
Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled ${PRODUCT_NAME}."
FunctionEnd