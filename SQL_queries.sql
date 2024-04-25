
---------------------------------------------------------------------------------
------------------------------------Feature Engineering---------------------------


-- Creat column time_of_date

select 
   time,
     (case 
     	when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
     end
     ) as Time_of_date
   from saleswalmart s 
   
   
alter table saleswalmart add column Time_of_date varchar(20)

#UPDATE COLUMN IN TABLE
update saleswalmart 
set Time_of_date =  (case 
     	when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
     end
     )

--- creat column day_name
select 
   date,
   Dayname(date)as day_name
  from saleswalmart s 

alter table saleswalmart add column day_name varchar(20)

update saleswalmart 
set day_name = DAYNAME(DATE)

--- creat column month_name
select 
   date,
   Monthname(date)as month_name
  from saleswalmart s 

alter table saleswalmart add column month_name varchar(20)

update saleswalmart 
set month_name = monthname(date) 

-----------------------Business Questions To Answer-------------

#How many unique cities does the data have?
select count(distinct city ) as Distinct_city from saleswalmart s 

#In which city is each branch?
select distinct city,branch from saleswalmart s 

----------------Product------------
#1. How many unique product lines does the data have?
select distinct `Product line`  from saleswalmart s 

#2. What is the most common payment method?
select Payment, count(payment)as most_common_payment  from saleswalmart s 
group by Payment 
order by most_common_payment desc limit 1
# => most_common_payment is Ewallet 
 
#3. What is the most selling product line?
SELECT
    `Product line` ,SUM(quantity) as qty
	FROM saleswalmart s 
GROUP BY `Product line` 
ORDER BY qty desc ;`
#productline and sum quanlity of productline

#4. What is the total revenue by month?
Select Month_name, sum(total) as Total_Revenue From saleswalmart s 
 group by month_name
 order by total_revenue 


#5. What month had the largest COGS? 
Select month_name, sum(cogs) as COGS from saleswalmart s 
group by month_name
order by COGS desc limit 1
=> January Had 110,759

#6. What product line had the largest revenue?
Select `Product line` , sum(total) as Total_Revenue 
From saleswalmart s 
GROUP BY `Product line` 
order by total_revenue desc limit 1
=> Food and beverages had 56,144.844


#7. What is the city with the largest revenue?
Select `city` , sum(total) as Total_Revenue 
 From saleswalmart s 
GROUP BY `city`
order by total_revenue desc limit 1
=> naypyitaw had 110,568.7065


#8. What product line had the largest VAT?

 Select `Product line`, avg(tax 5%) as VAT
From saleswalmart s 
 group by `Product line` 
 order by VAT desc 

#9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
#step 1 avg product line
  SELECT product line,
  SUM(total) AS sales,
        AVG(SUM(total)) AS avg_sales
    FROM saleswalmart
    GROUP BY product line
#step 2 add column
SELECT 
    *,
    CASE
        WHEN sales > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS Performance
FROM (
    SELECT
        product_line,
        SUM(total) AS sales,
        AVG(SUM(total))  AS avg_sales
    FROM saleswalmart
    GROUP BY product_line
) AS product_sales;
------------------
9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 sai đề vì tổng sale đâu so sánh vớ trung bình tổng sale 1 productline 
SELECT 
    *,
    CASE
        WHEN sales > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS Performance
FROM (
    SELECT
        product line,
        SUM(total) AS sales,
        AVG(SUM(total))  AS avg_sales
    FROM saleswalmart
    GROUP BY product line
) AS product_sales;


 SELECT
  `Product line`,
  SUM(total) AS sales,
  AVG(total) AS AVG_SALES
FROM
  saleswalmart
GROUP BY
  `Product line`;

#10. Which branch sold more products than average product sold?
select Branch,sum(Quantity) as sales, avg(Quantity) as AVG_Quanlity from saleswalmart s 
group by branch 
Having sum(quantity) > avg (quantity)

#11. What is the most common product line by gender? # count(gender) as total_gd là số lượng nam, nữ trong tưng product line
select `Product line`  , Gender, count(gender) as total_gd  from saleswalmart s 
group by `Product line`, Gender 
order  by count(gender) desc

#12. What is the average rating of each product line?
select `Product line` , round(AVG(Rating),2)  as AVG_rating from saleswalmart s 
group by `Product line`
order by AVG_rating desc  #round(AVG(Rating),2) rút gọn số thập phân
