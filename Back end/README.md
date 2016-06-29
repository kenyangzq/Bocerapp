Information about Bocerapp Back end repository


The app.js contains the entry point of the server.

All the routers should go in the Router folder, nothing goes in the app.js file.

The dataModel folder contains .js files specifying the models we are using. Need to including the methods related exclusively to that model and the data stuctures suitable for that model.

All database stuff go in the mysql folder. Should include the .sql inplementation file, so that the database would be easily migrated to other platforms or servers.