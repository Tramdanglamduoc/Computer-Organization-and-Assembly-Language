@echo off
if [%1]==[] goto nofilepath

:::::::::: Compile ::::::::::
ml /c /Zi %1.asm
if errorlevel 1 goto builderror

:::::::::: Link ::::::::::
link kernel32.lib ucrt.lib legacy_stdio_definitions.lib %1.obj /merge:.CRT=.rdata /subsystem:console /debug /incremental:no
if errorlevel 1 goto builderror

:::::::::: Debug :::::::::
windbg.exe -WF"%WinDbgWorkspacePath%\WinDbgWorkspace.WEW" -c"bu $exentry;g" %~n1.exe
goto TheEnd

:nofilepath
echo ************* ERROR: No source file specified! ************* 
goto TheEnd

:builderror
echo ************* Build Error *************

:TheEnd