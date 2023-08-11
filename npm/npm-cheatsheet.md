
System Limit Number Of File Watchers Reached.
This is an issue with nodemon. The easiest way to resolve is to 
increase your system limit 
(the better way to resolve is to determine why nodemon is trying to track so many files).


`sudo sysctl fs.inotify.max_user_watches=100000`
The above change will only persist until you restart.

To set a permanent limit, use
`echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p`
