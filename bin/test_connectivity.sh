#!/bin/bash

# Configuration Variables
PORT=7777                      # Terraria server port
WSL_IP="172.20.255.228"       # Your WSL instance IP
WINDOWS_WSL_IP="172.20.240.1" # Windows IP from WSL network
WINDOWS_LAN_IP="192.168.1.168" # Windows IP on local network
EXTERNAL_IP="72.202.189.169"  # Your external IP

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to run test and print result
run_test() {
    local test_name="$1"
    local host="$2"
    local port="$3"
    
    printf "Testing ${test_name}... "
    if nc -zv "$host" "$port" 2>&1 | grep -q "succeeded"; then
        echo -e "${GREEN}SUCCESS${NC}"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        return 1
    fi
}

# Print configuration
echo "Terraria Server Connectivity Tester"
echo "=================================="
echo "Port: $PORT"
echo "WSL IP: $WSL_IP"
echo "Windows (WSL Network) IP: $WINDOWS_WSL_IP"
echo "Windows (LAN) IP: $WINDOWS_LAN_IP"
echo "External IP: $EXTERNAL_IP"
echo "=================================="

# Run all tests
echo -e "\nRunning connectivity tests..."
echo "--------------------------------"

# Test 1: Local Connection
run_test "Local Connection (WSL)" "localhost" "$PORT"

# Test 2: WSL to Windows (WSL Network)
run_test "WSL to Windows (WSL Network)" "$WINDOWS_WSL_IP" "$PORT"

# Test 3: WSL to Windows (LAN)
run_test "WSL to Windows (LAN)" "$WINDOWS_LAN_IP" "$PORT"

# Test 4: External Connection
run_test "External Connection" "$EXTERNAL_IP" "$PORT"

echo -e "\nTest Summary:"
echo "--------------------------------"
echo "If any tests failed, check:"
echo "1. Terraria server is running"
echo "2. Windows port forwarding is configured"
echo "3. Router port forwarding is configured"
echo "4. Windows Firewall allows incoming connections"
echo "5. No other service is using port $PORT"

# Get current IP configuration for troubleshooting
echo -e "\nCurrent Network Configuration:"
echo "--------------------------------"
ip route | grep default