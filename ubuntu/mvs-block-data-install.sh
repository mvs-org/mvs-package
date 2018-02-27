#!/bin/bash

DB_PATH="$HOME/.metaverse/mainnet"
FROM_PATH="./mainnet"

declare -a block_data_arr=("account_asset_row"
                "address_asset_table"
                "block_index"
                "history_rows"
                "metadata"
                "spend_table"
                "transaction_table"
                "asset_table"
                "block_table"
                "history_table"
                "stealth_rows"
                )

declare -a account_arr=("account_table"
                "account_asset_table"
                "address_asset_row"
                "account_address_table"
                "account_address_rows"
                )


function usage()
{
    echo "Usage:"
    echo "$0"
    echo "$0 /path/to/block/data/"
    echo "default path : $DB_PATH"
    echo ""
}

function cp_files()
{
    declare -a argAry=("${!1}")
    #echo "${argAry[@]}"
    for i in "${argAry[@]}"
    do
        /bin/cp "$FROM_PATH/$i" "$DB_PATH/$i";
        echo "finished copy $i"
    done
}

if [[ $# -gt 1 ]] || [[ $1 = "-h" ]] || [[ $1 = "--help" ]]
then
    usage
    exit 1
fi

# tar
echo  "unpackaging mainnet......"
tar -xzvf mainnet.tar.gz

if [ $# -eq 1 ]
then
    DB_PATH=$1
fi

if [ -d "$DB_PATH" ]
then
	echo "copying data into $DB_PATH"
    cp_files block_data_arr[@]
else
	echo "$DB_PATH not found, please make sure it exist!"
	exit 1
fi

if [ -f "$DB_PATH/account_table" ]
then
    echo "account data exist not overwrite it!"
else
    cp_files account_arr[@]
fi

