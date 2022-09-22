#!/bin/bash

# Globals

trap "exit 1" ERR
export TOP_PID=$$

# Functions

exit_with_message () {
    echo "$1";
    exit 1;
}

get_service_content () {
    content=$(
printf "import { Injectable } from \"@nestjs/common\";

@Injectable()
export class %sService {}
" "$component_name"
);

printf "%s" "$content" | cat > "${service_and_module_directory_path}/${component_service_name}";

}

get_module_content () {
    content=$(
printf "import { Module } from \"@nestjs/common\";
import { %sService } from './%s.service\";

@Module({
    imports:[],
    providers:[%sService],
    exports:[%sService]
})
export class %sModule {}
" "$component_name" "$component_directory_name" "$component_name" "$component_name" "$component_name"
);

printf "%s" "$content" | cat > "${service_and_module_directory_path}/${component_module_name}";

}

get_controller_content () {
    content=$(
printf "import { Controller, Get } from \"@nestjs/common\";
import { %sService } from \"src/domain/%s/%s.service\";

@Controller(\"%s\")
export class %sController {
    constructor(private %sService: %sService) {}
}
" "$component_name" "$component_directory_name" "$component_directory_name" "$component_directory_name" "$component_name" "$component_directory_name" "$component_name"
);

printf "%s" "$content" | cat > "${controller_directory_path}/${component_controller_name}";

}

# Initial Validations

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

controller_directory_path_prefix="${path_prefix}/src/http"
controller_directory_path="${controller_directory_path_prefix}/${component_directory_name}"

set -e

(  
    mkdir -p "$service_and_module_directory_path" || exit_with_message "Couldn't create module and service directory!";
    mkdir -p "$controller_directory_path" || exit_with_message "Couldn't create controller directory!";
    touch "${service_and_module_directory_path}/${component_service_name}" || exit_with_message "Couldn't create service file!";
    touch "${service_and_module_directory_path}/${component_module_name}" || exit_with_message "Couldn't create module file!";
    touch "${controller_directory_path}/${component_controller_name}" || exit_with_message "Couldn't create controller file!";
    get_service_content || exit_with_message "Couldn't append to service content!";
    get_module_content || exit_with_message "Couldn't append to module content!";
    get_controller_content || exit_with_message "Couldn't append to controller content!";
)


echo "Done!"