@echo off
title IT Utils
chcp 65001 >nul
mode 120,40

:interface
echo ██╗████████╗    ██╗   ██╗████████╗██╗██╗     ███████╗
echo ██║╚══██╔══╝    ██║   ██║╚══██╔══╝██║██║     ██╔════╝
echo ██║   ██║       ██║   ██║   ██║   ██║██║     ███████╗
echo ██║   ██║       ██║   ██║   ██║   ██║██║     ╚════██║
echo ██║   ██║       ╚██████╔╝   ██║   ██║███████╗███████║
echo ╚═╝   ╚═╝        ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝


:menu
echo [1] Limpar cache DNS
echo [2] Limpar Arquivos temporários
echo [3] Verificar conexão com a internet
echo [4] Reparar e Reparar o Disco (chkdsk)
echo [5] Reparar Arquivos do Windows (sfc)
echo [6] Abrir Gerenciador de Tarefas
echo [7] Abrir Windows Update
echo [8] Abrir Painel de Controle
echo [9] Diagnosticar problemas de Memória
echo [10] Desfragmentar Disco
echo [11] Verificar Integridade (dism)
echo [12] Criar Ponto de restauração
echo [13] Abrir Logs de eventos
echo [14] Ver informações do sistema
echo [15] Atualizar apps (winget)
echo [16] Limpar Spooler de Impressão
echo [17] Relatórios de energia/bateria
echo [18] Coletar logs (pacote diagnóstico)
echo [19] Reset de rede (Winsock/IP)
echo [20] Windows Defender: verificação rápida
echo [0] Sair
set /p "choice=Escolha uma opção: "
if "%choice%" == "1" goto 1
if "%choice%" == "2" goto 2
if "%choice%" == "3" goto 3
if "%choice%" == "4" goto 4
if "%choice%" == "5" goto 5
if "%choice%" == "6" goto 6
if "%choice%" == "7" goto 7
if "%choice%" == "8" goto 8
if "%choice%" == "9" goto 9
if "%choice%" == "10" goto 10
if "%choice%" == "11" goto 11
if "%choice%" == "12" goto 12
if "%choice%" == "13" goto 13
if "%choice%" == "14" goto 14
if "%choice%" == "15" goto 15
if "%choice%" == "16" goto 16
if "%choice%" == "17" goto 17
if "%choice%" == "18" goto 18
if "%choice%" == "19" goto 19
if "%choice%" == "20" goto 20
if "%choice%" == "0" goto end
goto menu


:1
ipconfig /flushdns
echo Cache DNS limpo com sucesso
pause.
goto menu

:2
del /f /q /s %temp%\* >nul
echo Arquivos temporários limpos com sucesso
pause.
goto menu

:3
ping -n 1 8.8.8.8 >nul
if %errorlevel% == 0 (
    echo Conexão com a internet estabelecida
) else (
    echo Conexão com a internet não estabelecida
)
pause.
goto menu

:4
chkdsk C: /f /r
echo Sistema reparado com sucesso
pause.
goto menu

:5
sfc /scannow
echo Arquivos do Windows reparados com sucesso
pause.
goto menu

:6
taskmgr
pause.
goto menu

:7
wupdmgr
pause.
goto menu

:8
control
pause.
goto menu

:9
mdsched
pause.
goto menu

:10
set /p "drive=Digite a letra da unidade para desfragmentar (ex: C): "
if "%drive%"=="" goto menu
defrag %drive%: /O /U /V
pause.
goto menu

:11
echo Verificando imagem do sistema (DISM /ScanHealth)...
dism /Online /Cleanup-Image /ScanHealth
echo.
echo Reparando imagem do sistema (DISM /RestoreHealth)...
dism /Online /Cleanup-Image /RestoreHealth
echo.
echo DISM finalizado.
pause.
goto menu

:12
echo Criando ponto de restauracao do sistema (sera solicitado elevacao/UAC)...
set /p "desc=Digite uma descricao (ou deixe em branco para 'ITUtils'): "
if "%desc%"=="" set "desc=ITUtils"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { Enable-ComputerRestore -Drive ''C:\\'' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description ''%desc%'' -RestorePointType ''MODIFY_SETTINGS''; Write-Host ''Ponto de restauracao criado.'' } catch { Write-Error $_; exit 1 }'"
echo.
echo Se houver erro de permissao ou protecao desativada, execute como Administrador e verifique a Protecao do Sistema em C:\.
pause.
goto menu

:13
eventvwr.msc
pause.
goto menu

:14
systeminfo | more
pause.
goto menu

:15
echo Atualizando aplicativos via winget (sera solicitado elevacao/UAC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw \"winget nao encontrado. Instale o App Installer da Microsoft Store.\" } ; winget source update | Out-Host; winget upgrade --all --accept-source-agreements --accept-package-agreements --include-unknown | Out-Host; Write-Host \"Atualizacao de apps concluida.\" } catch { Write-Error $_; exit 1 }'"
pause.
goto menu

:16
echo Limpando Spooler de Impressao (sera solicitado elevacao/UAC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { Stop-Service -Name Spooler -Force -ErrorAction Stop; Remove-Item -Path ''$env:SystemRoot\\System32\\spool\\PRINTERS\\*'' -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1; Start-Service -Name Spooler -ErrorAction Stop; Write-Host ''Spooler limpo e reiniciado.'' } catch { Write-Error $_; exit 1 }'"
pause.
goto menu

:17
echo Gerando relatorios de energia e bateria (sera solicitado elevacao/UAC)...
set "ENERGY_PATH=%USERPROFILE%\Desktop\energy-report.html"
set "BATTERY_PATH=%USERPROFILE%\Desktop\battery-report.html"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command',('try { powercfg /energy /output ""' + $env:ENERGY_PATH + '"" /duration 60 ^>^&1 ^| Out-Null; powercfg /batteryreport /output ""' + $env:BATTERY_PATH + '"" ^>^&1 ^| Out-Null; Write-Host ''Relatorios gerados.'' } catch { Write-Error $_; exit 1 }')"
timeout /t 1 >nul 2>&1
if exist "%ENERGY_PATH%" start "" "%ENERGY_PATH%"
if exist "%BATTERY_PATH%" start "" "%BATTERY_PATH%"
echo Arquivos gerados em:
echo   %ENERGY_PATH%
echo   %BATTERY_PATH%
pause.
goto menu

:18
echo Coletando logs (sera solicitado elevacao/UAC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { $tmp=$env:TEMP; wevtutil epl System "$tmp\\System.evtx" /ow:true; wevtutil epl Application "$tmp\\Application.evtx" /ow:true; systeminfo > "$tmp\\systeminfo.txt"; $desktop=[Environment]::GetFolderPath('Desktop'); $zip=Join-Path $desktop ("ITUtils-Diagnostics-" + (Get-Date -Format yyyyMMdd-HHmmss) + ".zip"); Compress-Archive -Path "$tmp\\System.evtx","$tmp\\Application.evtx","$tmp\\systeminfo.txt" -DestinationPath $zip -Force; Write-Host "Pacote gerado: $zip" } catch { Write-Error $_; exit 1 }'"
pause.
goto menu

:19
echo Resetando configuracoes de rede (sera solicitado elevacao/UAC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { netsh winsock reset | Out-Host; netsh int ip reset | Out-Host; ipconfig /flushdns | Out-Host; Write-Host ''Reset concluido. Pode ser necessario reiniciar o computador.'' } catch { Write-Error $_; exit 1 }'"
pause.
goto menu

:20
echo Executando verificacao rapida com Microsoft Defender (sera solicitado elevacao/UAC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','try { if (Get-Command MpCmdRun.exe -ErrorAction SilentlyContinue) { MpCmdRun.exe -SignatureUpdate | Out-Host; MpCmdRun.exe -Scan -ScanType 2 | Out-Host } elseif (Get-Command Start-MpScan -ErrorAction SilentlyContinue) { Update-MpSignature -ErrorAction SilentlyContinue; Start-MpScan -ScanType QuickScan } else { throw ''Microsoft Defender nao encontrado ou desativado.'' } ; Write-Host ''Verificacao rapida concluida.'' } catch { Write-Error $_; exit 1 }'"
pause.
goto menu

:end
exit
