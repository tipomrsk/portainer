#!/bin/bash

# This script is a simple example of how to build and push a Docker image to Docker Hub.
# It uses the figlet command to display text stylized with ASCII art.
# The user is prompted to enter the image name, the path to the Dockerfile, the source code directory, and the image version.
# The script also login to Docker Hub, builds the image, pushes it to Docker Hub, and logout of Docker Hub.
# The script uses ANSI colors to display messages in the terminal.


# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to display text stylized with Figlet
figlet_action() {
    echo -e "${YELLOW}"
    figlet -c "$1"
    echo -e "${NC}"
}

# Function to prompt user input
get_input() {
    read -p "$1" input
    echo $input
}

# Function to log in to Docker Hub
docker_login() {
    figlet_action "Logging Docker Hub"
    docker login
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error logging into Docker Hub. Check your credentials and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Login successful.${NC}"
}

# Function to log out of Docker Hub
docker_logout() {
    figlet_action "Loggout Docker Hub"
    docker logout
}

# Function to build and push the image
build_and_push_image() {
    figlet_action "Building image"
    docker build -t $1:$4 -f $2 $3

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error building the image.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Image build successful.${NC}"

    figlet_action "Pushing image"
    docker push "$1":"$4"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error pushing the image to Docker Hub.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Image push successful.${NC}"
}

messages() {
    echo -e "${YELLOW}!!! Always use absolute path for Dockerfile and context files. !!!${NC}"
    echo -e "Example of absolute path: ${PURPLE}/home/user/cool-system/${NC}"
}

# Main function
main() {
    messages
    image_name=$(get_input "Enter the image name: ")

    dockerfile_path=$(get_input "Enter the path to Dockerfile (default is current directory): ")
    dockerfile_path=${dockerfile_path:-.}

    code_dir=$(get_input "Enter the source code directory (default is 'app'): ")
    code_dir=${code_dir:-app}

    docker_version=$(get_input "Enter the image version (default is 'latest'): ")
    docker_version=${docker_version:-latest}

    # Execute operations
    docker_login
    build_and_push_image "$image_name" "$dockerfile_path" "$code_dir" "$docker_version"
    docker_logout

    echo -e "${GREEN}Process completed successfully.${NC}"
}

# Call the main function
main
