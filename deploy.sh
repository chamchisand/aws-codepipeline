#c!/bin/bash

prompt() {
  key=$1
  default=${!key}

  if [ -n "$default" ]; then
    msg="$key ($default):"
  else
    msg="$key:"
  fi

  while true; do
    read -r -p "$msg" value

    if [ -n "$value" ]; then
      eval "$key=$value"
      break
    elif [ -n "$default" ]; then
      eval "$key=$default"
      break
    fi
  done
}

stack_name=$1
yaml=./cfn.yaml

AppName=HelloWorld
InstanceType=t2.micro
ImageId=
VpcId=
SubnetIDs=
InstanceProfile=
KeyPairName=
GitOwner=chmchisand
GitRepo=aws-codepipeline
GitBranch=master
# GitOAuthToken=

if [ -z "$stack_name" ]; then
  echo Usage: $0 stack-name
  exit
fi

prompt AppName
prompt InstanceType
prompt ImageId
prompt VpcId
prompt SubnetIDs
prompt InstanceProfile
prompt KeyPairName
# prompt GitOwner
# prompt GitRepo
# prompt GitBranch
# prompt GitOAuthToken

aws cloudformation validate-template --template-body file://$yaml --output text

if [ "$?" -ne 0 ]; then
  exit 1
fi

aws cloudformation deploy \
  --capabilities CAPABILITY_IAM \
  --template-file $yaml \
  --stack-name $stack_name \
  --parameter-overrides \
    AppName=${AppName} \
    InstanceProfile=${InstanceProfile} \
    InstanceType=${InstanceType} \
    ImageId=${ImageId} \
    VpcId=${VpcId} \
    KeyPairName=${KeyPairName} \
    SubnetIDs=${SubnetIDs} \
    GitOwner=${GitOwner} \
    GitRepo=${GitRepo} \
    GitBranch=${GitBranch}
    # GitOAuthToken=${GitOAuthToken}
