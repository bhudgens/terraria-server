#!/bin/bash

# AWS SSO CLI Configuration Script

# Configuration
SSO_START_URL="https://ordino.awsapps.com/start"
SSO_REGION="us-east-1"
SSO_PROFILE="terraria-admin"
SSO_ROLE_NAME="AdministratorAccess" # Default admin role name

# Check if AWS CLI v2 is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI not found. Installing AWS CLI v2..."
        
        # Install required packages
        if [ -f /etc/debian_version ]; then
            sudo apt-get update
            sudo apt-get install -y unzip curl
        elif [ -f /etc/redhat-release ]; then
            sudo yum install -y unzip curl
        fi
        
        # Download and install AWS CLI v2
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf aws awscliv2.zip
        
        echo "AWS CLI v2 installed successfully"
    fi
}

# Configure AWS SSO
setup_sso() {
    echo "Configuring AWS SSO..."
    
    # Create AWS config directory if it doesn't exist
    mkdir -p ~/.aws
    
    # Create/update config file
    cat > ~/.aws/config << EOF
[profile ${SSO_PROFILE}]
sso_start_url = ${SSO_START_URL}
sso_region = ${SSO_REGION}
sso_account_id = REPLACE_WITH_ACCOUNT_ID
sso_role_name = ${SSO_ROLE_NAME}
region = ${SSO_REGION}
output = json
EOF
    
    echo "AWS SSO profile '${SSO_PROFILE}' configured."
    echo "Please follow these steps to complete the setup:"
    echo "1. Visit ${SSO_START_URL}"
    echo "2. Sign in and copy your Account ID"
    echo "3. Run this command with your Account ID:"
    echo "   sed -i 's/REPLACE_WITH_ACCOUNT_ID/YOUR_ACCOUNT_ID/' ~/.aws/config"
    echo "4. Then run: aws sso login --profile ${SSO_PROFILE}"
    
    # Add profile to bashrc if not already there
    if ! grep -q "export AWS_PROFILE=${SSO_PROFILE}" ~/.bashrc; then
        echo -e "\n# Set default AWS profile" >> ~/.bashrc
        echo "export AWS_PROFILE=${SSO_PROFILE}" >> ~/.bashrc
        
        # Update current session
        export AWS_PROFILE=${SSO_PROFILE}
        echo "Default profile set to '${SSO_PROFILE}'"
    fi
}

# Main script
echo "AWS SSO Configuration Script"

# Install/verify AWS CLI
check_aws_cli

# Configure SSO
setup_sso

echo -e "\nInitial configuration complete!"
echo "After setting your Account ID, you can:"
echo "1. Login: aws sso login --profile ${SSO_PROFILE}"
echo "2. Verify setup: aws sts get-caller-identity"
echo "3. List available accounts: aws sso list-accounts"