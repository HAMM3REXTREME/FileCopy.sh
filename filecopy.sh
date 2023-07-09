#!/bin/sh

# filecopy - Automatically copy files over SFTP. Will also save older versions in a specified directory.
# This program is not intended to be used for file sync in a way similar to rsync or Syncthing.
# This program simplly moves the old folder in remote to a directory before copying over the new folder from local to remote.
# You also need to make sure the folder exists on both sides before running this script.


#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty #of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/#licenses/>.






do_entry () {
  sleep 0.1
  date="/.oldsaves/$(date +%Y-%m-%d_%T)/"
  printf "mkdir \'$remote/.oldsaves/\'\n\
mkdir \'$remote$date\'\n\
rename \'$remote$folder\' \'$remote/$date$folder\'\n\
mkdir \'$remote$folder\'\n\
put -r \'$local$folder\' \'$remote\'\n" | sftp "$host"

}


main_loop () {
    while IFS="," read -r local remote folder host enabled
    do
    if [ ! -e "$local" ]; then
        printf "Warning: $local does not appear to exist...\n"
    fi
    if [[ $enabled == "TRUE" ]]; then
        printf "Uploading a entry...\n"
        do_entry
    else
        printf "Skipping Entry...\n"
    fi

    done < <(tail -n +2 locations.csv)

}

main_loop

