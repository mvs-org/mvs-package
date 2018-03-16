#!/bin/bash

# unpack mvs-htmls
echo  "unpackaging mvs-htmls......"
unzip -q mvs-htmls.zip

TARGET=mvs-htmls
echo "=> copy $TARGET to ~/.metaverse"
mkdir -p ~/.metaverse
/bin/cp -rf $TARGET ~/.metaverse
echo "=> Installed successfully. then open 'mvsd'"
exit 0
