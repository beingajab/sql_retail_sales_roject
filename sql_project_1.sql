--Sql Retail Analysis
CREATE Database sql_project_2
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
                     (
                           transactions_id INT PRIMARY KEY,
		                   sale_date DATE,
						   sale_time TIME, 
		                   customer_id INT,
		                   gender VARCHAR(15),
						   age int,
						   category varchar(15),
		                   quantiy INT,
		                   price_per_unit FLOAT,
		                   cogs FLOAT,
		                   total_sale FLOAT
                                        );
select * from retail_sales
--Data Cleaning
select COUNT(*) from retail_sales
select * from retail_sales
where transactions_id is NULL

select * from retail_sales
where sale_date is NULL

select * from retail_sales
where sale_time is NULL

select * from retail_sales
where customer_id is NULL

select * from retail_sales
where
gender is NULL
OR
age is NULL
or
category is null
or
quantity is null 
or price_per_unit is null 
or 
cogs is null 
or 
total_sale is null
ALTER TABLE retail_sales
RENAME COLUMN quantiy 
TO quantity

--data Exploration
-- How many sales we have?
select count(*) as total_sale From retail_sales

--How many unique customers do we have?
select count(DISTINCT customer_id) as total_sale From retail_sales

--How many categories do we have?
select count(DISTINCT category) as total_sale From retail_sales
select distinct category from retail_sales

-- Data Analysis Business KEY PROBLEMS 
--0.1 write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales 
where sale_date = '2022-11-05'

--
--0.2 Write a SQL query to retrieve all transactions where the category is 'Clothing" and quantitysold more than 4 the month of Nov-2022
select *
from retail_sales 
where category = 'Clothing'
AND  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and quantity >= 4
--0.3 write a SQL query to calculate the total sales (tatal sale) for each category,
select 
category, sum(total_sale)as net_sale,
count(*) as total_orders from retail_sales
group by 1

--0.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age),2) as avg_age from retail_sales where category = 'Beauty'

--Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000,
select * from retail_sales where total_sale > 1000;

--Q.6 write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender,
count(*) as total_trans from retail_sales 
group by category, gender
order by category

--0.7 write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year, month, avg_sale from 
(
select
extract(YEAR FROM sale_date) as year,
extract(MONTH FROM sale_date) as month,
avg(total_sale) as avg_sale,rank() over(partition by extract(YEAR FROM sale_date) order by avg(total_sale) desc) as rank
FROM retail_sales
GROUP BY year, month) as t1  where rank = 1
--order by year, avg_sale desc

--Q. Write a SQL query to find the tops customers based on the highest total sales
select customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id order by total_sale desc
limit 5;

--Q. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as unique_customers from retail_sales
group by category

--0.10 Write a SQL query to create each shift and number of orders (Example Horning 12, Afternoon Between 12 4 17. Evening 17)
with hourly_sale
as
(

select *,
  CASE 
  when extract(HOUR from sale_time) < 12 then 'Morning'
  when extract(HOUR from sale_time) between 12 AND 17  then 'Afternoon'
  else 'Evening'
end as shift
from retail_sales 
)
select shift,
count(*) as total_orders from hourly_sale
group by shift

--END OF PROJECT