SELECT firstName, lastName, title
FROM employee
LIMIT 5;

SELECT model, EngineType
FROM model
LIMIT 5;

-- see query for table 
SELECT sql
FROM sqlite_schema
WHERE name = 'employee';

-- Create a list of employees and their immediate managers
SELECT e.firstName || ' ' || e.lastName as 'Employee', 
e.title as 'Employee Title',
m.firstName || ' ' || m.lastName as 'Manager' 
FROM employee e
INNER JOIN employee m
WHERE e.managerId = m.employeeId;

-- Find salespeople who have zero sales
SELECT e.firstName || ' ' || e.lastName as 'Sales People With no Sales'
FROM employee e
LEFT join sales s
ON e.employeeId = s.employeeId
WHERE s.salesId IS NULL
AND e.title = 'Sales Person';

-- List all the customers and their sales, even if some data is gone
SELECT c.firstName, c.lastName, c.email, 
s.salesAmount, s.soldDate
FROM customer c
INNER JOIN sales s
ON c.customerId = s.customerId
UNION
SELECT c.firstName, c.lastName, c.email, s.salesAmount, s.soldDate
FROM customer c
LEFT JOIN sales s
ON c.customerId = s.customerId
WHERE s.salesId IS NULL
UNION
SELECT c.firstName, c.lastName, c.email, s.salesAmount, s.soldDate
FROM sales s
LEFT JOIN customer c
ON c.customerId = s.customerId
WHERE c.customerId IS NULL;

--Pull a report that totals the number of cars sold by each employee
SELECT s.employeeId, e.firstName, e.lastName, COUNT(s.employeeId) as 'Number of cars sold'
FROM sales s 
INNER JOIN employee e
ON s.employeeId = e.employeeId
GROUP BY s.employeeId;

--Produce a report that lists the least and most expensive car sold by each employee this year
SELECT e.employeeId, e.firstName, e.lastName, 
MAX(s.salesAmount) as 'Most expensive car sold', MIN(s.salesAmount) as 'Lease expensive car sold'
FROM employee e 
INNER JOIN sales s
ON e.employeeId = s.employeeId
WHERE s.soldDate >= date('now','start of year')
GROUP BY s.employeeId;

--List employees who have made more than 5 sales this year
SELECT e.employeeId, e.firstName, e.lastName, 
MAX(s.salesAmount) as 'Most expensive car sold', MIN(s.salesAmount) as 'Lease expensive car sold'
FROM employee e 
INNER JOIN sales s
ON e.employeeId = s.employeeId
WHERE s.soldDate >= date('now','start of year')  
GROUP BY s.employeeId
HAVING COUNT(*) > 5;

--Create a report showing the total sales per year
SELECT DISTINCT strftime('%Y', soldDate) as Year,
ROUND(SUM(salesAmount),2) as 'Total sales'
FROM sales
GROUP BY Year

--Find all sales where the car purchased was electric
SELECT s.salesId, s.salesAmount, s.soldDate, i.colour, i.year, m.model
FROM sales s
INNER JOIN inventory i
on s.inventoryId = i.inventoryId
INNER JOIN model m 
on i.modelId = m.modelId
WHERE m.EngineType = 'Electric';


