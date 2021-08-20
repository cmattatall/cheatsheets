
# Timezone is incorrect

There may be many causes of this so it is hard to make 
a comprehensive guide on this. As a quick fix, we can do
$sudo ntpdate ntp.ubuntu.com

As a less hacky fix, we can also make a systemd service
that runs that command on systemd service startup, but
ideally we'd like to change some configuration params
to fix the problem in a more streamlined manner


The following may help with troubleshooting steps:
- Check status of the systemd service for timesync:

```
$systemd-timesyncd.service - Network Time Synchronization
	Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; disabled; vendor preset: enabled)
	Active: inactive (dead)
	Docs: man:systemd-timesyncd.service(8)
```

You can fix this using `$sudo systemctl restart systemd-timesyncd.service `
	


- Check if ntpdate is installed using `$ sudo dpkg --list | grep ntpdate`.
	If not, we can install with `$sudo apt-get update && apt-get install -y ntpdate`

- Check status of timesync.service using $timedatectl
  The output should look something like: 

```
$ timedatectl 
Local time: Wed 2020-03-18 18:01:20 GMT
Universal time: Wed 2020-03-18 18:01:20 UTC
RTC time: Wed 2020-03-18 18:01:20
Time zone: Europe/London (GMT, +0000)
System clock synchronized: yes
```

- You may be able to fix the synchronization issue by adding the following to /etc/systemd/timesyncd.conf:

```
[Time] 
NTP=10.199.999.99 10.999.999.999
```

- Technically, ntpdate is deprecated, we should be using ntpd insteadl

```
sudo service ntp stop
sudo ntpd -gq
sudo service ntp start
```

In the above command, the -gq flags tells the ntp daemon to correct the time
regardless of the offset (g) and exit immediately (q) after setting the time.
