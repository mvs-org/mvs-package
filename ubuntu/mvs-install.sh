#!/bin/bash
TARGET=mvs-htmls
echo "=> copy $TARGET to ~/.metaverse"
mkdir -p ~/.metaverse
/bin/cp -rf $TARGET ~/.metaverse
echo "=> Installed successfully. then open 'mvsd'"
exit 0
