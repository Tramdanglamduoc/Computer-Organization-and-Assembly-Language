@echo off
set mypath=%cd%

set path=%path%;%mypath%;%mypath%\MASM16_Tools
echo:
echo Subfolders at %mypath% :
echo --------------------------------
dir /b /a:d 
echo --------------------------------
echo:
echo Enter the command CD to go to the folder with your 16-bit source code files
echo Use b16.bat to build .exe executable (example: b16 Hello)
echo Run emul.bat to open emulation environment for 16-bit apps in the current folder
echo In the emulation environment window run your 16-bit apps 
echo and use afd.exe for debugging (example: afd hello.exe)
echo:
%comspec% /k
