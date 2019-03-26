use sakila;

-- 1a. Display first and last names of all actors from the table "actor"
select first_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(first_name, " ", last_name)) as 'Actor Name'
from actor;

-- Find ID Number, first name, last name of an actor, of whom you only know by the first name, "Joe"
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- Find all actors whose last name contain the letters GEN:
select first_name, last_name
from actor
where last_name like "%GEN%";

-- Find all actors whose last names contain the letters LI. Be sure to order by last name, then first name.
select first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- Create a column in the table actor
alter table actor
add column description blob;

select *
from actor;

-- Delete the description column
-- alter table actor
-- drop column description blob;

select * 
from actor;

-- List the last names of actors..
select last_name
from actor;

-- as well as how many actors have that last name..
select last_name, count(last_name) as 'Last Name Count'
from actor
group by last_name;

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name as 'Last Name', count(last_name) as 'Last Name Count'
from actor
group by last_name
having count(last_name) >1;

-- The actor Harpo Williams was accidentally entered in the actor table as Grucho Williams. Write a query to fix..
select first_name, last_name
from actor
where first_name = "Groucho" and last_name = "Williams";

update actor
set first_name = "Harpo"
where first_name = "Groucho" and last_name = "Williams";

-- If the first name of the actor is currently Harpo, change it to Groucho..
update actor
set first_name = "Harpo"
where first_name = "Groucho";

-- createe new address table
create table address_new (
	address_id INT not null,
    address varchar(50) not null,
    address2 varchar(50) not null,
    district varchar(50) not null,
    city_id INT not null,
    postal_code INT not null,
    phone INT not null,
    location varchar(50) not null,
    last_update varchar(100) not null
    );
    
-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff.first_name as 'First Name', staff.last_name as 'Last Name' , address.address as 'Address'
from staff
join address
on address.address_id = staff.address_id;

-- * Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select concat(staff.first_name, ' ',staff.last_name), as 'Staff Member' sum(payment.amount) as 'Total Amount'
from payment
join staff
on payment.staff_id = staff.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select concat(staff.first_name, ' ',staff.last_name) as 'Staff Member', sum(payment.amount) as 'Total Amount'
from payment
join staff
on payment.staff_id
where payment_date like '2005-08%'
group by payment.staff_id;

-- * List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select concat(film_actor.first_name, ' ',film_actor.last_name) as 'Actor', sum(actor.amount) as 'Number of Actors listed'
from actor
inner join film_actor;

-- Hunchback Impossible exist in the inventory system?
select title as film, count(inventory.inventory_id) as 'Amount of Copies'
from film
join inventory
on film.film_id = inventory.film_id
where film.title = "Hunchback Impossible"
group by film.film_id;    

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select concat(customer.first_name, ' ',customer.last_name) as 'Customer Name', sum(payment.amount) as 'Total Paid'
from payment 
JOIN customer
on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title
from film
where film.language_id = (select language_id from language where name =  'English')
and film.title like 'K%' or 'Q%';

-- Use subqueries to display all actors who appear in the film Alone Trip
select concat(first_name, ' ',last_name) as 'Actors in Alone Trip'
from actor
where actor_id in 
	(
    select actor_id from film_actor where film_id = 
	(select film_id from film where title = 'Alone Trip')
    );
    
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
select concat(customer.first_name, ' ', customer.last_name) as 'Name', customer.email as 'Canadian Customer E-mails'
from customer
join address on address.address_id
join city as cy on address.city_id = cy.city_id
join country as ct on ct.country_id = cy.country_id
where ct.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.title as 'Title of Film'
	from film as f
	join film_category as fc on fc.film_id = f.film_id
	join category as c on c.category_id = fc.category_id
	where c.name = 'Family';
    
-- 7e. Display the most frequently rented movies in descending order.
select f.title as 'Movie', count(r.rental_date) as 'Rental Frequency'
from film as f
join inventory as i on i.film_id = f.film_id
join rental as r on r.inventory_id = i.inventory_id
group by f.title
order by count(r.rental_date) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select store as 'Store', total_sales as 'Total Sales (USD)' from sales_by_store;

select concat(c.city,', ',cy.country) as `Store`, s.store_id as 'Store ID', 
	sum(p.amount) as `Total Sales` 
	from payment as p
	join rental as r on r.rental_id = p.rental_id
	join inventory as i on i.inventory_id = r.inventory_id
	join store as s on s.store_id = i.store_id
	join address as a on a.address_id = s.address_id
	join city as c on c.city_id = a.city_id
	join country as cy on cy.country_id = c.country_id
	group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id as 'Store ID', city.city as 'City', country.country as 'Country'
	from store
	join address on address.address_id = store.address_id
	join city on city.city_id = address.city_id
	join country on country.country_id = city.country_id
	order by store.store_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name as 'Film Type', sum(p.amount) as 'Gross Revenue (Top 5)'    	
	from category as c
	join film_category as fc on fc.category_id = c.category_id
	join inventory as i on i.film_id = fc.film_id
	join rental as r on r.inventory_id = i.inventory_id
	join payment as p on p.rental_id = r.rental_id
	group by c.name
	order by sum(p.amount) desc
	limit 5;
    
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_5_genre_revenue as 
	SELECT c.name as 'Film', sum(p.amount) as 'Gross Revenue'
	from category as c
	join film_category as fc on fc.category_id = c.category_id
	join inventory as i on i.film_id = fc.film_id
	join rental as r on r.inventory_id = i.inventory_id
	join payment as p on p.rental_id = r.rental_id
	group by c.name
	order by sum(p.amount) desc
	limit 5;

-- 8b. How would you dislay the view that you created in 8a. ?
SELECT *
	FROM top_5_genre_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_5_genre_revenue;