#!/bin/bash
aws dynamodb create-table --table-name usuarios \
--attribute-definitions AttributeName=Id,AttributeType=S \
--key-schema AttributeName=Id,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
