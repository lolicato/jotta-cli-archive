#! /bin/bash

# Backup your default IFS
SAVEIFS=IFS

# Overwrite your default IFS
# It as allow to use name with space 
# in your file and/or directory
IFS=$(echo -en "\n\b")


# It takes the first argment: 
# Input folder
FOLDER=$1

# It takes the second argment: 
# Output folder in your Jottacloud Archive folder
WHERE=$2

# It stores in an array the tree structure 
# of the mother folder
array=($(find $FOLDER -type d ))


cnt=-1

# It finds the tree structure of the mother folder
# with the absolute path and iterate over them
for i in `find $FOLDER  -type d \( ! -name . \) -exec bash -c "cd '{}' && pwd" \;` ;do

# If the iterating item is a folder and it has a 
# different name then the input folder, iterate
# over all the file inside the folder:
if [ -d "$i" ]; then
	if [[ `basename $i` != $FOLDER ]]; then
	cnt=$((cnt+1))
	echo $WHERE/"${array[$cnt]}"
	for filename in $i/*  ; do
		jotta-cli archive $filename --remote `printf $WHERE/"${array[$cnt]}"` 

done
fi
fi
done

# Restore default IFS
IFS=$SAVEIFS
