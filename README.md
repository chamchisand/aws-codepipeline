***** DEPLOY **
./deploy.sh stack-name

```
aws cloudformation deploy 
  --capabilities CAPABILITY_IAM 
  --template-file ./cfn.yaml
  --stack-name <value> 
  --parameter-overrides 
    AppName=<value>
    ImageId=<value> 
    InstanceType=<value> 
    VpcId=<value>
    KeyPairName=<value>
    SubnetIDs=<value>
    GitRepo=<value> 
    GitBranch=<value>
```

** DELETE STACK **
./delete.sh stack-name

aws cloudformation delete-stack --stack-name 
