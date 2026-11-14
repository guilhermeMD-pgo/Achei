@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
title Achei - Shopping Capim Dourado

echo ==================================================
echo       ACHEI - SHOPPING CAPIM DOURADO
echo ==================================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo ERRO: Node.js nao foi encontrado.
  echo Instale a versao LTS em https://nodejs.org/
  echo Depois feche e abra este arquivo novamente.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo ERRO: npm nao foi encontrado. Reinstale o Node.js.
  pause
  exit /b 1
)

node -e "const v=process.versions.node.split('.').map(Number); process.exit(v[0] > 20 || (v[0] === 20 && v[1] >= 9) ? 0 : 1)"
if errorlevel 1 (
  echo ERRO: o Achei precisa do Node.js 20.9 ou superior.
  node -v
  pause
  exit /b 1
)

echo [1/3] Verificando dependencias...
if not exist "node_modules\next\package.json" (
  echo Primeira inicializacao: baixando dependencias. Aguarde...
  if exist package-lock.json (
    call npm ci
  ) else (
    call npm install
  )
  if errorlevel 1 goto erro
) else (
  echo Dependencias ja instaladas.
)

echo.
echo [2/3] Preparando banco de dados local...
if not exist ".data" mkdir ".data"
call npm run db:migrate
if errorlevel 1 goto erro
call npm run db:seed
if errorlevel 1 goto erro
call npm run db:seed:promotions
if errorlevel 1 goto erro

echo.
echo [3/3] Iniciando o Achei...
start "Achei - Servidor" cmd /k "cd /d ""%~dp0"" && npm run dev -- -p 3000"

echo Aguardando o servidor ficar pronto na porta 3000...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ok=$false; for($i=0; $i -lt 60; $i++){ if(Test-NetConnection -ComputerName 127.0.0.1 -Port 3000 -InformationLevel Quiet -WarningAction SilentlyContinue){$ok=$true; break}; Start-Sleep -Seconds 2 }; if($ok){exit 0}else{exit 1}"
if errorlevel 1 goto servidor_nao_iniciou

start "" "http://127.0.0.1:3000"
echo.
echo O Achei esta disponivel em http://127.0.0.1:3000
echo Mantenha a janela 'Achei - Servidor' aberta enquanto usar o sistema.
echo Para encerrar, feche a janela do servidor.
echo.
pause
exit /b 0

:servidor_nao_iniciou
echo.
echo O servidor nao respondeu em 120 segundos.
echo Verifique a janela 'Achei - Servidor' e copie aqui a mensagem de erro.
echo Confira tambem se a porta 3000 ja esta sendo usada por outro programa.
pause
exit /b 1

:erro
echo.
echo ERRO durante a preparacao do Achei.
echo Leia a mensagem acima. Verifique a internet e a instalacao do Node.js.
pause
exit /b 1
