#!/bin/bash


if [ $# -ne 1 ]
then
	echo " fichier en  xls"
	echo "$0 exemple.xls"
	exit 99
fi

#put data in pc
UTILISATEURS=( 0 )



index=0
OLDIFS=$IFS
IFS=:
while read -r username _ _ _ _ dir _
do
    USERS[$index]=$username
    index=$(($index+1))
done <<<$(grep /home /etc/passwd | sort -t: -k6 )
IFS=$OLDIFS




FICHIER=$1
PASS=123456

OLDIFS=$IFS
IFS=','
[ ! -f $FICHIER ] && { echo "$FICHIER non existant"; exit 99; }
while read id username nom prenom 
do
	username=${username:1:-1}
        if [[ "$username"  = "username" ]] || [ -z  "$username" ]
	then
		continue
	fi

	#Verification
	if [[ " ${UTILISATEURS[@]} " =~ " $username " ]];
	then
		echo "$username existed."
	else
		echo "add $username."
		sudo useradd "$username" --create-home
		#mettre le mots de passe
		echo "$username":${PASS} | sudo chpasswd
	fi

done <<<$(xls2csv ${FICHIER})
IFS=$OLDIFS
