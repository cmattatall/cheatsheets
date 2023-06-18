To fix alt-tab behaviour on ubuntu 
(e.g. to use alt + $VARIOUS keybindings in vscode),

you need to change the listeners bound to dconf.

The easiest way to do this is to install dconf-editor

`sudo apt-get update && sudo apt-get install -y dconf-editor`


Then use dconfig editor and go to `org/gnome/desktop/wm/keybindings`
and edit the appropriate binding

