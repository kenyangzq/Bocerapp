//book operations router
//Created by Yicheng Wang 07/08/2016

//////////////////////////////////////
//preprocess
//////////////////////////////////////

//import the needed packages
var express = require("express");
var db = require("./db");
var AWS = require("aws-sdk");

var router = express.Router();

//aws config
AWS.config.update({accessKeyId: 'AKIAI2QINCTBNZFUSVNA', secretAccessKey: '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'});
AWS.config.update({region: 'us-west-1'});
var s3 = new AWS.S3({params: {Bucket: 'bocerbookimage'}});

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

//add book small image to a book's image collection
router.post("/addBookSmallImage",function(req,res){
    var bookID = req.bookID;
    var imagepos = req.imagepos;
    var imagebody = imagebody;

    var imageID = bookID + '-' + imagepos + '-small';

    var out = {
	'Target Action':'addbooksmallimageresult',
	'content':''
    };
    
    var params = {
	'Bucket':'bocerbookimage',
	'Key':imageID,
	'Body':imagebody
    };
    
    s3.putObject(params, function(err, data) {
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

//add book big image to a book's image collection
router.post("/addBookBigImage",function(req,res){
    var bookID = req.bookID;
    var imagepos = req.imagepos;
    var imagebody = imagebody;

    var imageID = bookID + '-' + imagepos + '-big';

    var out = {
        'Target Action':'addbookbigimageresult',
        'content':''
    };

    var params = {
        'Bucket':'bocerbookimage',
        'Key':imageID,
        'Body':imagebody
    };

    s3.putObject(params, function(err, data) {
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
