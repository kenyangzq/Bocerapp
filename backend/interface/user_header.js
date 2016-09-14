//login path should be: bocerbook.com/login
var login = {
    'username':username,
    'password':password
};

var back_msg = {
    'Target Action':'loginresult',
    'content':['success','fail','not exist','system error']  //just one of these
};
