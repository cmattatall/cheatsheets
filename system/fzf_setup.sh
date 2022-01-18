
## INSTALL FZF ##

```sh
sudo apt-get install -y fzf
```

## ADD THIS TO YOUR BASHRC TO SET UP KEYBINDINGS WITH FZF

```sh
which fzf > /dev/null
if [ "$?" -eq "0" ]; then
    #echo "fzf is installed"!
    FZF_KEYBINDINGS=$(dpkg -L fzf | grep bindings | grep $(basename $(realpath $SHELL)))
    if [ -f "$FZF_KEYBINDINGS" ]; then
        . $FZF_KEYBINDINGS
    
    fi
fi
```
