#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install python-software-properties -y
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y

# install pm2
sudo npm install pm2 -g

# Install nginx
sudo apt-get install nginx -y

# This block will fix an nginx bug
sudo systemctl stop nginx
sudo mkdir /etc/systemd/system/nginx.service.d
# build the file in root where no sudo is needed
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > ~/override.conf
sudo cp ~/override.conf /etc/systemd/system/nginx.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl start nginx

# Make a global variable
export DB_HOST=137.20.2.96
# set the db host to the same ip as the db in the global variable folder
echo "export DB_HOST=137.20.2.96" >> ~/.bashrc
# export DB_HOST=192.168.10.148
# source rereads the file, shouldn't need it but it is in here just in case
source ~/.bashrc

# go to app install npm and pm2 start
cd /home/ubuntu/app
sudo npm install
pm2 start app.js --update-env
# Dont need to set the port as the mogodb is assigned to 0.0.0.0 so it listens across all ports

# copy the synced reverse proxy configuration file to the sites available folder
sudo cp /home/ubuntu/app/reverse-proxy.conf /etc/nginx/sites-available/reverse-proxy.conf
# link the new proxy, setting it as default
sudo ln -s /etc/nginx/conf.d/reverse-proxy.conf /etc/nginx/sites-enabled/default
# finally, restart the nginx service so the new config takes hold
sudo systemctl restart nginx