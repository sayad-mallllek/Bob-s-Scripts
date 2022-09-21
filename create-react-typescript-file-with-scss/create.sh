#!/bin/bash

# Globals

trap "exit 1" ERR
export TOP_PID=$$

# Functions

exit_with_message () {
    echo "$1";
    exit 1;
}

get_tsx_content () {

content=$(
printf "import classes from \"./%s\";

interface Props { }

const %s = ({ }: Props) => {
    return (
        <div>
            %s
        </div>
    )
}

export default %s;

" "$scss_file_name" "$directory_name" "$directory_name" "$directory_name"
);

echo "$content" | cat > "$tsx_file_name";
}

get_directory_name () {
    regex='(.*/|^)(.*)'
    [[ $1 =~ $regex ]]
    name="${BASH_REMATCH[2]}"
    echo $name;
}

get_directory_path_before () {
    regex='(.*/|^)(.*)'
    [[ $1 =~ $regex ]]
    name="${BASH_REMATCH[1]}"
    echo $name;
}

# Initial Validations

if [ -z "$1" ]
    then
        echo "Please provide a name for your module."
        exit 1
fi

if ! [[ $1 =~ ^[a-zA-Z/]+$ ]]
    then
        echo "Your module name should contain only alphabets (no numbers or spaces)."
        exit 1
fi

# Handling initial values

path_prefix="./"

directory_name="$(get_directory_name $1)"
directory_path="${path_prefix}$(get_directory_path_before $1)${directory_name^}";
scss_prefix=${directory_name,}
tsx_file_name="index.tsx";
scss_file_name="$scss_prefix.module.scss"

## !---- Script execution ----! ##

# Creating folder and files in a transaction

set -e

(  
    mkdir -p "$directory_path" || exit_with_message "Couldn't create directory!";
    cd "$directory_path" || exit_with_message "Couldn't traverse into directory!";
    touch "$tsx_file_name" || exit_with_message "Couldn't create tsx file!";
    touch "$scss_file_name" || exit_with_message "Couldn't create scss file!";
    get_tsx_content || exit_with_message "Couldn't append to content!";
)


# Appending content to folder

echo "Done!";
