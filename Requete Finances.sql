USE toys_and_models;

#Finances :
#Le chiffre d’affaires des commandes des deux derniers mois par pays.
#Les commandes qui n’ont pas encore été payées.

With CTE as
(
SELECT customers.customerNumber, customers.customerName, customers.country, YEAR(o.orderDate) AS annee, MONTH(o.orderDate) AS mois,
SUM(od.quantityOrdered * od.priceEach) AS total_ca,
RANK() OVER(PARTITION BY YEAR(o.orderDate), MONTH(o.orderDate) ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS Classement
from customers
join orders as o
	on customers.customerNumber = o.customerNumber
join orderdetails as od
	on od.orderNumber = o.orderNumber
WHERE year(orderdate) = 2024 and (month(orderdate) < 4)
GROUP BY customers.customerNumber, annee, mois
ORDER BY annee desc, mois desc)
SELECT country, annee, mois, sum(total_ca)
from CTE
GROUP BY country, annee, mois
ORDER BY annee, mois ;

#KPI numéro 2
#On veut comparer ce qu'on a facturé à nos clients par rapport à ce qu'ils ont payé

WITH Tot_paiments AS
(Select customers.customerName, customers.customerNumber, sum(amount) as Tot_Paiments, customers.creditLimit
from customers
join payments
	on customers.customerNumber = payments.customerNumber
GROUP BY customers.customerNumber),
Tot_CA as
(Select customers.customerName, customers.customerNumber, sum(od.quantityOrdered*od.priceEach) as totCA
from customers
join orders
	on customers.customerNumber = orders.customerNumber
join orderdetails as od
	on od.orderNumber = orders.orderNumber
GROUP BY customers.customerNumber)
SELECT customers.customerName, customers.customerNumber, Tot_paiments, totCA, (totCA-Tot_paiments) AS Dette, customers.creditLimit, round(((totCA-Tot_paiments)/customers.creditLimit*100),2) AS Tx_util_Credit
FROM customers
join Tot_CA on Tot_CA.customerNumber = customers.customerNumber
join Tot_paiments on Tot_paiments.customerNumber = customers.customerNumber
WHERE (totCA-Tot_paiments) !=0
ORDER BY Dette DESC;
