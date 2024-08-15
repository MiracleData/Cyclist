--  Creation of Schema
CREATE SCHEMA cyclist;
USE cyclist;

-- Checking the structure of our dataset
SHOW COLUMNS FROM cyclist;
SELECT * FROM cyclist LIMIT 10;

-- Modifying data type
ALTER TABLE cyclist
ADD COLUMN start_date DATE;

UPDATE cyclist
SET start_date = DATE(SUBSTRING_INDEX(start_time, ' UTC', 1));

UPDATE cyclist
SET start_time = CONCAT(TIME(SUBSTRING_INDEX(start_time, ' UTC', 1)), ' UTC');

-- Data Cleaning; Checking for missing values
SELECT 
    SUM(CASE WHEN trip_id IS NULL THEN 1 ELSE 0 END) AS missing_trip_id,
    SUM(CASE WHEN subscriber_type IS NULL THEN 1 ELSE 0 END) AS missing_subscriber_type,
    SUM(CASE WHEN bikeid IS NULL THEN 1 ELSE 0 END) AS missing_bikeid,
    SUM(CASE WHEN start_time IS NULL THEN 1 ELSE 0 END) AS missing_start_time,
    SUM(CASE WHEN start_station_id IS NULL THEN 1 ELSE 0 END) AS missing_start_station_id,
    SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS missing_start_station_name,
    SUM(CASE WHEN end_station_id IS NULL THEN 1 ELSE 0 END) AS missing_end_station_id,
    SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS missing_end_station_name,
    SUM(CASE WHEN duration_minutes IS NULL THEN 1 ELSE 0 END) AS missing_duration_minutes
FROM cyclist;

-- Checking for duplicates
SELECT trip_id, COUNT(*) 
FROM cyclist
GROUP BY trip_id
HAVING COUNT(*) > 1;

-- Checking data consistencies
SELECT * 
FROM cyclist 
WHERE duration_minutes < 0;

-- On which day of the week do we on average have the longest trip?
SELECT DAYOFWEEK(start_date) AS day_of_week, AVG(duration_minutes) AS average_trip_duration
FROM cyclist
GROUP BY day_of_week
ORDER BY average_trip_duration DESC;
-- The day of the week with the longest average trip duration is Sunday, with an average duration of 78.0581 minutes.


-- What month/year has the most bike trips and what is the count of the trips?  
SELECT DATE_FORMAT(start_date, '%Y-%m') AS month_year, COUNT(*) AS trip_count
FROM cyclist
GROUP BY month_year
ORDER BY trip_count DESC
LIMIT 1;
-- The month/year with the most bike trips is September 2020, with a total of 496 trips.


-- Identify the peak hour(s) of the day when the highest number of trips start. 
SELECT HOUR(start_time) AS hour_of_day, COUNT(*) AS trip_count
FROM cyclist
GROUP BY hour_of_day
ORDER BY trip_count DESC
LIMIT 1;
-- The peak hour with the highest number of trips is the 19th hour on average.


-- How does this vary between weekdays and weekends? 
-- Analyzing peak hours for weekdays 
SELECT 
    'Weekday' AS day_type,
    HOUR(start_time) AS hour_of_day,
    COUNT(*) AS trip_count
FROM 
    cyclist
WHERE 
    WEEKDAY(start_date) < 5
GROUP BY 
    hour_of_day
ORDER BY 
    trip_count DESC
LIMIT 1;
-- During weekdays, the peak hour is the 19th hour with 380 trips.


-- Analyzing peak hours for weekends
SELECT 
    'Weekend' AS day_type,
    HOUR(start_time) AS hour_of_day,
    COUNT(*) AS trip_count
FROM 
    cyclist
WHERE 
    WEEKDAY(start_date) >= 5
GROUP BY 
    hour_of_day
ORDER BY 
    trip_count DESC
LIMIT 1;
-- On weekends, the peak hour is the 12th hour with 203 trips.

