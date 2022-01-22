#!/bin/bash -xe

echo "Clean out mirrors and other cache apt things"
sudo apt-get autoclean
sudo apt python3-devel.x86_64 -y
sudo apt install python3-setuptools.noarch -y 
apt install unixODBC-devel -y

echo "Preparing environment is done"
