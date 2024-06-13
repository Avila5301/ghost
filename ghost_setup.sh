#!/bin/bash

starting_point() {
    echo "Welcome to Ghost Install Script"
    sleep 3
    echo " "
    echo "Please start with creating a user then run step 2 which complets the rest of the script"
    echo "1. Create a new user for Ghost"
    echo "2. Continue with the rest of the install"
    read answer
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
        echo "Created user $user..."
        echo " "
        sleep 2
        echo "Setting $user to sudo group..."
        usermod -aG sudo $user
        echo "New user added..."
        sleep 3 
    fi
    echo "Continuing & Switching user --> $user"
    sleep 3
    su -c '/tmp/ghost_setup.sh' $user
    sleep 3
}

check_updates() {
    clear
    sleep 2
    echo "Checking for Updates and Upgrading..."
    sleep 2
    sudo -S apt update
    echo " "
    echo "Running Upgrade -y next..."
    sleep 4
    sudo -S apt upgrade -y
    clear
}

install_nginx() {
    echo "Installing Nginx..."
    echo " "
    sleep 3
    sudo -S apt install nginx -y
    echo "Nginx Install Completed..."
    sleep 2
}

check_firewall() {
    clear
    echo "Do you have ufw enabled? Y/N: "
    read firewall
    if [[ $firewall -eq "y" ]]; then
        sudo -S apt allow 'Nginx Full'
    else
        echo "Skipping this Step"
        echo " "
        sleep 2
    fi
}

install_mysql() {
    clear
    echo "Installing MySQL Server..."
    sleep 3
    sudo -S apt install mysql-server -y
    echo "MySQL Install completed..."
    echo " "
    sleep 5
    clear
    prep_mysql
}

prep_mysql() {
    echo "Copy this and paste the following 3 lines into mysql"
    echo "Paste in one at a time"
    echo " "
    echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '<your-new-root-password>';"
    echo "FLUSH PRIVILEGES;"
    echo "exit"
    echo " "
    sudo -S mysql
}

install_nodejs() {
    clear
    echo "Installing Node.js Keyring"
    sleep 2
    sudo -S apt update
    sudo -S apt install -y ca-certificates curl gnupg
    $keyring="/etc/apt/keyrings"
    if [ -d /etc/apt/keyrings ]; then
        echo "Keyring Directory exist"
        echo "Adding node.js keyring to $keyring directory..."
        sleep 2
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo -S gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    else
        echo "$keyring does not exist...creating it now."
        sleep 2
        sudo -S mkdir -p $keyring
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo -S gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    fi

    clear
    echo "Node.JS Keyring added..."
    echo "Installing Node.js v18"
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    echo "Continuing in 5 seconds..."
    sleep 5
    clear
    sudo -S apt update
    echo "Running apt install nodejs -y next..."
    sleep 3
    sudo -S apt install nodejs -y
    echo "Node.JS Install completed..."
    sleep 3
}

install_ghostCLI() {
    clear
    echo "Installing Ghost-CLI..."
    sleep 3
    sudo -S npm install ghost-cli@latest -g
}

create_website_dir() {
    echo " "
    echo "Let's Create a directory for your blog website"
    echo "Enter your domain name..."
    read domain
    echo "Enter your username created in step 1."
    read user
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
    echo "Installing Ghost into current directory..."
    pwd
    sleep 3
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
    create_website_dir username
}

start