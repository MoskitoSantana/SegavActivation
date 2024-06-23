#SingleInstance Force

NormalizePath(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    buf := Buffer(cc*2)
    DllCall("GetFullPathName", "str", path, "uint", cc, "ptr", buf, "ptr", 0)
    return StrGet(buf)
}

OutPutPath := NormalizePath(A_Temp . "\AutoSegavLic")
UnzipPath := NormalizePath(OutPutPath "\7za.exe")
LicensePath := NormalizePath(OutPutPath "\license.7z")

OutPutFile := NormalizePath(OutPutPath . "\segav.lic")

FileInstall("7za.exe" , UnzipPath, 1)
FileInstall("license.7z", LicensePath, 1)
FileInstall("7za.dll" , OutPutPath "\7za.dll", 1)
FileInstall("7zxa.dll" , OutPutPath "\7zxa.dll", 1)
FileInstall("Readme.md", A_ScriptDir "\Readme.md", 1)

SegavMainTitle := "Segurmática Antivirus - Personal"

OpenLicenseText := "&Abrir"
NewLicenseTitle := "Nueva licencia..."
TechSupportTitle := "Soporte técnico"

PathSelector := "Edit1"
NewLicenseButton := "Button14"
OpenLicenseButton := "Button2"
TechSuppportButton := "Button13"

ZipPassword := "ZipPassword"

if FileExist(UnzipPath)
    RunWait(UnzipPath . " x " . LicensePath . " -p" . ZipPassword . " -o" . OutPutPath . " -y",,"hide")
else {
    MsgBox("No se encontro un fichero 7z con licencia valida")
    Exit(1)
}

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
    if FileExist(OutPutFile) {
        ControlFocus(PathSelector)
        ControlSetText(OutPutFile, PathSelector, NewLicenseTitle,,, "NA")
        ControlClick( OpenLicenseButton, NewLicenseTitle, OpenLicenseText,,, "NA" )
        Sleep 3000    
        FileDelete(LicensePath)
        FileDelete(OutPutFile)
        Exit(0)
    } else {
        MsgBox("No se encontro una licencia valida")
        Exit(1)
    }
}

if WinExist("ahk_class #32770") or WinExist("ahk_exe SegAV.exe"){
    WinActivate
    
    isOnTechWindow := ControlGetEnabled( TechSuppportButton , SegavMainTitle , TechSupportTitle )
    
    if ( isOnTechWindow) {
        openLicenceWindow()
        Sleep 500
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
        Sleep 500
        openNewLicenseOption()
        SetNewLicense()
    }
}
