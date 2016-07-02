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
    console.log(req);
    var username = req.body.username;
    var password = req.body.password;
    var out = {
	'Target Action':'loginresult',
	'content':''
	};
    var result = db.loginCheck(username,password);
    if(result == 1){
	out.content = 'success';
    }
    else if(result == 2){
	out.content = 'fail';
    }
    else if(result == 3){
	out.content = 'not exist';
    }
    else{
	out.content = 'system error';
    }
    res.send(out);
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
    var pack = {
	'username':username,
	'firstname':firstname,
	'lastname':lastname,
	'password':password
    };
    var result = db.addUser(pack);
    if(result == 1) out.content = 'success';
    else if(result ==2) out.content = 'system error';
    else out.content = 'already exist'
    res.send(out);
});




module.exports = router;
