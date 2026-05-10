@echo off
setlocal

set "CLAUDE_EXE=%USERPROFILE%\.local\bin\claude.exe"
set "API_CMD=%~dp0start-claude.bat"
set "API_URL=http://localhost:4141/"

rem Show a modern Vista-style folder-picker dialog. Cancel = abort.
for /f "usebackq delims=" %%I in (`powershell -NoProfile -STA -Command ^
    "Add-Type -AssemblyName PresentationFramework;" ^
    "try {" ^
    "  $d = New-Object Microsoft.Win32.OpenFolderDialog;" ^
    "  $d.Title = 'Select folder to open Claude in';" ^
    "  if ($d.ShowDialog()) { $d.FolderName }" ^
    "} catch {" ^
    "  $d = New-Object Microsoft.Win32.OpenFileDialog;" ^
    "  $d.Title = 'Select folder to open Claude in';" ^
    "  $d.ValidateNames = $false; $d.CheckFileExists = $false; $d.CheckPathExists = $true;" ^
    "  $d.FileName = 'Select this folder';" ^
    "  if ($d.ShowDialog()) { Split-Path -Parent $d.FileName }" ^
    "}"`) do set "CLAUDE_DIR=%%I"

if not defined CLAUDE_DIR (
    echo No folder selected - aborting.
    endlocal
    exit /b 1
)

rem Check if anything is responding on :4141
powershell -NoProfile -Command "try { $null = Invoke-WebRequest -Uri '%API_URL%' -UseBasicParsing -TimeoutSec 2; exit 0 } catch { if ($_.Exception.Response) { exit 0 } else { exit 1 } }"

if %ERRORLEVEL%==0 (
    echo copilot-api already running on %API_URL% - opening only claude tab
    wt -w new --title "claude" -d "%CLAUDE_DIR%" cmd /k "%CLAUDE_EXE%"
) else (
    echo Nothing on %API_URL% - starting copilot-api and claude
    wt -w new --title "coplot-api" cmd /k "%API_CMD%" ^; new-tab --title "claude" -d "%CLAUDE_DIR%" cmd /k "%CLAUDE_EXE%"
)

endlocal
