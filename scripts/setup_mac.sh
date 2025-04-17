#!/bin/bash

# Setup Script for macOS - Code Campfire Python Backend
echo "=== Setting up Code Campfire Python Backend environment for macOS ==="

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

# Install required dependencies
echo "Installing dependencies..."
brew install python3 postgresql jq httpie readline sqlite3 xz zlib tcl-tk@8

# Check if pyenv is already installed
if ! command -v pyenv &> /dev/null; then
    echo "Installing pyenv..."
    # Skip pyenv installation if directory already exists
    if [ -d "$HOME/.pyenv" ]; then
        echo "Pyenv directory already exists, skipping installation."
    else
        curl https://pyenv.run | bash
        
        # Configure shell for pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
    fi
else
    echo "pyenv already installed."
fi

# Skip Python installation if causing issues
echo "Checking Python 3 installation..."
if command -v python3 &> /dev/null; then
    python3_version=$(python3 --version)
    echo "Python 3 is already installed: $python3_version"
else
    echo "Python 3 not found. Installing via Homebrew..."
    brew install python3
fi

# Create Python virtual environment with standardized name
echo "Creating virtual environment..."
python3 -m venv venv
echo "Created virtual environment: venv"

# Activate virtual environment and install Django
echo "Installing Django and required packages..."
source venv/bin/activate
pip install Django djangorestframework psycopg2-binary python-dotenv django-cors-headers

# Set up database and environment
echo "Setting up database configuration..."

# Check if .env already exists
if [ -f .env ]; then
    echo ".env file already exists. Skipping database setup."
else
    # Copy from sample if it exists
    if [ -f .env_sample.txt ]; then
        cp .env_sample.txt .env
        echo "Created .env file from sample template."
    else
        # Create new .env file
        cat > .env << EOF
DATABASE_NAME=codefire_db
DATABASE_USER=codefire_user
DATABASE_PASSWORD=codefire_password
DATABASE_HOST=localhost
DATABASE_PORT=5432
EOF
        echo "Created new .env file with default values."
    fi
    
    # Database setup prompt
    echo ""
    echo "Would you like to setup a PostgreSQL database with these credentials? (y/n)"
    read -r setup_db
    
    if [ "$setup_db" = "y" ] || [ "$setup_db" = "Y" ]; then
        db_name=$(grep DATABASE_NAME .env | cut -d= -f2)
        db_user=$(grep DATABASE_USER .env | cut -d= -f2)
        db_password=$(grep DATABASE_PASSWORD .env | cut -d= -f2)
        
        # Create PostgreSQL user and database
        echo "Creating database user and database..."
        createuser -s "$db_user" 2>/dev/null || echo "User may already exist, continuing..."
        createdb -O "$db_user" "$db_name" 2>/dev/null || echo "Database may already exist, continuing..."
        
        # Set user password
        psql -c "ALTER USER $db_user WITH PASSWORD '$db_password';" postgres
        
        echo "Database setup completed."
    else
        echo "Skipping database setup. You'll need to set up the database manually."
    fi
fi

# Run migrations
echo "Running Django migrations..."
python3 manage.py migrate

# Instructions for activating the virtual environment
echo "
=== Setup Complete ===

IMPORTANT: To use Django, you MUST activate the virtual environment first!

To activate the virtual environment in the future, run:
source venv/bin/activate

Once activated, run the server with:
python3 manage.py runserver

To start the server now, run these commands:
source venv/bin/activate
python3 manage.py runserver
"

echo "Setup completed!" 