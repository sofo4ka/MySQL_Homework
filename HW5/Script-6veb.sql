-- ������������ �������� ������������
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

-- ������ ������ ������������ 1 � ��������� ���� � �������� 

select  
	firstname,
	lastname,
	timestampdiff(year, birthday, now()) as age,
	case(gender)
		when 'm' then '�������'
		when 'f' then '�������'
	end as 'gender'
from users where id in (select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null);


-- �������� id ������ ������������ ����� 1
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
union
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved';

-- �������� id ������ ������������ ����� 2
select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null;

-- ������������� ���������, ������������ ������������ (������)
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	message,
	create_at 
from messages m
where to_user_id = 30 and is_read = 0;

-- ���-�� ������������� ���������, ������������ ������������ 30 �� ������
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



-- ������� ���-�� ������, �������������� ������ �������������

select avg(total_user_posts) from (select count(*) as total_user_posts  from posts group by user_id) as total_users_posts_tbl;

-- ����� ��������
select count(*) as total_news, monthname(created_at) as `month` from posts group by `month` order by total_news desc;

-- ������� ���������� ����� � ���� �������������
select (select count(*) from users_communities)/(select count(*) from users);

-- ���-�� ������������� �� ����� ����� � ��������� ������ �������������
select (select count(*) from users)/(select count(distinct community_id ) from users_communities);

--  min max
select max(timestampdiff(year, birthday, now())) as age from users;

select timestampdiff(year, birthday, now()) as age from users order by age desc limit 1;

select gender, min(timestampdiff(year, birthday, now())) as age from users group by gender;

-- ������������ ������� � null
select count(*) from photos;

select count(id) from photos;

select count(description) from photos;


-- ����� ����� ��������� ������������. �� ���� ������ ����� ������������ ������� ��������, ������� ������ ���� ������� � ����� �������������.
-- (���� � ��������� ������, �� ������� ��� ������, ��� ��� ��������� ������)

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


-- ���������� ����� ���������� ������, ������� �������� 10 ����� ������� �������������.
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

-- ������ ��� � �� ���������� ���, ��� �� ��� �������� =(



-- ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?



-- ����� 10 �������������, ������� ��������� ���������� ���������� � ������������� ���������� ����.

