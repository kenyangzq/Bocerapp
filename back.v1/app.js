//Bocer app server entry program
//Yicheng Wang 06/24/2016


//import needed files
var express = require('express');
var bodyParser = require("body-parser");

var app = express();


//routers
var login = require("./Routers/userinfo");
var bookopr = require("./Routers/bookopr");

//utilities
app.use(bodyParser.json({limit:'50mb'}));
app.use(bodyParser.urlencoded({ limit:'50mb',extended: true }));

///////////////////////////////////////
//functions for rendering pages and handle requests
///////////////////////////////////////


//user login
app.use("/",login);
app.use("/",bookopr);









app.listen(80,function(){ //listen to localhost at port 80, which is always used by the ec2 server programs
	console.log("server listening");
});
