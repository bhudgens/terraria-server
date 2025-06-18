# Terraria Server Setup

This repository contains scripts to set up and manage a persistent Terraria server on Linux.

## Installation

1. Clone this repository to your desired location
2. Make the scripts executable:
   ```bash
   chmod +x install.sh start.sh stop.sh test_connectivity.sh
   ```
3. Run the installation script:
   ```bash
   ./install.sh
   ```

## Configuration

Edit `serverconfig.txt` to customize your server settings:
- `worldname`: Name of your world
- `password`: Server password (leave empty for no password)
- `maxplayers`: Maximum number of players (default: 8)
- `port`: Server port (default: 7777)
- `difficulty`: World difficulty (0: Normal, 1: Expert, 2: Master, 3: Journey)

## Network Setup (Required for External Players)

1. Windows Port Forwarding (WSL to Windows):
   ```powershell
   # Run in Windows PowerShell as Administrator
   cd \\wsl.localhost\Ubuntu-20.04\home\bhudgens\reverts\terraria-server
   .\configure_windows_forwarding.ps1 -WSLIp <your-wsl-ip> -Port 7777
   ```

2. Router Port Forwarding:
   - Log into your router (typically http://192.168.1.1)
   - Find the port forwarding section
   - Add a new rule:
     - External Port: 7777
     - Internal IP: Your Windows PC's local IP (e.g., 192.168.1.168)
     - Internal Port: 7777
     - Protocol: TCP

3. Test Connectivity:
   ```bash
   ./test_connectivity.sh
   ```
   This will verify all network paths are working correctly.

## Server Management

- Start the server:
  ```bash
  ./start.sh
  ```
- Stop the server:
  ```bash
  ./stop.sh
  ```
- Start in debug mode (shows console output):
  ```bash
  ./debug.sh
  ```
- Access server console:
  ```bash
  screen -r terraria
  ```
- Detach from console:
  Press `Ctrl+A` then `D`

## Setting Up Systemd Service

1. Edit `terraria.service` and replace `USER` with your username
2. Copy the service file to systemd:
   ```bash
   sudo cp terraria.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```
3. Enable and start the service:
   ```bash
   sudo systemctl enable terraria
   sudo systemctl start terraria
   ```

## Systemd Service Management

- Start server:
  ```bash
  sudo systemctl start terraria
  ```
- Stop server:
  ```bash
  sudo systemctl stop terraria
  ```
- Check status:
  ```bash
  sudo systemctl status terraria
  ```
- View logs:
  ```bash
  sudo journalctl -u terraria
  ```

## Backup

The world files are stored in the `Worlds` directory. Make regular backups of this directory to prevent data loss.
# Directory Structure
- bin/      - Main server management scripts
- bin/aws/  - AWS-related scripts
- config/   - Configuration files
- lib/      - Library files and DLLs
- server/   - Server binaries and executables
- systemd/  - Systemd service files
- Worlds/   - Game world files

# Quick Start
Use `./terraria.sh` with the following commands:
- `./terraria.sh install` - Install the server
- `./terraria.sh start`   - Start the server
- `./terraria.sh stop`    - Stop the server
- `./terraria.sh debug`   - Start with console output
- `./terraria.sh test`    - Test connectivity
- `./terraria.sh dns`     - Update DNS records
