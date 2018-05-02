#!/bin/bash

function do_exit {
	echo "$1"
	exit -1
}

if [[ -f /initialized ]]; then
	echo "You should throw away the container after usage!"
	exit -1
fi

GPG_HOME=$(cat /etc/passwd | awk -F ":" "/^gpg:/{print \$6}")

mkdir -p ${GPG_HOME}/.gnupg

#cryptsetup luksOpen /gpg_container.luks vault || do_exit "error decrypting container"
mount ${GPG_DEV} /mnt || do_exit "error mounting container"
mount -o bind /mnt/gnupg ${GPG_HOME}/.gnupg
chown -R gpg.gpg ${GPG_HOME}

touch /initialized
su gpg -c /bin/bash
