#! /usr/bin/bash

# Ensure the script exits on errors
set -e

#############################
# Function to convert tflx  #
#############################
convert_tflx_to_txt() {
    local prep_workbook="$1"

    # Extract elements from the full path
    local full_path=$(realpath "$prep_workbook")
    local dir_name=$(dirname "$full_path")
    local file_name=$(basename "$full_path")
    local base_name=$(basename "$full_path" .tflx)

    # Step 1: Rename the extension from .tflx to .zip
    local zip_file="${dir_name}/${base_name}.zip"
    mv "$prep_workbook" "$zip_file"
    echo "Renamed '$file_name' to '$(basename "$zip_file")'"

    # Step 2: Unzip the .zip file to a folder
    local unzip_folder="${dir_name}/${base_name}"
    unzip "$zip_file" -d "$unzip_folder"
    echo "Unzipped '$(basename "$zip_file")' to '$(basename "$unzip_folder")/'"

    # Step 3: Move the "flow" file outside of the unzipped folder and rename it to .txt
    local flow_file="$unzip_folder/flow"
    if [[ -f "$flow_file" ]]; then
        local renamed_flow_file="${unzip_folder}.txt"
        mv "$flow_file" "$renamed_flow_file"
        echo "Moved and renamed 'flow' to '$(basename "$renamed_flow_file")'"
    else
        echo "Error: 'flow' file not found in '$(basename "$unzip_folder")'"
        exit 1
    fi

    # Step 4: Delete the zipped and unzipped folder
    rm -rf "$zip_file"
    rm -rf "$unzip_folder"
    echo "Deleted '$(basename "$zip_file")' and '$(basename "$unzip_folder")'"

    echo
    echo "TFLX-to-TXT extraction complete!"
}

#############################
# Function to convert twbx  #
#############################
convert_twbx_to_txt() {
    local workbook="$1"

    # Extract elements from the full path
    local full_path=$(realpath "$workbook")
    local dir_name=$(dirname "$full_path")
    local file_name=$(basename "$full_path")
    local base_name=$(basename "$full_path" .twbx)

    # Step 1: Rename the extension from .twbx to .zip
    local zip_file="${dir_name}/${base_name}.zip"
    mv "$workbook" "$zip_file"
    echo "Renamed '$file_name' to '$(basename "$zip_file")'"

    # Step 2: Unzip the .zip file to a folder
    local unzip_folder="${dir_name}/${base_name}"
    unzip "$zip_file" -d "$unzip_folder"
    echo "Unzipped '$(basename "$zip_file")' to '$(basename "$unzip_folder")/'"

    # Step 3: Find the .twb file in the unzipped folder
    # Typically, a .twbx file contains one .twb file at the root of the extracted folder
    local twb_file=$(find "$unzip_folder" -type f -name "*.twb" | head -n 1)
    if [[ -z "$twb_file" ]]; then
        echo "Error: No .twb file found in '$(basename "$unzip_folder")'"
        exit 1
    fi

    # Rename the .twb file to .txt
    local renamed_twb_file="${unzip_folder}.txt"
    mv "$twb_file" "$renamed_twb_file"
    echo "Moved and renamed '$(basename "$twb_file")' to '$(basename "$renamed_twb_file")'"

    # Step 4: Delete the zipped and unzipped folder
    rm -rf "$zip_file"
    rm -rf "$unzip_folder"
    echo "Deleted '$(basename "$zip_file")' and '$(basename "$unzip_folder")'"

    echo
    echo "TWBX-to-TXT extraction complete!"
}


##################################
# Main script execution starts   #
##################################

# Check if the input file path is provided
if [[ -z "$1" ]]; then
    echo "Error: No input file provided."
    echo "Usage: $0 /path/to/workbook.tflx or $0 /path/to/workbook.twbx"
    exit 1
fi

input_file="$1"

# Validate if the provided file exists
if [[ ! -f "$input_file" ]]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Extract the extension
extension="${input_file##*.}"

case "$extension" in
    tflx)
        convert_tflx_to_txt "$input_file"
        ;;
    twbx)
        convert_twbx_to_txt "$input_file"
        ;;
    *)
        echo "Error: Invalid file type '$extension'. Only 'tflx' or 'twbx' are supported."
        exit 1
        ;;
esac
