@echo off
setlocal
TITLE RP Console Repairs - Frankenstein Launcher

REM Episode 3: Start the existing RP PSU serial monitor and OBS.
REM No PSU output or recording is activated by this launcher.

set "MONITOR=%USERPROFILE%\RP_PSU_ROB2_TEST.ps1"
if not exist "%MONITOR%" (
  echo Could not find the RP PSU monitor:
  echo %MONITOR%
  echo.
  echo The monitor script must be in your Windows user folder.
  pause
  exit /b 1
)

set "OBS=%ProgramFiles%\obs-studio\bin\64bit\obs64.exe"
if exist "%OBS%" goto found_obs
set "OBS=%LOCALAPPDATA%\Programs\obs-studio\bin\64bit\obs64.exe"
if exist "%OBS%" goto found_obs

echo Could not find OBS in its standard installation folders.
echo No programs were started. Tell Partner where OBS is installed.
pause
exit /b 1

:found_obs
REM Keep the monitor in its own window and make OBS the active workspace.
start "RP FRANKENSTEIN PSU MONITOR" powershell.exe -NoProfile -ExecutionPolicy Bypass -NoExit -File "%MONITOR%"
if errorlevel 1 (
  echo Failed to start the PowerShell monitor.
  pause
  exit /b 1
)

REM Give PowerShell a moment to open before starting OBS.
timeout /t 2 /nobreak >nul

REM Reuse OBS if already running, to avoid launching a second instance.
for %%I in ("%OBS%") do set "OBS_DIR=%%~dpI"
tasklist /FI "IMAGENAME eq obs64.exe" /NH | find /I "obs64.exe" >nul
if errorlevel 1 start "" /D "%OBS_DIR%" "%OBS%"

exit /b 0
