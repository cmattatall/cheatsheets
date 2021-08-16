
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
