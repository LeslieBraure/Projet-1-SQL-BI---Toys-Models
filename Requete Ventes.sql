USE toys_and_models;

#Ventes : Le nombre de produits vendus par catégorie et par mois, avec comparaison et taux de variation par rapport au même mois de l’année précédente

WITH ludokpi1 as
(SELECT p.productLine, MONTH(o.orderDate), YEAR(o.orderDate), SUM(od.quantityOrdered) as qte,
		LAG(SUM(od.quantityOrdered)) OVER (PARTITION BY p.productLine, MONTH(o.orderDate) ORDER BY YEAR(o.orderDate)) AS qte_prec,
        SUM(od.quantityOrdered) - LAG(SUM(od.quantityOrdered)) OVER (PARTITION BY productLine, MONTH(o.orderDate) ORDER BY YEAR(o.orderDate)) as ecart
FROM orderdetails od
JOIN products p ON p.productCode = od.productCode
JOIN orders o ON o.orderNumber = od.orderNumber
GROUP BY YEAR(o.orderDate), MONTH(o.orderDate), p.productLine
ORDER BY p.productLine, MONTH(o.orderDate), YEAR(o.orderDate))
SELECT *, ecart/qte_prec as variat
FROM ludokpi1;

#KPI numéro 2: Le stock des 5 produits les moins commandés
SELECT products.productCode, products.productName, sum(orderdetails.quantityOrdered) AS tot_ventes, products.quantityInStock
FROM orderdetails
INNER JOIN products 
ON orderdetails.productCode = products.productCode
GROUP BY products.productCode
ORDER BY tot_ventes asc
limit 5;
