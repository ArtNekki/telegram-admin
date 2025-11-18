#!/bin/bash

# Copyright (c) 2024 Anton Maiatskii
# This script is part of bash-utils (https://github.com/ArtNekki/bash-utils)
# Version: 1.0.0
# Licensed under the MIT License. See the LICENSE file in the root directory
# of this project for full license details.

# Logger function
source "./logger.sh"

if [ $# -eq 0 ]; then
  log "ERROR" "Config is not set"
  exit 1
fi

# Set default values
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_rsa}"
SSH_USER="${SSH_USER:-root}"
SSH_PORT="${SSH_PORT:-22}"
SSH_HOST="$(doppler secrets get SSH_HOST --plain --config "$1")"

# Function to check server availability
check_server() {
  if ! ping -c 1 -W 2 "$SSH_HOST" &>/dev/null; then
    log "WARNING" "Server $SSH_HOST is unreachable"
    read -rp "Continue with the connection attempt? (y/n): " choice
    if [[ $choice != [Yy]* ]]; then
      exit 1
    fi
  fi
}

# Check server availability
check_server

# Connect to the server
echo "Connecting to $SSH_USER@$SSH_HOST..."
ssh -i "$SSH_KEY" -p "$SSH_PORT" "$SSH_USER@$SSH_HOST"
