@ECHO OFF
REM Plex Windows Status Check and Restart
REM 2017 - Leigh Cameron
REM Use at your own risk, paths and names may need to be updated
REM GPL v3
REM Requires curl.exe and libcurl.dll to function -> https://curl.haxx.se/download.html (grab Win32 version and libcurl.dll)
REM I placed curl and libcurl.dll into the same path as the batch to keep it simple and portable.

SETLOCAL EnableExtensions
SET "PMSPATH=E:\Program Files (x86)\Plex\Plex Media Server"		REM Set you servers PMS Path Here!!!

REM Do Not Edit Below this line!!! This means you Julius.

SET EXENAME="Plex Media Server.exe"	REM This is the Plex Service name
SET "PEXE=Plex Media Server.exe"	REM This is for Tasklist to work
SET "PLEXWEB=http://localhost:32400/web/index.html"	REM This is the web url for the local plex web app

FOR /F "tokens=1 delims=,  " %%x IN ('tasklist /NH /FO CSV /FI "IMAGENAME eq %PEXE%"') DO IF %%x == "%PEXE%" goto started

goto stopped

echo unknown status
goto end
:trouble
echo Oh noooo.. trouble, use manual intervention, or call someone you trust
goto end
:started
echo %PEXE% is started, keep calm and carry on
goto web
:stopped
echo %PEXE% is stopped, unleash the restart dragons
echo Starting Plex Media Server
cd /d %PMSPATH%
start "" %EXENAME%
goto end
:erro
echo Error please check your command.. hopefully you don't get this, seriously 
goto end
:web
REM Perform a sanity check on the web app, just incase the service is running but plex is still hung (not that way you dirty minded twit)
curl -I %PLEXWEB% | FIND "200 OK"
if %ERRORLEVEL% == 1 goto webstop
if %ERRORLEVEL% == 0 goto webok
echo unknown status
goto end
:webok
echo All is well on the webfront, carry on
goto end
:webstop
echo Web app not responding, must restart Plex Service!
echo Terminating Plex Media Server
taskkill /F /IM "%PEXE%"
ping 127.0.0.1 -n 10 > nul		REM This is effectively a sleep for 10 seconds, adjust as needed... or follow the rule above.
echo Starting Plex Media Server
cd /d %PMSPATH%
start "" %EXENAME%
goto end
:end
exit



