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

# Stay in root directory and use relative paths
cd "$SERVER_DIR"

# Run the server directly with output to console
./server/TerrariaServer.bin.x86_64 \
    -config config/serverconfig.txt \
    -worldpath Worlds \
    -world Worlds/MyWorld.wld