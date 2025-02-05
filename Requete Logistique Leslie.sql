USE toys_and_models;

SELECT *
FROM products;

#Le stock des 5 produits les plus commandés
SELECT products.productCode, products.productName, sum(orderdetails.quantityOrdered) AS tot_ventes, products.quantityInStock
FROM orderdetails
INNER JOIN products 
ON orderdetails.productCode = products.productCode
GROUP BY products.productCode
ORDER BY tot_ventes desc
limit 5;

#Le délai moyen des livraisons
#délai moyen nécessaire entre le passage de la commande et sa réception par le client

SELECT orders.requiredDate, orders.shippedDate, (orders.requiredDate - orders.shippedDate) as average_shipping_time
FROM orders
ORDER BY average_shipping_time DESC
;

with kpi2_1 as
(SELECT orders.requiredDate, orders.shippedDate, (orders.requiredDate - orders.shippedDate) as average_shipping_time
FROM orders
ORDER BY average_shipping_time DESC
)
SELECT ROUND(AVG(orders.requiredDate - orders.shippedDate),0) AS average_shipping_time_average
FROM orders
;