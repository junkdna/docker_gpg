#!/bin/bash

function do_exit {
	sudo cryptsetup luksClose vault
	exit -1 
}

if [[ -z "${GPG_CONTAINER}" ]]; then
	GPG_CONTAINER=${PWD}/gpg_container.luks
fi

GPG_HOME=$(cat /etc/passwd | awk -F ":" "/^${GPG_USER}:/{print \$6}")
CONTAINER_TAG=$(echo ${USER}_$(hostname))/gpg:latest

docker pull ubuntu:bionic
docker build --tag=${CONTAINER_TAG} .

if [[ ! -e /dev/mapper/vault ]]; then
	sudo cryptsetup luksOpen ${GPG_CONTAINER} vault || do_exit
fi
GPG_DEV=$(readlink -f /dev/mapper/vault)

docker run -it --rm --name "${USER}_gpg_container" \
	--network none \
	--privileged \
	--device $GPG_DEV \
	-e GPG_DEV=$GPG_DEV \
	-v /tmp/keys_to_sign:/home/gpg/keys_to_sign:ro \
	-v /tmp/signed_keys:/home/gpg/signed_keys \
	${CONTAINER_TAG}; sudo cryptsetup luksClose vault
