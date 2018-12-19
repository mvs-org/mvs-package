#!/bin/bash

DB_FROM_PATH="./mainnet"
DB_TARGET_PATH="$HOME/.metaverse/mainnet"

declare -a account_array=(
                "account_address_rows"
                "account_address_table"
                "account_asset_row"
                "account_asset_table"
                "account_table"
                )

function is_account_related()
{
    result="false"
    table_name="$1"
    for i in "${account_array[@]}"
    do
        if [ "$i" = "$table_name" ]
        then
            result="true"
            break
        fi
    done
    echo "$result"
}

function usage()
{
    echo "Usage:"
    echo "$0"
    echo "$0 /path/to/block/data/"
    echo "default path : $DB_TARGET_PATH"
    echo ""
}

if [[ $# -gt 1 ]] || [[ $1 = "-h" ]] || [[ $1 = "--help" ]]
then
    usage
    exit
fi

if [ ! -e "$DB_FROM_PATH" ]
then
    echo "$DB_FROM_PATH not exist"
    exit 1
fi

if [ $# -eq 1 ]
then
    DB_TARGET_PATH=$1
fi
mkdir -p "$DB_TARGET_PATH"

read -p "Are you sure copy block data to $DB_TARGET_PATH? (y/n): " answer
if [ "$answer" != "y" ] && [ "$answer" != "yes" ]
then
    exit
fi

# copy account unrelated tables
echo "=> copying account unrelated tables into $DB_TARGET_PATH"
for i in $(ls "$DB_FROM_PATH")
do
    result=$(is_account_related "$i")
    if [ "$result" = "true" ]
    then
        continue
    fi
    /bin/cp -v "$DB_FROM_PATH/$i" "$DB_TARGET_PATH/$i";
    echo "finished copy $i"
done

# copy account related tables
echo ""
if [ -f "$DB_TARGET_PATH/account_table" ]
then
    echo "account data exist, not overwrite it!"
else
    echo "=> copying account related tables into $DB_TARGET_PATH"
    for i in "${account_array[@]}"
    do
        /bin/cp -v "$DB_FROM_PATH/$i" "$DB_TARGET_PATH/$i";
        echo "finished copy $i"
    done
fi

echo ""
echo "=> Installed successfully to $DB_TARGET_PATH"
