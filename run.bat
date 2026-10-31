@echo off
setlocal
cd /d "%~dp0"
title AI-NIDS

rem ---- choose Python: project virtual environment first, then the active/system Python
set "PY="
if exist "venv\Scripts\python.exe" set "PY=venv\Scripts\python.exe"
if not defined PY (
    where python >nul 2>nul
    if errorlevel 1 (
        echo [ERROR] Python was not found. Install Python 3.10 or newer from https://www.python.org/downloads/
        echo         and tick "Add python.exe to PATH" during installation.
        pause
        exit /b 1
    )
    set "PY=python"
)

rem ---- check dependencies
"%PY%" -c "import streamlit, pandas, numpy, sklearn, plotly, joblib" >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Required packages are missing for: %PY%
    echo.
    echo Run these commands once in this folder, then run run.bat again:
    echo     python -m venv venv
    echo     venv\Scripts\activate
    echo     pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo Starting AI-NIDS... your browser should open automatically.
echo If it does not, open the Local URL printed below. Press Ctrl+C to stop.
"%PY%" -m streamlit run app.py
if errorlevel 1 (
    echo.
    echo [ERROR] The application stopped with an error. See the messages above.
    pause
)
endlocal
