create database Retail_analysis;


//*Which factors contribute to the highest sales in a particular region?"*/

SELECT 
    c.country,
    c.city,
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
JOIN products_3 p 
    ON od.productCode = p.productCode
JOIN productlines_3 pl 
    ON p.productLine = pl.productLine
GROUP BY c.country, c.city, pl.productLine
ORDER BY total_sales DESC;


//*How can customer purchasing patterns be influenced to increase average order value?*/

SELECT 
    c.country,
    ROUND(
        SUM(od.quantityOrdered * od.priceEach) 
        / COUNT(DISTINCT o.orderNumber), 2
    ) AS avg_order_value
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
GROUP BY c.country
ORDER BY avg_order_value DESC;


//*What are the key drivers of sales growth, and how can they be leveraged for future success?*/

SELECT 
    YEAR(o.orderDate) AS order_year,
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS yearly_sales
FROM orders_3 o
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
JOIN products_3 p 
    ON od.productCode = p.productCode
JOIN productlines_3 pl 
    ON p.productLine = pl.productLine
GROUP BY order_year, pl.productLine
ORDER BY order_year, yearly_sales DESC;


//*Which product features or attributes are most appealing to customers?*/
 
 
 SELECT 
    p.productLine,
    SUM(od.quantityOrdered) AS total_units_sold,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM products_3 p
JOIN orderdetails_3 od 
    ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY total_revenue DESC;

5.How can the product mix be optimized to cater to changing market demands?;

SELECT 
    pl.productLine,
    ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS sales,
    ROUND(
        SUM(od.quantityOrdered * od.priceEach) * 100.0 /
        (SELECT SUM(quantityOrdered * priceEach) FROM orderdetails_3),
        2
    ) AS sales_percentage
FROM productlines_3 pl
JOIN products_3 p 
    ON pl.productLine = p.productLine
JOIN orderdetails_3 od 
    ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY sales_percentage DESC;

6.Are there any specific market segments where a particular product is underperforming, and how can it be improved?;

SELECT 
    c.country,
    p.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
JOIN products_3 p 
    ON od.productCode = p.productCode
GROUP BY c.country, p.productLine
HAVING total_sales < 50000
ORDER BY total_sales;


//***What are the main factors that influence customer loyalty and repeat purchases?***/

SELECT 
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS total_orders,
    SUM(od.quantityOrdered * od.priceEach) AS lifetime_value
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName
HAVING COUNT(o.orderNumber) > 5
ORDER BY lifetime_value DESC;




//***How do customer preferences differ based on geographic location, and how can marketing campaigns be customized accordingly?**/

SELECT 
    c.country,
    p.productLine,
    SUM(od.quantityOrdered) AS units_sold
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
JOIN products_3 p 
    ON od.productCode = p.productCode
GROUP BY c.country, p.productLine
ORDER BY c.country, units_sold DESC;


//***What are the characteristics of high-value customers, and how can similar customers be targeted for acquisition?**/

SELECT 
    country,
    COUNT(customerNumber) AS high_value_customers,
    AVG(total_spent) AS avg_spend
FROM (
    SELECT 
        c.customerNumber,
        c.country,
        SUM(od.quantityOrdered * od.priceEach) AS total_spent
    FROM customers_3 c
    JOIN orders_3 o 
        ON c.customerNumber = o.customerNumber
    JOIN orderdetails_3 od 
        ON o.orderNumber = od.orderNumber
    GROUP BY c.customerNumber, c.country
) t
WHERE total_spent > 100000
GROUP BY country;


//***How can marketing strategies be tailored to target specific demographic segments in different regions?***/

SELECT 
    country,
    AVG(creditLimit) AS avg_credit_limit,
    COUNT(customerNumber) AS customer_count
FROM customers_3
GROUP BY country
ORDER BY avg_credit_limit DESC;


//***What are the potential untapped markets based on demographic indicators, and how can market penetration be increased?**/

SELECT 
    country,
    COUNT(customerNumber) AS customer_count
FROM customers_3
GROUP BY country
HAVING COUNT(customerNumber) < 5
ORDER BY customer_count;


//***How do customer preferences and behavior differ based on demographic factors, and how can they be leveraged for personalized marketing campaigns?**/

SELECT 
    c.country,
    pl.productLine,
    COUNT(DISTINCT c.customerNumber) AS customers,
    SUM(od.quantityOrdered * od.priceEach) AS sales
FROM customers_3 c
JOIN orders_3 o 
    ON c.customerNumber = o.customerNumber
JOIN orderdetails_3 od 
    ON o.orderNumber = od.orderNumber
JOIN products_3 p 
    ON od.productCode = p.productCode
JOIN productlines_3 pl 
    ON p.productLine = pl.productLine
GROUP BY c.country, pl.productLine
ORDER BY sales DESC;


