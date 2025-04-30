--Netflix Project---

drop table if exists netflix;
create table  netflix
 (
 show_id varchar (10),
 type varchar (50),
 title varchar (250),
 director varchar (250),
 casts  VARCHAR(1000),
 country  varchar (250),
 date_added varchar(50),
 release_year int,
 rating	varchar(10),
 duration	varchar(50),
 listed_in varchar(500),
 description varchar(300)
);


Select *from netflix;


Select count (*) as total_content
from netflix;

Select 
	distinct type
	from netflix;

---Business Problems and Solutions---

--Count the Number of Movies vs TV Shows

Select 
type,
count(*) as total_content
from netflix
Group by type

---Find the Most Common Rating for Movies and TV Shows

Select
	type,
	rating
	from
(
Select 
type,
rating,
count(*),
Rank () over(partition by type order by count(*) desc) as ranking
--- MAX(rating)
from netflix
Group by 1,2
)as t1
where
	ranking= 1

---List All Movies Released in a Specific Year (e.g., 2020)
	Select * from netflix
	where 
	type = 'Movie'
	And
	release_year = 2020

---	 Find the Top 5 Countries with the Most Content on Netflix
Select
	 unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
	From netflix
	group by 1
	order by 2 desc
	limit 5

Select 
	 unnest(string_to_array(country, ',')) as new_country
	 from netflix

--- Identify the Longest Movie
Select * from netflix
Where 
	type = 'Movie'
	And
	duration = (select  max (duration) from netflix)

----Find Content Added in the Last 5 Years
Select 
	* 
	from netflix
	where
		to_date(date_added, 'Month DD ,YYYY') >= current_date -interval '5 years '

Select current_date -interval '5 years '

-- Find All Movies/TV Shows by Director 'Rajiv Chilaka'

Select *from netflix
	Where director like '%Rajiv Chilaka%'

--List All TV Shows with More Than 5 Seasons
		select *
		from netflix
		where
		type = 'TV Show'
		And
		split_part(duration,' ', 1)::int > 5

----Count the Number of Content Items in Each Genre
		
		Select 
		unnest(String_to_array(listed_in, ',')),
		count (show_id)
		from netflix
		group by 1

---.Find each year and the average numbers of content release in India on netflix.
select 
	Extract(YEAR from TO_DATE(date_added, 'Month DD, YYYY')) as year,
	count(*),
	Round(
	count(*)::int/(Select count(*) from netflix Where country = 'India')::int *100
	,2) as avg_content_per_year
	from netflix
 	where country = 'India'
	 Group By 1

--List All Movies that are Documentaries
Select *
From netflix
Where listed_in Like '%Documentaries%'

--- Find All Content Without a Director

Select *
From netflix
Where director is null

---Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
 Select * from netflix
 Where casts ilike '%Salman Khan%'
 And 
 release_year > Extract(year from current_date) - 10

--- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select
--show_id,
--casts,
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
Group by 1
order by 2 desc
Limit 10

---Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table
as
(Select * ,
	case
	when description ilike '%kill%' 
	or
	description ilike'%violence%' then 'Bad'
	Else 'Good'
	end category
	from netflix)
Select 
	category,
	Count(*) as total_content
	from new_table
	Group by 1


	


