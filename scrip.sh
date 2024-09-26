#!/bin/bash

# Prompt the user for the GitHub repository URL
read -p "Enter your GitHub repository URL: " GITHUB_REPO

# Variables
PROJECT_DIR="/var/www/html/project"  # Directory to clone the project
NGINX_CONF="/etc/nginx/sites-available/project"  # Nginx configuration file

# Update packages
sudo apt update -y

# Install Nginx and Git if not already installed
sudo apt install nginx git -y

# Clone the GitHub repository
if [ -d "$PROJECT_DIR" ]; then
    echo "Project directory already exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull origin main  # Change 'main' if your default branch is different
else
    echo "Cloning the project from GitHub..."
    sudo git clone "$GITHUB_REPO" "$PROJECT_DIR"
fi

# Set permissions
sudo chown -R www-data:www-data "$PROJECT_DIR"
sudo chmod -R 755 "$PROJECT_DIR"

# Create Nginx configuration file without server_name
echo "server {
    listen 80;

    location / {
        root $PROJECT_DIR;
        index index.html index.htm index.php;
        try_files \$uri \$uri/ /index.html;
    }
}" | sudo tee "$NGINX_CONF"

# Enable the site and test Nginx configuration
sudo ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/
sudo nginx -t

# Restart Nginx to apply changes
sudo systemctl restart nginx

echo "Deployment completed. Your project is now hosted on Nginx."
