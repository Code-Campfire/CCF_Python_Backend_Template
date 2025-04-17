# Code Campfire Python Backend

A Django REST API project for Code Campfire.

## Setup and Installation

### Quick Setup Using Scripts

For a quick and automated setup, we provide scripts for both macOS and Windows environments:

#### macOS

1. Open Terminal and navigate to the project root directory.
2. Run the setup script:
   ```bash
   chmod +x scripts/setup_mac.sh  # Make script executable (first time only)
   ./scripts/setup_mac.sh
   ```
3. The script will:
   - Install required dependencies
   - Set up Python 3 and required packages
   - Create a virtual environment and install Django
   - Create a `.env` file with database settings
   - Offer to create the PostgreSQL database for you
   - Run initial database migrations
4. After the script completes, **you MUST activate the virtual environment**:
   ```bash
   source venv/bin/activate
   ```
5. Start the development server:
   ```bash
   python3 manage.py runserver
   ```
6. Access the application at http://localhost:8000/api/hello/
7. For future sessions, always activate the virtual environment first:
   ```bash
   source venv/bin/activate
   python3 manage.py runserver
   ```

#### Windows

1. Open Command Prompt or PowerShell as administrator and navigate to the project root directory.
2. Run the setup script:
   ```cmd
   scripts\setup_windows.bat
   ```
3. The script will:
   - Check for Python and required packages
   - Create a virtual environment
   - Install project dependencies
   - Create a `.env` file with database settings
   - Offer to create the PostgreSQL database for you
   - Run initial database migrations
4. After the script completes, verify the virtual environment is activated.
5. Start the development server:
   ```cmd
   python manage.py runserver
   ```
6. Access the application at http://localhost:8000/api/hello/
7. For future sessions, always activate the virtual environment first:
   ```cmd
   venv\Scripts\activate.bat
   python manage.py runserver
   ```

### Manual Setup Instructions

### Setting up a Debian-based Linux Development Environment

This guide will help you set up your Debian-based Linux environment for development.

#### Prerequisites

Make sure you have sudo privileges on your system.

#### Installation Steps

This is the recommended environment setup for projects. The team can choose to use a different environment, but less support will be available in the community for differing environments.

##### Linux (Debian-based e.g. Ubuntu)

1. **Update Package Lists**

    ```bash
    sudo apt update
    ```

2. **Install Required Dependencies**

    ```bash
    sudo apt install -y build-essential python3-dev python3-pip python3-venv git \
        postgresql postgresql-contrib libpq-dev \
        make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
        wget curl llvm libncurses5-dev libncursesw5-dev xz-utils \
        tk-dev libffi-dev liblzma-dev python-openssl jq httpie
    ```