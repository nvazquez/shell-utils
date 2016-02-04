#!/bin/bash

# 2016-02-01
# Nicolas Vazquez
# --------------------------------------------------------------------------------------------------------------------------
# Script to copy multiple files from source to dest host, using scp.
# PRE: Configure id_rsa.pub key file and add it to dest authorized_keys file, to not ask for password in every scp command
# --------------------------------------------------------------------------------------------------------------------------

intro(){
	echo
	echo
	echo "************************Copy Files to Server************************"
	echo "Number of files to copy: $1"
	echo
	echo "Details:"
	echo
	echo "local_base_folder = "$SRC_HOST_BASE_ROUTE
	echo
	echo "dst_host_ip_address = "$DEST_HOST_IP
	echo "dst_host_folder = "$DEST_HOST_BASE_ROUTE
	echo "dst_host_user = "$DEST_HOST_USER
	echo "********************************************************************"
	echo
	echo
}

display_help(){
	echo "usage: copyMultipleFilesToServer [-b <local_base_folder>]"
	echo "                                 [-H <dst_host_ip_address>] [-d <dst_host_folder>] [-u <dst_host_user>]"
	echo "                                 file1 [... fileN]"
	echo
}

# Variables
SRC_HOST_BASE_ROUTE="/home/XXX"			# -b route
DEST_HOST_IP="ZZ.ZZ.ZZ.ZZ"				# -H ip
DEST_HOST_BASE_ROUTE="/home/WW"			# -d route
DEST_HOST_USER="YYY"					# -u user

# getopts tutorial
# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts 'hH:u:b:d:' option; do
	case "$option" in
	h) 	display_help
		exit
		;;
	b)	SRC_HOST_BASE_ROUTE=$OPTARG
		;;
	u)	DEST_HOST_USER=$OPTARG
		;;
	H)	DEST_HOST_IP=$OPTARG
		;;
	d)	DEST_HOST_BASE_ROUTE=$OPTARG
		;;
	\?)	echo "Invalid option"
		exit
		;;
	esac
done

echo $SRC_HOST_BASE_ROUTE
echo $DEST_HOST_IP
echo $DEST_HOST_USER
echo $DEST_HOST_BASE_ROUTE

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