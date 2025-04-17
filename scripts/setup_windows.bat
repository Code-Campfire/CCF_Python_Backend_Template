@echo off
echo === Setting up Code Campfire Python Backend environment for Windows ===

:: Check if Python is installed
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Python not found. Please install Python 3.9+ from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

:: Display Python version
python --version
echo.

:: Check if pip is installed
where pip >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo pip not found. Please ensure Python was installed correctly.
    pause
    exit /b 1
)

:: Install required Python packages
echo Installing required Python packages...
pip install virtualenv

:: Create a virtual environment with standardized name
echo Creating virtual environment...
virtualenv venv
echo Virtual environment created: venv

:: Activate the virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

:: Install required packages in the virtual environment
echo Installing project dependencies...
pip install Django djangorestframework psycopg2-binary python-dotenv django-cors-headers

:: Check if PostgreSQL is installed by looking for psql
where psql >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo PostgreSQL not found. Please install PostgreSQL from https://www.postgresql.org/download/windows/
    echo Make sure to note the password you set for the 'postgres' user.
    echo After installation, you'll need to:
    echo 1. Add PostgreSQL bin directory to your PATH
    echo 2. Create a database and user for the project
) else (
    echo PostgreSQL is installed.
)

:: Set up database and environment
echo Setting up database configuration...

:: Check if .env already exists
if exist .env (
    echo .env file already exists. Skipping creation.
) else (
    :: Copy from sample if it exists
    if exist .env_sample.txt (
        copy .env_sample.txt .env
        echo Created .env file from sample template.
    ) else (
        :: Create new .env file
        echo DATABASE_NAME=codefire_db> .env
        echo DATABASE_USER=codefire_user>> .env
        echo DATABASE_PASSWORD=codefire_password>> .env
        echo DATABASE_HOST=localhost>> .env
        echo DATABASE_PORT=5432>> .env
        echo Created new .env file with default values.
    )
    
    :: Database setup prompt
    echo.
    set /p setup_db=Would you like to setup a PostgreSQL database with these credentials? (y/n): 
    
    if /i "%setup_db%"=="y" (
        :: Extract database info from .env file
        for /f "tokens=2 delims==" %%a in ('findstr "DATABASE_NAME" .env') do set db_name=%%a
        for /f "tokens=2 delims==" %%a in ('findstr "DATABASE_USER" .env') do set db_user=%%a
        for /f "tokens=2 delims==" %%a in ('findstr "DATABASE_PASSWORD" .env') do set db_password=%%a
        
        :: Create PostgreSQL user and database using psql
        echo Creating database user and database...
        
        :: Create a temporary SQL file
        echo CREATE USER %db_user% WITH PASSWORD '%db_password%';> setup_db.sql
        echo CREATE DATABASE %db_name% OWNER %db_user%;>> setup_db.sql
        
        :: Run the SQL commands (requires the user to enter password)
        echo Please enter your PostgreSQL superuser (postgres) password:
        psql -U postgres -f setup_db.sql
        
        :: Clean up
        del setup_db.sql
        
        echo Database setup completed.
    ) else (
        echo Skipping database setup. You'll need to set up the database manually.
    )
)

:: Run migrations
echo Running Django migrations...
python manage.py migrate

echo.
echo === Setup Complete ===
echo.
echo To activate the virtual environment in the future:
echo venv\Scripts\activate.bat
echo.
echo To run the server:
echo python manage.py runserver
echo.

:: Keep the window open
pause 