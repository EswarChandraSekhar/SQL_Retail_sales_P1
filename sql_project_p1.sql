-- Retail Sales Analysis -Project 1

-- Create Table
DROP TABLE IF EXISTS retail_sales;
Create table retail_sales 
		(
		  transactions_id	INT PRIMARY KEY,
		  sale_date	DATE,
		  sale_time TIME,
		  customer_id	INT,
		  gender VARCHAR(15),
		  age INT,
		  category VARCHAR(15),
		  quantiy	INT,
		  price_per_unit FLOAT,
		  cogs FLOAT,
		  total_sale FLOAT
		);

select * from retail_sales
limit 10;

select 
	count(*)
from retail_sales;

-- DAta Cleaning

select * from retail_sales
where 
	transactions_id is NULL
	or 
	sale_date is NULl
	or
	sale_time is NULL
	or 
	customer_id is NULL
	or 
	gender is NULL
	or
	age is NULL
	or 
	category is NULL 
	or 
	quantiy is NULL
	or
	price_per_unit is NULL
	or 
	cogs is NULL
	or 
	total_sale is NULL;
	
Delete from retail_sales
where 
	transactions_id is NULL
	or 
	sale_date is NULl
	or
	sale_time is NULL
	or 
	customer_id is NULL
	or 
	gender is NULL
	or
	age is NULL
	or 
	category is NULL 
	or 
	quantiy is NULL
	or
	price_per_unit is NULL
	or 
	cogs is NULL
	or 
	total_sale is NULL;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sales from retail_sales

-- How many unique customers we have?
select count(distinct customer_id) as unique_cust from retail_sales

-- What unique categiries we have?
select distinct category as unique_cat from retail_sales

--Data Analysis & Business Key problems & answers

-- Q.1 Write a sql query to retrieve all columns for sales made on '2022-11-05'
select *
from retail_sales
where sale_date = '2022-11-05'

--Q.2 Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in month of nov-2022

select 
	*
	from retail_sales
	where
		category = 'Clothing'
		and 
		to_char(sale_date, 'YYYY-MM') = '2022-11'
		and 
		quantiy >= 4
-- Q.3 Write a sql query to calculate the total sales for each category	
select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1

-- Q.4 Write a sql query to calculate the total aveerage of customers who purchased items fromm the 'Beauty category.'
select 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a sql query to find all transactions where the total_sale is greater than 10000.
select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by category, gender
order by 1

-- Q.7 Write a sql query to calculate the average sales for each month. find out best selling month in each year
select 
	year, month, avg_sale
from
(
	select 
		Extract(year from sale_date) as year,
		Extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(PARTITION by Extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
) as t1
where rank = 1;

select * from retail_sales

-- Q.8 Write a sql query to find the top 5 customers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a sql query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id) as uique_customers
from retail_sales
group by category

-- Q.10 Write a sql query to create each shift and number of orders (example morning < 12, afternoon between 12 & 17, evening > 17).
with hourly_sales as 
(
select *,
		case
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift
from retail_sales
)
select shift,
		count(*)
from hourly_sales
group by shift

-- End of Project--




