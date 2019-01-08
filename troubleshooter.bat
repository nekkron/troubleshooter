@echo off
REM All-in-one Troubleshooting Script. COPY THIS FILE TO YOUR DESKTOP AND RUN FROM DESKTOP
REM This troubleshooter was designed for Windows 7 and older.
REM This file was created by James Kasparek [jkasparek@uso.org] (v 1.0)

%systemdrive%
set troublepath=%temp%\troubleshooter
set LOG=%userprofile%\Desktop\%COMPUTERNAME%.txt
md %troublepath%

title Computer Troubleshooting Assistant - DO NOT CLOSE THIS WINDOW

echo This file is collecting information about your system. 
echo When this window disappears, please email the file on your desktop labeled:  
echo "%COMPUTERNAME%.txt" to the service desk along with a detailed description 
echo of the problem you are having.
echo.
echo Computer Name: %COMPUTERNAME% 
echo.
echo %USERNAME% is running the troubleshooter.
echo.

echo Generating Time Stamp 
echo DATE and TIME: > %LOG%
echo %date% >> %LOG%
echo %time% >> %LOG%
echo. >> %LOG%

wmic /OUTPUT:%troublepath%\1SERVICETAG.txt Bios get SerialNumber 2>nul 
type %troublepath%\1SERVICETAG.txt >> %LOG%
echo. >> %LOG%

echo ===============================SYSTEM INFO================================ >> %LOG%
echo Collecting System Information 
systeminfo >> %LOG% 
echo. >> %LOG%

echo Hard Disk Drive Information >> %LOG%
echo --------------------------- >> %LOG%
wmic /OUTPUT:%troublepath%\1HDD_INFO.txt DiskDrive get Name,Size,Model 2>nul 
type %troublepath%\1HDD_INFO.txt >> %LOG%
echo. >> %LOG%

echo Printers Installed >> %LOG%
echo ------------------ >> %LOG%
wmic /OUTPUT:%troublepath%\1PRINTERS.txt Printer list Status 2>nul 
type %troublepath%\1PRINTERS.txt >> %LOG%
echo. >> %LOG%

echo Active Share Drives >> %LOG%
echo ------------------- >> %LOG%
wmic /OUTPUT:%troublepath%\1SHARE.txt Share list Brief 2>nul 
type %troublepath%\1SHARE.txt >> %LOG%
echo. >> %LOG%

echo ==============================USER ACCOUNTS=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Users on System

dir "%systemdrive%\Users" >> %LOG%
echo. >> %LOG%

echo ===============================SYSTEM DUMPS=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Information on System Dumps (Blue Screens)

dir "%windir%\MiniDump" >> %LOG% 
xcopy "%windir%\Minidump\" "%onedrive%\Troubleshooter\BSOD\" /y/c/r/h 
rem Add in a way instead of giving an error on the CMD window, to 'ignore' the null
echo. >> %LOG%

echo ==============================SOFTWARE INFO=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Software Information

echo InstallDate  Product Name							Vendor				Version >> %LOG%
wmic Product get Name,Version,Vendor,InstallDate | more +1 | sort /+14 >> %LOG%
echo. >> %LOG%

echo =================================IPCONFIG================================= >> %LOG%
echo Collecting IP information 

ipconfig /all >> %LOG% 
echo. >> %LOG%

echo ==================================PING==================================== >> %LOG%
echo Pinging Office 365 Website

ping -4 portal.office.com >> %LOG%
echo. >> %LOG%

echo ===============================TRACE ROUTE================================ >> %LOG%
echo Collecting Trace Route Information

tracert -4 portal.office.com >> %LOG%
echo. >> %LOG%

echo ==============================NEARBY DEVICES============================== >> %LOG%
echo. >> %LOG%
echo Finding Nearby Devices >> %LOG%
echo ---------------------- >> %LOG%
arp -a >> %LOG%
echo. >> %LOG%

echo ============================NETWORK STATISTICS============================ >> %LOG%
echo. >> %LOG%
echo Netstat Extended Information >> %LOG%
echo ---------------------------- >> %LOG%
netstat -n -o -a >> %LOG%
echo. >> %LOG%

echo ==============================TASKS RUNNING=============================== >> %LOG%
echo. >> %LOG%
tasklist /v >> %LOG%
echo. >> %LOG%

echo =============================RUNNING SERVICES============================= >> %LOG%
echo Collecting Computer Service Information

echo. >> %LOG%
net start >> %LOG%
echo. >> %LOG%

echo =============================GROUP POLICIES=============================== >> %LOG%
echo Collecting Group Policy Information

gpresult /R >> %LOG%
echo. >> %LOG%

echo ========================================================================== >> %LOG%
REM Clean-up the temporary files
rd /S /Q %troublepath%
ECHO. 
ECHO Copying %COMPUTERNAME%.txt to your OneDrive.
xcopy %LOG% "%OneDrive%\Troubleshooter\" /R/Y/Z
TIMEOUT /t 5