# Explore tables by selecting all columns from the table for my client
SELECT 
    *
FROM
    sakila.customer;
    
# Select one column from a table. Get film titles.
SELECT 
    title
FROM
    sakila.film;
    
# Get unique list of film languages under the alias language.
SELECT 
    name AS language
FROM
    sakila.language;
    
# Find out how many stores does the company have
SELECT 
    COUNT(*)
FROM
    sakila.store;
    
# Find out how many employees staff does the company have
SELECT 
    COUNT(*)
FROM
    sakila.staff;
    
# Return a list of employee first names only
SELECT 
    first_name
FROM
    sakila.staff;