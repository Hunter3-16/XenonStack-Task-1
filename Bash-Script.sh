!/bin/bash
VERSION="v0.1.0"
# Function to display help for the file getinfo command
file_getinfo_help() {
    echo "Usage: internsctl file getinfo [options] <file-name>"
    echo ""
    echo "Options:"
    echo "  --size, -s             Print file size"
    echo "  --permissions, -p      Print file permissions"
    echo "  --owner, -o            Print file owner"
    echo "  --last-modified, -m    Print last modified time"
}
# Function to get information about a file
file_getinfo() {
    local file="$1"

    if [ ! -e "$file" ]; then
        echo "Error: File '$file' not found."
        exit 1
    fi
    echo "File: $file"
    echo "Access: $(stat -c %A "$file")"
    echo "Size(B): $(stat -c %s "$file")"
    echo "Owner: $(stat -c %U "$file")"
    echo "Modify: $(stat -c %y "$file")"
    while [ $# -gt 1 ]; do
        case "$2" in
            --size | -s)
                echo "Size(B): $(stat -c %s "$file")"
                ;;
            --permissions | -p)
                echo "Access: $(stat -c %A "$file")"
                ;;
            --owner | -o)
                echo "Owner: $(stat -c %U "$file")"
                ;;
            --last-modified | -m)
                echo "Modify: $(stat -c %y "$file")"
                ;;
            *)
                echo "Error: Invalid option '$2'."
                file_getinfo_help
                exit 1
                ;;
        esac
        shift
    done
}
# Function to get CPU information
get_cpu_info() {
    lscpu
}
# Function to get memory information
get_memory_info() {
    free
}
# Function to create a new user
create_user() {
    local username="$1"
    if [ -z "$username" ]; then
        echo "Error: Missing username."
        exit 1
    fi
    # Create user with home directory
    useradd -m "$username"
    # Set a default password (change it later)
    echo "$username:password" | chpasswd
    echo "User '$username' created successfully."
}
# Function to list users
list_users() {
    if [ "$1" == "--sudo-only" ]; then
        getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 { print $1 }' | xargs groups | grep -E '\bsudo\b' | cut -d : -f 1
    else
        getent passwd | cut -d : -f 1
    fi
}
# Function to display help
display_help() {
    echo "Usage: internsctl [OPTION] COMMAND [ARGS...]"
    echo ""
    echo "Options:"
    echo "  --help        Display this help message"
    echo "  --version     Display version"
}
internsctl() {
    case "$1" in
        --help)
            display_help
            ;;
        --version)
            echo "internsctl $VERSION"
            ;;
        cpu)
            shift
            case "$1" in
                getinfo)
                    get_cpu_info
                    ;;
                *)
                    echo "Error: Invalid cpu command."
                    exit 1
                    ;;
            esac
            ;;
        memory)
            shift
            case "$1" in
                getinfo)
                    get_memory_info
                    ;;
                *)
                    echo "Error: Invalid memory command."
                    exit 1
                    ;;
            esac
            ;;
        user)
            shift
            case "$1" in
                create)
                    shift
                    create_user "$1"
                    ;;
                list)
                    shift
                    list_users "$1"
                    ;;
                *)
                    echo "Error: Invalid user command."
                    exit 1
                    ;;
            esac
            ;;
        file)
            shift
            case "$1" in
                getinfo)
                    shift
                    file_getinfo "$@"
                    ;;
                *)
                    echo "Error: Invalid file command."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Error: Invalid command."
            exit 1
            ;;
    esac
}

