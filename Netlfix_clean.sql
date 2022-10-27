create database PortofolioProject;
use PortofolioProject;


CREATE TABLE netflix(
show_id      VARCHAR(5)  PRIMARY KEY
  ,type         VARCHAR(7) 
  ,title        VARCHAR(104) 
  ,director     VARCHAR(208)
  ,cast         VARCHAR(771)
  ,country      VARCHAR(123)
  ,date_added   varchar(20)
  ,release_year INTEGER  
  ,rating       VARCHAR(8)
  ,duration     VARCHAR(10)
  ,listed_in    VARCHAR(79) 
  ,description  VARCHAR(248) 
) engine=InnoDB;


-- Import data
LOAD DATA INFILE 'C:/Program Files/MySQL/MySQL Server 8.0/Import/netflix_titles.csv'
INTO TABLE netflix 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Check for duplicates
SELECT show_id, COUNT(*)                                                                                                                                                                            
FROM netflix 
GROUP BY show_id                                                                                                                                                                                            
ORDER BY show_id DESC;

-- Check null value
SELECT COUNT(*) as id
FROM netflix
where show_id is null ;

-- Rename column
alter table netflix
rename column listed_in to genre,
rename column cast to movie_cast;

-- Change blank value to null
update netflix
set 
    type = nullif(type, ''),
    title = nullif(title, ''),
    director = nullif(director, ''),
    movie_cast = nullif(movie_cast, ''),
    country = nullif(country, ''),
    date_added = nullif(date_added, ''),
    release_year = nullif(release_year, ''),
    rating = nullif(rating, ''),
    duration = nullif(duration, ''),
    genre = nullif(genre, '');
    
-- Count null values in every column    
select 
  sum(case when type is null then 1 else 0 end) type_null,
  sum(case when title is null then 1 else 0 end) title_null,
  sum(case when director is null then 1 else 0 end) director_null,
  sum(case when movie_cast is null then 1 else 0 end) cast_null,
  sum(case when country is null then 1 else 0 end) country_null,
  sum(case when date_added is null then 1 else 0 end) date_added_null,
  sum(case when release_year is null then 1 else 0 end) release_null,
  sum(case when rating is null then 1 else 0 end) rating_null,
  sum(case when duration is null then 1 else 0 end) duration_null,
  sum(case when genre is null then 1 else 0 end) genre_null
from netflix;

-- Check correlation column director with column movie_cast
WITH cte AS
(
SELECT title, CONCAT(director, '---', movie_cast) AS director_cast 
FROM netflix
)
SELECT director_cast, COUNT(*) AS count
FROM cte
GROUP BY director_cast
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Create table nt2 based on table netflix

-- Update director by movie cast (becasue director have corelation with movie cast)
update netflix, nt2
set netflix.director = nt2.director
WHERE nt2.cast = netflix.movie_cast AND netflix.director is null;

-- Update country by director
update netflix, nt2
set netflix.country = nt2.country
WHERE nt2.director = netflix.director and netflix.show_id <> nt2.show_id AND netflix.country is null;

-- Update null value with "Not Given"
update netflix
set director = 'Not Given'
where director is null;
update netflix
set country = 'Not Given'
where country is null;
update netflix
set movie_cast = 'Not Given'
where movie_cast is null;

-- Delete row in column if value null <100
delete from netflix
where rating is null;
delete from netflix
where duration is null;
delete from netflix
where date_added is null;

-- Count country
select count(country) as count, country from netflix
group by country
order by count desc;

-- Count director
select count(director) as count, director from netflix
group by director
order by count desc;

-- Count genre
select count(genre) as count, genre from netflix
group by genre
order by count desc;

-- Count movie by release year
select release_year, count(*) as total_movie from netflix
group by release_year
order by total_movie;

-- Check oldest movie
select title, release_year from netflix
order by release_year asc;

-- Export to csv for visualization
select * from netflix;
SELECT 'show_id', 'type', 'title', 'director', 'movie_cast', 'country', 'date_added', 'release_year', 'rating', 'duration', 'genre'
UNION ALL
SELECT show_id, type, title, director, movie_cast, country, date_added, release_year, rating, duration, genre from netflix
INTO OUTFILE 'C:/temp/netflix_cleanv2.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';
