#!/bin/bash

# Terraria Server Installation Script
SERVER_VERSION="1449"  # Latest version as of now
DOWNLOAD_URL="https://terraria.org/api/download/pc-dedicated-server/terraria-server-${SERVER_VERSION}.zip"
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"  # Get root directory

echo "Installing required dependencies..."
if [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt-get install -y unzip curl screen mono-complete
elif [ -f /etc/redhat-release ]; then
    sudo yum install -y unzip curl screen mono-complete
fi

echo "Downloading Terraria Server..."
cd "$SERVER_DIR"
curl -SL "$DOWNLOAD_URL" -o terraria-server.zip

echo "Extracting server files..."
unzip -o terraria-server.zip
rm terraria-server.zip

# Move Linux files to server directory
mv "${SERVER_VERSION}/Linux/"* server/
rm -rf ${SERVER_VERSION}

# Make the server executable
chmod +x server/TerrariaServer.bin.x86_64

# Handle server configuration
if [ ! -f "config/serverconfig.txt" ]; then
    echo "Creating new server configuration..."
    cat > config/serverconfig.txt << EOL
world=Worlds/MyWorld.wld
autocreate=1
worldname=MyWorld
difficulty=0
maxplayers=8
port=7777
password=
motd=Welcome to My Terraria Server!
worldpath=./Worlds
banlist=banlist.txt
secure=1
language=en/US
EOL
else
    echo "Existing server configuration found, preserving..."
fi

# Create Worlds directory if it doesn't exist
mkdir -p Worlds

echo "Installation complete!"
echo "Current server configuration (config/serverconfig.txt):"
cat config/serverconfig.txt
echo -e "\nTo manage the server, use:"
echo "  ./terraria.sh start  - Start the server"
echo "  ./terraria.sh stop   - Stop the server"
echo "  ./terraria.sh debug  - Start with console output"
echo "  ./terraria.sh test   - Test connectivity"