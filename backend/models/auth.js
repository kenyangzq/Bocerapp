var mongoose = require('mongoose');
var schema = mongoose.Schema;

var authSchema = new schema({
    user:{
	type:String,
	required:true,
	unique:true
    },
    passwd:{
	type:String,
	required:true
    },
    createdate: Date
});


var auth = mongoose.model('auth',authSchema);

module.exports = auth;
