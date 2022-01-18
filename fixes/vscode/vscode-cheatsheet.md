
# Fix powerline fonts in vscode integrated terminal:

```sh
sudo apt-get update && \
sudo apt-get install -y fonts-powerline powerline && \
git clone git@github.com:cmattatall/Menlo-for-Powerline.git && \
sudo mv Menlo*.tff /usr/share/fonts && \
sudo fc-cache -fv  && \
rm -r Menlo-for-Powerline
```
