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
	'Target Action':'signupresult',
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
		var auth = {
		    'username':username,
		    'password':password
		};
      	        db.query('INSERT INTO User SET ?',auth,function(err){
		    if(err){
			out.content = 'system error';
			res.send(out);
		    }
		    else{
			var info = {
			    'username':username,
			    'firstname':firstname,
			    'lastname':lastname,
			};
		        db.query('INSERT INTO Profile SET ?',info,function(err){
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


//Retrieve User's info.
router.post("/retrieveUserInfo", function (req, res) {
    var username = req.body.username;
	db.query('SELECT * FROM Profile WHERE username = ?',username,function(err,rows){
		if(err){
			out.content = 'system error';
			res.send(out);
		}else{
			if(rows.length == 0){
				out.content = 'no such user exists';
				res.send(out);
			}else{
				res.json({firstName:rows[0].firstName,lastName:row[0].lastName,profileImage:row[0].profileImage});
			}
		}
	});
});



module.exports = router;
