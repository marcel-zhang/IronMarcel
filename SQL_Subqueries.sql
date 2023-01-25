USE sakila;

# 1. List all films whose length is longer than the average of all the films.
SELECT title FROM film
WHERE length > 
	(
	SELECT AVG(length) 
    FROM film
    );

# 2. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) copy_count 
FROM inventory 
WHERE film_id = 
	(
	SELECT film_id 
	FROM film 
    WHERE title = UPPER('Hunchback Impossible')
    );

#3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(first_name, ' ', last_name) full_name
FROM actor 
WHERE actor_id IN
	(
    SELECT actor_id 
    FROM film_actor
    WHERE film_id = 
		(
        SELECT film_id
        FROM film
        WHERE title = UPPER('Alone Trip')
        )
	);
        
SELECT a.first_name, a.last_name 
FROM actor a  
JOIN film_actor USING(actor_id)
JOIN film f USING(film_id)
WHERE f.title = UPPER('Alone Trip');

#4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as family films.
SELECT title
FROM film 
WHERE film_id IN
	(
    SELECT film_id
    FROM film_category
    WHERE category_id =
		(
        SELECT category_id
        FROM category
        WHERE name = 'Family'
        )
	);

# 5. Get name and email from customers from Canada using subqueries. 
# Do the same with joins. Note that to create a join, 
# you will have to identify the correct tables with their primary keys and foreign keys, 
# that will help you get the relevant information.

## Using subqueries
SELECT first_name, last_name, email
FROM customer 
WHERE address_id IN
	(
    SELECT address_id
    FROM address
    WHERE city_id IN
		(
        SELECT city_id
        FROM city
        WHERE country_id IN
			(
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
            )
		)
	);

## Using JOIN
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country co USING(country_id)
WHERE co.country = 'Canada';

# OPTIONAL

# 6. Which are films starred by the most prolific actor? 
# Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then 
# use that actor_id to find the different films that he/she starred.

# Complicated way
SELECT title
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM film_actor
    WHERE actor_id =
		(
		SELECT actor_id 
		FROM 
			(
			SELECT actor_id, COUNT(film_id) film_count
			FROM film_actor
			GROUP BY actor_id
			) AS film_count
		WHERE film_count = 
			(
            SELECT MAX(film_count)
            FROM 
				(
				SELECT actor_id, COUNT(film_id) film_count
				FROM film_actor
				GROUP BY actor_id
				) AS film_count
			)
		)
	);

# Neat way
SELECT title
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM film_actor
    WHERE actor_id =
		(
		SELECT actor_id 
		FROM film_actor
        GROUP BY actor_id
		ORDER BY COUNT(film_id) DESC
		LIMIT 1
        )
	);
    
# 7. Films rented by most profitable customer. 
# You can use the customer table and payment table to find the most profitable customer ie 
# the customer that has made the largest sum of payments
SELECT title 
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM inventory
    WHERE inventory_id IN
		(
        SELECT inventory_id
        FROM rental
        WHERE customer_id =
			(
            SELECT customer_id
			FROM payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC
            LIMIT 1
			)
		)
	);

SELECT first_name, last_name
FROM customer
WHERE customer_id =
	(
    SELECT customer_id
	FROM payment
	GROUP BY customer_id
	ORDER BY SUM(amount) DESC
    LIMIT 1
    );

# Customer ID ranked by total spending
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

# 8. Customers who spent more than the average payments
# (this refers to the average of all amount spent per each customer).

## Using subquery alias
SELECT first_name, last_name
FROM customer
WHERE customer_id IN
	(
    SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >
		(
		SELECT AVG(amount_sum)
		FROM
			(
			SELECT SUM(amount) amount_sum
			FROM payment
			GROUP BY customer_id
			) AS amount_by_customer
		)
	)
ORDER BY first_name;

## Using 'WITH' clause
WITH amount_by_customer AS 
	(
    SELECT SUM(amount) amount_sum
    FROM payment
    GROUP BY customer_id
    )
    
SELECT first_name, last_name
FROM customer
WHERE customer_id IN
	(
    SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >
		(
		SELECT AVG(amount_sum)
		FROM amount_by_customer
		)
	)
ORDER BY first_name;
