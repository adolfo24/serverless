const fs = require('fs');
exports.handler = function(event, context) {
    fs.readFile(__dirname + '/index.html', 'utf8', function(err, html){
        context.succeed(html);
    });
};