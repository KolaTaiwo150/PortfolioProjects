use restaurant_db;

-- 1. View the menu_items table.

SELECT 
    *
FROM
    menu_items;

-- 2. Find the number of items on the menu.

SELECT 
    COUNT(*) AS 'No. of items'
FROM
    menu_items;

-- 3. What are the least and most expensive items on the menu?

SELECT 
    *
FROM
    menu_items
ORDER BY price ASC;

SELECT 
    *
FROM
    menu_items
ORDER BY price DESC;

-- 4. How many Italian dishes are on the menu?

SELECT 
    COUNT(*) AS 'No. of Italian Items'
FROM
    menu_items
WHERE
    category = 'Italian';

-- 5. What are the least and most expenive Italian dishes on the menu?

SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price ASC;

SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price DESC;

-- 6. How many dishes are in each category?

SELECT 
    category, COUNT(menu_item_id) AS 'No. of dishes'
FROM
    menu_items
GROUP BY category
ORDER BY COUNT(menu_item_id) DESC;

-- 7. What is the avergae dish price within each category?

SELECT 
    category, ROUND(AVG(price), 2) AS 'Average price'
FROM
    menu_items
GROUP BY category
ORDER BY AVG(price) DESC;

-- 8. View the order_details table.

SELECT 
    *
FROM
    order_details;

-- 9. What is the date range of the table?

SELECT 
    MIN(order_date), MAX(order_date)
FROM
    order_details;

-- 10. How many orders were made within this date range?

SELECT 
    COUNT(DISTINCT order_id) AS 'No. of orders'
FROM
    order_details;

-- 11. How many items were ordered within this date range?

SELECT 
    COUNT(order_details_id) AS 'No. of items ordered'
FROM
    order_details;

-- 12. WHich orders had the most numer of items?

SELECT 
    order_id AS 'Order',
    COUNT(item_id) AS 'No. of items'
FROM
    order_details
GROUP BY order_id
ORDER BY COUNT(item_id) DESC;

-- 13. How many orders had more than 12 items?

SELECT 
    COUNT(*) AS 'No. of Orders w/ 12+ items'
FROM
    (SELECT 
        order_id AS 'Order', COUNT(item_id) AS 'No. of items'
    FROM
        order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12) AS num_orders;
    
-- 14. Combine the menu_items and order_details tables into a single table.

SELECT 
    *
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id;

-- 15. What were the least and most ordered items? What categories were they in?

SELECT 
    item_name,
    category,
    COUNT(order_details_id) AS num_purchases
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_name , category
ORDER BY COUNT(order_details_id) DESC;

-- 16. What were the top 5 orders that spent the most money?

SELECT 
    order_id AS 'Order', SUM(price) AS 'Total Price'
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY SUM(price) DESC
LIMIT 5;

-- 17. View the details of the highest spend order. What insights can you gather? 

SELECT 
    category, COUNT(item_id) AS 'No. of Items'
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
WHERE
    order_id = 440
GROUP BY category
ORDER BY 2 DESC;

-- 18. View the details of the top 5 highest spend orders. What insights can you gather? 

SELECT 
    order_id, category, COUNT(item_id) AS 'No. of Items'
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
WHERE
    order_id IN (440 , 2075, 1957, 330, 2675)
GROUP BY order_id , category
ORDER BY 1 , 3 DESC;