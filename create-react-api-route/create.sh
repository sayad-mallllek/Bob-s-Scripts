#!/bin/bash

# Initial Values
api_route_prefix="src/api/"
api_route="/"
folder_name=""
file_name=""
api_method="get"

# Functions
get_help() {
    printf "react_api_create allows you to create your react api route\n"
}

# Flags assignment

while getopts ":h" flag; do
    case "$flag" in
    h) get_help
        exit 0
        ;;
    \?) ;;
    esac
done

# Validations

if [ ! $# -eq 2 ]; then
    printf "%d arguments were provided\nYou need to specify 2 arguments [file_name] [api_route]\n" "$#"
    exit 1
fi

if ! [[ $1 =~ ^[a-zA-Z0-9]+$ ]]; then
    printf "Invalid api method and file name! Name must contain letters and numbers only!\n"
    exit 1
fi

if ! [[ $2 =~ ^/[a-zA-Z0-9/_=?-]+$ ]]; then
    printf "Invalid api route! Route must start with '/' and must contain letters, numbers, or either characters ['/','?','=','-','_'] only!\n"
    exit 1
fi

# Script Execution

while getopts ":m:f:h" flag; do
    case "$flag" in
    m) api_method=${OPTARG} ;;
    f) folder_name=${OPTARG} ;;
    h) get_help
        exit 0
        ;;
    \?)
        printf "flag: ${OPTARG} is not a valid flag\n"
        exit 1
        ;;
    esac
done

file_name=$1
api_route=$2

full_route="${api_route_prefix}${file_name}"

if [ ! -z $folder_name ]; then
    full_route="${api_route_prefix}${folder_name}/${file_name}"
fi

full_pathname="${full_route}/${file_name}.ts"

mkdir -p "$full_route"
touch "$full_pathname"
# # echo "Username: $username";
# # echo "Age: $age";
# # echo "Full Name: $fullname";
