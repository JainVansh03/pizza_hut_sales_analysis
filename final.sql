show databases;
use pizza_hut;
show tables;
-- total number of order placed ?

SELECT count(order_id) as total_orders from orders;

-- Calculate total revenue generated from pizza sales ?

SELECT
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        INNER JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
    
-- Identify the highest priced pizza ?
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Most common pizza size ordered ?
SELECT 
    pizzas.size, SUM(order_details.quantity) AS total_quantity
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY total_quantity DESC
LIMIT 1;


-- most ordered pizza with quantity ?
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS Ordered
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Ordered DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered ?

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_ordered
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY total_ordered DESC;

-- Determine the distribution of orders by hour of the day ?

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS total_order
FROM
    orders
GROUP BY hour
ORDER BY total_order DESC;

-- Join relevant tables to find the category-wise distribution of pizzas ?

SELECT 
    category, COUNT(name) AS count
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day ?

SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date AS day, SUM(quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY day) AS order_quantity;

Determine the top 3 most ordered pizza types based on revenue ?
select pizza_types.category, round(sum(quantity * price),2) as total_revenue from pizza_types join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id join order_details on pizzas.pizza_id = order_details.pizza_id group by category order by total_revenue desc;

-- Calculate the percentage contribution of each pizza type to total revenue ?
SELECT 
    pizza_types.category,
    ((SUM(order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2)
        FROM
            order_details
                INNER JOIN
            pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100) AS sold
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category;

-- Analyze the cumulative revenue generated over time ?

select order_date, sum(sold) over(order by order_date) from (select orders.order_date, sum(pizzas.price * order_details.quantity) as sold from orders join order_details on order_details.order_id = orders.order_id join pizzas on pizzas.pizza_id = order_details.pizza_id group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category ?
-- want name and category

select category, name, revenue, ranking from (select category, name, revenue, rank() over(partition by category order by revenue desc) as ranking from (select pizza_types.category, pizza_types.name, sum(pizzas.price*order_details.quantity) as revenue from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details on order_details.pizza_id = pizzas.pizza_id group by pizza_types.category, pizza_types.name) as pizza) as pizza1 where ranking <=3;

































