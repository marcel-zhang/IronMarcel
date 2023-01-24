USE sakila;

# 1. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id, ci.city, co.country
FROM
    store AS s
        JOIN
    address USING (address_id)
        JOIN
    city AS ci USING (city_id)
        JOIN
    country AS co USING (country_id);

# 2. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    s.store_id, SUM(p.amount) AS total_amount
FROM
    store AS s
        JOIN
    staff USING (store_id)
        JOIN
    payment AS p USING (staff_id)
GROUP BY s.store_id;

# 3. What is the average running time(length) of films by category?
SELECT 
    ca.name, ROUND(AVG(f.length), 2) AS length_avg
FROM
    category AS ca
        JOIN
    film_category USING (category_id)
        JOIN
    film AS f USING (film_id)
GROUP BY ca.category_id
ORDER BY ca.name;

# 4. Which film categories are longest(length) (find Top 5)? (Hint: You can rely on question 3 output.)
SELECT 
    ca.name, ROUND(AVG(f.length), 2) AS length_avg
FROM
    category AS ca
        JOIN
    film_category USING (category_id)
        JOIN
    film AS f USING (film_id)
GROUP BY ca.category_id
ORDER BY length_avg DESC
LIMIT 5;

# 5. Display the top 5 most frequently(number of times) rented movies in descending order.
SELECT 
    f.title, COUNT(r.rental_id) AS rental_count
FROM
    film AS f
        JOIN
    inventory USING (film_id)
        JOIN
    rental AS r USING (inventory_id)
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

# 6. List the top five genres in gross revenue in descending order.
SELECT 
    ca.name, SUM(p.amount) AS total_amount
FROM
    category AS ca
        JOIN
    film_category USING (category_id)
        JOIN
    film USING (film_id)
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
        JOIN
    payment AS p USING (rental_id)
GROUP BY category_id
ORDER BY total_amount DESC
LIMIT 5;

# 7. Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    f.title,
    inventory_id,
    (CASE
        WHEN COUNT(r.return_date) = COUNT(r.rental_date) THEN 1
        ELSE 0
     END) AS available
FROM
    inventory AS i
        JOIN
    store AS s USING (store_id)
        JOIN
    film AS f USING (film_id)
        JOIN
    rental AS r USING (inventory_id)
WHERE
    f.title = 'ACADEMY DINOSAUR'
        AND s.store_id = 1
GROUP BY i.inventory_id;

SELECT 
    f.title, s.store_id, i.inventory_id, r.rental_date, r.return_date
FROM
    inventory AS i
        LEFT JOIN
    store AS s USING (store_id)
        LEFT JOIN
    film AS f USING (film_id)
        JOIN
    rental AS r USING (inventory_id)
WHERE
    f.title = 'ACADEMY DINOSAUR'
        AND s.store_id = 1;