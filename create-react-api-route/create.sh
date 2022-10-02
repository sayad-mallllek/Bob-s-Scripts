#!/bin/bash

# Initial Values
api_route_prefix="src/api/"
api_route="/"
folder_name=""
file_name=""
api_method="get"
input_params=""

# Functions
get_help() {
    printf "react_api_create allows you to create your react api route\n"
}

get_api_file_content() {
    content=$(printf "import { sendRequest } from \".%s/axios\";

export const checkAvailability = async (%s) => {
  const res = await sendRequest<unknown, unknown>({
    method: \"%s\",
    url: \`%s\`,
  });
  return res.data;
};
" "$( if [[ -n $folder_name ]]; then printf "%s" "."; fi )" "$input_params" "$api_method" "$api_route")

printf "%s" "$content" | cat > "${full_pathname}";
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

if [ $# -lt 2 ]; then
    printf "%d arguments were provided\nYou need to specify atleast 2 arguments [file_name] [api_route]\n" "$#"
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

while getopts ":m:f:i" flag; do
    case "$flag" in
    m) api_method=${OPTARG} ;;
    f) folder_name=${OPTARG} ;;
    i) input_params="input unknown" ;;
    \?)
        printf "flag: %s is not a valid flag\n" "${OPTARG}"
        exit 1
        ;;
    esac
done

file_name=$1
api_route=$2

full_route="${api_route_prefix}${file_name}"

if [ -n "$folder_name" ]; then
    echo "I entered here!"
    full_route="${api_route_prefix}${folder_name}/${file_name}"
fi

full_pathname="${full_route}/${file_name}.ts"

mkdir -p "$full_route"
touch "$full_pathname"
get_api_file_content


# # echo "Username: $username";
# # echo "Age: $age";
# # echo "Full Name: $fullname";
