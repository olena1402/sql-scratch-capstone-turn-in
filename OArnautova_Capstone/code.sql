--1
-- Get number of the campaigns 
SELECT 
  COUNT(DISTINCT utm_campaign) AS 'Number of campaigns'
FROM page_visits;

-- Get number of the sources
SELECT
  COUNT(DISTINCT utm_source) AS 'Number of sources'
FROM page_visits;

-- Relationship between the campaigns and the sources
SELECT
  DISTINCT utm_campaign AS 'Campaigns',
  utm_source AS 'Sources'
FROM page_visits
ORDER BY utm_campaign;

--2
-- Get names of the website's pages
  
SELECT DISTINCT page_name AS 'Names of pages'
FROM page_visits;

--3
-- Count first touches for each campaign
-- Create temporary table first_touch to find all first touches for every user

WITH first_touch AS (
    SELECT user_id, MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    
-- Create temporary table ft_attr to add extra info (source and campaign) by 
-- joinig 2 tables: first_touch and page_visits
    
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)

-- Count first touches for each campaign

SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Number'
FROM ft_attr
GROUP BY ft_attr.utm_source, ft_attr.utm_campaign
ORDER BY COUNT(*) DESC;
    
--4
-- Count last touches for each campaign
-- Create temporary table last_touch to find all last touches for every user

WITH last_touch AS (
  SELECT user_id, 
  MAX(timestamp) AS last_touch_at
  FROM page_visits
GROUP BY user_id),

-- Create temporary table lt_attr to add extra info (source and campaign) by 
-- joining 2 tables: last_touch and page_visits

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

-- Count last touches for each campaign

SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Number'
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;

--5
-- Using COUNT and DISTINCT to count Visitors that made a purchase

SELECT COUNT(DISTINCT user_id) AS 'Visitors that made a purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

--6
-- Count last touches for the purchase page
-- Create temporary table last_touch to find all last touches for every user

WITH last_touch AS (
  SELECT user_id, 
  MAX(timestamp) AS last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
  
-- Create temporary table lt_attr to add extra info (source and campaign) by 
-- joining 2 tables: last_touch and page_visits
  
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

-- Count last touches for the purchase page

SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Number'
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;
