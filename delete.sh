#!/bin/bash

stack_name=$1

if [ -z "$stack_name" ]; then
  echo Usage: $0 --stack-name name
  echo aws cloudformation delete-stack name
  exit
fi

read -r -p "Are you sure to delete $stack_name? [y/n] " response

if [[ "$response" =~ ^[Yy]$ ]]; then

  aws cloudformation describe-stacks --stack-name $stack_name

  if [ "$?" -ne 0 ]; then
    exit
  fi

  resources=$(aws cloudformation list-stack-resources --stack-name $stack_name --output text)
  bucket=$(echo "$resources" | grep Artifact | grep "${stack_name,,}-artifact" | awk '{print $4}')

  if [ -n "$bucket" ]; then
    echo Bucket: $bucket

    aws s3api head-bucket --bucket $bucket

    if [ "$?" -eq 0 ]; then
      aws s3 rb s3://$bucket --force
    fi
  fi

  echo Delete Stack: $stack_name
  aws cloudformation delete-stack --stack-name $stack_name
fi
