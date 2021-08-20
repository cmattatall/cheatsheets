
# Files

## Check if a file exists

```
FILE=/path/to/my/file
if [[ -e "$FILE" ]]; then ... fi
```

## Check if a file is a regular file, not directory or device

```
FILE=/path/to/my/file
if [[ -f "$FILE" ]]; then ... fi
```

## Check if a file is a directory 

```
FILE=/path/to/my/file
if [[ -d "$FILE" ]]; then ... fi
```

## Check if a file is NOT a directory 

```
FILE=/path/to/my/file
if [[ ! -d "$FILE" ]]; then ... fi
```

## Check if a file is executable 

```
FILE=/path/to/my/file
if [[ -x "$FILE" ]]; then ... fi
```

# Arrays

## Create an array of strings

```
declare -a arr=("one" "two" "three")
```

## Create an empty array 

```
declare -a arr=()
```

## Pass an array to a function
	
```
declare -a arr=("a" "b" "c")

function foo () {
	array_passed=$1
}

foo "${arr[@]}"
```

## Loop over an array of strings

```
declare -a required_packages=("wget" "tar" "make" "gcc" "g++" "libssl-dev" "build-essential")
UPDATED=0
for pkg in ${required_packages[@]}; do
    echo -n "Checking for ${pkg} ..."
    echo ""
    dpkg -s ${pkg} 2> /dev/null # check if installed
    if [ "$?" -ne 0 ]; then
        if [ -z $UPDATED ]; then
            apt-get update
            UPDATED=1
        fi
        apt-get install -y ${pkg}
        if [ "$?" -ne 0 ] ; then
                apt-cache search "${pkg}" | grep "${pkg}"
            if [ "$?" -ne 0 ]; then
                echo "Could not install package ${pkg} because apt says it does not exist."
                exit 0
            else 
                echo "" # formatting
                echo "Could not install ${pkg} using the package manager. Please try installing it manually"
                exit 0
            fi
        fi
    else
        echo -n " ok "
        echo "" # formatting
    fi
done
```


# Commands





