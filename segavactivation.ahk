#SingleInstance Force

SegavMainTitle := "Segurmática Antivirus - Personal"
; SubMenuTitle
TechSupportTitle := "Soporte técnico"
NewLicenseTitle := "Nueva licencia..."
OpenLicenseText := "&Abrir"
; Buttons
TechSuppportButton := "Button13"
NewLicenseButton := "Button14"
OpenLicenseButton := "Button2"

; Box
PathSelector := "Edit1"
UnzipPath := A_ScriptDir "\7za.exe"
LicensePath := A_WorkingDir . "\license.7z"
OutPutPath := A_Temp . "\AutoSegavLic"
OutPutFile := OutPutPath . "\segav.lic"
ZipPassword := "ZipPassword"

if FileExist(UnzipPath)
    RunWait(UnzipPath . " x " . LicensePath . " -p" . ZipPassword . " -o" . OutPutPath . " -y",,"hide")

openLicenceWindow(){
    SetControlDelay(-1)
    ControlClick(TechSuppportButton, SegavMainTitle, TechSupportTitle,,, "NA")
}

openNewLicenseOption(){
    SetControlDelay(-1)
    ControlClick( NewLicenseButton, SegavMainTitle, NewLicenseTitle,,, "NA" )
}

SetNewLicense(){
    SetControlDelay(-1)
    WinWait(NewLicenseTitle)
    WinActivate(NewLicenseTitle)
    ControlFocus(PathSelector)
    ControlSetText(OutPutFile, PathSelector, NewLicenseTitle,,, "NA")
    ControlClick( OpenLicenseButton, NewLicenseTitle, OpenLicenseText,,, "NA" )
}

if WinExist("ahk_class #32770") or WinExist("ahk_exe SegAV.exe"){
    WinActivate
    isOnTechWindow := ControlGetEnabled( TechSuppportButton , SegavMainTitle , TechSupportTitle )
    
    if ( isOnTechWindow) {
        openLicenceWindow()
        openNewLicenseOption()
        SetNewLicense()
    }

} else {
    Run("SegAV.exe")
    WinWait(SegavMainTitle)
    WinActivate(SegavMainTitle)
    
    isOnTechWindow := ControlGetEnabled( TechSuppportButton , SegavMainTitle , TechSupportTitle )
    
    if ( isOnTechWindow ) {
        openLicenceWindow()
        openNewLicenseOption()
        SetNewLicense()

    }


}
