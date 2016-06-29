//mysql database connection
//Yicheng Wang 06/28/2016

var mysql = require("mysql")

var db = mysql.createConnection({
    host : 'localhost',
    user : 'root',
    password : '1Qaz2wsx'
});

db.connect(function(err){
    console.log("mysql connected.");
});
