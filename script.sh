#!/bin/bash

# Prompt the user for the GitHub repository URL
read -p "Enter your GitHub repository URL: " GITHUB_REPO

# Prompt the user for the type of application
echo "Select the type of application:"
echo "1) HTML/CSS/JS"
echo "2) React"
echo "3) Angular"
echo "4) Vue"
read -p "Enter your choice (1-4): " APP_TYPE

# Prompt the user for the operating system type
echo "Select your operating system type:"
echo "1) Debian/Ubuntu"
echo "2) RHEL/CentOS"
read -p "Enter your choice (1-2): " OS_TYPE

# Set package manager based on OS type
if [ "$OS_TYPE" -eq 1 ]; then
    PACKAGE_MANAGER="apt"
    INSTALL_COMMAND="sudo apt install -y"
else
    PACKAGE_MANAGER="yum"
    INSTALL_COMMAND="sudo yum install -y"
fi

# Variables
PROJECT_DIR="/var/www/html/project"  # Directory to clone the project
NGINX_CONF="/etc/nginx/sites-available/project"  # Nginx configuration file

# Update packages
sudo $PACKAGE_MANAGER update -y

# Install Nginx and Git if not already installed
sudo $INSTALL_COMMAND nginx git

# Clone the GitHub repository
if [ -d "$PROJECT_DIR" ]; then
    echo "Project directory already exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull origin main  # Change 'main' if your default branch is different
else
    echo "Cloning the project from GitHub..."
    sudo git clone "$GITHUB_REPO" "$PROJECT_DIR"
fi

# Navigate to the project directory
cd "$PROJECT_DIR"

# Create the directory for sites-available if it doesn't exist
if [ ! -d "/etc/nginx/sites-available" ]; then
    sudo mkdir /etc/nginx/sites-available
fi

if [ ! -d "/etc/nginx/sites-enabled" ]; then
    sudo mkdir /etc/nginx/sites-enabled
fi

# Check application type and set up accordingly
if [ "$APP_TYPE" -eq 1 ]; then
    # HTML/CSS/JS app
    echo "Setting up HTML/CSS/JS app..."
    # No additional setup required for plain HTML/CSS/JS

    # Set permissions
    sudo chown -R root:root "$PROJECT_DIR"
    sudo chmod -R 755 "$PROJECT_DIR"

    # Create Nginx configuration for HTML/CSS/JS
    echo "server {
        listen 80;

        location / {
            root $PROJECT_DIR;
            index index.html index.htm;
            try_files \$uri \$uri/ /index.html;
        }
    }" | sudo tee "$NGINX_CONF"

elif [ "$APP_TYPE" -eq 2 ]; then
    # React app
    echo "Setting up React app..."
    # Install Node.js and npm
    sudo $INSTALL_COMMAND nodejs npm

    # Install dependencies and build the React app
    npm install
    npm run build

    # Set permissions for the build folder
    sudo chown -R root:root "$PROJECT_DIR/dist"
    sudo chmod -R 755 "$PROJECT_DIR/dist"

    # Create Nginx configuration for React
    echo "server {
        listen 80;

        location / {
            root $PROJECT_DIR/dist;
            index index.html;
            try_files \$uri \$uri/ /index.html;
        }
    }" | sudo tee "$NGINX_CONF"

elif [ "$APP_TYPE" -eq 3 ]; then
    # Angular app
    echo "Setting up Angular app..."
    # Install Node.js and npm
    sudo $INSTALL_COMMAND nodejs npm

    # Install Angular CLI
    sudo npm install -g @angular/cli

    # Install dependencies and build the Angular app
    npm install
    ng build --prod

    # Set permissions for the dist folder
    sudo chown -R root:root "$PROJECT_DIR/dist"
    sudo chmod -R 755 "$PROJECT_DIR/dist"

    # Create Nginx configuration for Angular
    echo "server {
        listen 80;

        location / {
            root $PROJECT_DIR/dist;
            index index.html;
            try_files \$uri \$uri/ /index.html;
        }
    }" | sudo tee "$NGINX_CONF"

elif [ "$APP_TYPE" -eq 4 ]; then
    # Vue app
    echo "Setting up Vue app..."
    # Install Node.js and npm
    sudo $INSTALL_COMMAND nodejs npm

    # Install Vue CLI
    sudo npm install -g @vue/cli

    # Install dependencies and build the Vue app
    npm install
    npm run build

    # Set permissions for the dist folder
    sudo chown -R root:root "$PROJECT_DIR/dist"
    sudo chmod -R 755 "$PROJECT_DIR/dist"

    # Create Nginx configuration for Vue
    echo "server {
        listen 80;

        location / {
            root $PROJECT_DIR/dist;
            index index.html;
            try_files \$uri \$uri/ /index.html;
        }
    }" | sudo tee "$NGINX_CONF"

else
    echo "Invalid selection. Exiting."
    exit 1
fi

# Create the symbolic link for sites-enabled
sudo ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Restart Nginx to apply changes
sudo systemctl restart nginx

echo "Deployment completed. Your application is now hosted on Nginx."
