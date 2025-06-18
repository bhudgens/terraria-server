#!/bin/bash

# Terraria Server Start Script
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$SERVER_DIR/Worlds" ]; then
    mkdir -p "$SERVER_DIR/Worlds"
fi

echo "Starting Terraria server..."
cd "$SERVER_DIR"

# Start server in screen session with proper paths
screen -dmS terraria ./server/TerrariaServer.bin.x86_64 \
    -config config/serverconfig.txt \
    -worldpath Worlds \
    -world Worlds/MyWorld.wld

echo "Server started in screen session 'terraria'"
echo "To attach to the console, use: screen -r terraria"
echo "To detach from console, press: Ctrl+A then D"

# Monitor server startup with increased delay
echo "Waiting for server to fully initialize..."
sleep 5
if screen -list | grep -q "terraria"; then
    echo "Server started successfully!"
    echo "Running connectivity tests..."
    sleep 2  # Additional delay before running tests
    ./bin/test_connectivity.sh
else
    echo "Server failed to start. Check logs for details."
    exit 1
fi