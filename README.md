# Code Campfire Python Backend

A Django REST API project for Code Campfire.

## Setup and Installation

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

##### MacOS

1. **Install Homebrew (if necessary)**

    ```bash
    curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

    ```

2. **Install Dependencies**

    ```bash
    brew install python3 postgresql jq httpie readline sqlite3 xz zlib tcl-tk@8
    ```

3. **Install pyenv**

    ```bash
    curl https://pyenv.run | bash
    ```

4. **Add pyenv to your shell configuration**

    ```bash
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    ```

5. **Reload shell configuration**

    ```bash
    source ~/.zshrc
    ```

6. **Verify installation**

    ```bash
    pyenv --version
    ```

7. **Install the latest stable Python version**

    ```bash
    pyenv install <latest_stable_version>
    ```

8. **Set it as the global version**

    ```bash
    pyenv global <latest_stable_version>
    ```

9. **Verify the installation**

    ```bash
    python --version
    ```

10. **Make sure your shell is configured to use the new Python version**

    Restart terminal.

11. **Install Python Tools**

    ```bash
    pip3 install --user pipx
    python3 -m pipx ensurepath
    ```

12. **Install Poetry**

    ```bash
    pipx install poetry
    ```

13. **Verify Poetry Installation**

    ```bash
    poetry --version
    ```

### Project Setup

1. **Initialize Project with Poetry**

    ```bash
    poetry init
    ```

2. **Install Project Dependencies**

    ```bash
    poetry lock
    poetry install Django djangorestframework psycopg2 sqlparse asgiref Pillow load_dotenv django-cors-headers
    ```

3. **Create a Virtual Environment**

    ```bash
    python3 -m venv venv_py_<version_number>
    ```

4. **Activate Virtual Environment**

    ```bash
    source venv_py_<version_number>/bin/activate
    ```

### PostgreSQL Setup

#### Linux (Debian-based)

1. **Enable and Start PostgreSQL Service**

    ```bash
    sudo service postgresql start
    ```

#### MacOS

1. **Start PostgreSQL Service**

    ```bash
    brew services start postgresql
    ```

### Database Configuration for all OS

2. **Create a PostgreSQL User and Database**

    ```bash
    sudo -u postgres psql -c "CREATE USER your_database_user WITH PASSWORD 'your_user_password';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON SCHEMA public TO your_database_user;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_database_user;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_database_user;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO your_database_user;"
    ```

3. **Create an .env.local file in the project root**

    ```bash
    DATABASE_NAME=your_database_name
    DATABASE_USER=your_database_user
    DATABASE_PASSWORD=your_user_password
    DATABASE_HOST=localhost
    DATABASE_PORT=5432
    ```
