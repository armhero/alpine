#!/bin/sh

set -e
set -x

usage() {
	printf >&2 '%s: [-a arch] [-r release] [-t tag] [-m mirror] [-s] [-t tag]\n' "$0"
	exit 1
}

tmp() {
	TMP=$(mktemp -d ${TMPDIR:-$PWD}/alpine-docker-XXXXXXXXXX)
	ROOTFS=$(mktemp -d ${TMPDIR:-$PWD}/alpine-docker-rootfs-XXXXXXXXXX)
	trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
	curl -SL $MAINREPO/$ARCH/APKINDEX.tar.gz | tar -Oxz | grep --text '^P:apk-tools-static$' -A1 | tail -n1 | cut -d: -f2
}

getapk() {
	curl -SL $MAINREPO/$ARCH/apk-tools-static-$(apkv).apk | tar -xz -C $TMP sbin/apk.static
}

mkbase() {
	$TMP/sbin/apk.static --repository $MAINREPO --update-cache --allow-untrusted --root $ROOTFS --initdb add alpine-base
}

conf() {
	echo "${MAINREPO}\n" > $ROOTFS/etc/apk/repositories
	echo "${ADDITIONALREPO}\n" >> $ROOTFS/etc/apk/repositories
}

pack() {
	local id
	tar --numeric-owner -C $ROOTFS -cf $TMP/rootfs.tar .
	id=$(docker import $TMP/rootfs.tar armhero/alpine:$REL)

	docker tag $id armhero/alpine:$TAG
	docker run --rm armhero/alpine:$TAG sh -c "echo 'alpine:${REL} with id=${id} and tag=${TAG} created!\n'"
}

while getopts ":a:r:m:t:h" opt; do
	case $opt in
		a)
		  ARCH=$OPTARG
		  ;;
		r)
			REL=$OPTARG
			;;
		m)
			MIRROR=$OPTARG
			;;
		t)
		  TAG=$OPTARG
			;;
		h)
			usage
			;;
		\?)
	    echo "Invalid option: -$OPTARG" >&2
			exit 1
	    ;;
	esac
done

REL=${REL:-edge}
MIRROR=${MIRROR:-http://mirror1.hs-esslingen.de/pub/Mirrors/alpine}
MAINREPO=$MIRROR/$REL/main
ADDITIONALREPO=$MIRROR/$REL/community
ARCH=${ARCH:-armhf}
TAG=${TAG:-latest}

echo "Create temp..."
tmp
echo "Download tools..."
getapk
echo "Create baseimage..."
mkbase
echo "Configure package lists..."
conf
echo "Pack image..."
pack
echo "Finished!"
