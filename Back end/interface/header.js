
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

//add book path should be: bocerbook.com/addBook
var bookinfo = {
    'username':username,
    'bookname':bookname,
    'ISBN':ISBN,
    'author':author,
    'edition':edition,
    'className':className,
    'price':price
};

var back_msg = {
    'Target Action':'addbookresult',
    'content':['success','server error']
    'bookID':bookID //only when the content is success will the bookID contain info
};

//add book images path should be: bocerbook.com/addBookImage
var bookimage = {
    'bookID':bookID,
    'imagepos':imagepos,
    'imagebody':imagebody,
};

var back_msg = {
    'Target Action':'addbookimageresult',
    'content':['success','system error']
};
