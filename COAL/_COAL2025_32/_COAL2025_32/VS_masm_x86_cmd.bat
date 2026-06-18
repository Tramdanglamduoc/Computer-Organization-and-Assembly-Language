@echo off
if defined VisualStudioVersion (
	echo MS Visual Studio %VisualStudioVersion% command line development environment already set
	goto SkipVSSetup
)

setlocal ENABLEDELAYEDEXPANSION

:: Find and run Visual Studio script vcvars32.bat to setup command line development environment
for %%D in ("%ProgramW6432%" "%PROGRAMFILES%" "%PROGRAMFILES(X86)%") do (
  for %%V in (18 2022 2019 2017) do (
    for %%T in (Professional Enterprise Community BuildTools) do (
      set pathVSbat=%%~D\Microsoft Visual Studio\%%V\%%T\VC\Auxiliary\Build\vcvars32.bat
       if exist "!pathVSbat!" goto Found
     )
   )
 )

echo ************* ERROR:   vcvars32.bat  file not found *************
echo ************* MS Visual Studio may not be installed ************* 
pause
exit

:Found
call "%pathVSbat%"

:SkipVSSetup

:: Find WinDbgX86 folder and set environment variables %pathWinDbg% and %WinDbgWorkspacePath% 
:: used by scripts bcd.bat and debug.bat
set mypath=%cd%
set WinDbgWorkspacePath=%mypath%

for %%D in ("%ProgramW6432%" "%PROGRAMFILES%" "%PROGRAMFILES(X86)%") do (
	for %%V in (10 11) do (
		set WinDbgPath=%%~D\Windows Kits\%%V\Debuggers\x86
		if exist "!WinDbgPath!\windbg.exe" goto WinDbgFound
	)
)
:: If not found in Windows SDK folders, search for user's WinDbgX86 folder 
for %%P in (%mypath% %HOMEDRIVE% %SystemDrive% %LOCALAPPDATA% %APPDATA%) do (
	set WinDbgPath=%%~P\WinDbgX86
	if exist "!WinDbgPath!" goto WinDbgFound
)

echo ************* WARNING:   Debugger windbg.exe (x86) not found *************
goto Ready
:WinDbgFound
echo Debugger windbg.exe (x86) path=%WinDbgPath%

:: Find ollydbg folder and set environment variable %OllyDbgPath% 
:: used by scripts bcdolly.bat and dolly.bat
for %%P in (%mypath% %HOMEDRIVE% %SystemDrive% %LOCALAPPDATA% %APPDATA%) do (
	set OllyDbgPath=%%~P\odbg201
	if exist "!OllyDbgPath!" goto OllyDbgFound
)
echo ************* WARNING:   odbg201  folder not found *************
goto Ready
:OllyDbgFound
echo Debugger ollydbg.exe (x86) path=%OllyDbgPath%


set path=%path%;%mypath%;%WinDbgPath%;%OllyDbgPath%

:Ready
echo:
echo Subfolders at %mypath% :
echo --------------------------------
dir /b /a:d 
echo --------------------------------
echo:
echo Enter the command CD to go to the folder with the source code files
echo:
%comspec% /k
