@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Fatec Mission - Inicializacao

rem ======================================================================
rem  Inicializa os 3 projetos do Fatec Mission, cada um em sua janela:
rem    API (3000)  ->  App mobile (5173)  ->  Painel admin (5175)
rem  Para encerrar um projeto, feche a janela dele (ou Ctrl+C nela).
rem ======================================================================

set "RAIZ=%~dp0"
set "API=%RAIZ%fatec-mission-api"
set "WEB=%RAIZ%fatec-mission-web"
set "ADMIN=%RAIZ%fatec-mission-admin"

echo.
echo  ==============================================
echo     FATEC MISSION - iniciando os projetos
echo  ==============================================
echo.

rem ---------------------------------------------------------------- pré-requisitos
where node >nul 2>&1
if errorlevel 1 (
  echo  [ERRO] Node.js não encontrado. Instale em https://nodejs.org e tente de novo.
  pause
  exit /b 1
)

for %%P in ("%API%" "%WEB%" "%ADMIN%") do (
  if not exist "%%~P\package.json" (
    echo  [ERRO] Projeto não encontrado: %%~P
    echo         Deixe este arquivo na pasta que contém os 3 projetos.
    pause
    exit /b 1
  )
)

rem A API precisa do .env com as credenciais do MySQL
if not exist "%API%\.env" (
  copy "%API%\.env.example" "%API%\.env" >nul
  echo  [AVISO] A API ainda não tinha o arquivo .env - criei um a partir do .env.example.
  echo          Preencha DB_PASSWORD e JWT_SECRET no Bloco de Notas que vai abrir,
  echo          salve, feche e volte aqui.
  notepad "%API%\.env"
  pause
)

rem ---------------------------------------------------------------- dependências
rem Verifica cada projeto separadamente e instala o que faltar (um, dois ou os três)
echo  Verificando dependências dos projetos...
set "FALHA_INSTALACAO="
call :instalar "%API%"   || set "FALHA_INSTALACAO=1"
call :instalar "%WEB%"   || set "FALHA_INSTALACAO=1"
call :instalar "%ADMIN%" || set "FALHA_INSTALACAO=1"
if defined FALHA_INSTALACAO (
  echo.
  echo  [ERRO] Não foi possível instalar todas as dependências.
  echo         Corrija o problema indicado acima e execute este arquivo novamente.
  pause
  exit /b 1
)

rem ---------------------------------------------------------------- modo do app mobile
echo.
echo  App mobile:
echo    [1] Normal  - http://localhost:5173
echo    [2] HTTPS   - necessário para usar a câmera do celular na rede local
choice /c 12 /t 30 /d 1 /n /m "  Escolha 1 ou 2 - padrão 1 em 30 segundos: "
if errorlevel 2 (
  set "WEB_SCRIPT=dev:https"
  set "WEB_URL=https://localhost:5173"
) else (
  set "WEB_SCRIPT=dev"
  set "WEB_URL=http://localhost:5173"
)
echo.

rem ---------------------------------------------------------------- API
call :porta_em_uso 3000
if not errorlevel 1 (
  echo  [OK] API já está rodando na porta 3000.
) else (
  echo  Iniciando a API...
  start "Fatec Mission - API" /d "%API%" cmd /k npm run dev
  echo  Aguardando a API criar o banco e ficar pronta...
  call :aguardar_porta 3000 60
  if errorlevel 1 (
    echo  [AVISO] A API não respondeu em 60s. Confira a janela "Fatec Mission - API":
    echo          o MySQL está ligado? As credenciais do .env estão corretas?
  ) else (
    echo  [OK] API pronta em http://localhost:3000  - Swagger em /api-docs
  )
)

rem ---------------------------------------------------------------- App mobile
call :porta_em_uso 5173
if not errorlevel 1 (
  echo  [OK] App mobile já está rodando na porta 5173.
) else (
  echo  Iniciando o app mobile...
  start "Fatec Mission - App mobile" /d "%WEB%" cmd /k npm run %WEB_SCRIPT%
)

rem ---------------------------------------------------------------- Painel admin
call :porta_em_uso 5175
if not errorlevel 1 (
  echo  [OK] Painel admin já está rodando na porta 5175.
) else (
  echo  Iniciando o painel administrativo...
  start "Fatec Mission - Admin" /d "%ADMIN%" cmd /k npm run dev
)

rem ---------------------------------------------------------------- abre o navegador
call :aguardar_porta 5175 30
if not errorlevel 1 start "" "http://localhost:5175"
call :aguardar_porta 5173 30
if not errorlevel 1 start "" "%WEB_URL%"

echo.
echo  ==============================================
echo    API ............ http://localhost:3000/api-docs
echo    App mobile ..... %WEB_URL%
echo    Painel admin ... http://localhost:5175
echo  ==============================================
echo    No celular, use o endereço "Network" exibido
echo    na janela "Fatec Mission - App mobile".
echo    Para encerrar, feche as janelas de cada projeto.
echo.
pause
exit /b 0


rem ======================================================================
rem  Sub-rotinas
rem ======================================================================

rem Instala as dependências do projeto %1 quando:
rem   - a pasta node_modules não existe; ou
rem   - existe, mas está incompleta/desatualizada (npm ls acusa pacote faltando ou inválido),
rem     por exemplo após uma instalação interrompida ou um pacote novo no package.json.
rem errorlevel 0 = dependências OK; 1 = falha na instalação
:instalar
set "_proj=%~nx1"
if not exist "%~1\node_modules" (
  echo  [..] %_proj%: dependências não instaladas - instalando, pode levar alguns minutos...
  goto instalar_executar
)
pushd "%~1"
call npm ls --depth=0 >nul 2>&1
set "_ls=%errorlevel%"
popd
if "%_ls%"=="0" (
  echo  [OK] %_proj%: dependências já instaladas.
  exit /b 0
)
echo  [..] %_proj%: dependências incompletas ou desatualizadas - instalando...
:instalar_executar
pushd "%~1"
call npm install --no-audit --no-fund
set "_npm=%errorlevel%"
popd
if not "%_npm%"=="0" (
  echo  [ERRO] Falha ao instalar as dependências de %_proj%.
  echo         Verifique a conexão com a internet e a mensagem do npm acima.
  exit /b 1
)
echo  [OK] %_proj%: dependências instaladas com sucesso.
exit /b 0

rem errorlevel 0 se houver algo escutando na porta %1
:porta_em_uso
netstat -ano | findstr /r /c:":%~1 .*LISTENING" >nul
exit /b %errorlevel%

rem Espera até %2 segundos a porta %1 abrir. errorlevel 0 = abriu
:aguardar_porta
set /a _espera=0
:aguardar_porta_loop
call :porta_em_uso %~1
if not errorlevel 1 exit /b 0
set /a _espera+=1
if %_espera% geq %~2 exit /b 1
rem pausa de ~1s (ping funciona mesmo sem teclado interativo, ao contrario do timeout)
ping -n 2 127.0.0.1 >nul
goto aguardar_porta_loop
