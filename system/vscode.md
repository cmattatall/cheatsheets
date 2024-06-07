
Many linux systems capture presses on the alt key so if keybinds in vscode 
that use the alt key (e.g. ctrl + alt + right arrow ) don't work, do the
following:

1. install dconf-editor
  apt-get install dconf-editor

2. open dconf-editor and navigate to org/gnome/desktop/wm/keybindings

3. Find the appropriate keybinding (if there is not one here, then the issue
   lies elsewhere)

   e.g. the default binding for 'switch-to-workspace-down' is CTRL+ALT+DOWN

4. Toggle the 'use default value' option

5. Replace the keybind with an alternative keybind or to disable, use
   [ "disabled" ]




Install vscode using apt so you don't need snap

```shell
sudo apt-get install wget gpg;
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg;
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg;

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list';
rm -f packages.microsoft.gpg;
sudo apt install apt-transport-https -y;
sudo apt-get update && sudo apt-get install -y code;
```
