# Set Up 2 Factor authentication on a desktop machine

** After performing these commands, simply just paste with CTRL+V **
```sh
which oathtool
if [ "$?" -ne 0 ]; then
  echo "oathtool not installed, please perform sudo apt-get install oathtool"
  exit -1
fi
which xclip
if [ "$?" -ne 0 ]; then
  echo "xclip not installed, please perform sudo apt-get install xclip"
  exit -1
fi
oathtool -b --totp 'PUT_YOUR_SECRET_HERE' | sed -z '$ s/\n$//' | xclip -selection c
```