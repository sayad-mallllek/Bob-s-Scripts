#!/bin/bash

# Globals

trap "exit 1" ERR
export TOP_PID=$$

# Functions

exit_with_message () {
    echo "$1";
    exit 1;
}

if [ -z "$1" ]
    then
        echo "Please provide a name for your component."
        exit 1
fi

if ! [[ $1 =~ ^[a-zA-Z]+$ ]]
    then
        echo "Your component name should contain only alphabets (no numbers, spaces, or special characters)."
        exit 1
fi

# Handling initial values

path_prefix="."

component_name="${1^}"
component_directory_name="${1,}"

component_module_name=$(printf "%s.module.ts" "$component_directory_name")
component_service_name=$(printf "%s.service.ts" "$component_directory_name")
component_controller_name=$(printf "%s.controller.ts" "$component_directory_name")

service_and_module_directory_path_prefix="${path_prefix}/src/domain"

service_and_module_directory_path="${service_and_module_directory_path_prefix}/${component_directory_name}"

set -e

(  
    mkdir -p "$service_and_module_directory_path" || exit_with_message "Couldn't create directory!";
    cd "$directory_path" || exit_with_message "Couldn't traverse into directory!";
    touch "$tsx_file_name" || exit_with_message "Couldn't create tsx file!";
    touch "$scss_file_name" || exit_with_message "Couldn't create scss file!";
    get_tsx_content || exit_with_message "Couldn't append to content!";
)


echo "$component_module_name";
echo "$component_service_name";