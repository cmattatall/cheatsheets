## declare an array variable
declare -a arr=("element1" "element2" "element3")

## now loop through the above array
for i in "${arr[@]}"
do
   echo "$i"
done
# You can access them using echo "${arr[0]}", "${arr[1]}" also
