
@echo off

:: Programmé créé par TERIIHOANIA Joan Heimanu alias heimanuter
:: Membre de batch.xoo.it
:: Contact : joprocorp@gmail.com
:: Contact : http://joan-teriihoania.fr/

Rem ---------------------- Copyright ----------------------------------
 
:: Code par TERIIHOANIA Joan Heimanu alias heimanuter.
:: Ne pas copier, modifier, distribuer ce code sans mon autorisation.
:: Ne pas supprimer ce Copyright.

:: Commandes externes utilisées :
::  - pandoc (https://pandoc.org/)
::  - python (https://www.python.org/) sous l'alias py
::  - powershell (https://docs.microsoft.com/fr-fr/powershell/)
::  - pdflatex (https://miktex.org/) de miktex

Rem ---------------------- Copyright ----------------------------------

set version=1587325122
set exitted=false

set download_link=http://joan-teriihoania.fr/program/convert/updater/download.php
set input_filename=
set output_filename=Output
set overwrite=false
set pdflatex_logs=false

set temp_dir=%temp%\rapport_temp
set latex_filename=Latex.tex
set temp_latex_filename=%temp_dir%\%latex_filename%
set replacement_main_tex_file=%temp_dir%\Main.tex
set exit_code=0
echo.

if exist "convert_changelogs.txt" del /q "convert_changelogs.txt" > nul
::if exist updater.bat echo [INFO] Version %version% installed with success !
if exist updater.bat del /q updater.bat > nul

if "%~1" equ "" (
  echo [INFO] Convert version %version% created by TERIIHOANIA Joan Heimanu - 2020
  echo [INFO] To use this command, open a command prompt.
  echo [INFO] Type : '%~n0%~x0 /?' for more information.
  echo.
  exit /b
)

:args_load_loop
IF "%~1" equ "" goto :args_load_loop_end_point
IF "%~1" equ "--input" (
    SET input_filename=%~2
    if "%output_filename%" equ "Output" set output_filename=%input_filename%
    SHIFT
)
IF "%~1" equ "--output" (
    SET output_filename=%~2
    SHIFT
)
IF "%~1" equ "--logs-pdflatex" set pdflatex_logs=true
IF "%~1" equ "--overwrite" (
    SET overwrite=true
)
if "%~1" equ "--version" (
  echo [INFO] Convert version %version% created by TERIIHOANIA Joan Heimanu - 2020
  echo [INFO] For more information, use '/?' option.
  goto exit
  exit /b
)
if "%~1" equ "--changelogs" (
  call :--changelogs
  goto exit
  exit /b
)

if "%~1" equ "--install-pdflatex" (
  call :--install-pdflatex
  goto exit
  exit /b
)

if "%~1" equ "--check-update" (
  call :check_version > nul
  call :check_version
  exit /b
)

if "%~1" equ "/?" (
  call :help
  goto exit
  exit /b
)

if "%~1" equ "--temp-reset" (
  if not exist "%temp_dir%\reset.log" echo test > "%temp_dir%\reset.log"
  echo [INFO] Resetting temp folder...
  del /s /q "%temp_dir%\"> nul
  if exist "%temp_dir%\reset.log" echo [ERRO] Reset operation failed
  if not exist "%temp_dir%\reset.log" echo [INFO] Reset operation complete
  echo.
  exit /b
)

if "%~1" equ "--temp-open" (
  explorer "%temp%\rapport_temp"
  goto exit
  exit /b
)

if "%~1" equ "--set-main" (
  if not exist "%~2" echo [ERRO]  "%~2" file not found.
  if not exist "%~2" echo [ERRO]  Parameter ignored.
  if exist "%~2" set replacement_main_tex_file=%~2
  SHIFT
)

if "%~1" equ "--replace-main" (
  if "%~2" equ "" echo [INFO] No replacement file specified.
  if "%~2" equ "" goto exit
  if "%~2" equ "" exit /b

  if not exist "%~2" echo [INFO] Specified file could not be found.
  if not exist "%~2" goto exit
  if not exist "%~2" exit /b

  echo [INFO] Replacing main Latex file by "%~2"...
  if exist "%temp_dir%\Main.tex" del /q "%temp_dir%\Main.tex" > nul
  if exist "%temp_dir%\%~2" del /q "%temp_dir%\%~2" > nul
  copy "%~2" "%temp_dir%" > nul
  set local_path=%~dp0
  cd /d "%temp_dir%"
  ren "%~2" "Main.tex"
  cd /d "%local_path%"
  echo [INFO] Main Latex file replaced
  SHIFT
  goto exit
  exit /b
)

if "%~1" equ "--update" (
  call :--update
  exit /b
)

SHIFT
GOTO :args_load_loop

:args_load_loop_end_point

set command_needed=0
WHERE powershell >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo [ERRO] The command 'powershell' is not installed.
  set command_needed=1
)

WHERE pdflatex >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo [ERRO] The command 'pdflatex' is not installed.
  echo [INFO] Use '--install-pdflatex' option to install ^(Windows only^).
  set command_needed=1
)

WHERE pandoc >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo [ERRO] The command 'pandoc' is not installed.
  set command_needed=1
)

WHERE py >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo [ERRO] The command 'py' is not installed.
  set command_needed=1
)

if %command_needed% neq 0 (
  echo [INFO] Make sure to install the previous command^(s^).
  echo [INFO] If the command^(s^) are installed, contact the developer.
  set exit_code=7
  goto exit
)

if "%input_filename%" equ "" (
  echo [ERRO]  Input file not specified.
  set exit_code=1
  goto exit
)

if "%output_filename%" equ "" (
  set output_filename=%input_filename%
)

if not exist "%input_filename%" (
  echo [ERRO]  Input file "%input_filename%" could not be found in directory.
  echo [ERRO]  Please check if the file exists or is in the active directory.
  set exit_code=1
  goto exit
)

if not exist "%temp_dir%" (
  md "%temp_dir%"
)

if exist "%temp_latex_filename%" (
  del /q "%temp_dir%\%latex_filename%" > nul
)

echo [INFO] Converting markdown to Latex...
pandoc -f gfm -t latex "%input_filename%">"%temp_latex_filename%"
if not exist "%temp_latex_filename%" (
  echo [ERRO]  Conversion to LATEX failed
  set exit_code=2
  goto exit
)

echo [INFO] Reformatting Latex file...


if not exist "%temp_dir%\format.py" (
  echo [INFO] Downloading formatting script...
  powershell -Command "Invoke-WebRequest %download_link%?filename=format.py -OutFile %temp_dir%\format.py -Headers @{'Cache-Control'='no-cache'}" > nul
  if not exist "%temp_dir%\format.py" echo [ERRO]  The formatting script could not be downloaded
  if not exist "%temp_dir%\format.py" set exit_code=7
  if not exist "%temp_dir%\format.py" goto exit
  echo [INFO] Formatting script downloaded with success
)

py "%temp_dir%\format.py" "%temp_latex_filename%"

echo [INFO] Converting to PDF...
if exist "%output_filename%.pdf" if "%overwrite%" neq "true" (
  echo [ERRO]  File already named as "%output_filename%.pdf" found
  echo [ERRO]  Use '--overwrite' option to overwrite the existing file.
  set exit_code=3
  goto exit
)

if not exist "%temp_dir%\Main.tex" (
  echo [INFO] Downloading template file...
  powershell -Command "Invoke-WebRequest %download_link%?filename=Main.tex -OutFile %temp_dir%\Main.tex -Headers @{'Cache-Control'='no-cache'}" > nul
  if not exist "%temp_dir%\Main.tex" echo [ERRO]  The template file could not be downloaded
  if not exist "%temp_dir%\Main.tex" set exit_code=5
  if not exist "%temp_dir%\Main.tex" goto exit
  echo [INFO] Template file downloaded with success
)

if exist "%output_filename%.pdf" del /q "%output_filename%.pdf" > nul
if "%pdflatex_logs%" equ "true" pdflatex "%replacement_main_tex_file%" --job-name="%output_filename%" --aux-directory="%temp_dir%"
if "%pdflatex_logs%" neq "true" pdflatex "%replacement_main_tex_file%" --job-name="%output_filename%" --aux-directory="%temp_dir%" > nul

if not exist "%output_filename%.pdf" (
  echo [ERRO]  Conversion to PDF failed
  set exit_code=4
  goto exit
)

echo [INFO] Updating TOC from PDF...
del /q "%output_filename%.pdf" > nul
if "%pdflatex_logs%" equ "true" pdflatex "%replacement_main_tex_file%" --job-name="%output_filename%" --aux-directory="%temp_dir%"
if "%pdflatex_logs%" neq "true" pdflatex "%replacement_main_tex_file%" --job-name="%output_filename%" --aux-directory="%temp_dir%" > nul

if not exist "%output_filename%.pdf" (
  echo [ERRO]  Conversion to PDF failed
  set exit_code=4
  goto exit
)

goto exit

:help
  echo This command will convert any github markdown file to PDF while reformatting it using
  echo a Latex format file. It uses pandoc, a python script and pdflatex. By default, the command
  echo will download a Main.tex file in the temp folder which will be the root Latex file.
  echo.
  echo This file include all boot tags, the coverpage and the table of contents generated by Latex
  echo automatically. The downloaded file is a template. Feel free to edit it.
  echo Note that if the file is deleted, it will be redownloaded and reloaded.
  echo.
  echo.
  echo Syntax: %~n0 [option]
  echo.
  echo Options :
  echo   --input ^<Filename^>
  echo   --output ^<Filename^>
  echo.
  echo   --overwrite        : Option to overwrite, disabled by default, the contentof any file
  echo                        named as the given output filename with the result of the conversion.
  echo   --update           : Update the command to the latest release.
  echo   --check-update     : Search for the latest release.
  echo   --version          : Stop the execution to only display the version header.
  echo   --temp-reset       : Delete all files within the temp folder.
  echo   --install-pdflatex : Install pdflatex (Miktex).
  echo   --logs-pdflatex    : Display logs of pdflatex during conversion.
  echo   --changelogs       : Display the latest changelogs published.
  echo   --temp-open        : Open an explorer window to the temp folder location.
  echo   --replace-main     : Replace the Main.tex Latex file to a specified file given in parameter.
  echo   --set-main         : Set the Main.tex Latex file to the specified file given in parameter
  echo                        only for the current conversion. Not permanent.
  echo.
  echo Error codes index:
  echo   [0] The process ended without any errors.
  echo   [1] The process couldn't find the given input filename.
  echo   [2] The conversion failed to LATEX from GITHUB MARKDOWN or the outputed result/file
  echo       from the conversion couldn't be found by the process.
  echo   [3] The process found a file already named as the given output PDF filename.
  echo   [4] The conversion failed to PDF from LATEX or the outputed result/file
  echo       from the conversion couldn't be found by the process.
  echo   [5] The Main.tex file used for the generation of PDF could not be found and downloaded.
  echo   [6] The format.py script used to reformat Latex file could not be found and downloaded.
  echo   [7] One the following required command is not installed :
  echo          - pandoc (https://pandoc.org/)
  echo          - pdflatex (https://miktex.org/)
  echo          - py (https://www.python.org/)
  echo          - powershell (https://docs.microsoft.com/fr-fr/powershell/)
  echo.
  echo IMPORTANT : If your installation is outdated, can't update or has unresolvable execution
  echo             issues, please consider download a newer version with the following link :
  echo.
  echo https://joan-teriihoania.fr/program/convert/updater/download.php?filename=convert.bat^&download=true
  echo.
goto:eof


:check_version
  if exist version.txt del /q "version.txt" > nul
  powershell -Command "Invoke-WebRequest %download_link%?filename=version.txt -OutFile version.txt -Headers @{'Cache-Control'='no-cache'}" > nul

  if exist version.txt (
    set last_version=0
    set /p last_version=<version.txt
    if "%last_version%" equ "0" goto :check_version
    if "%last_version%" equ "" goto :check_version
    
    if "%last_version%" gtr "%version%" echo [INFO] [!] New version ^(%last_version%^) available.
    if "%last_version%" gtr "%version%" echo [INFO] [!] Use '--update' option to update.
    if "%last_version%" gtr "%version%" echo [INFO] [!] Use '--changelogs' to get the changelogs.

    if "%last_version%" equ "%version%" echo [INFO] Your version is up-to-date.
  )
  
  if not exist version.txt echo [ERRO] The latest version index could not be downloaded.
  if not exist version.txt goto exit
  if not exist version.txt exit /b
  
  if exist version.txt del /q "version.txt" > nul
  echo|set /P ="%date%">"%temp_dir%\convert_last_version_check.log"
  echo|set /P ="%last_version%">"%temp_dir%\convert_last_version.log"
goto:eof


:exit
  if "%exitted%" equ "true" exit /b
  call :auto_check_version
  set exitted=true

  if %exit_code% neq 0 (
    echo [EXIT] Process ended with exit code %exit_code%
    echo [EXIT] Use '/?' option to display help.
  )
  echo.
  exit /b

:auto_check_version
  if not exist "%temp_dir%\convert_last_version_check.log" echo|set /P ="boot">"%temp_dir%\convert_last_version_check.log"
    if not exist "%temp_dir%\convert_last_version.log" echo|set /P ="%version%">"%temp_dir%\convert_last_version.log"
    
    set /p convert_last_version_check=<%temp_dir%\convert_last_version_check.log
    set /p last_version_checked=<%temp_dir%\convert_last_version.log
    
    if "%convert_last_version_check%" neq "%date%" call :check_version > nul
    if "%convert_last_version_check%" neq "%date%" call :check_version
    if "%convert_last_version_check%" equ "%date%" (
      if "%last_version_checked%" gtr "%version%" echo [INFO] [!] New version ^(%last_version_checked%^) available.
      if "%last_version_checked%" gtr "%version%" echo [INFO] [!] Use '--update' option to update.
      if "%last_version_checked%" gtr "%version%" echo [INFO] [!] Use '--changelogs' to get the changelog.
    )
  goto:eof

:--update
  call :check_version > nul
  call :check_version > nul
  if exist "_%~n0%~x0" del /q "_%~n0%~x0" > nul
  echo [INFO] Downloading latest version...
  powershell -Command "Invoke-WebRequest %download_link%?filename=convert.bat -OutFile _%~n0%~x0 -Headers @{'Cache-Control'='no-cache'}" > nul
  if exist "_%~n0%~x0" echo [INFO] Download complete
  if not exist "_%~n0%~x0" echo [ERRO] Latest version file could not be downloaded
  if not exist "_%~n0%~x0" goto exit
  if not exist "_%~n0%~x0" exit /b

  if exist "updater.bat" del /q "updater.bat" > nul
  echo [INFO] Downloading updater...
  powershell -Command "Invoke-WebRequest %download_link%?filename=updater.bat -OutFile updater.bat -Headers @{'Cache-Control'='no-cache'}" > nul
  if exist "_%~n0%~x0" echo [INFO] Download complete
  if not exist "_%~n0%~x0" echo [ERRO] Updater could not be downloaded
  if not exist "_%~n0%~x0" goto exit
  if not exist "_%~n0%~x0" exit /b

  start updater.bat %~n0%~x0

  echo [INFO] Update to version %last_version% complete
  echo|set /P ="%date%">"%temp_dir%\convert_last_version_check.log"
  echo|set /P ="%last_version%">"%temp_dir%\convert_last_version.log"
goto:eof


:--install-pdflatex
  WHERE pdflatex >nul 2>nul
  IF %ERRORLEVEL% EQU 0 echo [INFO] pdflatex is already installed
  IF %ERRORLEVEL% EQU 0 goto exit
  IF %ERRORLEVEL% EQU 0 exit /b

  echo [INFO] This operation may take several minutes.
  echo [INFO] Downloading installer utility...
  if not exist miktexsetup-x64.zip powershell -Command "Invoke-WebRequest https://miktex.org/download/win/miktexsetup-x64.zip -OutFile miktexsetup-x64.zip -Headers @{'Cache-Control'='no-cache'}" > nul
  if not exist miktexsetup-x64.zip echo [ERRO] Installer utility could not be downloaded.
  if not exist miktexsetup-x64.zip goto exit
  if not exist miktexsetup-x64.zip exit /b

  echo [INFO] Expanding installer utility...
  if exist   del /q "%temp_dir%\miktexsetup.exe" > nul
  powershell -Command "Expand-Archive -Force miktexsetup-x64.zip %temp_dir%\"
  if not exist "%temp_dir%\miktexsetup.exe" echo [ERRO] Installer utility could not be expanded.
  if not exist "%temp_dir%\miktexsetup.exe" goto exit
  if not exist "%temp_dir%\miktexsetup.exe" exit /b

  set /p installation_dir_pdflatex=[INFO] Enter the installation folder ^(%temp%\miktex^) :
  if "%installation_dir_pdflatex%" equ "" set installation_dir_pdflatex=%temp%\miktex
  echo [INFO] Downloading installation...
  "%temp_dir%\miktexsetup.exe" --verbose "--local-package-repository=%installation_dir_pdflatex%" --package-set=complete download
  echo [INFO] Installation downloaded

  echo [INFO] Installing...
  "%installation_dir_pdflatex%\miktexsetup.exe" --quiet "--local-package-repository=%installation_dir_pdflatex%" --package-set=basic install
  echo [INFO] Installation complete
  echo [INFO] You may need to restart the console to apply the installation.
goto:eof

:--changelogs
  echo [INFO] Downloading changelogs...
  if exist convert_changelogs.txt del /q convert_changelogs.txt > nul
  powershell -Command "Invoke-WebRequest %download_link%?filename=changelogs.txt -OutFile convert_changelogs.txt" > nul

  if not exist "convert_changelogs.txt" echo [INFO] The changelogs could not be downloaded.
  if exist "convert_changelogs.txt" (
    echo.
    type convert_changelogs.txt
    echo.
    del /q "convert_changelogs.txt" > nul
  )
  echo.
goto:eof