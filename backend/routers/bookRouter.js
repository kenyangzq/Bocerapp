var express = require('express');
var bodyParser = require('body-parser');
var books = require('../models/books.js');

var bookRouter =express.Router();

bookRouter.use(bodyParser.json());

bookRouter.route('/')
.post(function(req,res,next){
	if (!req.body){
		res.sendStatus(400);
	}
	
	var book = new books(req.body);
	
	book.save(function(err,book){
		if(err){
			console.error(err);
			res.sendStatus(404);
		}else{
			console.log(book);
			console.log("Successfully created book for user " + req.body.user);
			res.sendStatus(200);
		} 
	});
});

bookRouter.route('/:bookId')
.get(function(req,res,next){
	books.findOne({_id: req.params.bookId},function(err,book){
		if(err){
			res.sendStatus(404);
		}else{
			res.send(book);
		}
	});
});

bookRouter.route('/school/:schoolName')
.get(function(req,res,next){
	books.find({school: req.params.schoolName},function(err,books){
		if(err){
			res.sendStatus(404);
		}else{
			res.send(books);
		}
	})
});

module.exports = bookRouter;