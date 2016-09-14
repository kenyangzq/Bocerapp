//mysql database connection: The mysql database server is currently managed by Chen Shao
//Yicheng Wang 06/28/2016

////////////////////////////////////////
//preprosess
////////////////////////////////////////

//request needed packages
var mysql = require("mysql")


//mysql config info
var db = mysql.createConnection({
    host : 'localhost',
    user : 'root',
    password : '1Qaz2wsx',
    database : 'BocerApp'
});



//connecting to the server
db.connect(function(err){
    if(err){
	console.log("errors happening");
    }
    else{
	console.log("mysql db connected");
    }
});


module.exports = db;
