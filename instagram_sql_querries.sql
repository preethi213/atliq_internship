-- How many unique post types are found in the 'fact_content' table? 
SELECT distinct(post_type) FROM gdb0120.fact_content;
SELECT count(distinct((post_type))) FROM gdb0120.fact_content;


-- What are the highest and lowest recorded impressions for each post type? 
SELECT POST_TYPE , MAX(IMPRESSIONS) AS HIGHEST_IMPRESSION , MIN(IMPRESSIONS) AS LOWEST_IMPRESSION FROM FACT_CONTENT GROUP BY POST_TYPE;



-- Filter all the posts that were published on a weekend in the month of March and April and export them to a separate csv file. 
SELECT distinct(post_type) , MONTH_NAME , WEEKDAY_or_weekend  FROM FACT_CONTENT 
LEFT JOIN DIM_DATES USING(DATE)
WHERE MONTH_NAME IN ('March','April') AND  WEEKDAY_or_weekend = 'Weekend'
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/weekend_posts_march_april.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE 'secure_file_priv';



/*Create a report to get the statistics for the account. The final output 
includes the following fields: 
• month_name 
• total_profile_visits 
• total_new_followers */

SELECT MONTH_NAME , SUM(PROFILE_VISITS) AS TOTAL_PROFILE_VISITS , SUM(NEW_FOLLOWERS) AS TOTAL_NEW_FOLLOWERS FROM FACT_ACCOUNT
LEFT JOIN DIM_DATES USING (DATE)
GROUP BY(MONTH_NAME);



/*Write a CTE that calculates the total number of 'likes’ for each 
'post_category' during the month of 'July' and subsequently, arrange the 
'post_category' values in descending order according to their total likes.*/

with cte1 as (SELECT POST_CATEGORY ,SUM(LIKES) AS TOTAL_LIKES FROM FACT_CONTENT
LEFT JOIN DIM_DATES USING(DATE)
WHERE MONTH_NAME = 'JULY'
GROUP BY (POST_CATEGORY) ) 
SELECT * FROM CTE1 
ORDER BY TOTAL_LIKES  DESC ;



/*Create a report that displays the unique post_category names alongside 
their respective counts for each month. The output should have three 
columns:  
• month_name 
• post_category_names  
• post_category_count*/


SELECT 
    MONTH_NAME, 
    GROUP_CONCAT(DISTINCT POST_CATEGORY ORDER BY POST_CATEGORY SEPARATOR ', ') AS post_category_names, 
    COUNT(DISTINCT POST_CATEGORY) AS post_category_count
FROM FACT_CONTENT 
LEFT JOIN DIM_DATES USING(DATE)
GROUP BY MONTH_NAME
ORDER BY FIELD(MONTH_NAME, 'January', 'February', 'March', 'April', 'May', 'June', 
                           'July', 'August', 'September', 'October', 'November', 'December');



/*What is the percentage breakdown of total reach by post type?  The final 
output includes the following fields: 
• post_type 
• total_reach 
• reach_percentage */

WITH CTE1 AS(
SELECT POST_TYPE, SUM(REACH) AS TOTAL_REACH
FROM FACT_CONTENT
GROUP BY POST_TYPE)
SELECT POST_TYPE, TOTAL_REACH , ROUND((TOTAL_REACH/(SELECT SUM(TOTAL_REACH) FROM CTE1 ))* 100,2) AS REACH_PERCENTAGE
FROM CTE1;



/*Create a report that includes the quarter, total comments, and total 
saves recorded for each post category. Assign the following quarter 
groupings: 
(January, February, March) → “Q1” 
(April, May, June) → “Q2” 
(July, August, September) → “Q3” */

ALTER TABLE gdb0120.dim_dates
ADD COLUMN quarter VARCHAR(2) GENERATED ALWAYS AS (
    CASE
        WHEN MONTH_NAME IN ('January', 'February', 'March') THEN 'Q1'
        WHEN MONTH_NAME IN ('April', 'May', 'June') THEN 'Q2'
        WHEN MONTH_NAME IN ('July', 'August', 'September') THEN 'Q3'
        ELSE 'Unknown'
    END
) VIRTUAL;
    
SELECT POST_CATEGORY, QUARTER , SUM(COMMENTS) AS TOTAL_COMMENTS, SUM(SAVES) AS TOTAL_SAVES FROM FACT_CONTENT
LEFT JOIN DIM_DATES USING(DATE)
GROUP BY POST_CATEGORY,QUARTER;


/*List the top three dates in each month with the highest number of new 
followers. The final output should include the following columns: 
• month 
• date 
• new_followers*/

WITH CTE AS (
    SELECT 
        MONTH_NAME,
        DATE,
        NEW_FOLLOWERS,
        ROW_NUMBER() OVER (PARTITION BY MONTH_NAME ORDER BY NEW_FOLLOWERS DESC) AS row_num
    FROM fact_account
    LEFT JOIN DIM_DATES USING(DATE)
)
SELECT 
    month_name,
    DATE,
    NEW_FOLLOWERS
FROM CTE
WHERE row_num <= 3
ORDER BY MONTH_NAME, row_num;



/*Create a stored procedure that takes the 'Week_no' as input and 
generates a report displaying the total shares for each 'Post_type'. The 
output of the procedure should consist of two columns: 
• post_type 
• total_shares*/

DELIMITER $$

CREATE PROCEDURE GetTotalSharesByWeek(IN week_no INT)
BEGIN
    SELECT 
        POST_TYPE, 
        SUM(SHARES) AS total_shares
    FROM FACT_CONTENT
    LEFT JOIN DIM_DATES USING(DATE)
    WHERE WEEK(DATE) = week_no
    GROUP BY POST_TYPE;GetTotalSharesByWeek
END $$

DELIMITER ;








