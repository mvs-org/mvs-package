#!/bin/bash

HTMLS_FROM_PATH="./mvs-htmls"
HTMLS_TARGET_PATH="$HOME/.metaverse"

mkdir -p "$HTMLS_TARGET_PATH"

DB_FROM_PATH="./mainnet"
DB_TARGET_PATH="$HOME/.metaverse/mainnet"

declare -a block_data_arr=(
                "address_asset_row"
                "address_asset_table"
                "address_did_row"
                "address_did_table"
                "address_mit_row"
                "address_mit_table"
                "asset_table"
                "block_index"
                "block_table"
                "cert_table"
                "did_table"
                "history_rows"
                "history_table"
                "metadata"
                "mit_history_row"
                "mit_history_table"
                "mit_table"
                "spend_table"
                "stealth_rows"
                "transaction_table"
                )

declare -a account_arr=(
                "account_address_rows"
                "account_address_table"
                "account_asset_row"
                "account_asset_table"
                "account_table"
                )


function usage()
{
    echo "Usage:"
    echo "$0"
    echo "$0 /path/to/block/data/"
    echo "default path : $DB_TARGET_PATH"
    echo ""
}

function cp_files()
{
    declare -a argAry=("${!1}")
    #echo "${argAry[@]}"
    for i in "${argAry[@]}"
    do
        /bin/cp "$DB_FROM_PATH/$i" "$DB_TARGET_PATH/$i";
        echo "finished copy $i"
    done
}

if [[ $# -gt 1 ]] || [[ $1 = "-h" ]] || [[ $1 = "--help" ]]
then
    usage
    exit 1
fi

if [ ! -e mvs-htmls.tar.gz ]
then
    echo "mvs-htmls.tar.gz not exist"
    exit 1
fi

if [ ! -e mainnet.tar.gz ]
then
    echo "mainnet.tar.gz not exist"
    exit 1
fi

if [ $# -eq 1 ]
then
    DB_TARGET_PATH=$1
fi
mkdir -p "$DB_TARGET_PATH"

# unpack mvs-htmls
echo  "unpackaging mvs-htmls......"
tar -zxf mvs-htmls.tar.gz

# unpack database
echo  "unpackaging mainnet......"
tar -xzvf mainnet.tar.gz

if [ ! -d "$HTMLS_FROM_PATH" ]
then
    echo "$HTMLS_FROM_PATH htmls not found, please make sure it exist!"
    exit 1
fi

if [ ! -d "$DB_FROM_PATH" ]
then
    echo "$DB_FROM_PATH htmls not found, please make sure it exist!"
    exit 1
fi

# copy htmls
echo "=> copy $HTMLS_FROM_PATH to $HTMLS_TARGET_PATH"
/bin/cp -rf $HTMLS_FROM_PATH $HTMLS_TARGET_PATH

# copy database
echo "copying data into $DB_TARGET_PATH"
cp_files block_data_arr[@]

if [ -f "$DB_TARGET_PATH/account_table" ]
then
    echo "account data exist, not overwrite it!"
else
    cp_files account_arr[@]
fi

# clean jobs
rm -r "$HTMLS_FROM_PATH"
rm -r "$DB_FROM_PATH"

echo "=> Installed successfully. then open 'mvsd'"
