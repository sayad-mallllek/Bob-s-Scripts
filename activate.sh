#!/bin/bash

mkdir -p $HOME/scripts
cp ./create-react-typescript-file-with-scss/create.sh $HOME/scripts/tsxcreate.sh || exit 1
cp ./create-nest-component/create.sh $HOME/scripts/nestcreate.sh || exit 1
echo -e "alias tsxcreate='bash $HOME/scripts/tsxcreate.sh'" >> "$HOME/.bashrc" || exit 1
echo -e "alias nestcreate='bash $HOME/scripts/nestcreate.sh'" >> "$HOME/.bashrc" || exit 1
source "$HOME/.bashrc" || exit 1