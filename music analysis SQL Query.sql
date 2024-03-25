use music_analysis

SElect * from customer
select * from customer where country = 'Germany'
select * from customer order by first_name
select count(*) as total_customer from customer 
select count(*) as total ,city from customer group by city 
select distinct country from customer

--Ques1 Set

-- 1) Who is the senior most employee based on Jo title?
select top 1 * from employee
order by levels desc 

--select * from employee
--order by levels desc 
--limit 1        (supported by PostGreSQL)


--2) Which countries have the most invoices?
select count(*) as c,billing_country 
from invoice
group by billing_country 
order by c desc

--3) What are top 3 values of total invoice?
select * from invoice

select top 3 * from invoice 
order by total desc 

--4). Which city has the best customers? We would like to throw a promotional Music
--Festival in the city we made the most money. Write a query that returns one city that
--has the highest sum of invoice totals. Return both the city name & sum of all invoice totals?

select sum(total)as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total Desc

--5)  Who is the best customer? The customer who has spent the most money will be
--declared the best customer. Write a query that returns the person who has spent the most money

select * from customer

select TOP 1 customer.customer_id,
			 customer.first_name,
			 customer.last_name ,
			 SUM(invoice.total) as total
from customer 
JOIN invoice ON customer.customer_id = invoice.customer_id  
GROUP BY customer.customer_id,
         customer.first_name,
         customer.last_name
ORDER BY total DESC




-- Question set 2 
--1)Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
/*Method 1 */

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;


/* Method 2 */

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;



--2)Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands

SELECT top 10 artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id,
	     artist.name
ORDER BY number_of_songs DESC

-- Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the
--longest songs listed firstSELECT name,milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track )
ORDER BY milliseconds DESC;






