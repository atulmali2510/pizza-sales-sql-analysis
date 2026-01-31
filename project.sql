create database Projects;

use projects;

create table orders (
	order_id int primary key,
    date text,
    time TIME 
    );
    
create table pizza_types(
	pizza_type_id varchar (60) primary key,
	name varchar(60),
    category varchar(15),
    ingredients text
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(60) PRIMARY KEY,
    pizza_type_id VARCHAR(60),
    size VARCHAR(5),
    price DECIMAL(5,2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

create table order_details(
	order_details_id int primary key ,
    order_id int, 
    pizza_id varchar(60),
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (pizza_id) references pizzas(pizza_id)
);

select * from orders;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv"
INTO TABLE order_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from pizzas ;
select * from order_details;
select * from pizza_types;
select * from orders;

############################# Basic ############################

# 1 Retrieve the total number of orders placed
SELECT COUNT(*) FROM orders;

# 2 Calculate the total revenue generated from pizza sales
SELECT 
	sum(order_details.quantity * pizzas.price) as total_revenue
from 
	order_details
inner join 
	pizzas
on 
	order_details.pizza_id = pizzas.pizza_id ;

# 3 Identify the highest-priced pizza with name and other details
select 
	* 
from 
	pizzas 
inner join 
	pizza_types
on 
	pizzas.pizza_type_id = pizza_types.pizza_type_id
order by 
	price desc 
limit 1;

# 4 Identify the most common pizza size ordered
SELECT 
    pizzas.size, 
    SUM(order_details.quantity) AS total_pizzas 
FROM 
    order_details 
INNER JOIN 
    pizzas 
ON 
    order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizzas.size
ORDER BY
    total_pizzas DESC
LIMIT 1;

# 5 List the top 5 most ordered pizza types along with their quantities
SELECT 
    pizza_types.name, pizza_types.category,
    SUM(order_details.quantity) AS total_orders
FROM
    order_details
INNER JOIN 
    pizzas
ON
    order_details.pizza_id = pizzas.pizza_id
INNER JOIN 
    pizza_types
ON
    pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY
    pizza_types.name, pizza_types.category
ORDER BY
    total_orders DESC
LIMIT 5;

###########################  intermediate  ##########################

# 1. Join the table to  Find total quantity of each pizza category ordered
SELECT 
    pizza_types.category, SUM(order_details.quantity) AS total_orders
FROM
    order_details
INNER JOIN 
    pizzas
ON
    order_details.pizza_id = pizzas.pizza_id
INNER JOIN 
    pizza_types
ON
    pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY
	pizza_types.category
ORDER BY
    total_orders DESC
;

# 2. Determine the Distribution of orders by hour of the day

SELECT 
    HOUR(time) AS Times, 
    COUNT(*) AS Orders
FROM 
    orders
GROUP BY 
    Times 
ORDER BY 
    Times;

# 3. join relevent tableto find the  Category-wise distribution of pizzas 

SELECT 
    pizza_types.category, 
    COUNT(orders.order_id) AS total_order
FROM 
    orders
INNER JOIN 
    order_details ON orders.order_id = order_details.order_id
INNER JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
INNER JOIN 
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizza_types.category; 
    
# 4. Group the orders by date and calculate the Average number of pizzas ordered per day
with a as(
select 
	 orders.date , sum(order_details.quantity) as total_QTY
from
	orders
inner join 
	order_details
on 
	orders.order_id = order_details.order_id
group by
	orders.date )
select round(avg(total_qty)) from a;
    
# 5. Determine the Top 3 most ordered pizza types based on revenue

select 
	pizza_types.name as Names, sum(order_details.quantity * pizzas.price ) as Revenue  
from
	order_details
inner join
	pizzas
on
	order_details.pizza_id = pizzas.pizza_id
inner join
	pizza_types
on 
	pizzas.pizza_type_id = pizza_types.pizza_type_id
group by
	Names
order by
	revenue desc 
limit 3 ;
 