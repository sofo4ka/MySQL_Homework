use music1;

- триггер для исправления невалидной даты рождения
drop trigger if exists check_user_age_before_insert;
delimiter //

create trigger check_user_age_before_insert before insert on users
for each row
begin
	if new.birthday > current_date() then
		set new.birthday = current_date();
	end if; 
end//

delimiter ;

-- триггер на повторные порядковые номера в плейлистах
drop trigger if exists check_songsonplaylists_numbervalidity;
delimiter //

create trigger check_songsonplaylists_numbervalidity before insert on songsonplaylists
for each row
begin
	declare currentplaylist int;
	declare maxnumberonplaylist int;
	if (new.songnumberonplaylist <> 1) and (playlist_id is not null) then
		set currentplaylist := playlist_id;
		select MAX(songnumberonplaylist) into maxnumberonplaylist from songsonplaylists where playlist_id = currentplaylist;
		set new.songnumberonplaylist = maxnumberonplaylist + 1;	
	end if;
end//

delimiter ;

select MAX(songnumberonplaylist) from songsonplaylists where playlist_id = 15;

-- Представление, которое выводит пользовательские плейлисты.
create or replace view usersplaylists(id, playlistname, coverimage, description, created_by) as
	select 
		p.id, p.playlistname, p.coverimage, p.description, u.loginname		
	from playlists as p
	left join users as u
	on p.created_by = u.id;
select * from usersplaylists;   


-- Представление, которое сопоставляет песни с авторами и альбомами.
create or replace view songalbumartist(id, songname, albumname, artist_id, artistsname) as
select s.id, s.songname, a.albumname, sp.artist_id, ar.artistsname 	
from songperformers as sp
	left join artists as ar 
	on sp.artist_id = ar.id	
	left join songs as s 
	on sp.song_id = s.id
	left join albums as a 
	on s.album_id = a.id; 
select id, songname, albumname, artistsname from songalbumartist order by id;

-- Представление, которое сопоставляет песни со стримов с авторами и альбомами, включая нулевые строки.
create or replace view allsongalbumartist(id, songname, albumname, artist_id, artistsname) as
select s.id, s.songname, a.albumname, sp.artist_id, ar.artistsname 	
from songperformers as sp
	right join artists as ar 
	on sp.artist_id = ar.id	
	left join songs as s 
	on sp.song_id = s.id
	left join albums as a 
	on s.album_id = a.id; 
select * from allsongalbumartist;

-


-- Самые прослушиваемые песни.
create or replace view moststreamedsongs(song_id, countofstreams) as
select song_id, count(*) as countofstreams from streams group by song_id order by countofstreams desc;

select mss.countofstreams , s.songname, a.albumname, ar.artistsname 	
from moststreamedsongs as mss
left join songs as s 
	on mss.song_id = s.id
left join songperformers as sp
	on mss.song_id = sp.song_id 
left join artists as ar 
	on sp.artist_id = ar.id	
left join albums as a 
	on s.album_id = a.id;
	

-- Самые прослушиваемые альбомы.
create or replace view moststreamedalbums(album_id, countofstreams) as
select album_id, count(*) as countofstreams from streams group by album_id order by countofstreams desc;

select msa.countofstreams , a.albumname, ar.artistsname 	
from moststreamedalbums as msa
left join albums as a 
	on msa.album_id = a.id
left join artistsandalbums as aa
	on msa.album_id = aa.album_id 
left join artists as ar 
	on aa.artist_id = ar.id;
	
-- самые залайканные плейлисты
create or replace view likedsongsview(song_id, countoflikes) as
select song_id, count(*) as countoflikes from likedsongs 
where likedornot = '1' group by song_id order by countoflikes desc;

select lsv.countoflikes, s.songname, a.albumname, ar.artistsname 
from likedsongsview as lsv
left join songperformers as sp
	on lsv.song_id = sp.song_id
left join artists as ar 
	on sp.artist_id = ar.id	
left join songs as s 
	on sp.song_id = s.id
left join albums as a 
	on s.album_id = a.id
limit 10; 

-- самый популярные артисты по подпискам
select ar.artistsname, subscribes.artist_id, count(*) as countofsubscribers from subscribes 
left join artists as ar 
	on subscribes.artist_id = ar.id	
where subscribedornot = '1' group by artist_id order by countofsubscribers desc limit 10;


-- самые популярные плейлисты
select p.playlistname, p.description, u.loginname as creator, likedplaylists.playlist_id, count(*) as countoflikes from likedplaylists
left join playlists as p 
	on likedplaylists.playlist_id = p.id
left join users as u 
	on p.created_by = u.id 	
where likedornot = '1' group by playlist_id order by countoflikes desc limit 10;	


-- подборки по жанру пост панка
select s.genre, s.id, s.songname, a.albumname, sp.artist_id, ar.artistsname 	
from songperformers as sp 
	left join artists as ar 
	on sp.artist_id = ar.id	
	left join songs as s 
	on sp.song_id = s.id
	left join albums as a 
	on s.album_id = a.id
	where s.genre = 'Post-punk';
	
-- самые залайканные песни в жанре пост-панк
create or replace view likedsongsview(song_id, countoflikes) as
select song_id, count(*) as countoflikes from likedsongs where likedornot = '1'
group by song_id order by countoflikes desc;

select lsv.countoflikes, s.genre, s.songname, a.albumname, ar.artistsname 
from likedsongsview as lsv
left join songperformers as sp
	on lsv.song_id = sp.song_id
left join artists as ar 
	on sp.artist_id = ar.id	
left join songs as s 
	on sp.song_id = s.id
left join albums as a 
	on s.album_id = a.id
 where s.genre = 'Post-punk' limit 10;
 
-- Самые прослушиваемые песни в жанре пост-панк
create or replace view moststreamedsongs(song_id, countofstreams) as
select song_id, count(*) as countofstreams from streams group by song_id order by countofstreams desc;

select mss.countofstreams, s.genre, s.songname, a.albumname, ar.artistsname 	
from moststreamedsongs as mss
left join songs as s 
	on mss.song_id = s.id
left join songperformers as sp
	on mss.song_id = sp.song_id 
left join artists as ar 
	on sp.artist_id = ar.id	
left join albums as a 
	on s.album_id = a.id
where s.genre = 'Post-punk' limit 10;

   -- новые релизы
select s.id, s.songname, a.albumname, sp.artist_id, ar.artistsname, a.yearofrelease 	
from songperformers as sp
	left join artists as ar 
	on sp.artist_id = ar.id	
	left join songs as s 
	on sp.song_id = s.id
	left join albums as a 
	on s.album_id = a.id
order by a.yearofrelease desc limit 20; 

 -- Процедура, позволяющая посмотреть подписки юзера
drop procedure if exists usersubscribeinfo;
delimiter //

create procedure usersubscribeinfo(in for_user_id int)
begin
	select u.id as user_id, subscribes.artist_id, artists.artistsname, u.loginname
	from subscribes
	left join users as u
		on subscribes.users_id = u.id
	left join artists 
		on subscribes.artist_id = artists.id
	where subscribedornot = '1' and u.id = for_user_id;
end//
delimiter ;

call usersubscribeinfo(200);

-- Процедура, позволяющая посмотреть стримы юзера
drop procedure if exists userstreamsinfo;
delimiter //

create procedure userstreamsinfo(in for_user_id int)
begin
	select u.id, u.loginname, str.song_id, s.songname, a.albumname, ar.artistsname 	
	from streams as str
	left join users as u
		on str.users_id = u.id
	left join songs as s 
		on str.song_id = s.id
	left join songperformers as sp
		on str.song_id = sp.song_id 
	left join artists as ar 
		on sp.artist_id = ar.id	
	left join albums as a 
		on s.album_id = a.id
	where u.id = for_user_id;
end//
delimiter ;

call userstreamsinfo(8);

 
 -- Процедура, позволяющая посмотреть любимые песни
drop procedure if exists userfavoritesongsinfo;
delimiter //

create procedure userfavoritesongsinfo(in for_user_id int)
begin
	select u.id as user_id, ls.song_id, s.songname, s.genre, u.loginname
	from likedsongs as ls
	left join users as u
		on ls.users_id = u.id
	left join songs as s
		on ls.song_id = s.id	
	where likedornot = '1' and u.id = for_user_id;
end//
delimiter ;

call userfavoritesongsinfo(232);