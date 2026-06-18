@echo off
if [%1]==[] goto nofilepath

:::::::::: Debug :::::::::
windbg.exe -WF"%WinDbgWorkspacePath%\WinDbgWorkspace.WEW" -c"bu $exentry;g" %~n1.exe

goto TheEnd

:nofilepath
echo ************* ERROR: File not specified! ************* 
:TheEnd
