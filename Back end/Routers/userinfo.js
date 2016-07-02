//login router
//Yicheng Wang 06/24/2016

///////////////////////////////////////////
//preprocess
///////////////////////////////////////////

//inporting the needed packages
var express = require('express');
var db = require('./db');

var router = express.Router();




///////////////////////////////////////////
//login actions
///////////////////////////////////////////

//check login information
router.post("/login",function(req,res){
    var username = req.body.username;
    var password = req.body.password;
    var out = {
	'Target Action':'loginresult',
	'content':''
	};
    //access to the mysql databse
    db.query('SELECT password FROM User WHERE username = ?',username,function(err,rows){
        if(err){
	    out.content = 'system error';
	    res.send(out);
	}
        else{
	    if(rows.length == 0){
		out.content = 'not exist';
		res.send(out);
	    }
	    else{
	        var pass = rows[0].password;;
	        if(pass == password){
		    out.content = 'success';
		    res.send(out);
		}
		else{
		    out.content = 'fail';
		    res.send(out);
		}
	    }
	}
    });

});

//add user to the database
router.post("/addUser",function(req,res){
    var username = req.body.username;
    var firstname = req.body.firstname;
    var lastname = req.body.lastname;
    var password = req.body.password;
    var out = {
	'Target Action':'loginresult',
	'content':''
    };
    db.query('SELECT * FROM Profile WHERE username = ?',username,function(err,rows){
        if(err){
	    out.content = 'system error';
	    res.send(out);
	}
        else{
	    if(rows.length != 0){
		out.content = 'already exist';
		res.send(out);
	    }
	    else{
	        db.query('INSERT INTO User (username, password) VALUES(?,?)',username,password,function(err){
		    if(err){
			out.content = 'system error';
			res.send(out);
		    }
		    else{
		        db.query('INSERT INTO Profile (username,firstname,lastname) VALUES(?,?,?)',username,firstname,lastname,function(err){
			    if(err){
				out.content = 'system error';
				res.send(out);
			    }
			    else{
				out.content = 'success';
				res.send(out);
			    }
			});
		    }
		});
	    }
	}
    });
});




module.exports = router;
