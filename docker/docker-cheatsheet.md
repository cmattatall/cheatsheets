
# Change permissions to allow docker use without sudo

$ sudo groupadd docker
$ sudousermod -aG docker $(whoami)
$ sudo reboot


# Configure docker to start on boot

$ sudo systemctl enable docker.service
$ sudo systemctl enable containerd.service

# apt-get update doesn't work from inside dockerfile

https://stackoverflow.com/questions/24832972/docker-apt-get-update-fails

1. Make sure you have network connectivity
2. Make sure docker daemon has correct permissions
3. Edit /etc/docker/daemon.json dns fields and make sure that DNS servers are
   valid. A solid and commonly used public DNS server is googles DNS resolver
   at 8.8.8.8 and 8.8.4.4

Once you have made the change that you believe to fix the proble, you should
restart the docker daemon.

$sudo systemctl restart docker.server OR $sudo service docker restart OR just
restart your machine

# Docker can't seem to find packages (apt, apk, pacman, etc)

1. Confirm network connectivity
2. Confirm docker image network settings (especially if using docker-compose)
3. Check if /etc/docker/daemon.json exists. If exists, make sure DNS servers are valid
4. Restart the docker daemon using

- $ sudo systemctl restart docker.service 
- Restart your machine
- Manually kill the processes associated with docker and use systemd to relaunch docker.



Assuming the package exists for the correct version, and
that your docker network settings are configured correctly,
and that you have 

