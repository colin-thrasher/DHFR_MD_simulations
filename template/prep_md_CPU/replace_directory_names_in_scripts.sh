# Script Name: Replace_directory_names_in_scripts #
# Description: Iterates through all files in current directory to replace strings found in files ending in .sh. #
#               Place this bash script in the directory where the files reside. #

# Take the search string.
read -p "Enter the search string: " search

# Take the replace string.
read -p "Enter the replace string: " replace

# Take the file type
read -p "Enter the file suffix: " file_suffix

FILES="$(pwd)"/*$file_suffix

for f in $FILES
do
	echo "Processing $f file..."
  
	sed -i "s/${search//\//\\/}/${replace//\//\\/}/g" $f
done

#$SHELL


### Alternative method to find all files ending in .sh in current directory

# search_dir="$(pwd)"
# for entry in "$search_dir"/*.sh
# do
#   echo "$entry"
# done
