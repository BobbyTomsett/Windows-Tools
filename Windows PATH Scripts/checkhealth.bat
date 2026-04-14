@echo off

::start
echo Checking System health...

::sfcscannow
sfc /scannow >> "logs\checkhealth.log"

::DISM
DISM /Online /Cleanup-Image /RestoreHealth >> "logs\checkhealth.log"
