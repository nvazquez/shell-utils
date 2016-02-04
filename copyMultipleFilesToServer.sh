#!/bin/bash

# 2016-02-01
# Nicolas Vazquez
# --------------------------------------------------------------------------------------------------------------------------
# Script to copy multiple files from source to dest host, using scp.
# PRE: Configure id_rsa.pub key file and add it to dest authorized_keys file, to not ask for password in every scp command
# --------------------------------------------------------------------------------------------------------------------------
# USAGE: ./copyMultipleFilesToServer.sh file1 file2 file3 ... fileN

intro(){
	echo
	echo "************************Copy Files to Server************************"
	echo "Number of files to copy: $1"
	echo "********************************************************************"
	echo
}

display_help(){
	echo "Usage: copyMultipleFilesToServer [-h <host_ip>] file1 ... [fileN]"
}

while getopts ':hs:' option; do
	case "$option" in
	h) 	display_help
		exit
		;;
	esac
done

# Variables
SRC_HOST_BASE_ROUTE="/home/XXX"
DEST_HOST_USER="YYY"
DEST_HOST_IP="ZZ.ZZ.ZZ.ZZ"
DEST_HOST_BASE_ROUTE="/home/WW"

# Pass params number to intro function
intro "$#"

# Store arguments in array
arguments=("$@") 
N=${#arguments[@]} 

# Copy files through scp (having id_rsa.pub key file on server's authorized_keys)
oneLineFiles=""
for (( i=0;i<$N;i++)); do 
    arg=${arguments[${i}]}
	scp $SRC_HOST_BASE_ROUTE/$arg $DEST_HOST_USER@$DEST_HOST_IP:$DEST_HOST_BASE_ROUTE/$arg
done

echo
echo "Transfer completed."
echo "********************************************************************"