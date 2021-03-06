;NSIS Modern User Interface
;Installation OrionBanque
;Written by GG 0.02 with NSIS Open Source Compiler version 3.03
; 0.01 [31-10-18] GG - Premi�re version 
; 0.02 [11-01-19] GG - Ajout optionnel du raccourci vers le bureau via une CheckBox � cocher
;--------------------------------
;Include Modern ui
!include "MUI2.nsh"

SetCompressor /SOLID lzma

!define PRODUCT_NAME "OrionBanque"
!define PRODUCT_VERSION "orion_version"
!define PRODUCT_PUBLISHER "Cyril Charlier"
!define PRODUCT_WEB_SITE "http://www.orionbanque.fr"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\orionbanque.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define MUI_WELCOMEFINISHPAGE_BITMAP setup_bmp 
; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "orion_icone"
!define MUI_UNICON "ico_uninstall"

!define WELCOME_TITLE "Bienvenue dans l'installation de ${PRODUCT_NAME} ${PRODUCT_VERSION}"
 
!define UNWELCOME_TITLE 'Welcome to the extra 3 lines test uninstall wizard. \
This page has extra space for the UN-welcome title!'
 
!define FINISH_TITLE "Fin de l'installation de ${PRODUCT_NAME} ${PRODUCT_VERSION}"
 
!define UNFINISH_TITLE 'Finished the extra 3 lines test uninstall wizard. \
This page has extra space for the UN-finish title!'
 
!define MUI_WELCOMEPAGE_TITLE "${WELCOME_TITLE}"
!define MUI_FINISHPAGE_TITLE "${FINISH_TITLE}"
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_PAGE_CUSTOMFUNCTION_SHOW CheckBoxShortcut
 
; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Directory page
!insertmacro MUI_PAGE_DIRECTORY

Var mycheckbox ; Statut de la coche de cr�ation du raccourci sur le bureau
var click ; Flag de l'�tat coch� : 1 ou non coch� : 0

Function CheckBoxShortcut
${NSD_CreateCheckbox} 120u -18u 50% 12u "Cr�er un raccourci sur le bureau"
Pop $mycheckbox
${NSD_Check} $mycheckbox ; Check it by default
intop $click 1 + 0   ; Coch� par d�faut

SetCtlColors $mycheckbox "" ${MUI_BGCOLOR} ; Couleur du fond idem � celui par d�faut
GetFunctionAddress $0 OnCheckbox ; Lorsque l'on clique on appelle la fonction OnCheckBox
nsDialogs::OnClick $mycheckbox $0
nsDialogs::Show
FunctionEnd

Function OnClick
	Pop $0 # HWND
	MessageBox MB_OK clicky
FunctionEnd

Function OnCheckbox ; Fonction appel�e par le clic
	Pop $0 # HWND
	intop $click 1 - $click ; Si coch� (1), on d�coche (0) et inversement
FunctionEnd

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "French"
!insertmacro LANGFILE "French" = "Fran�ais" "Francais"

; Reserve files
ReserveFile /plugin InstallOptions.dll

; MUI end ------
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\out\SetupOrionBanque_orion_version.exe"
InstallDir "$PROGRAMFILES\OrionBanque"
ShowInstDetails show
ShowUnInstDetails show

BrandingText "NSIS 3.04 / � OrionBanque - Cyril Charlier"
VIAddVersionKey /LANG=${LANG_FRENCH} "ProductName" "OrionBanque"
VIAddVersionKey /LANG=${LANG_FRENCH} "ProductVersion" "orion_version"
VIAddVersionKey /LANG=${LANG_FRENCH} "Comments" "OrionBanque est un produit de Cyril Charlier"
VIAddVersionKey /LANG=${LANG_FRENCH} "CompanyName" "Cyril Charlier"
VIAddVersionKey /LANG=${LANG_FRENCH} "LegalCopyright" "� OrionBanque"
VIAddVersionKey /LANG=${LANG_FRENCH} "Copyright" "� OrionBanque 2019"
VIAddVersionKey /LANG=${LANG_FRENCH} "FileDescription" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_FRENCH} "FileVersion" "orion_version"
VIProductVersion "orion_version"

Section "SectionPrincipale" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try

  File /r orion_directory\*.*
  CreateDirectory "$SMPROGRAMS\OrionBanque"
  CreateShortCut "$SMPROGRAMS\OrionBanque\OrionBanque.lnk" "$INSTDIR\orionbanque.exe"
	intcmp $click 0 noshortcut ; Si la
  CreateShortCut "$DESKTOP\OrionBanque.lnk" "$INSTDIR\orionbanque.exe"
  noshortcut:
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\OrionBanque\D�sinstallation.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post

  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\orionbanque.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\orionbanque.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) a �t� d�sinstall� avec succ�s de votre ordinateur."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "�tes-vous certains de vouloir d�sinstaller totalement $(^Name) et tous ses composants ?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Rmdir /r "$INSTDIR"
  Delete "$SMPROGRAMS\OrionBanque\D�sinstallation.lnk"
  Delete "$DESKTOP\OrionBanque.lnk"
  Delete "$SMPROGRAMS\OrionBanque\OrionBanque.lnk"
  RMDir "$SMPROGRAMS\OrionBanque"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  strcmp "${PRODUCT_DIR_REGKEY}" "" fin
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
fin:
  SetAutoClose true
SectionEnd