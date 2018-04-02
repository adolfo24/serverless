#!/bin/bash
NAME=index
METHOD=GET
LAMBDA=helloworld
CREDENTIALS=arn:aws:iam::974349055189:role/lambda-s3-apigw-role
ACCOUNT_ID=974349055189
REGION=us-east-1
zip  helloworld.zip helloworld.js
ARN_LAMBDA=$(aws lambda create-function --region $REGION --function-name $LAMBDA --zip-file fileb://helloworld.zip --role $CREDENTIALS --handler helloworld.handler --runtime nodejs6.10 --query '[FunctionArn]' --output text) 


