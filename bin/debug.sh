#!/bin/bash

# Terraria Server Debug Script - Runs server with direct console output
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$SERVER_DIR/Worlds" ]; then
    mkdir -p "$SERVER_DIR/Worlds"
fi

echo "Starting Terraria server in debug mode..."
echo "Server output will be displayed directly in this console."
echo "Press Ctrl+C to stop the server."
echo "----------------------------------------"

# Change to server directory for proper path resolution
cd "$SERVER_DIR/server"

# Run the server directly with output to console
./TerrariaServer.bin.x86_64 \
    -config ../config/serverconfig.txt