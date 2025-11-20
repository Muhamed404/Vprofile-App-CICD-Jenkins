#!/bin/bash

CLUSTER=$1
SERVICE=$2

# Get first running task
TASK_ARN=$(aws ecs list-tasks \
  --cluster "$CLUSTER" \
  --service-name "$SERVICE" \
  --query "taskArns[0]" \
  --output text)

# Get ENI ID
ENI_ID=$(aws ecs describe-tasks \
  --cluster "$CLUSTER" \
  --tasks "$TASK_ARN" \
  --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
  --output text)

# Get Public IP from ENI
aws ec2 describe-network-interfaces \
  --network-interface-ids "$ENI_ID" \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text