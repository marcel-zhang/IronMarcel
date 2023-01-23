USE sakila

# 2. Explore tables by selecting all columns from the table for my client
SELECT * FROM sakila.customer;
    
# 3. Select one column from a table. Get film titles.
SELECT 
    title
FROM
    sakila.film;
    
# 4. Get unique list of film languages under the alias language.
SELECT 
    name AS language
FROM
    sakila.language;
    
# 5.1. Find out how many stores does the company have
SELECT 
    COUNT(*)
FROM
    sakila.store;
    
# 5.2. Find out how many employees staff does the company have
SELECT 
    COUNT(*)
FROM
    sakila.staff;
    
# 5.3. Return a list of employee first names only
SELECT 
    first_name
FROM
    sakila.staff;