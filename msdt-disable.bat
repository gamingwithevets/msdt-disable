@echo off
set "version=1.0.1"

net session >nul 2>&1
if %errorlevel% == 0 (goto menu)

echo Running as administrator.
echo This instance of this script will be closed.

echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params=%*
echo UAC.ShellExecute "cmd", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:menu
set "header=MSDT Protocol Disabler (CVE-2022-30190 Patch Tool) - v%version%&echo GitHub repository: github.com/gamingwithevets/msdt-disable&echo (c) 2022 GamingWithEvets Inc.&echo."

cls
echo %header%
echo Checking MSDT registry key...
reg query HKEY_CLASSES_ROOT\ms-msdt >nul 2>&1
if %errorlevel% == 0 (echo Found key.&goto confirm)
echo Cannot find MSDT registry key!
echo You have probably disabled it already.
echo.
echo Press any key to exit.
pause >nul
cls
exit /b

:confirm
echo.
choice /n /m "Turn off the MSDT protocol (ms-msdt://)? [Y/N] "
if %errorlevel% == 2 (cls&exit /b)

:backup
cls
echo %header%
if exist %userprofile%\msdt_bak.reg (
echo Deleting previous backup...
del msdt_bak.reg
)
echo Backing up MSDT registry key...
reg export HKEY_CLASSES_ROOT\ms-msdt %userprofile%\msdt_bak.reg >nul 2>&1
if exist %userprofile%\msdt_bak.reg (echo Backed up successfully.&goto next)
cls
echo %header%
echo Cannot back up registry key!
echo Without backing up, you cannot restore the MSDT protocol
echo without recreating the key yourself!
echo.
echo [1] Try again (RECOMMENDED)
echo [2] Continue without disabling
echo [3] Abort the process
echo.
choice /n /c 123 /m "Your choice: "
if %errorlevel% == 1 (goto backup)
if %errorlevel% == 2 (cls&echo %header%&goto next)
if %errorlevel% == 3 (cls&exit /b)

:next
echo Deleting MSDT registry key...
reg delete HKEY_CLASSES_ROOT\ms-msdt /f >nul 2>&1
if %errorlevel% == 0 (echo Deleted successfully.&goto success)
cls
echo %header%
echo Cannot delete registry key!
echo If you abort the process, you are open to
echo exploits that could potentially be used to
echo harm your computer and/or steal your personal
echo information!
echo.
echo [1] Try again (RECOMMENDED)
echo [2] Abort the process
echo.
choice /n /c 12 /m "Your choice: "
if %errorlevel% == 1 (cls&echo %header%&goto next)
if %errorlevel% == 2 (cls&exit /b)

:success
echo.
echo MSDT protocol disabled!
echo Now you can breathe a sigh of relief.
echo To enable the protocol again, open the file
echo msdt_bak.reg in your user folder.
echo.
echo Press any key to exit.
pause >nul
cls
exit /b
