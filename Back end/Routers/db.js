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

/////////////////////////////////////////
//db user operations
/////////////////////////////////////////

//check if login information is correct
db.loginCheck = function(username,passwd){ //check if login information is correct
    db.query('SELECT password FROM User WHERE username = ?',username,function(err,rows){
	if(err){
	    console.log(err);
	    return 4; //system error
	}
	else{
	    if(rows.length == 0){
		return 3;  //user does not exist
	    }
	    else{
		var pass = rows[0].password;;
		if(pass == passwd) return 1;  //success
		return 2; //wrong;
	    }
	}
    });
}


//add new users to the database
//Things contained in the pack: username, firstname, lastname, password 
db.addUser = function(pack){ //add user to the database based on the info in the pack. Need to check if username already exists
    var username = pack.username;
    db.query('SELECT * FROM Profile WHERE username = ?',username,function(err,rows){
	if(err) return 2; //system error
	else{
	    if(rows.length != 0) return 3; //username already exist
	    else{
		db.query('INSERT INTO User (username, password) VALUES(?,?)',pack.username,pack.password,function(err){
		    if(err) return 2; //system error;
		    else{
			db.query('INSERT INTO Profile (username,firstname,lastname) VALUES(?,?,?)',pack.username,pack.firstname,pack.lastname,function(err){
			    if(err) return 2; //system error
			    else return 1; //success'
			});
		    }
		});	
	    }
	}
    });
}





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
