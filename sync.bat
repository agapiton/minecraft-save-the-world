@echo off
setlocal

rem === Paths: edit if something lives elsewhere ===
set "INST=%USERPROFILE%\curseforge\minecraft\Instances\minecraft save the world"
set "SRV=%USERPROFILE%\mctest-server"

rem === Client-only mods: NOT copied to the server (parts of jar names) ===
set CLIENT_ONLY=*embeddium* *oculus* *entityculling* *immediatelyfast*

echo Sync: "%INST%" -^> "%SRV%"
echo The server must be stopped!
echo.

if not exist "%INST%\mods" (
  echo ERROR: mods folder not found in "%INST%"
  goto :error
)

rem mods: mirror (mods removed from the instance are removed from the server too)
robocopy "%INST%\mods" "%SRV%\mods" /MIR /XF %CLIENT_ONLY% /NJH /NJS /NDL /NP
if errorlevel 8 goto :error

rem config, defaultconfigs, kubejs: copy over, never delete anything on the server
for %%D in (config defaultconfigs kubejs) do (
  if exist "%INST%\%%D" (
    robocopy "%INST%\%%D" "%SRV%\%%D" /E /XD exported probe /NJH /NJS /NDL /NP
    if errorlevel 8 goto :error
  )
)

echo.
echo Done.
pause
exit /b 0

:error
echo.
echo SYNC FAILED. Check the paths at the top of this script.
pause
exit /b 1
