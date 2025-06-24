#!/bin/bash
#
# Script Name: logic_pro_backup.sh
# Description: A utility script to backup and restore Logic Pro settings.
#
# MIT License
#
# Copyright (c) 2025 Vasco Nunes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Usage:
#
# Backup:
# `./logic_pro_backup.sh --backup /path/to/folder/destination`
#
# Restore:
# `./logic_pro_backup.sh --restore /path/to/logic_pro_backup.zip`

# ANSI color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Paths to Logic Pro settings
LOGIC_PRO_SETTINGS_PATHS=(
    "$HOME/Library/Application Support/Logic"
    "$HOME/Library/Preferences/com.apple.logic.pro.cs"
    "$HOME/Library/Preferences/com.apple.logic10.plist"
    "$HOME/Music/Audio Music Apps"
)

# Function to backup Logic Pro settings
backup_settings() {
    local destination="$1"
    local backup_file="$destination/logic_pro_backup.zip"

    echo -e "${YELLOW}Backing up Logic Pro settings to $backup_file...${RESET}"
    # Create a zip archive
    zip -r "$backup_file" "${LOGIC_PRO_SETTINGS_PATHS[@]}"
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Error: Failed to create backup. Please check the destination path and permissions.${RESET}"
        exit 1
    fi

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Backup completed successfully: $backup_file${RESET}"
    else
        echo -e "${RED}Error: Failed to create backup.${RESET}"
        exit 1
    fi
}

# Function to restore Logic Pro settings
restore_settings() {
    local source="$1"

    echo -e "${YELLOW}Restoring Logic Pro settings from $source...${RESET}"

    # Ask for confirmation
    echo -e "${YELLOW}Are you sure you want to proceed? This will overwrite existing settings. (yes/no)${RESET}"
    read -r confirmation
    confirmation=$(echo "$confirmation" | tr '[:upper:]' '[:lower:]')
    if [[ "$confirmation" != "yes" ]]; then
        echo -e "${RED}Restore operation canceled.${RESET}"
        exit 0
    fi

    # Extract the zip archive
    unzip -o "$source" -d "$HOME"
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Error: Failed to restore settings. Please check the backup file.${RESET}"
        exit 1
    fi

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Restore completed successfully.${RESET}"
    else
        echo -e "${RED}Error: Failed to restore settings.${RESET}"
        exit 1
    fi
}

# Check if zip and unzip are installed
if ! command -v zip &> /dev/null; then
    echo -e "${RED}Error: 'zip' is not installed. Please install it and try again.${RESET}"
    exit 1
fi

if ! command -v unzip &> /dev/null; then
    echo -e "${RED}Error: 'unzip' is not installed. Please install it and try again.${RESET}"
    exit 1
fi

# Main script logic
if [[ $# -lt 2 ]]; then
    echo -e "${RED}Usage: $0 --backup <destination> | --restore <source>${RESET}"
    exit 1
fi

option="$1"
path="$2"

case "$option" in
    --backup)
        if [[ ! -d "$path" ]]; then
            echo -e "${RED}Error: Destination directory does not exist.${RESET}"
            exit 1
        fi
        backup_settings "$path"
        ;;
    --restore)
        if [[ ! -f "$path" ]]; then
            echo -e "${RED}Error: Backup file does not exist.${RESET}"
            exit 1
        fi
        restore_settings "$path"
        ;;
    *)
        echo -e "${RED}Invalid option: $option. Use '--backup' or '--restore'.${RESET}"
        exit 1
        ;;
esac
