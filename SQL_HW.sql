USE sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT  first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT (first_name," ", last_name) AS full_name FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%GEN';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name; 

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR(10) AFTER first_name;
    
#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
	MODIFY middle_name BLOB;
    
#3c. Now delete the middle_name column.
ALTER TABLE actor
	DROP COLUMN middle_name;

#1a Display the first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(*)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT COUNT(*), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO",
        last_name = "WILLIAMS"
WHERE actor_id = 172;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = "MUCH GROUCHO",
        last_name = "WILLIAMS"
WHERE actor_id = 172;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON a.address_id = s.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT s.first_name, s.last_name, COUNT(p.amount) as total_rung
FROM staff s
JOIN payment p
ON p.staff_id = s.staff_id
WHERE payment_date BETWEEN "2005-08-01" and "2005-08-31"
GROUP BY s.first_name, s.last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.actor_id) as actors_in_film
FROM film f
JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(i.film_id) 
FROM inventory i
JOIN film f
ON i.film_id = f.film_id 
GROUP BY f.title 
HAVING f.title = 'HUNCHBACK IMPOSSIBLE';


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name,
SUM(p.amount) 
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id 
GROUP BY c.first_name, c.last_name;


#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT title
FROM film
WHERE language_id IN
	(
    SELECT language_id
    FROM language
    WHERE name = 'English'
    )
 AND title LIKE 'Q%' OR title LIKE 'K%';


#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);


#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN
(
	SELECT customer_id
    FROM country
    WHERE country = 'Canada'
);


#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title 
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
        SELECT category_id
        FROM category
        WHERE name = 'family films'
        )
	);

#7e. Display the most frequently rented movies in descending order.
SELECT r.title, r.rental_rate
FROM
	(SELECT * FROM film ORDER BY rental_rate DESC) AS r;


#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT c.store_id, SUM(p.amount) as total_amt
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.store_id;


#7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, cont.country
FROM store s
	JOIN address a
		ON s.address_id = a.address_id
	JOIN city c
		ON a.city_id = c.city_id
	JOIN country cont
		ON c.country_id = cont.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT cat.name, SUM(p.amount)
FROM category cat
	JOIN film_category fcat
		ON cat.category_id = fcat.category_id
	JOIN inventory i
		ON fcat.film_id = i.film_id
	JOIN rental r
		ON i.inventory_id = r.inventory_id
	JOIN payment p
		ON r.customer_id = p.customer_id
GROUP BY cat.name 
LIMIT 5;


#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_grossing AS
SELECT cat.name, SUM(p.amount)
FROM category cat
	JOIN film_category fcat
		ON cat.category_id = fcat.category_id
	JOIN inventory i
		ON fcat.film_id = i.film_id
	JOIN rental r
		ON i.inventory_id = r.inventory_id
	JOIN payment p
		ON r.customer_id = p.customer_id
GROUP BY cat.name 
LIMIT 5;


#8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW top_grossing;


#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_grossing;