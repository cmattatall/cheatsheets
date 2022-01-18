##

Add this to your .bashrc to hook direnv into your shell
```sh
which direnv > /dev/null
if [ "$?" -eq "0" ]; then
    #echo "direnv is installed!"
    eval "$(direnv hook bash)"
fi
```
