#!/bin/bash
set -e

APP_NAME="TODO: ${name}-cloud-native-hands-on とか)"

ECR_REGISTRY="TODO"
CLUSTER_NAME="TODO"
SERVICE_NAME="TODO"
AWS_REGION="ap-northeast-1"

COMMIT_HASH=$(git rev-parse --short HEAD)
PUSH_IMAGE_NAME="${ECR_REGISTRY}/${APP_NAME}:${COMMIT_HASH}"

# ECR push
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
docker build -t $APP_NAME .
docker tag ${APP_NAME}:latest $PUSH_IMAGE_NAME
docker push $PUSH_IMAGE_NAME

# deploy
ecs-deploy -c $CLUSTER_NAME -n $SERVICE_NAME -i $PUSH_IMAGE_NAME -r $AWS_REGION
