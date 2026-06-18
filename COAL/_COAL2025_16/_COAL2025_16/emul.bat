@echo off
setlocal ENABLEDELAYEDEXPANSION
:: Find  DOSBox-0.74-3 folder and set environment variables 
for %%P in ("%mypath%\MASM16_Tools" "%ProgramW6432%" "%PROGRAMFILES%" "%PROGRAMFILES(X86)%") do (
	set DOSBoxPath=%%~P\DOSBox-0.74-3
	if exist "!DOSBoxPath!" goto Found
)

echo ************* ERROR:   DOSBox-0.74-3  folder not found *************
goto TheEnd

:Found
echo DOSBox-0.74-3 folder path=%DOSBoxPath%

start /b /d "%DOSBoxPath%" DOSBox.exe -c "mount F '%mypath%\MASM16_Tools'" -c "set path=F:" -c cls -c "mount W '%cd%'" -c W: -noconsole -conf "%mypath%\dosbox-0.74-3.conf"

:TheEnd
