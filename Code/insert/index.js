'use strict';
 
var AWS = require('aws-sdk'),
	uuid = require('uuid'),
	documentClient = new AWS.DynamoDB.DocumentClient(); 
 
exports.handler = function(event, context, callback){
	var params = {
		Item : {
			"Id" : uuid.v1(),
			"name" : event.name,
			"email" : event.email
		},
		TableName : "Users"
	};
	documentClient.put(params, function(err, data){
		callback(err, {success:true});
	});
}