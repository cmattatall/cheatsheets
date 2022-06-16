
# Command to use docker to log in to AWS ECR
```sh
AWS_ACCOUNT_NUMBER=1423082349823984
REGION=us-east-1
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${REGION}.amazonaws.com
```

# Export environment credentials from role ARN via assumption as IAM identity without jq, sed, awk, etc

exports environment variables for 
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN 

The caller must have permissions with your current awscli credentials to assume the role.
  
```sh
ROLE_ARN_TO_ASSUME="PUT YOUR ROLE ARN HERE";
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
       $(aws sts assume-role --role-arn ${ROLE_ARN_TO_ASSUME} \
           --role-session-name MyAssumedIamRoleSessionName \
           --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
           --output text))
```

# Export environment credentials from role ARN via assumption as WEB identity without jq, sed, awk, etc    

exports environment variables for 
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN 

The web identity (identified by the token) must be trusted in the role trust policy

```sh
ROLE_ARN_TO_ASSUME="PUT YOUR ROLE ARN HERE";
WEB_IDENTITY_TOKEN=${BITBUCKET_STEP_OIDC_TOKEN};
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
       $(aws sts assume-role-with-web-identity --role-arn ${ROLE_ARN_TO_ASSUME} \    
           --web-identity-token ${WEB_IDENTITY_TOKEN} \        
           --role-session-name MyAssumedIamWebIdentityRoleSessionName \        
           --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \       
           --output text))
```
