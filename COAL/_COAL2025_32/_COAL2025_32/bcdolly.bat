@echo off
if [%1]==[] goto nofilepath

:::::::::: Compile ::::::::::
ml /c /Zi %1.asm
if errorlevel 1 goto builderror

:::::::::: Link ::::::::::
link kernel32.lib ucrt.lib legacy_stdio_definitions.lib %1.obj /merge:.CRT=.rdata /subsystem:console /incremental:no /debug
if errorlevel 1 goto builderror


:::::::::: Debug :::::::::
setlocal ENABLEDELAYEDEXPANSION
for %%P in (%mypath% %HOMEDRIVE% %SystemDrive% %LOCALAPPDATA% %APPDATA%) do (
	set OllyDbgPath=%%~P\odbg201
	if exist "!OllyDbgPath!" goto OllyDbgFound
)
echo ************* WARNING:   odbg201  folder not found *************
goto TheEnd

:OllyDbgFound
%OllyDbgPath%\ollydbg %1.exe
goto TheEnd

:nofilepath
echo ************* ERROR: No source file specified! ************* 
goto TheEnd

:builderror
echo ************* Build Error *************

:TheEnd