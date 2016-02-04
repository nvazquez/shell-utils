#!/bin/bash

# 2016-02-01
# Nicolas Vazquez
# --------------------------------------------------------------------------------------------------------------------------
# Script to copy multiple files from source to dest host, using scp.
# PRE: Configure id_rsa.pub key file and add it to dest authorized_keys file, to not ask for password in every scp command
# --------------------------------------------------------------------------------------------------------------------------

# Default values, used if not set in params
readonly DEFAULT_LOCAL_FOLDER=/home/XXX
readonly DEFAULT_DEST_HOST_IP=ZZ.ZZ.ZZ.ZZ
readonly DEFAULT_DEST_HOST_BASE_ROUTE=/home/WW
readonly DEFAULT_DEST_HOST_USER=YYY

intro(){
	echo
	echo
	echo "********************************************************************"
	echo "Transfer arguments:"
	echo
	echo "    local_base_folder = "$SRC_HOST_BASE_ROUTE
	echo "    dst_host_ip_address = "$DEST_HOST_IP
	echo "    dst_host_folder = "$DEST_HOST_BASE_ROUTE
	echo "    dst_host_user = "$DEST_HOST_USER
	echo "********************************************************************"
	echo
}

display_help(){
	echo "usage: copyMultipleFilesToServer [-b <local_base_folder>]"
	echo "                                 [-H <dst_host_ip_address>] [-d <dst_host_folder>] [-u <dst_host_user>]"
	echo "                                 file1 [... fileN]"
	echo
}

transfer_files(){
	echo "********************************************************************"
	echo "Starting file transfer: ("$N" files)"
	echo
	# Copy files through scp (having id_rsa.pub key file on server's authorized_keys)
	oneLineFiles=""
	for (( i=0;i<$N;i++)); do 
		arg=${arguments[${i}]}
		scp $SRC_HOST_BASE_ROUTE$arg $DEST_HOST_USER@$DEST_HOST_IP:$DEST_HOST_BASE_ROUTE$arg
	done

	echo
	echo "Transfer completed."
	echo "********************************************************************"
}

normalize_routes(){
	if [ ! "$SRC_HOST_BASE_ROUTE" ] ; then
		# If src_host_base_route is null, use current folder by pwd and adding '/' character at the end
		SRC_HOST_BASE_ROUTE=$(pwd)/
	elif [ ! $SRC_HOST_BASE_ROUTE == "*/" ] ; then
		# If is set, check if it doesn't end with '/' character, if not, add it
		case $SRC_HOST_BASE_ROUTE in
		*/)	#Ends with '/', do nothing
			;;
		*)	SRC_HOST_BASE_ROUTE=$SRC_HOST_BASE_ROUTE/
			;;
		esac
	fi
	
	if [ ! "$DEST_HOST_BASE_ROUTE" ] ; then
		# If dest_host_base_route is null, use / folder
		DEST_HOST_BASE_ROUTE=/
	elif [ ! $DEST_HOST_BASE_ROUTE == "*/" ] ; then
		# If is set, check if it doesn't end with '/' character, if not, add it
		case $DEST_HOST_BASE_ROUTE in
		*/)	#Ends with '/', do nothing
			;;
		*)	DEST_HOST_BASE_ROUTE=$DEST_HOST_BASE_ROUTE/
			;;
		esac
	fi
}

# Variables
SRC_HOST_BASE_ROUTE=$DEFAULT_LOCAL_FOLDER
DEST_HOST_IP=$DEFAULT_DEST_HOST_IP
DEST_HOST_BASE_ROUTE=$DEFAULT_DEST_HOST_BASE_ROUTE
DEST_HOST_USER=$DEFAULT_DEST_HOST_USER

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

# Print details
normalize_routes
intro

# Move cursor to get files to copy
shift $(($OPTIND - 1))

# Store arguments in array
arguments=("$@") 
N=${#arguments[@]} 

transfer_files
exit 