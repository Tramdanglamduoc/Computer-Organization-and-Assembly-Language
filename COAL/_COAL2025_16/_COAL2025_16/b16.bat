@echo off
if [%1]==[] goto Nosource

ml /nologo /c %1.asm
if errorlevel 1 goto BuildError

link16 /nologo %1.obj,,NUL,,,
if errorlevel 1 goto BuildError
goto BuildSuccess

:BuildError
echo -------------Build error!-------------
goto TheEnd
:Nosource
echo -------------No source file specified!-------------
goto TheEnd
:BuildSuccess
echo -------------Build completed successfully-------------
:TheEnd
