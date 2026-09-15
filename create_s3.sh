#!/bin/bash
set -e

# Pass bucket name as $1 or via TF_STATE_BUCKET env var
BUCKET_NAME="${1:-$TF_STATE_BUCKET}"

if [ -z "$BUCKET_NAME" ]; then
    echo "❌ Error: S3 bucket name is required."
    echo "Usage: ./create_s3.sh <bucket-name>"
    exit 1
fi

REGION="${AWS_DEFAULT_REGION:-ap-south-1}"

echo "🔨 Creating S3 bucket '$BUCKET_NAME' in region '$REGION'..."

if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME"
else
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
fi

aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "✅ Secured S3 bucket '$BUCKET_NAME' setup complete."