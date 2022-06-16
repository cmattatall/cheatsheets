
AWS_ACCOUNT_NUMBER=1423082349823984
REGION=us-east-1
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${REGION}.amazonaws.com
