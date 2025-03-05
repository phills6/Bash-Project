#!/bin/bash

# Function to display help message
show_help() {
    echo "Usage: $0 [-h] [-r] file1 file2"
    echo ""
    echo "Concatenates two text files into a single output file."
    echo ""
    echo "Options:"
    echo "  -h   Display this help message."
    echo "  -r   Prompt the user to name the output file. If not provided, the default name is file1_file2.txt."
    exit 0
}

# Regular expression to match valid text file names (only alphanumeric, underscore, hyphen, and .txt extension)
file_regex='^[a-zA-Z0-9_-]+\.txt$'

# Initialize variables
rename_output=false
files=()

# Parse command-line arguments
while getopts ":hr" opt; do
    case ${opt} in
        h) show_help ;;  # Display help and exit
        r) rename_output=true ;;  # Set rename option
        \?) echo "Error: Invalid option '-$OPTARG'"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Check if exactly two files are provided
if [ $# -ne 2 ]; then
    echo "Error: You must provide exactly two text files."
    echo "Use '$0 -h' for help."
    exit 1
fi

# Validate filenames using the regex
for file in "$@"; do
    if [[ ! $file =~ $file_regex ]]; then
        echo "Error: Invalid filename '$file'. Must be a .txt file with only letters, numbers, '_', or '-'."
        exit 1
    fi
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist."
        exit 1
    fi
    files+=("$file")
done

# Set output filename
if [ "$rename_output" = true ]; then
    read -p "Enter the output filename: " output_file
    if [[ ! $output_file =~ $file_regex ]]; then
        echo "Error: Invalid output filename. Must be a .txt file with only letters, numbers, '_', or '-'."
        exit 1
    fi
else
    output_file="${files[0]%.*}_${files[1]%.*}.txt"
fi

# Concatenate files into output file
cat "${files[0]}" "${files[1]}" > "$output_file"
echo "Files concatenated successfully into '$output_file'."
