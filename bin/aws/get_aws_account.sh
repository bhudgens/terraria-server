#!/bin/bash

# Script to get AWS Account ID from SSO login

echo "Getting AWS Account information..."

# Try SSO login
aws sso login --profile terraria-admin

# If login successful, list accounts
if [ $? -eq 0 ]; then
    echo -e "\nAvailable AWS accounts:"
    aws sso list-accounts --profile terraria-admin --output json | jq -r '.accountList[] | "Account ID: \(.accountId)\nAccount Name: \(.accountName)\n"'
    
    echo -e "\nTo configure your account ID, run:"
    echo 'sed -i "s/REPLACE_WITH_ACCOUNT_ID/YOUR_ACCOUNT_ID/" ~/.aws/config'
    echo "Replace YOUR_ACCOUNT_ID with the account ID you want to use"
else
    echo "Failed to login to AWS SSO. Please make sure:"
    echo "1. You have completed SSO setup at https://ordino.awsapps.com/start"
    echo "2. Your AWS CLI is configured correctly"
    echo "3. You have permission to access AWS accounts through SSO"
fi