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

while getopts ":r:m:f:h" flag;
do
    case "$flag" in
        r) api_route=${OPTARG};;
        m) api_method=${OPTARG};;
        f) folder_name=${OPTARG};;
        n) file_name=${OPTARG};;
        h) get_help
            exit 0;;
        \?) printf "flag: ${OPTARG} is not a valid flag\n"
            exit 1
            ;;
    esac
done

full_route="${api_route_prefix}${file_name}"

if [ ! -z $folder_name ]; then
     full_route="${api_route_prefix}${folder_name}/${file_name}"
fi

full_pathname="${full_route}/${file_name}.ts"

mkdir -p "$full_route";
touch "$full_pathname";
# echo "Username: $username";
# echo "Age: $age";
# echo "Full Name: $fullname";