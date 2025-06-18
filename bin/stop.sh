#!/bin/bash

# Terraria Server Stop Script

# Check if the server is running
if ! screen -ls | grep -q "terraria"; then
    echo "Terraria server is not running!"
    exit 1
fi

# Send "exit" command to the server and wait for it to stop
echo "Stopping Terraria server..."
screen -S terraria -X stuff "exit$(printf \\r)"

# Wait for the screen session to end
while screen -ls | grep -q "terraria"; do
    echo "Waiting for server to stop..."
    sleep 1
done

echo "Server stopped successfully!"