var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// create a schema
var bookSchema = new Schema({
    user:{
		type: String,
		required: true
	},
	title:  String,
	author: String,
	edition: String,
	className: String,
	price: Number,
	ISBN: String,
	school: String,
	smallImage: [String],
	largeImage: [String]
});

bookSchema.index({school: 1, ISBN: -1});

var books = mongoose.model('book', bookSchema);

// make this available to our Node applications
module.exports = books;