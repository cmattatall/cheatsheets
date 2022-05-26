
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
