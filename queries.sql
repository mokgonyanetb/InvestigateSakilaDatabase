/* Query - Query used for 1st insight */

SELECT category, SUM(rental_count)
FROM
	(SELECT DISTINCT
	  f.title,
	  c.name category,
	  COUNT(r.inventory_id) OVER (PARTITION BY f.title, c.name) AS rental_count
	FROM film f
	JOIN film_category fc ON f.film_id = fc.film_id
	JOIN category c ON fc.category_id = c.category_id
	JOIN inventory i ON f.film_id = i.film_id
	JOIN rental r ON i.inventory_id = r.inventory_id
	WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	ORDER BY category, title) sub
GROUP by category;

/* Query - Query used for 2nd insight */

SELECT 
	category, 
	SUM(amount) total_amount_per_category
FROM
	(SELECT 
		f.title,
		c.name category,
		p.amount
	FROM film f
	JOIN film_category fc ON f.film_id = fc.film_id
	JOIN category c ON fc.category_id = c.category_id
	JOIN inventory i ON f.film_id = i.film_id
	JOIN rental r ON i.inventory_id = r.inventory_id
	JOIN payment p ON r.rental_id = p.rental_id)
GROUP BY 1
ORDER BY 2 DESC;

/* Query 3 - Query used for 3rd insight */

SELECT country,
		COUNT(*) num_customers
FROM
	(SELECT *
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id 
	JOIN city cty
	ON cty.city_id = a.city_id 
	JOIN country ct
	ON ct.country_id = cty.country_id) sub
GROUP BY country
ORDER BY num_customers DESC
LIMIT 10;

/* Query 4 - Query used for 4th insight */

WITH customer_data AS(
	SELECT *
	FROM customer c
	JOIN address a ON c.address_id = a.address_id
	JOIN city AS cty ON cty.city_id = a.city_id
	JOIN country AS ct ON ct.country_id = cty.country_id
	JOIN payment AS p 
	ON p.customer_id = c.customer_id)	
SELECT
	first_name ||' '||last_name AS full_name,
	country,
	SUM(amount) AS amount_spent
FROM customer_data
GROUP BY full_name, country
ORDER BY 3 DESC
LIMIT 10;