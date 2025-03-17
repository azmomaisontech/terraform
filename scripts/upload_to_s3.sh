#!/bin/bash

# Check if version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

# Define the base S3 bucket URL
S3_BUCKET="test-one-s3-bucket-prod"

# Loop through each app directory and upload the dist folder
echo "Uploading files to S3 $apps"
for app in apps/*; do
  if [ -d "$app/dist" ]; then
    app_name=$(basename "$app")
    echo "Uploading $app_name"
#    aws s3 sync "$app/dist" "s3://$S3_BUCKET/$app_name/$VERSION/"
  fi
done
