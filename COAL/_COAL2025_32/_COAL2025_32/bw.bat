@echo off
if [%1]==[] goto nofilepath

:::::::::: Compile ::::::::::
ml /c /Zi %1.asm
if errorlevel 1 goto builderror

:::::::::: Link ::::::::::
link /subsystem:windows /incremental:no /debug %1.obj 
if errorlevel 1 goto builderror

goto TheEnd

:nofilepath
echo ************* ERROR: No source file specified! ************* 
goto TheEnd

:builderror
echo ************* Build Error *************

:TheEnd
