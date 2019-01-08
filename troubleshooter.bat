@echo off
REM All-in-one Troubleshooting Script. COPY THIS FILE TO YOUR DESKTOP AND RUN FROM DESKTOP
REM This troubleshooter was designed for Windows 7 and newer.
REM This file was created by James Kasparek [nekkron@gmail.com] (v 1.0)

:Set Variables
%systemdrive%
md %troublepath%
set troublepath=%temp%\troubleshooter
set LOG=%userprofile%\Desktop\%COMPUTERNAME%.txt
md %OneDrive%\support
set support=%OneDrive%\support\
set SERIAL=wmic bios get serialnumber
set HDDinfo=wmic DiskDrive get Name,Size,Model
set PRINTERSinstalled=wmic Printer list Status
set WHATSshared=wmic Share list Brief
set InstalledSoftware=wmic Product get Name,Version,Vendor,InstallDate

title Computer Troubleshooting Assistant - DO NOT CLOSE THIS WINDOW

:Start
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

echo Serial Number: >> %LOG%
echo %SERIAL% >> %LOG%
echo. >> %LOG%

echo ===============================SYSTEM INFO================================ >> %LOG%
echo Collecting System Information 
systeminfo >> %LOG% 
echo. >> %LOG%

echo Hard Disk Drive Information >> %LOG%
echo --------------------------- >> %LOG%
echo %HDDinfo% >> %LOG%
echo. >> %LOG%

echo Printers Installed >> %LOG%
echo ------------------ >> %LOG%
echo %PRINTERSinstalled% >> %LOG%
echo. >> %LOG%

echo Active Share Drives >> %LOG%
echo ------------------- >> %LOG%
echo %WHATSshared% >> %LOG%
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
xcopy "%windir%\Minidump\" "%support%" /y/c/r/h 1>nul
rem Add in a way instead of giving an error on the CMD window, to 'ignore' the null
echo. >> %LOG%

echo ==============================SOFTWARE INFO=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Software Information

echo InstallDate  Product Name							Vendor				Version >> %LOG%
%InstalledSoftware% | more +1 | sort /+14 >> %LOG%
echo. >> %LOG%

echo =================================IPCONFIG================================= >> %LOG%
echo Collecting IP information 

ipconfig /all >> %LOG% 
echo. >> %LOG%

echo ==================================PING==================================== >> %LOG%
echo Pinging www.office.com

ping -4 www.office.com >> %LOG%
echo. >> %LOG%

echo ===============================TRACE ROUTE================================ >> %LOG%
echo Collecting Trace Route Information

tracert -4 www.office.com >> %LOG%
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
xcopy %LOG% "%support%" /R/Y/Z
TIMEOUT /t 5
