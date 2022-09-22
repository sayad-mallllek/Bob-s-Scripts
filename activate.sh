#!/bin/bash

cp ./creacreate-react-typescript-file-with-scss/create.sh /usr/bin/tsxcreate.sh
cp ./create-nest-component/create.sh /user/bin/nestcreate.sh
printf "alias tsxcreate='/usr/bin/tsxcreate.sh'" | cat >> ~/.bashrc
printf "alias nestcreate='/usr/bin/nestcreate.sh'" | cat >> ~/.bashrc