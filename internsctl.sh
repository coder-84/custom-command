#!/bin/bash
export PATH=$PATH:/usr/local/bin

# Define version information
VERSION="v0.1.0"

# Define usage information
usage() {
    echo "Usage: internsctl [OPTIONS]"
    echo "  --help       Display usage examples and help information."
    echo "  --version    Display the version of internsctl."
    echo "  file getinfo [options] <file-name>   Get file information."
    echo "    -size, -s            Print file size."
    echo "    -permissions, -p     Print file permissions."
    echo "    -owner, -o           Print file owner."
    echo "    -last-modified, -m   Print last modified time."
}

# Function to get file information
get_file_info() {
    if [ $# -eq 0 ]; then
        echo "Please provide a filename."
        exit 1
    fi

    filename="$1"

    # Check for options
    while [[ "$#" -gt 1 ]]; do
        case $2 in
            -size | -s)
                stat -c "Size (B): %s" "$filename"
                ;;
            -permissions | -p)
                stat -c "Permissions: %A" "$filename"
                ;;
            -owner | -o)
                stat -c "Owner: %U" "$filename"
                ;;
            -last-modified | -m)
                stat -c "Modify: %y" "$filename"
                ;;
            *)
                echo "Invalid option: $2"
                usage
                exit 1
                ;;
        esac
        shift
    done

    # Default output if no options specified
    echo "File: $filename"
    stat -c "Access: %A" "$filename"
    stat -c "Size (B): %s" "$filename"
    stat -c "Owner: %U" "$filename"
    stat -c "Modify: %y" "$filename"
}

# Check for command-line options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help)
            usage
            exit 0
            ;;
        --version)
            echo "internsctl version $VERSION"
            exit 0
            ;;
        file)
            shift
            case $1 in
                getinfo)
                    shift
                    get_file_info "$@"
                    exit 0
                    ;;
                *)
                    echo "Invalid file command: $1"
                    usage
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Invalid option or command: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

