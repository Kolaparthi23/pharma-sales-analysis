USE datamatrix_sales;

SELECT *
FROM `pharma-data`;

       # data exploriaratin and data cleaning
----- just to understand the data --------
select distinct(count(distributor))FROM `pharma-data`;
select count(distributor)FROM `pharma-data`;

----------- to know the null_values exist --------
select quantity,price,sales,distributor,price 
FROM `pharma-data`
where quantity is null or price is null or sales is null or distributor is null or price is null;

---------- identifying the duplicates ----------
WITH rank_data AS (
    SELECT
        `distributor`,
        `customer name`,
        `city`,
        `country`,
        `channel`,
        `product name`,
        `product class`,
        ROW_NUMBER() OVER (
            PARTITION BY 
                `distributor`,
                `customer name`,
                `city`,
                `country`,
                `channel`,
                `product name`,
                `product class`
            ORDER BY `distributor`
        ) AS row_num
    FROM `pharma-data`
)
select 
    `distributor`,
    `product name`,
    COUNT(*) AS duplicate_count
FROM rank_data
WHERE row_num > 1
GROUP BY `distributor`, `product name`
ORDER BY duplicate_count DESC;

------ Rename the column-------
alter table `pharma-data`
rename column `customer name` to customer_name,
rename column `Sub-channel` to sub_channel,
rename column `Product Name` to product_name,
rename column `Product Class` to product_class,
rename column `Name of Sales Rep` to Name_of_Sales_Rep,
rename column `Sales Team` to Sales_Team;


---- monthly sales of company --------
select year,Month,city, channel,count(*),sum(sales) as overall_sales
from `pharma-data`
group by year,Month,city, channel
order by overall_sales desc;

select product_name,product_class,customer_name, city,sum(sales) as overall_sales
from `pharma-data`
group by product_name,product_class,customer_name,city
order by overall_sales desc;
-------- top product class name ----------
select product_class,sum(sales) as sal
from `pharma-data`
group by product_class
order by sal desc;
-------- top product name by sales ----------
select product_name,sum(sales) as sal
from `pharma-data`
group by product_name
order by sal desc;
----------- top custometer city by sales -------------
select city,sum(sales) as sal
from `pharma-data`
group by city
order by sal desc;
--------- overview of sales by distributor and product name ----------------
select Distributor,product_name,sum(sales)as sum_of_sales, avg(Sales) as average_sales,count(sales) 
from `pharma-data`
group by distributor,product_name
order by average_sales desc;

SELECT
    Distributor,
    product_name,

    SUM(
        CASE 
            WHEN sales < 0 THEN sales
            ELSE 0
        END
    ) AS negative_sales,

    SUM(
        CASE 
            WHEN sales > 0 THEN sales
            ELSE 0
        END
    ) AS positive_sales,

    SUM(sales) AS net_sales
FROM `pharma-data`
GROUP BY Distributor, product_name
order by negative_sales asc;
-------- top 5 products ----------
select product_name ,sum(sales) as sal
from `pharma-data`
group by product_name
order by sal desc
limit 5;
-------- top 5 customers ---------------
select customer_name ,sum(sales) as sal
from `pharma-data`
group by customer_name
order by sal desc
limit 5;
------------- top 5 cities ---------------
select city,sum(sales) as sal
from `pharma-data`
group by city
order by sal desc
limit 5;
----------- slaes spilt by channel and sub channel----------
select channel,sub_channel ,sum(sales) as sal
from `pharma-data`
group by channel,sub_channel
order by sal desc;
---------- sales by sales team and product split ---------
select sales_team,product_name,sum(sales) as sal
from `pharma-data`
group by sales_team,product_name
order by sal desc;
-------- sales by sales team and product_class split ---
select sales_team,product_class,sum(sales) as sal
from `pharma-data`
group by sales_team,product_class
order by sal desc;
------- top sales manager -------
select sales_team,manager,sum(sales) as sal
from `pharma-data`
group by sales_team,manager
order by sal desc
limit 5;
--------- top sales rep ------
select name_of_sales_rep,sales_team ,sum(sales) as sal
from `pharma-data`
group by name_of_sales_rep,sales_team
order by sal desc
limit 5;
------------ Top product split by sales team contributions---------------
select product_class ,sales_team ,sum(sales) as sal
from `pharma-data`
group by product_class,sales_team
order by sal desc
limit 5;
