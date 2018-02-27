#!/bin/bash

usage() {
    echo "Usage:"
    echo "$0 <synced-block-height>"
    echo "eg:"
    echo "$0 900000"
}

check_exist() {
    for path in "${!1}"
    do
        if [ ! -e "$path" ]
        then
            echo "$path ---- not exist"
            CHECK_RESULT=false
        else
            echo "$path ---- exist"
        fi
    done
}

copy_files() {
    local dest="$2"
    for path in "${!1}"
    do
        echo "copy $path"
        /bin/cp -Rf "$path" "$dest"
    done
}

# files to be copied and zipped
declare -a FILES=(
    mainnet.tar.gz
    mvs-block-data-install.sh
    )

if [ $# != 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    usage
    exit
fi

echo "-- check existence"
CHECK_RESULT=true
check_exist FILES[@]
echo "------ check finished  ---------"
echo ""
if [ "$CHECK_RESULT" = false ]
then
    echo "check existence failed, EXIT"
    exit 1
fi

HEIGHT="$1"
PACK_NAME="metaverse-mainnet-blocks-$HEIGHT"
TARBALL_FILE_NAME="${PACK_NAME}.tar.gz"
DEST_DIR="$PACK_NAME"

if [ -e "$DEST_DIR" ] || [ -e "$TARBALL_FILE_NAME" ]
then
    echo "$DEST_DIR or $TARBALL_FILE_NAME already exist"
    read -p "do you want to delete them and continue? (y/n)" reply
    if [ "$reply" = y ]
    then
        rm -rf "$DEST_DIR"
        rm -rf "$TARBALL_FILE_NAME"
    else
        echo "you choose not to continue, EXIT"
        exit
    fi
fi

echo "-- make directory $DEST_DIR"
mkdir -p "$DEST_DIR"
echo ""

echo "$HEIGHT" > $DEST_DIR/height

echo "-- copy files to directory $DEST_DIR"
copy_files FILES[@] "$DEST_DIR"
echo "------ copy finished  ---------"
echo ""

echo "-- generate tarball file $TARBALL_FILE_NAME"
/bin/tar -zcvf "$TARBALL_FILE_NAME" "$DEST_DIR"
echo "------ tar finished  ---------"
echo ""

rm -rf "$DEST_DIR"

ls -l "$TARBALL_FILE_NAME"
