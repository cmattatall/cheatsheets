#!/bin/bash
# Bash script to install python3.10 on ubuntu 20.04
#
# Run with root permissions
#

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.10

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2

# Fix gnome terminal on ubuntu 20.04
sudo sed -i.old '1 s;/usr/bin/python3;/usr/bin/python3.8;' /usr/bin/gnome-terminal
