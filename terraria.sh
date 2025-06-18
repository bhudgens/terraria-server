#!/bin/bash

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to bin directory for script execution
cd "$SCRIPT_DIR/bin"

case "$1" in
    start)
        ./start.sh
        ;;
    stop)
        ./stop.sh
        ;;
    debug)
        ./debug.sh
        ;;
    test)
        ./test_connectivity.sh
        ;;
    dns)
        ./update_dns.sh
        ;;
    install)
        ./install.sh
        ;;
    *)
        echo "Usage: $0 {start|stop|debug|test|dns|install}"
        exit 1
        ;;
esac
