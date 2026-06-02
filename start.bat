@echo off
echo ============================================================
echo  WVS Wireless Sensor Network Monitor
echo ============================================================
echo.

REM Check if virtual environment exists
IF NOT EXIST "venv\Scripts\activate.bat" (
    echo Creating virtual environment...
    python -m venv venv
    echo.
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install / upgrade dependencies
echo Installing dependencies...
pip install -r requirements.txt --quiet
echo.

REM Start the application
echo Starting WVS server...
echo Open your browser at: http://localhost:8080
echo Press Ctrl+C to stop.
echo.
python main.py

pause
