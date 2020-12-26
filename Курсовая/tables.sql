drop database if exists music1;
create database music1;
use music1;
-- база данных медиаплеера типа Spotify

drop table if exists users;
create table users(
	id serial primary key, -- serial = bigint unsigned not null auto_increment unique 
	firstname varchar(20) comment 'Имя пользователя',
	lastname varchar(20) comment 'Фамилия пользователя',
	email varchar(50) unique comment 'Электронная почта',
	gender char(10),
	phone varchar(20) unique,
	loginname varchar(30) comment 'Короткое имя или никнейм пользователя',
	pass char(20) comment 'Пароль',
	birthday date,
	country varchar(40),
	created_at datetime default now()
);

alter table users add index(phone);
alter table users add index(email);
alter table users add index(loginname);

drop table if exists artists;
create table artists(
	id serial primary key,
	artistsname varchar(50) comment 'Имя исполнителя/коллектива',
	image_id bigint unsigned,
	description text,
	unique key(artistsname),
	index(artistsname)
);

drop table if exists songs;
create table songs(
	id serial primary key,
	songname varchar(100) comment 'Название музыкального трека',
	album_id bigint unsigned not null,
	songnumberonalbum bigint unsigned not null comment 'Порядковый номер песни в оригинальном альбоме', 
	songduration varchar(10) comment 'Длительность песни',
	songfile varchar(200) comment 'Ссылка на непосредственно музыкальный файл в хранилище/ либо сам файл', 
	genre varchar(50) comment 'Название музыкального жанра',
	index(songname),
	index(genre)	
);

drop table if exists albums;
create table albums(
	id serial primary key,
	albumname varchar(50) comment 'Название альбома/EP',
	coverimage varchar(200),
	yearofrelease bigint, 
	created_at datetime default now(),
	genre varchar(50) comment 'Название музыкального жанра альбома',
	index(genre),
	index(albumname)
);

alter table songs add foreign key (album_id) references albums(id);

drop table if exists playlists;
create table playlists(
	id serial primary key,
	playlistname varchar(50) comment 'Название плейлиста',
	coverimage  varchar(200),
	description text,
	created_by bigint unsigned not null,
	created_at datetime default now(),
	index(playlistname)
);
alter table playlists add foreign key (created_by) references users(id);

drop table if exists subscribes;
create table subscribes(
	id serial primary key,
	users_id bigint unsigned not null,
	artist_id bigint unsigned not null,
	subscribedornot char(1),
	updated_at datetime default now(), 
	foreign key (users_id) references users(id),
	foreign key (artist_id) references artists(id)
);

drop table if exists likedsongs;
create table likedsongs(
	id serial primary key,
	users_id bigint unsigned not null,
	song_id bigint unsigned not null,
	likedornot char(1),
	updated_at datetime default now(), 
	foreign key (users_id) references users(id),
	foreign key (song_id) references songs(id)	
);

drop table if exists likedalbums;
create table likedalbums(
	id serial primary key,
	users_id bigint unsigned not null,
	album_id bigint unsigned not null,
	likedornot char(1),
	updated_at datetime default now(), 
	foreign key (users_id) references users(id),
	foreign key (album_id) references albums(id)	
);

drop table if exists likedplaylists;
create table likedplaylists(
	id serial primary key,
	users_id bigint unsigned not null,
	playlist_id bigint unsigned not null,
	likedornot char(1),
	updated_at datetime default now(), 
	foreign key (users_id) references users(id),
	foreign key (playlist_id) references playlists(id)	
);



-- таблица связующая песни с артистами для обеспечения связи многие ко многим
drop table if exists songperformers;
create table songperformers(
	song_id bigint unsigned not null,
	artist_id bigint unsigned not null,
	primary key (song_id, artist_id),
	foreign key (song_id) references songs(id),
	foreign key (artist_id) references artists(id)
);
-- таблица связующая альбомы с артистами для обеспечения связи многие ко многим
drop table if exists artistsandalbums;
create table artistsandalbums(
	album_id bigint unsigned not null,
	artist_id bigint unsigned not null,
	primary key (album_id, artist_id),
	foreign key (album_id) references albums(id),
	foreign key (artist_id) references artists(id)
);

-- таблица связующая песни с альбомами для обеспечения связи многие ко многим
drop table if exists songsonplaylists;
create table songsonplaylists(
	song_id bigint unsigned not null,
	playlist_id bigint unsigned not null,
	songnumberonplaylist bigint unsigned not null, -- порядковый номер песни 
	primary key (song_id, playlist_id),
	foreign key (song_id) references songs(id),
	foreign key (playlist_id) references playlists(id)
);

-- таблица с прослушиваниями
drop table if exists streams;
create table streams(
	id serial primary key,
	users_id bigint unsigned not null,
	song_id bigint unsigned not null,
	album_id bigint unsigned not null,	
	listened_at datetime default current_timestamp,
	foreign key (users_id) references users(id),
	foreign key (song_id) references songs(id),
	foreign key (album_id) references albums(id),
	index(song_id)
);
