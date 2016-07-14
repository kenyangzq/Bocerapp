
//login path should be: bocerbook.com/login
var login = {
    'username':username,
    'password':password
};

var back_msg = {
    'Target Action':'loginresult',
    'content':['success','fail','not exist','system error']  //just one of these
};


//sign up path should be: bocerbook.com/addUser
var signup = {
    'username':username,
    'password':password,
    'firstname':firstname,
    'lastname':lastname
};

var back_msg = {
    'Target Action':'signupresult',
    'content':['success','system error','already exist'] //just one of these
};


//get userbasic info path should be: bocerbook.com/retrieveUserInfo
var userinfo = {
    'username':username
};

var back_msg = {
    'Target Action':'userbasicinfo',
    'content':['success','no such user exists','system error'] //just one of these
    'body':body //only when content is success will the body contains something
};

var body = { 
    'firstname':firstname,
    'lastname':lastname,
    'profileimage':profileimage
};

//add user small images path should be: bocerbook.com/addUserSmallImage
var bookimage = {
    'username':username,
    'imagebody':imagebody,
};

var back_msg = {
    'Target Action':'addusersmallimageresult',
    'content':['success','system error'] //need to check the number of success got.
};

//add book path should be: bocerbook.com/addBook
var bookinfo = {
    'username':username,
    'bookname':bookname,
    'ISBN':ISBN,
    'author':author,
    'edition':edition,
    'className':className,
    'price':price,
    'imagenum':imagenum
};

var back_msg = {
    'Target Action':'addbookresult',
    'content':['success','server error']
    'bookID':bookID //only when the content is success will the bookID contain info
};

//add book small images path should be: bocerbook.com/addBookSmallImage
var bookimage = {
    'bookID':bookID,
    'imagepos':imagepos,
    'imagebody':imagebody,
};

var back_msg = {
    'Target Action':'addbooksmallimageresult',
    'content':['success','system error'] //need to check the number of success got.
};

//add book images path should be: bocerbook.com/addBookBigImage
var bookimage = {
    'bookID':bookID,
    'imagepos':imagepos,
    'imagebody':imagebody,
};

var back_msg = {
    'Target Action':'addbookbigimageresult',
    'content':['success','system error'] //need to check the number of success got.
};



//retrieve book info path should be: bocerbook.com/retrieveBookBasicInfo
var request = {
    'username':username
};

var back_msg = {
    'Target Action':'retrievebookbasicinforesult',
    'content':['success','system error'] //only when the result is success will the body contain info
    'body':body
};

var body = [book1Json, book2Json........]


//retrieve book small image path should be: bocerbook.com/retrieveBookSmallImage
var request = {
    'bookID':bookID,
    'imagenum':imagenum
};

var back_msg = {
    'Target Action':'retrievebooksmallimageresult',
    'content':['success','system error'], //same here
    'imagepos':imagepos,
    'imagebody':imagebody 
};

