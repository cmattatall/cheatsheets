
#Based on: https://askubuntu.com/questions/4428/how-can-i-record-my-screen

- Install recordmydesktop

```sh
apt-get update && apt-get install -y recordmydesktop
```

# Record your entire screen

```sh
recordmydesktop --on-the-fly-encoding
```

# Record a specific window
This will allow you to first select the window with a mouse click, and it starts recording after you click.
```sh
recordmydesktop --windowid `xwininfo | grep 'id: 0x' | grep -Eo '0x[a-z0-9]+'`
```


