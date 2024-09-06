#!/bin/bash

# Define the directory where your Ubuntu Server Arsenal scripts are stored
SCRIPT_DIR="./assets/"

# Check if the script directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Error: Script directory $SCRIPT_DIR does not exist."
    exit 1
fi

# Function to display the menu
show_menu() {
    echo "Welcome to LinServArsenal!"
    echo "Select a script to run from your Linux Server Arsenal:"
    echo "-----------------------------------------"

    # List all scripts in the directory
    select script in $(ls "$SCRIPT_DIR"); do
        if [[ -n "$script" ]]; then
            echo "You selected $script. Running now..."
            # Run the selected script
            sudo bash "$SCRIPT_DIR/$script"
            break
        else
            echo "Invalid selection, please try again."
        fi
    done
}

# Call the menu function
show_menu
