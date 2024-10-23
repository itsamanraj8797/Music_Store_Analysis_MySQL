# Answer questions based on Company Requirement
 USE MUSIC_STORE;
# Easy Questions
 
# 1. Who is the Most Senior Employee Based on Job Title?
 select * from music_store.employee
 order by levels desc
 limit 1;
 
# 2. Which Countries have most invoices?
 SELECT  billing_country , COUNT(*) as Count FROM music_store.invoice 
 group by billing_country
 order by Count desc
 limit 1;
 
# 3. What are top 3 Values of Invoices?
 SELECT * FROM music_store.invoice 
 ORDER BY total DESC
 LIMIT 3;
 
/* 4. Which city has the Best Customer? We would like to throw a promotional Music Festival
      in the city we made most money.
      Write a query that returns one city that has highest sum of invoice totals. 
      (Returns both the city name and sum of all invoice totals) */
      
      SELECT billing_city , SUM(total) AS Total_invoice FROM music_store.invoice
      GROUP BY billing_city
      ORDER BY Total_invoice DESC 
      limit 1;
      
 /* 5. Who is the best Customer? 
       The customer who has spent the most money will be declared the Best Customer.
       Write a query that returns the person who has spent the Most Money. */
       
		SELECT
			c.customer_id,
			c.first_name,
			c.last_name,
			c.city,
			c.state,
			c.country,
			c.email,
			SUM(i.total) AS Purchased
		FROM
			music_store.customer AS c
		INNER JOIN
			invoice AS i ON c.customer_id = i.customer_id
		GROUP BY
			c.customer_id,
			c.first_name,
			c.last_name,
			c.city,
			c.state,
			c.country,
			c.email
		ORDER BY
			Purchased DESC 
		limit 1;

# Moderate Level Questions

/* 6. WAQ to return email,first name ,last_name & genre of all rock Music Listners. Return your list ordered 
alphabetically by email start with A.*/

SELECT DISTINCT email,first_name,last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
				SELECT track_id FROM track
                JOIN genre ON track.genre_id = genre.genre_id
                WHERE genre.name LIKE 'ROCK' )
ORDER BY email;

/* 7. Let's Invite the Artist who have written the most rock music in our Dataset. 
Write a query that returns the Artist name and Total track count of the Top 10 Rock Bands.*/

SELECT artist.artist_id,artist.name, count(artist.artist_id) AS Number_of_Songs
FROM track
JOIN album ON album.album_id = track.track_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id,artist.artist_id,artist.name
ORDER BY Number_of_Songs DESC
LIMIT 10;

/* 8. Return all the track names that have a song Length longer than the average
Song Length . Return the name and millisecond for each track. Order by the Song Length
with the Longest Songs listed first. */

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
		SELECT AVG(milliseconds) AS avg_track_length
		FROM track)
ORDER BY milliseconds DESC;


# Advance Questions

/* 9. Find how much amount spent by each customer on artists?
WAQ to return customer name,artist name and Total spent. */

WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id , artist.name AS artist_name,
    SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY 1,2
    ORDER BY 3 DESC
    LIMIT 1
)
SELECT C.customer_id,c.first_name,c.last_name,bsa.artist_name , SUM(il.unit_price * il.quantity) AS amount_spend
FROM INVOICE i
JOIN CUSTOMER c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
