//book operations router
//Created by Yicheng Wang 07/08/2016

//////////////////////////////////////
//preprocess
//////////////////////////////////////

//import the needed packages
var express = require("express");
var db = require("./db");

var router = express.Router();


//////////////////////////////////////
//book operations
//////////////////////////////////////

//add book to users' collections
router.post("/addBook",function(req,res){
    //extract the info
    var bookname = req.body.bookname;
    var username = req.body.username;
    var ISBN = req.body.ISBN;
    var author = req.body.author;
    var edition = req.body.edition;
    var className = req.body.className;
    var price = req.body.price;
    var out = {
	'Target Action':'addbookresult',
	'content':''
    };
    //do the insertion
    var bookinfo = {
	'username':username,
	'bookname':bookname,
	'ISBN':ISBN,
	'author':author,
	'edition':edition,
	'state':'0',
	'className':className,
	'price':price
    };
    db.query('INSERT INTO Book SET ?',bookinfo,function(err){
	if(err){
	    out.content = 'system error';
	    res.send(out);
	}
	else{
	    out.content = 'success';
	    res.send(out);
	}
	
    });
});


module.exports = router;