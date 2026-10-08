$puttyPath = "C:\Program Files\PuTTY"

$puttyDepedencies = @(
  "$puttyPath\plink.exe",
	"$puttyPath\pscp.exe",
	"$puttyPath\psftp.exe",
	"$puttyPath\puttygen.exe",
	"$puttyPath\pageant.exe"
 )
 
$wingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

$colorSuccess = @{ 
    BackgroundColor = 'Black'
    ForegroundColor = 'Green' 
}

$colorWarning = @{ 
    BackgroundColor = 'Black'
    ForegroundColor = 'Red' 
}


function Validate-Admin {

	if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		Write-Host "Please run this script as Administrator."
		return 
	} else {
		Write-Host "Running as Administrator."
	}
}
	
# Verify Winget is installed	

function Verify-Winget {
 
    if(-not(Test-Path -Path $wingetPath)) {
        try {
            Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$env:USERPROFILE\Downloads\WinGet.msixbundle"
            Add-AppxPackage -Path "$env:USERPROFILE\Downloads\WinGet.msixbundle"
			Write-Host "Winget has succesfully installed." @colorSuccess
        } catch {
            Write-Host "Winget failed to install" @colorWarning
			Write-Host "An error has occurred: $_" @colorWarning
        }
    }
}	
	
# Verify if Putty is installed. If it is not install it. 
	
function Install-Putty {
  
    if(-not(Test-Path -Path $puttyPath)){
        Write-Host "Putty path does not exist..." @colorWarning
        Write-Host "Putty will need to be installed..." @colorWarning
		try{
			winget install SimonTatham.PuTTY
			Write-Host "Putty has been succesfully installed" @colorSuccess
		} catch {
			Write-Host "Putty failed to installe" @colorWarning
			Write-Host "An error has occurred: $_" @colorWarning
		}
	}   	
 }

function Validate-Depedencies {
	
	foreach($i in $puttyDepedencies){
		if(-not(Test-Path -Path $plinkPath)){
			Write-Host "$i does not exist" @colorWarning
            return			
        }
	}
}

Validate-Admin
Verify-Winget
Install-Putty
Validate-Depedencies
