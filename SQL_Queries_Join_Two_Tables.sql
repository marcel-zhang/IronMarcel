USE sakila;

# 1. Which actor has appeared in the most films?
SELECT 
    a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM
    film_actor AS fa
        JOIN
    actor AS a USING (actor_id)
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

# 2. Most active customer (the customer that has rented the most number of films)
SELECT 
    c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM
    customer AS c
        JOIN
    rental AS r USING (customer_id)
GROUP BY customer_id
ORDER BY rental_count DESC
LIMIT 1;

# 3. List number of films per category.
SELECT 
    ca.name, COUNT(fc.film_id) AS film_count
FROM
    category AS ca
        JOIN
    film_category AS fc USING (category_id)
GROUP BY name
ORDER BY name;

# 4. Display the first and last names, as well as the address, of each staff member.
SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff AS s
        JOIN
    address AS a USING (address_id);

# 5. get films titles where the film language is either English or Italian, 
# and whose titles starts with letter "M" , sorted by title descending.
SELECT 
    f.title, l.name
FROM
    film AS f
        JOIN
    language AS l USING (language_id)
WHERE
    (l.name = 'English' OR l.name = 'Italian')
        AND f.title LIKE 'M%'
ORDER BY title DESC;

# 6. Display the total amount rung up by each staff member in August of 2005.
SELECT 
    s.first_name, s.last_name, SUM(p.amount) AS total_amount
FROM
    staff AS s
        JOIN
    payment AS p USING (staff_id)
WHERE
    payment_date LIKE '2005-08%'
GROUP BY staff_id
ORDER BY total_amount DESC;

# 7. List each film and the number of actors who are listed for that film.
SELECT 
    f.title, COUNT(fa.actor_id) AS actor_count
FROM
    film AS f
        JOIN
    film_actor AS fa USING (film_id)
GROUP BY film_id
ORDER BY actor_count DESC
LIMIT 10;

# 8. List the total paid by each customer. List the customers alphabetically by last name.
SELECT 
    c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM
    customer AS c
        JOIN
    payment AS p USING (customer_id)
GROUP BY customer_id
ORDER BY c.last_name;

# 9. Write sql statement to check if you can find any actor who never particiapted in any film.
SELECT 
    a.actor_id, a.first_name, a.last_name, fa.film_id
FROM
    film_actor AS fa
        LEFT JOIN
    actor AS a USING (actor_id)
WHERE fa.film_id IS NULL;

# 10. Get the addresses that have NO customers, and ends with the letter "e".
SELECT 
    a.address
FROM
    address AS a
        LEFT JOIN
    customer AS c USING (address_id)
WHERE
    c.customer_id IS NULL
	AND a.address LIKE '%e';
    
# OPTIONAL: what is the most rented film?
SELECT 
    f.title, COUNT(rental_date) AS rental_count
FROM
    film AS f
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
GROUP BY film_id
ORDER BY rental_count DESC
LIMIT 1;