#!/bin/bash

# AWS Route53 Dynamic DNS Updater
# Requirements:
# - AWS CLI installed and configured
# - jq for JSON parsing
# - A hosted zone in Route53

# Configuration
HOSTED_ZONE_ID="Z063489711SS9ADPHYQDN"  # Your Route53 hosted zone ID
DOMAIN_NAME="terraria.hudgenda.com"     # The full domain name you want to update (e.g., terraria.yourdomain.com)
TTL=300           # Time to live in seconds
INTERVAL=300      # How often to check IP (in seconds)

# Function to install dependencies
install_dependencies() {
    if ! command -v aws &> /dev/null || ! command -v jq &> /dev/null; then
        echo "Installing required dependencies..."
        if [ -f /etc/debian_version ]; then
            sudo apt-get update
            sudo apt-get install -y awscli jq
        elif [ -f /etc/redhat-release ]; then
            sudo yum install -y awscli jq
        else
            echo "Please install aws-cli and jq manually for your distribution"
            exit 1
        fi
    fi
}

# Function to get current external IP
get_current_ip() {
    curl -s ifconfig.me
}

# Function to get the current DNS record's IP
get_dns_ip() {
    aws route53 list-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --query "ResourceRecordSets[?Name == '$DOMAIN_NAME.'].ResourceRecords[0].Value" \
        --output text
}

# Function to update Route53 record
update_dns_record() {
    local new_ip=$1
    local change_batch="{
        \"Changes\": [{
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"$DOMAIN_NAME\",
                \"Type\": \"A\",
                \"TTL\": $TTL,
                \"ResourceRecords\": [{
                    \"Value\": \"$new_ip\"
                }]
            }
        }]
    }"
    
    aws route53 change-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-batch "$change_batch"
}

# Function to verify AWS CLI configuration
verify_aws_config() {
    if ! aws sts get-caller-identity &> /dev/null; then
        echo "AWS CLI is not configured. Please run 'aws configure' first."
        exit 1
    fi
}

# Main script
echo "AWS Route53 Dynamic DNS Updater"

# Check if configuration is set
if [ -z "$HOSTED_ZONE_ID" ] || [ -z "$DOMAIN_NAME" ]; then
    echo "Please configure HOSTED_ZONE_ID and DOMAIN_NAME in the script."
    exit 1
fi

# Install dependencies
install_dependencies

# Verify AWS configuration
verify_aws_config

echo "Starting DNS update service for $DOMAIN_NAME"
echo "Checking every $INTERVAL seconds"

while true; do
    current_ip=$(get_current_ip)
    dns_ip=$(get_dns_ip)
    
    if [ "$current_ip" != "$dns_ip" ]; then
        echo "IP change detected: $dns_ip -> $current_ip"
        echo "Updating DNS record..."
        if update_dns_record "$current_ip"; then
            echo "DNS record updated successfully"
        else
            echo "Failed to update DNS record"
        fi
    else
        echo "No IP change detected: $current_ip"
    fi
    
    sleep $INTERVAL
done