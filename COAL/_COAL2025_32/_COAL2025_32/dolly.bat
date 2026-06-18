@echo off
if [%1]==[] goto nofilepath

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
echo ************* ERROR: File not specified! ************* 
:TheEnd
