@echo off
chcp 65001 >nul
setlocal

rem === Пути: поправь, если что-то лежит в другом месте ===
set "INST=%USERPROFILE%\curseforge\minecraft\Instances\minecraft save the world"
set "SRV=%USERPROFILE%\mc-test-server"

rem === Клиентские моды: на сервер НЕ копируются (части имени jar-файла) ===
set CLIENT_ONLY=*embeddium* *oculus* *entityculling* *immediatelyfast*

echo Синхронизация: "%INST%" -^> "%SRV%"
echo Сервер должен быть остановлен!
echo.

rem mods: зеркалим (удалённые из инстанса моды удаляются и с сервера)
robocopy "%INST%\mods" "%SRV%\mods" /MIR /XF %CLIENT_ONLY% /NJH /NJS /NDL /NP
if %ERRORLEVEL% GEQ 8 goto :error

rem config, defaultconfigs, kubejs: копируем поверх, ничего не удаляя на сервере
for %%D in (config defaultconfigs kubejs) do (
  if exist "%INST%\%%D" (
    robocopy "%INST%\%%D" "%SRV%\%%D" /E /XD exported probe /NJH /NJS /NDL /NP
    if errorlevel 8 goto :error
  )
)

echo.
echo Готово.
pause
exit /b 0

:error
echo.
echo ОШИБКА при копировании (код %ERRORLEVEL%). Проверь пути в начале скрипта.
pause
exit /b 1
