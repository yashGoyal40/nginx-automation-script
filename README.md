# Nginx Automation Deployment Script

This repository contains an automation script to deploy web applications using Nginx. The script supports various application types, including static HTML/CSS/JS applications, as well as modern JavaScript frameworks like React, Angular, and Vue. It adapts to the user's operating system, whether it's Debian/Ubuntu or RHEL/CentOS.

## Features

- **Automatic Environment Setup**: Installs necessary packages and dependencies based on the selected application type.
- **Supports Multiple Application Types**:
  - Static HTML/CSS/JS
  - React
  - Angular
  - Vue
- **OS Compatibility**: Detects whether the operating system is Debian/Ubuntu or RHEL/CentOS and uses the appropriate package manager.
- **Easy to Use**: Prompts the user for input and executes the deployment automatically.

## Prerequisites

- **Linux Server**: This script is intended to be run on a Linux server.
- **Root Access**: The script requires `sudo` privileges to install packages and configure Nginx.
- **Git**: Make sure Git is installed on your server. If not, the script will install it automatically.

## Getting Started

Follow these steps to use the deployment script:

1. **Switch to Root User**
    you will need root permissions to do the configurations

   ```bash
   sudo su

2. **Clone the Repository**:
   You can download the script using `curl`. Run the following command in your terminal:

   ```bash
   curl -O https://raw.githubusercontent.com/yashGoyal40/nginx-automation-script/refs/heads/main/script.sh

3. **Make the Script Executable**:
   Once the script is downloaded, make it executable by running:
   ```bash
   sudo chmod +x script.sh

4. **Run the Script**:
   Execute the script with the following command:

   ```bash
    ./script.sh

## Script Prompts
- **The script will prompt you for the following inputs:**:
  - The GitHub repository URL containing your project.
  - The type of application (HTML/CSS/JS, React, Angular, or Vue).
  - The operating system type (Debian/Ubuntu or RHEL/CentOS).

## Deployment Process
**After providing the required inputs, the script will:**
- 1. Clone the specified repository.
  2. Install the necessary packages.
  3. Set up the Nginx configuration to serve your application.
  4. Restart Nginx to apply the changes.
     
## Usage Example
You can use the script as follows:
```bash
    curl -O https://raw.githubusercontent.com/yashGoyal40/nginx-automation-script/refs/heads/main/script.sh
    sudo chmod +x script.sh
    ./script.sh
```
## Contributing
Contributions are welcome! If you have suggestions for improvements or encounter issues, feel free to open an issue or submit a pull request

## Author

Yash Goyal
Feel free to connect with me on [GitHub](https://github.com/yashGoyal40).

