#!/bin/bash

PORT=7777
ROUTER_IP="192.168.1.1"
DESCRIPTION="Terraria Server"

# Function to get Windows host IP from WSL
get_windows_host_ip() {
    cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
}

# Function to get WSL IP
get_wsl_ip() {
    hostname -I | awk '{print $1}'
}

echo "Setting up port forwarding for WSL environment..."

# Install required tools if not present
if ! command -v upnpc &> /dev/null; then
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y miniupnpc netcat
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y miniupnpc netcat
    else
        echo "Please install miniupnpc and netcat manually for your distribution"
        exit 1
    fi
fi

WINDOWS_HOST_IP=$(get_windows_host_ip)
WSL_IP=$(get_wsl_ip)

echo -e "\nDetected IPs:"
echo "Windows Host IP: $WINDOWS_HOST_IP"
echo "WSL IP: $WSL_IP"
echo "Router IP: $ROUTER_IP"

# Test UPnP availability with specific router
echo -e "\nTesting UPnP availability..."
if ! upnpc -u http://$ROUTER_IP:1900/ctl/IPConn -l 2>/dev/null | grep -q "InternetGatewayDevice"; then
    echo -e "\nRouter Port Forwarding Instructions:"
    echo "Please forward port $PORT from your router to $WINDOWS_HOST_IP manually using these steps:"
    echo "1. Log into your router at http://$ROUTER_IP"
    echo "2. Find the port forwarding section (might be under Advanced, Gaming, or Applications)"
    echo "3. Add a new port forwarding rule:"
    echo "   - External Port: $PORT"
    echo "   - Internal IP: $WINDOWS_HOST_IP"
    echo "   - Internal Port: $PORT"
    echo "   - Protocol: TCP"
else
    echo "UPnP device found. Setting up port forwarding from router to Windows host..."
    upnpc -u http://$ROUTER_IP:1900/ctl/IPConn -a "$WINDOWS_HOST_IP" "$PORT" "$PORT" TCP "$DESCRIPTION"
fi

# Provide instructions for Windows port forwarding
echo -e "\nWindows Port Forwarding Instructions:"
echo "1. Open PowerShell as Administrator on Windows"
echo "2. Navigate to this directory:"
echo "   cd $(wslpath -w "$PWD")"
echo "3. Run the following command:"
echo "   .\\configure_windows_forwarding.ps1 -WSLIp $WSL_IP -Port $PORT"

# Get external IP
EXTERNAL_IP=$(curl -s ifconfig.me)
echo -e "\nConnection Information:"
echo "External IP: $EXTERNAL_IP"
echo "Port: $PORT"

echo -e "\nSetup Summary:"
echo "1. External players will connect to: $EXTERNAL_IP:$PORT"
echo "2. Configure Windows port forwarding using the PowerShell script"
echo "3. Manual router port forwarding may be required from Internet -> $WINDOWS_HOST_IP:$PORT"

echo -e "\nOnce port forwarding is configured, run these tests:"
echo "1. Test local connection: nc -zv localhost $PORT"
echo "2. Test WSL to Windows: nc -zv $WINDOWS_HOST_IP $PORT"
echo "3. Test external to Windows: nc -zv $EXTERNAL_IP $PORT"

echo -e "\nIf tests fail, ensure:"
echo "1. The PowerShell script was run as Administrator"
echo "2. Router port forwarding is configured correctly"
echo "3. Windows Firewall allows incoming connections on port $PORT"
echo "4. The Terraria server is running"