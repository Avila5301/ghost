# Ghost 

> Ghost is an open source blogging platform written in JavaScript and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.
>
> ~[Wiki](https://en.wikipedia.org/wiki/Ghost_(blogging_platform))


### Short Intro:

With this repo, I attempt to eliminate the issue(s) we sometime face when installing a new program / app which is trying to remember all the cmd needed to install everything
or having to copy / paste everything into a terminal, line by line. I hope you find this script useful and if you run into any error or issue(s), please let me know.


Also, if you can Star this repo, 1000x thanks and much Love!


### Script Purpose:

This script helps you automate the installation process of installing Ghost and its required components like MySQL, Node.js and Ghost itself as well as 
setting up users and directories. With this easy-to-follow guide, you can have a working version of Ghost and be posting blogs in record time! 


### CMD used in the Script

All CMDs were from the [ghost install documentation](https://ghost.org/docs/install/ubuntu/) for Ubuntu (22.04 LTS).


#### Server Prerequisites:

* Ubuntu 20.04 or Ubuntu 22.04
* NGINX (minimum of 1.9.5 for SSL)
* A supported version of Node.js
* MySQL 8
* Systemd
* A server with at least 1GB memory
* A registered domain name


## AWS EC2 Instructions:
I'm assuming you have already launched your EC2 and are ready to proceed with the Ghost Install


Start out by either SSH into your instance or use SSM to connect from the AWS EC2 console.

Run the following cmds in terminal:

1. `cd /tmp`

  * Either git clone the repo or create a new file with nano or vim and copy / paste the script into the file and save.

  * I'll be using git clone https://github.com/Avila5301/Ghost.git method for this walkthough.

2. Copy the repository `git clone https://github.com/Avila5301/Ghost.git` and `cd Ghost` into the Ghost directory.

        git clone https://github.com/Avila5301/Ghost.git
   <br>
   
        cd Ghost

4. Run `sudo chmod +x ghost_setup.sh` to set execution permissions to the file

        sudo chmod +x ghost_setup.sh
   
6. Run the script as sudo `sudo ./ghost_setup.sh` which will start the install process

        sudo ./ghost_setup.sh

7. Walk through all the steps of the script:
   1. Select 1 and create a new user for ghost
   2. The script will now use the new user to complete the rest of the script
      * During the MySQL install, be sure to note the three cmd to copy and paste into mysql console
      * During the site directory portion, be sure to name your directory to what you want your website / domain name you want to use
      * Also note that the Ghost script will also attempt to install TSL so be sure to have your Security Groups set correctly to allow this to complete
      * Be sure to note all your passwords as Ghost Install will ask you several times for sudo user password
   3. The install should now have completed and Ghost should be up and running. It will provide you with a link to nav to your website.


## Ghost Install Notes

When Ghost is being installed which is the last part of the script, it will prompt you with serveral questions and to enter your user password. 
Here is what you can expect and the defaults you can enter

    ? Enter your blog URL: YOUR DOMAIN NAME / URL | myblogwebsite.com
    ? Enter your MySQL hostname: 127.0.0.1 | Press enter to leave default
    ? Enter your MySQL username: root | Enter Root
    ? Enter your MySQL password: [hidden] | Enter your MySQL Root password
    ? Enter your Ghost database name: | Press enter to leave default
    ✔ Configuring Ghost
    ✔ Setting up instance
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ✔ Setting up "USERNAME" system user
    ? Do you wish to set up "USERNAME" mysql user? | Enter Yes for default
    ? Do you wish to set up Nginx? Yes
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    + sudo nginx -s reload
    ? Sudo Password [hidden]
    ✔ Setting up Nginx
    ? Do you wish to set up SSL? Yes
    ? Enter your email (For SSL Certificate) ENTER YOUR EMAIL ADDRESS
    + sudo mkdir -p /etc/letsencrypt
    ? Sudo Password [hidden]
    + sudo ./acme.sh --install --home /etc/letsencrypt
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    + sudo nginx -s reload
    ? Sudo Password [hidden]
    ✔ Setting up SSL
    ? Do you wish to set up Systemd? Yes
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ✔ Setting up Systemd
    ? Sudo Password [hidden]
    ? Do you want to start Ghost? Yes
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ? Sudo Password [hidden]
    ✔ Starting Ghost`

Ghost was installed successfully! To complete setup of your publication, visit:

      https://TheURLtoYourWebSite.com


You can now navagate to your website with the link and setup your website.
