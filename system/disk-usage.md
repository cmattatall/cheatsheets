# File containing commands that are useful when trying to resolve issues related to disk usage


# The Disk Usage Utility "du"

## Use 'du' disk usage utility to view a summary of the entire system
```sh
du -s /*
```



## More advanced usage of 'du'

-P = don't follow symlinks (this can cause files or directories to be counted twice)
-h = print Mio, Gio, etc
-s = only print the summary for each arg
-x = stay in 1 filesystem
-m = use size in megabytes

```sh
du -Pshxm /*
```

## View the 25 directories with the most disk usage

```sh
sudo du -xmP /* | sort -rn | head -25
```

## Display directories that are using more than 1GB total disk space
```sh
sudo du -h / | grep '^\s*[0-9\.]\+G'
```

# Other Disk Usage Tools

## DuTree (written in rus)

### DuTree Installation
```sh
cargo install dutree
```

### DuTree Usage

idk how to use dutree but it is here as an option so go explore it


## NCDU

ncdu is a TUI-based alternative to using the du command

### NCDU Installation
```sh
sudo apt install ncdu
```

### NCDU Usage
```sh
sudo ncdu -rx /
```


# Clean up trash

```
rm -rf ~/.local/share/Trash/*
```


# Cleaning Up Docker

If docker images are using way too much disk space, there
are several commands to clean the system

```sh
docker system prune
```

```sh
docker image prune -a
```





