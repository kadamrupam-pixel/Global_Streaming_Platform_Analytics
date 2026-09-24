# StreamMetrics: Streaming Platform Analytics Engine

## Project Overview
This project simulates the core relational database of a global streaming platform. The objective is to analyze subscriber engagement, audit content ratings, and dynamically rank digital assets to drive acquisition strategies. 

## Database Architecture
The database was modeled using MySQL and features three normalized tables:
* **subscribers:** Tracks user demographics, subscription tiers, and active/churn status.
* **content:** Catalogs movies and series by genre.
* **watch_logs:** Records transactional viewing history, durations, and user ratings.

## Key Technical Implementations
This repository demonstrates intermediate-to-advanced SQL querying techniques to solve practical product and marketing challenges:

1. **User Engagement Profiling:** Leverages `GROUP BY` and `HAVING` clauses, alongside `IS NULL` filtering, to isolate highly active users for beta testing rollouts.
2. **Exclusionary Set Logic:** Employs optimized `NOT EXISTS` correlated subqueries to identify specific behavioral cohorts (e.g., highly critical reviewers) for targeted feedback surveys.
3. **Partitioned Leaderboards:** Utilizes Common Table Expressions (CTEs) combined with `DENSE_RANK()` Window Functions to calculate the most consumed content strictly within distinct genre boundaries.
