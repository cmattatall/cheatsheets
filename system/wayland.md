# Enable/Disable Wayland

You can check your display manager using `echo $XDG_SESSION_TYPE`.

You may want to change from wayland to x11 because on certain systems, 
screensharing is disabled in wayland. This can cause issues on certain
builds of MS Teams

change `WaylandEnable=true` or `WaylandEnable=false` in `/etc/gdm3/custom.conf`

Then restart your computer
