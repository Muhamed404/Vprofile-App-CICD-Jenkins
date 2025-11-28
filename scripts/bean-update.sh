#!/bin/bash
RUN_ID=$1

APP_NAME="vprofile-app"
ENV_NAME="vprofile-${RUN_ID}"
BUCKET="elasticbeanstalk-us-east-1-441160708640"
WAR_FILE="vprofile-${RUN_ID}.war"
S3_KEY="vporfile-versions/${WAR_FILE}"
VERSION_LABEL="vprofile-${RUN_ID}"




# Upload new WAR
aws s3 cp ../../vprofile-v2.war s3://$BUCKET/$S3_KEY


# Create new application version
aws elasticbeanstalk create-application-version \
  --application-name $APP_NAME \
  --version-label $VERSION_LABEL \
  --source-bundle S3Bucket="$BUCKET",S3Key="$S3_KEY"


# Deploy it
aws elasticbeanstalk update-environment \
  --environment-name $ENV_NAME \
  --version-label $VERSION_LABEL
