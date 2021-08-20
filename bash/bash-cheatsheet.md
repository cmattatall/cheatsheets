

# Files

## Check if a file exists

FILE=/path/to/my/file
if [[ -e "$FILE" ]]; then ... fi

## Check if a file is a regular file, not directory or device

FILE=/path/to/my/file
if [[ -f "$FILE" ]]; then ... fi


## Check if a file is a directory 

FILE=/path/to/my/file
if [[ -d "$FILE" ]]; then ... fi


## Check if a file is NOT a directory 

FILE=/path/to/my/file
if [[ ! -d "$FILE" ]]; then ... fi


## Check if a file is executable 

FILE=/path/to/my/file
if [[ -x "$FILE" ]]; then ... fi


# Arrays

## Create an array of strings
	
	declare -a arr=("one" "two" "three")

## Create an empty array 

	declare -a arr=()

## Pass an array to a function
	
	declare -a arr=("a" "b" "c")

	function foo () {
		array_passed=$1
	}

	foo "${arr[@]}"

# Commands





