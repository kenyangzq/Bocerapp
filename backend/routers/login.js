var express = require('express');
var router = express.Router();
var auth = require('../datamodel/auth');


router.post('/addUser',function(req,res){
    var username = req.body.username;
    var passwd = req.body.passwd;
    var date = new Date();

    var userinfo = auth({
	username:username,
	passwd:passwd,
	createdate:date
    });

    userinfo.save(function(err){
	var out = {
	    'Target Action':'signupresult',
	    'content':''};
	if(err){
	    if(err.code == 11000){
		out.content='exist';
	    }else{
		out.content='fail';
	    }
	}
	else{
	    out.content='success';
	}
	res.send(out);

    });
});
