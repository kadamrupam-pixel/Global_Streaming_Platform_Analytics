create database if not exists Global_Streaming_Platform_Analyticss;

use Global_Streaming_Platform_Analyticss;

-- ------------------------------------------------------------------------------
-- Task 1: Schema Initialization and Data Generation
-- ------------------------------------------------------------------------------

CREATE TABLE subscribers (
    subscriber_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    plan_type VARCHAR(10),
    cancel_date DATE
);

CREATE TABLE content (
    content_id INT PRIMARY KEY,
    title VARCHAR(100),
    type VARCHAR(10),
    genre VARCHAR(10)
);

CREATE TABLE watch_logs (
    log_id INT PRIMARY KEY,
    subscriber_id INT,
    FOREIGN KEY (subscriber_id)
        REFERENCES subscribers (subscriber_id),
    content_id INT,
    FOREIGN KEY (content_id)
        REFERENCES content (content_id),
    watch_date DATE,
    minutes_watched INT,
    rating INT
);

insert into subscribers values
(101, 'Kiran Rao', 'Premium', NULL),
(102, 'John Doe', 'Basic', '2025-11-01'),
(103, 'Sanya Mirza', 'Premium', NULL),
(104, 'Alex Smith', 'Basic', NULL);

alter table content modify genre VARCHAR(20);

insert into content values
(201, 'Stranger Things', 'Series', 'Sci-Fi'),
(202, 'The Crown', 'Series', 'Drama'),
(203, 'Inception', 'Movie', 'Sci-Fi'),
(204, 'Planet Earth', 'Series', 'Documentary');

insert into watch_logs values
(301, 101, 201, '2026-01-15', 120, 5),
(302, 102, 203, '2026-01-16', 45, NULL),
(303, 101, 203, '2026-01-20', 148, 4),
(304, 103, 202, '2026-02-05', 300, 5),
(305, 104, 204, '2026-02-10', 60, NULL),
(306, 101, 204, '2026-02-15', 90, 3),
(307, 103, 201, '2026-03-01', 200, NULL);

-- ------------------------------------------------------------------------------
-- Task 2: The Engagement Report
-- Calculates the total number of minutes watched for active subscribers.
-- Filters for users with strictly > 100 total minutes of watch time.
-- ------------------------------------------------------------------------------

SELECT 
    s.full_name, SUM(w.minutes_watched) AS total_watch_time
FROM
    subscribers s
        INNER JOIN
    watch_logs w ON s.subscriber_id = w.subscriber_id
WHERE
    cancel_date IS NULL
GROUP BY full_name
HAVING total_watch_time > 100
ORDER BY total_watch_time DESC;

-- ------------------------------------------------------------------------------
-- Task 3: The Content Audit
-- Identifies critical subscribers who have never given a '5' star rating.
-- Utilizes a correlated NOT EXISTS subquery for optimized exclusion filtering.
-- ------------------------------------------------------------------------------

SELECT 
    full_name
FROM
    subscribers
WHERE
    subscriber_id NOT IN (SELECT 
            subscriber_id
        FROM
            watch_logs
        WHERE
            rating = 5);
            
-- ------------------------------------------------------------------------------
-- Task 4: The Genre Leaderboards
-- Determines the single most-watched piece of content within each genre.
-- Utilizes a CTE, JOINs, and DENSE_RANK() Window Function for category ranking.
-- ------------------------------------------------------------------------------

with genre_lead as(
select c.genre,
c.title,
sum(w.minutes_watched) as total_minutes,
dense_rank() over(partition by c.genre order by sum(w.minutes_watched) desc) as genre_rank
from content c
inner join watch_logs w
on c.content_id=w.content_id
group by genre,title)
select genre,
title,
total_minutes
from genre_lead
where genre_rank=1;