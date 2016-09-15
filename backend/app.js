var express = require('express');
var mongoose = require('mongoose');
var bookRouter = require('./routers/bookRouter.js');

var hostname = 'localhost';
var port = 3000;

var app = express();
app.use('/books',bookRouter);

mongoose.connect('mongodb://localhost:27017/bocer');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
  // we're connected!
  console.log('MongoDb database connected.');
});

app.listen(port, hostname, function(){
  console.log(`Server running at http://${hostname}:${port}/`);
});