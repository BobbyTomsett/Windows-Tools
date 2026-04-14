@echo off

:: Run SFC Scan
sfc /scannow

:: Run DISM Cleanup
DISM /Online /Cleanup-Image /RestoreHealth

pause
