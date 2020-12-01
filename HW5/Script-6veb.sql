-- ѕерсональна€ страница пользовател€
select 
	firstname,
	lastname,
	hometown,
	(select filename from photos where id = u.photo_id) as 'personal_photo',
	(select count(*) from (select initiator_user_id from friend_requests where target_user_id = u.id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = u.id and status = 'approved') as fr_list) as 'friends',
	(select count(*) from friend_requests where target_user_id = u.id and status ='requested') as 'followers',
	(select count(*) from photos where user_id = u.id) 'photos'
from users as u 
where id = 21;

-- —писок друзей пользовател€ 1 с указанием пола и возраста 

select  
	firstname,
	lastname,
	timestampdiff(year, birthday, now()) as age,
	case(gender)
		when 'm' then 'ћужчина'
		when 'f' then '∆енщина'
	end as 'gender'
from users where id in (select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null);


-- ѕолучить id друзей пользовател€ номер 1
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
union
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved';

-- ѕолучить id друзей пользовател€ номер 2
select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null;

-- непрочитанные сообщени€, адресованные пользователю (список)
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	message,
	create_at 
from messages m
where to_user_id = 30 and is_read = 0;

-- кол-во непрочитанных сообщений, адресованных пользователю 30 от друзей
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	count(*) as total_msg 
from messages m
where 
	from_user_id in (select initiator_user_id from friend_requests where target_user_id = m.to_user_id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = m.to_user_id and status = 'approved') 
and
	to_user_id = 30 
and is_read = 0 
group by m.from_user_id order by total_msg desc;



-- среднее кол-во постов, опубликованных каждым пользователем

select avg(total_user_posts) from (select count(*) as total_user_posts  from posts group by user_id) as total_users_posts_tbl;

-- архив новостей
select count(*) as total_news, monthname(created_at) as `month` from posts group by `month` order by total_news desc;

-- среднее количество групп у всех пользователей
select (select count(*) from users_communities)/(select count(*) from users);

-- кол-во пользователей на число групп с ненулевым числом пользлвателей
select (select count(*) from users)/(select count(distinct community_id ) from users_communities);

--  min max
select max(timestampdiff(year, birthday, now())) as age from users;

select timestampdiff(year, birthday, now()) as age from users order by age desc limit 1;

select gender, min(timestampdiff(year, birthday, now())) as age from users group by gender;

-- агрегирующие функции и null
select count(*) from photos;

select count(id) from photos;

select count(description) from photos;


-- ѕусть задан некоторый пользователь. »з всех друзей этого пользовател€ найдите человека, который больше всех общалс€ с нашим пользователем.
-- (если € правильно пон€ла, то общалс€ это значит, что его сообщени€ читали)

select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	count(*) as total_msg 
from messages m
where 
	from_user_id in (select initiator_user_id from friend_requests where target_user_id = m.to_user_id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = m.to_user_id and status = 'approved') 
and
	to_user_id = 1 
and is_read = 1 
group by m.from_user_id order by total_msg desc limit 1;


-- ѕодсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- 1 
select 
	concat(users.firstname, ' ', users.lastname) as username, timestampdiff(year, users.birthday, now()) as age,
	(select p.user_id from postslikes where p.post_id = p2.id and p.likeexists = 1) user_id,
	count(*) as total_postlikes 
from posts as p2
join postslikes as p on p.post_id = p2.id
join users on users.id = p2.user_id
order by age, total_postlikes limit 10;	
-- 2
select 
	concat(users.firstname, ' ', users.lastname) as username, timestampdiff(year, users.birthday, now()) as age,
	(select postslikes.post_id 
		from postslikes 
		where postslikes.post_id = p2.id 
			and postslikes.likeexists = 1 
		group by postslikes.post_id) likedposts, count(*) as total_postlikes 
from posts as p2
join users on users.id = p2.user_id
order by age, total_postlikes limit 10;
-- 3
select 
	concat(users.firstname, ' ', users.lastname) as username,
	timestampdiff(year, users.birthday, now()) as age,
		(select posts.user_id from posts 
		where postslikes.post_id = posts.id) user_id,
		count(*) as total_postlikes
from postslikes where postslikes.likeexists = 1
join posts on postslikes.post_id = posts.id
join users on users.id = posts.user_id
order by age, total_postlikes limit 10;

-- ничего так и не заработало так, как бы мне хотелось =(



-- ќпределить кто больше поставил лайков (всего) - мужчины или женщины?



-- Ќайти 10 пользователей, которые про€вл€ют наименьшую активность в использовании социальной сети.

