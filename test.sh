#!/bin/bash

if ! [[ $1 =~ ^[a-zA-Z/]+$ ]]
    then
        echo "Your module name should contain only alphabets (no numbers or spaces)."
        exit 1
fi

regex='(.*/|^)(.*)'
[[ $1 =~ $regex ]]
name="${BASH_REMATCH[2]}"
echo $name;