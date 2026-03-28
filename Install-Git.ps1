
function Install_Git {

    #Confirm running as admin

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run this script as Administrator."
        return 
    } else {
        Write-Host "Running as Administrator."
    }

    
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    
    if ($gitCmd) {
        Write-Host "Git is already installed..."
        return
    }


    # Verify Winget is installed

    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
 
    if ($wingetCmd) {
        winget install --id Git.Git -e --source winget
    } else {
        try {
            Install-Script -Name winget-install
            Write-Host "Winget is now installed..."
        } catch {
            Write-Host "Winget failed to install..."
        }
    }

    $cache = "$env:LOCALAPPDATA\Temp\Winget"

    if (Test-Path $cache) {
        Get-ChildItem $cache -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    #Confirm Git is installed 

    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    
    if ($gitCmd) {
        git --version
    } else {
        Write-Host "Something went wrong..."
    }

}
