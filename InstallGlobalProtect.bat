@echo off
setlocal
 
NET FILE >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run as administrator.
	pause
	exit /b 1
)

set "GlobalProtectPath=C:\Program Files\Palo Alto Networks\GlobalProtect\PanGPA.exe"
set "winget_path=C:\Users\%USERNAME%\AppData\Local\Microsoft\WindowsApps\winget.exe"
 
IF EXIST "%GlobalProtectPath%" (
    echo Palo Alto Global Protect is already installed.
	goto :EOF
)

IF EXIST "%winget_path%" (
         msiexec.exe /i GlobalProtect.msi /quiet PORTAL="portal.acme.com"
) ELSE (
	winget install --id=APP-ID1 -e  
	winget install --id=APP-ID2 -e
       IF %ERRORLEVEL% NEQ 0 (
            echo Error occurred! Error Level: %ERRORLEVEL%
        ) ELSE (
             echo Command executed successfully!
        )
)

echo Done 
pause
EXIT /B 0
