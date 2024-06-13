#!/bin/bash

LOGFILE="/tmp/ghost_install.log"
exec > >(tee -a $LOGFILE) 2>&1

starting_point() {
    echo "Welcome to Ghost Install Script for AWS EC2"
    sleep 1
    echo "Please start with creating a user then run step 2 which completes the rest of the script."
    echo "1. Create a new user for Ghost"
    echo "2. Continue with the rest of the install"
    read -p "Enter your choice: " answer
    if [[ $answer -eq "1" ]]; then
        create_user
    else
        main
    fi
}

create_user() {
    clear
    echo "Starting Script to install Ghost..."
    echo "Enter Username for Ghost installation"
    read user
    if id -u $user &>/dev/null; then
        clear
        echo "User Exists"
        echo "Please Use another name"
        echo " "
        create_user
        clear
    else
        echo "Creating user [$user]"
        sleep 1
        adduser $user
        sleep 2
        echo " "
        echo "Setting $user to sudo group..."
        usermod -aG sudo $user
        echo "New user added..."
        sleep 3 
    fi
    echo "Continuing & Switching user --> [$user]"
    sleep 3
    su -c '/tmp/Ghost/ghost_setup.sh' $user
    sleep 3
}

check_updates() {
    clear
    sleep 2
    echo "Checking for Updates and Upgrading..."
    sleep 2
    sudo -S apt update 
    sudo -S apt upgrade -y
    clear
}

install_nginx() {
    echo "Installing Nginx..."
    echo " "
    sleep 2
    sudo -S apt install nginx -y
    echo "Nginx Install Completed..."
    sleep 2
}

check_firewall() {
    clear
    read -p "Do you have ufw enabled? Y/N: " firewall
    if [[ $firewall =~ ^[Yy]$ ]]; then
        sudo -S ufw allow 'Nginx Full'
    else
        echo "Skipping this configuration"
        echo " "
        sleep 2
    fi
}

install_mysql() {
    clear
    echo "Installing MySQL Server..."
    sleep 2
    sudo -S apt install mysql-server -y
    echo "MySQL Install completed..."
    echo " "
    sleep 3
    clear
    prep_mysql
}

prep_mysql() {
    echo "Copy this and paste the following 3 lines into mysql"
    echo "Paste in one at a time"
    echo " "
    echo -e '\033[1;32m1.-----> ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'your-new-strong-root-password';\033[m';
    echo -e "\033[1;32m2.-----> FLUSH PRIVILEGES;\033[m";
    echo -e "\033[1;32m3.-----> exit\033[m";
    echo " "
    echo "Opening MySQL console..."
    sudo -S mysql
}

install_nodejs() {
    clear
    echo "Installing Node.js, Keyring and certificates"
    sleep 2
    sudo -S apt update
    echo " "
    sudo -S apt install -y ca-certificates curl gnupg
    $keyring="/etc/apt/keyrings"
    if [ ! -d $keyring ]; then
        echo "$keyring does not exist...creating it now."
        sleep 2
        sudo -S mkdir -p $keyring
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo -S gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    fi
    
    sleep 1
    echo " "
    echo "Adding node.js keyring to $keyring directory..."
    sleep 2
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo -S gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    clear
    echo "Node.JS Keyring added..."
    echo "Installing Node.js v18"
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    echo "Continuing in 3 seconds..."
    sleep 3
    clear
    sudo -S apt update
    echo "Running apt install nodejs -y next..."
    sleep 2
    sudo -S apt install nodejs -y
    echo "Node.JS Install completed..."
    sleep 2
}

install_ghostCLI() {
    clear
    echo "Installing Ghost-CLI..."
    sleep 3
    sudo -S npm install ghost-cli@latest -g
}

create_website_dir() {
    echo " "
    echo "Creating a directory for your blog website..."
    read -p "Enter your domain name: " domain
    read -p  "Enter your username created in step 1: " user
    sudo -S mkdir -p /var/www/$domain
    sudo -S chown $user:$user /var/www/$domain
    sudo -S chmod 775 /var/www/$domain
    cd /var/www/$domain
    echo "Directory created and are now in..."
    pwd
    sleep 3
    install_ghost
}

install_ghost() {
    clear
    echo "Installing Ghost into current directory...$(pwd)"
    echo "You will be required to enter your MySQL Password and User Password serveral time."
    sleep 2
    echo "Ghost Install will also attempt to install TSL certificate for your website"
    echo "Be sure to have your security groups config correctly"
    sleep 5
    ghost install
}

start() {
    clear
    echo "Starting Ghost Install Script..."
    starting_point
}

main() {
    sleep 3
    check_updates
    install_nginx
    check_firewall
    install_mysql
    install_nodejs
    install_ghostCLI
    create_website_dir
}

start