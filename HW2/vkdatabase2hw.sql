-- drop database if exists snet0611;
-- create database if not exists snet0611 character set = utf8mb4;
-- use snet0611;

drop database if exists snet0611;
create database snet0611;
use snet0611;

create table users(
	id serial primary key, -- serial = bigint unsigned not null auto_increment unique 
	firstname varchar(50),
	lastname varchar(50) comment '������� ������������',
	email varchar(120) unique,
	phone varchar(120) unique, -- `�`����� ��������� ������� ��� ��������, ������� ��������������� ��� ���������
	birthday date,
	hometown varchar(100),
	gender char(1),
	photo_id bigint unsigned,
	create_at datetime default now(),
	pass char(40)
	
	-- is_deleted bool,
	-- deleted_at datetime
);

alter table users add index (phone);
alter table users add index users_firstname_lastname_idx (firstname, lastname);
alter table users change column firstname firstname varchar(50) not null;

drop table if exists messages;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	message text,
	is_read bool default 0,
	create_at datetime default now(),
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	-- enum ������ �������� ������
	status enum('requested', 'approved','unfriended','declined'),
	requested_at datetime default now(),
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key (initiator_user_id, target_user_id),
	index(initiator_user_id),
	index(target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

drop table if exists communities;
create table communities(
	id serial primary key,
	name varchar(150),
	index(name)
);	

drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	primary key (user_id, community_id),
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);

drop table if exists posts;
create table posts(
	id serial primary key,
	user_id bigint unsigned not null,
	post text,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id)
);

drop table if exists postslikes;
create table postslikes(
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	likedornot char(1),
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

drop table if exists comments;
create table comments(
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	comment text,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

drop table if exists commentslikes;
create table commentslikes(
	id serial primary key,
	user_id bigint unsigned not null,
	comments_id bigint unsigned not null,
	likedornot char(1),
	foreign key (user_id) references users(id),
	foreign key (comments_id) references comments(id)
);

drop table if exists photos;
create table photos(
	id serial primary key,
	filename varchar(200),
	user_id bigint unsigned not null,
	description text,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id)
);

drop table if exists photoslikes;
create table photoslikes(
	id serial primary key,
	user_id bigint unsigned not null,
	photos_id bigint unsigned not null,
	likedornot char(1),
	foreign key (user_id) references users(id),
	foreign key (photos_id) references photos(id)
);