# Ghost 

> Ghost is an open source blogging platform written in JavaScript and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.
>
> ~[Wiki](https://en.wikipedia.org/wiki/Ghost_(blogging_platform))


I try to eliminate the issue(s) we sometime face when installing a new program / app which is trying to remember all the cmd needed to install everything. 
I hope you find this script useful and if you run into any error or issue(s), please let me know.

This script helps you automate the installation process of installing Ghost and its required components like MySQL, Node.js and Ghost itself as well as 
setting up users and directories. 
With this easy-to-follow guide, you can have a working version of Ghost and be posting blogs in record time! 


## AWS EC2 Instructions:

Start out by either SSH into your instance or use SSM to connect from the AWS EC2 console.
Run the following cmds in terminal:

1. `cd /tmp`

  * Either git clone the repo or create a new file with nano or vim and copy / paste the script into the file and save.

I'll be using the copy and paste method for this walkthough.

2. Create the new file with `sudo nano ghost_setup.sh`

3. While in file, copy and paste the script into the editor, save and exit.
4. Run `sudo chmod +x ghost_setup.sh` to set execution permissions to the file
5. Run the script as sudo `sudo ./ghost_setup.sh` which will start the install process
6. Walk through all the steps of the script:
   1. Select 1 and create a new user for ghost
   2. The script will now use the new user to complete the rest of the script
      * During the MySQL install, be sure to note the three cmd to copy and paste into mysql console
      * During the site directory portion, be sure to name your directory to what you want your website / domain name you want to use
      * Also note that the Ghost script will also attempt to install TSL so be sure to have your Security Groups set correctly to allow this to complete
      * Be sure to note all your passwords as Ghost Install will ask you several times for sudo user password
   3. The install should now have completed and Ghost should be up and running. It will provide you with a link to nav to your website.
