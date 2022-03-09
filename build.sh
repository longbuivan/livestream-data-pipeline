#!/bin/bash -xe

echo "Clean out mirrors and other cache apt things"
sudo apt autoclean
sudo apt autoremove

echo "Preparing environment is done"
