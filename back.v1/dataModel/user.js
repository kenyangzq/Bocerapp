// Yicheng Wang   06/24/2016

//user constructor
function user(name, pass){
	this.username = name;
	this.password = pass;
}

user.prototype.match = function(){ //class method to check if the given password have matching user
	
}


module.exports = user;
