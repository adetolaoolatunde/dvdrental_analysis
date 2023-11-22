-- #1
-- Display the customer names that share the same address
select c1.first_name, c1.last_name, c2.first_name, c2.last_name
from customer as c1
join customer as c2
on c1.customer_id <> c2.customer_id and c1.address_id = c2.address_id
;

-- #2
-- What is the name of the customers who made the highest total payment?
select c.customer_id, c.first_name, c.last_name, sum(p.amount) as total_paid
from customer as c
join payment as p
using(customer_id)
group by 1, 2, 3
order by 4 desc
limit 1
;

-- #3
-- What is the movie that was rented the most?
select f.title, count(rental_id)
from film as f
join inventory as i
using(film_id)
join rental as r
using(inventory_id)
group by 1
order by 2 desc
limit 1
;

-- #4
-- Which movies have been rented so far
select f.title, count(rental_id) as rented_count
from film as f
join inventory as i
using(film_id)
join rental as r
using(inventory_id )
group by 1
order by 2
;

-- #5
-- Which movies have not been rented so far
select f.title, count(rental_id) as rented_count
from film as f
left join inventory as i
using(film_id)
left join rental as r
using(inventory_id)
group by 1
having count(rental_id) = 0
order by 1
;

-- #6
-- Which customers have not rented any movies so far
select c.first_name, c.last_name, count(rental_id) as rented_count 
from customer as c
left join rental as r
using(customer_id)
group by 1, 2
having count(rental_id) = 0
order by 3
;

-- #7
-- Display each movie and the number of times it got rented
select f.title, count(rental_id) as rented_count
from film as f
join inventory as i
using(film_id)
join rental as r
using(inventory_id)
group by 1
order by 1
;

-- #8
-- Show the first and last name, and th enumber of films each actor acted in
select a.first_name || ' ' || a.last_name as actor, count(f.film_id) as film_count
from actor as a
left join film_actor as fa
using(actor_id)
left join film as f 
using(film_id)
group by 1
order by 1
;

-- #9
-- Display the names of the actors that acted in more than 20 movies
select a.first_name|| ' ' || a.last_name, count(f.film_id) as film_count
from actor as a
left join film_actor as fa
using(actor_id)
left join film as f 
using(film_id)
group by 1
having count(f.film_id) > 20
order by 1
;

-- #10
-- For all the moveis rated 'PG' show the movie and the number 
-- of times it got rented
select f.title, count(rental_id) as rented_count
from film as f
join inventory as i
using(film_id)
join rental as r
using(inventory_id)
where f.rating = 'PG'
group by 1
order by 1
;

-- #11
-- Display the movies offered for rent in store_id 1
-- and not in store_id 2
select f.title
from film as f
join (select distinct(i1.film_id) as film_id
		from inventory as i1
		left join inventory as i2
		on i1.film_id = i2.film_id and i1.store_id <> i2.store_id
		where i1.store_id = 1 and i2.store_id is null)
using(film_id)
;

-- #12
-- Display the moves offered for rent in any of the two stores 1 & 2
select distinct(f.title), i.store_id
from film as f
join inventory as i
using(film_id)
order by 1
;

-- #13
-- Display the movie titles of those movies offered in both stores 
-- at the same time
select f.title
from film as f
join (select distinct(i1.film_id) as film_id
		from inventory as i1
		join inventory as i2
		on i1.film_id = i2.film_id and i1.store_id <> i2.store_id)
using(film_id)
;

-- #14
-- Display the movie title for the most rented movie in the store with
-- store_id 1
select f.title, count(r.rental_id) store_1_rental_count
from film as f
join inventory as i
using(film_id)
join rental as r
using(inventory_id)
where i.store_id = 1
group by 1
order by 2 desc
limit 1
;

-- #15
-- How many movies are not offered for rent in the stores yet
select f.title
from film as f
left join inventory as i
using(film_id)
where i.inventory_id is null
order by 1
;

-- #16
-- show the number of rented movies under each rating
with temptbl as (
			select distinct(f.title) as title, f.rating as rating, r.rental_id as rental_id
			from film as f
			join inventory as i
			using(film_id)
			join rental as r
			using(inventory_id)
			order by 1 )
select rating, count(rental_id)
from temptbl
group by 1
order by 1
;

-- #17
-- Show the profit of each of the stores 1 & 2
select i.store_id, sum(p.amount)
from inventory as i
join rental as r
using(inventory_id)
join payment as p
using(rental_id)
group by 1
;