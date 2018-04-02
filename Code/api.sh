#!/bin/bash
NAME=$1
METHOD=GET
LAMBDA=$1
#CREDENTIALS=arn:aws:iam::974349055189:role/lambda-s3-apigw-role
CREDENTIALS=arn:aws:iam::759340312727:role/lambda_basic_execution
#ACCOUNT_ID=974349055189
ACCOUNT_ID=759340312727
REGION=us-east-1
ARN_LAMBDA=$(aws lambda create-function --region $REGION --function-name $LAMBDA --zip-file fileb://$1.zip --role $CREDENTIALS --handler $1.handler --runtime nodejs6.10 --query '[FunctionArn]' --output text) 


API_ID=$(aws apigateway create-rest-api --name $NAME --region $REGION --query '[id]' --output text)
PARENT_ID=$(aws apigateway get-resources --rest-api-id $API_ID --query 'items[*].[id]' --output text)
#RESOURCE_ID=(aws apigateway create-resource --rest-api-id $API_ID --path-part $NAME --parent-id $PARENT_ID --query '[id]' --output text)

aws apigateway put-method \
--rest-api-id $API_ID \
--resource-id $PARENT_ID \
--http-method $METHOD \
--authorization-type NONE


aws apigateway put-integration \
--rest-api-id $API_ID \
--resource-id $PARENT_ID \
--http-method $METHOD \
--type AWS \
--integration-http-method POST \
--uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/$ARN_LAMBDA/invocations

aws apigateway put-method-response \
--rest-api-id $API_ID \
--resource-id $PARENT_ID \
--http-method $METHOD \
--status-code 200 \
--response-models "{\"text/html\": \"Empty\"}"

aws apigateway put-integration-response \
--rest-api-id $API_ID \
--resource-id $PARENT_ID \
--http-method $METHOD \
--status-code 200 \
--response-templates file://request-template.json

aws apigateway create-deployment --rest-api-id $API_ID --stage-name $NAME

aws lambda add-permission \
--function-name $ARN_LAMBDA \
--statement-id $ACCOUNT_ID$API_ID$PARENT_ID \
--action lambda:InvokeFunction \
--principal apigateway.amazonaws.com \
--source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/$NAME/GET/"
echo "API ID: "$API_ID
echo "REGION: "$REGION
echo "ACCOUNT: "$ACCOUNT_ID
echo "https://$API_ID.execute-api.$REGION.amazonaws.com/$NAME"


