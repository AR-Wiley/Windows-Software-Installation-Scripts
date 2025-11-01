function Install-NotepadPP {

    #Confirm running as admin

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run this script as Administrator."
        return 
    } else {
        Write-Host "Running as Administrator."
    }
  
   $notepadPPPath = "C:\Program Files\Notepad++\notepad++.exe"

    if (Test-Path -Path $notepadPPPath) {
       Write-Host "Notepad++ is already installed."
       return 
    }

    # Verify Winget is installed

    $wingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
 
    if (Test-Path -Path $wingetPath) {
        winget install -e --id Notepad++.Notepad++ --silent
    } else {
        try {
            Install-Script -Name winget-install
            Write-Host "Winget is now installed"
        } catch {
            Write-Host "Winget failed to install"
        }
    }
    
    Try{
        Invoke-WebRequest `
            -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest/download/npp.8.2.1.Installer.exe" `
            -OutFile "$env:TEMP\npp_installer.exe"
        Write-Host "NotePad++ is now installed"
    } Catch {
        Write-Host "Failed to install"
    }   

    Start-Process -FilePath "$env:TEMP\npp_installer.exe" -ArgumentList "/S" -NoNewWindow -Wait

    Remove-Item "$env:TEMP\npp_installer.exe"
}

Install-NotepadPP