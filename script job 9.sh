#!/bin/bash

#En se basant sur le fichier CSV de Shell.exe

echo "/bin/false" >> /etc/shells

while IFS="," read -r id firstname lastname pwd usertype ;
do
firstlast="$firstname$lastname"

if [ $usertype == Admin ]
then
useradd -u $id -c "$firstname $lastname" $firstlast --shell /bin/false --home /home/$firstlast
echo  $firstlast:$pwd | chpasswd
usermod -aG sudo $firstlast


elif [ $usertype == User ]
then
useradd -u $id -c "$firstname $lastname" $firstlast --shell /bin/false --home /home/$firstlast
echo  $firstlast:$pwd | chpasswd

fi
done < <(tail -n +2 Shell_Userlist.csv)