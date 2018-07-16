#!/bin/bash

export AWS_DEFAULT_REGION=us-west-2

instance=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
tags=`aws ec2 describe-tags --output text --filters "Name=resource-id,Values=$instance"`
echo "instance=$instance"

IFS='
'
while read line; do
  IFS=$'\t' read -a split <<< "$line"
  key=${split[1]}
  val=${split[4]}

  if [[ "$key" != aws* ]]; then
    export $key=$val
	  echo "$key:$val"
  fi
done <<< "$tags"
