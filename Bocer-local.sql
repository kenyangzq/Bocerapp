create table if not exists User
	 (userName varchar(255) primary key, 
	 password varchar(255) not null);

create table if not exists Profile 
	(userName varchar(255) primary key,
	firstName varchar(255) not null, 
	lastName varchar(255) not null, 
	profileImageSmall varchar(1000),
	profileImageLarge varchar(1000),	
	foreign key (userName) references User (userName) on delete restrict on update cascade);