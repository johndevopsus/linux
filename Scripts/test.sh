#!/bin/bash -e

# Usage: export MS Access db file tables to CSV files in Linux 


#install mdbtools
# for ubuntu
#apt-get install mdbtools

#for macOS
#sudo brew install mdbtools

# Ask the user to enter the URL
echo Hello, Please enter the url?
read var_url
#download the URL
sudo wget $var_url

#If it is not installed,  Installs the unzip package ubuntu
#sudo apt install unzip 

# If it is not installed, Installs the unzip package debian
#sudo yum install unzip

#unzip the files
var_filename=$(ls -- *.zip)
unzip $var_filename

command -v mdb-tables >/dev/null 2>&1 || {
    echo >&2 "I require mdb-tables but it's not installed. Aborting.";
    exit 1;
}

fullfilename=$(ls -- *.accdb)
filename=$(basename "$fullfilename")
dbname=${filename%%.*}

mkdir "$dbname"
echo $fullfilename

### File names in Linux can contain any characters other than a forward slash ( / )
### We need to manipulate the $table vairable with sed comnand to prevent naming problems.
IFS=$'\n'
for table in $(mdb-tables -1 "$fullfilename"); do
    echo "Export table $table"
    mdb-export "$fullfilename" "$table" > "$dbname/$(sed 's/[/]//g' <<< $table).csv"
done

echo CSV files exported to the $PWD/"$dbname" directory. Please check with: '"'cd "$dbname"'"' command.
cd "$dbname"
