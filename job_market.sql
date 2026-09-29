CREATE DATABASE job_market;
USE job_market;


CREATE TABLE jobs (
    title TEXT,
    jobId BIGINT,
    currency VARCHAR(10),
    jobUploaded VARCHAR(50),
    companyName TEXT,
    tagsAndSkills TEXT,
    experience VARCHAR(50),
    salary VARCHAR(100),
    location TEXT,
    companyId BIGINT,
    ReviewsCount INT,
    AggregateRating DECIMAL(3,2),
    jobDescription TEXT,
    minimumSalary DECIMAL(12,2),
    maximumSalary DECIMAL(12,2),
    minimumExperience INT,
    maximumExperience INT
);

ALTER TABLE jobs MODIFY AggregateRating DECIMAL(3,2) NULL;

LOAD DATA INFILE '/var/lib/mysql-files/job_market_final.csv'
INTO TABLE jobs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
title, jobId, currency, jobUploaded, companyName, tagsAndSkills,
experience, salary, location, companyId, ReviewsCount,
@rating, jobDescription, @minSalary, @maxSalary,
@minExp, @maxExp
)
SET
AggregateRating = NULLIF(@rating, ''),
minimumSalary = NULLIF(@minSalary, ''),
maximumSalary = NULLIF(@maxSalary, ''),
minimumExperience = NULLIF(@minExp, ''),
maximumExperience = NULLIF(@maxExp, '');

SELECT COUNT(*) FROM jobs;


SELECT * FROM jobs LIMIT 10;

SELECT title, COUNT(*) AS job_count
FROM jobs
GROUP BY title
ORDER BY job_count DESC
LIMIT 20;




SELECT
    AVG(minimumSalary) AS average_minimum_salary,
    AVG(maximumSalary) AS average_maximum_salary,
    MIN(minimumSalary) AS lowest_minimum_salary,
    MAX(maximumSalary) AS highest_maximum_salary
FROM jobs
WHERE minimumSalary IS NOT NULL
   OR maximumSalary IS NOT NULL;
   
   SELECT
    minimumExperience,
    maximumExperience,
    COUNT(*) AS job_count
FROM jobs
GROUP BY minimumExperience, maximumExperience
ORDER BY job_count DESC;


SELECT companyName, COUNT(*) AS job_count
FROM jobs
GROUP BY companyName
ORDER BY job_count DESC
LIMIT 20;


SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(tagsAndSkills, ',', n.n), ',', -1)) AS skill,
    COUNT(*) AS demand
FROM jobs
JOIN (
    SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
) n
ON n.n <= 1 + LENGTH(tagsAndSkills) - LENGTH(REPLACE(tagsAndSkills, ',', ''))
WHERE tagsAndSkills IS NOT NULL
GROUP BY skill
ORDER BY demand DESC
LIMIT 20;

SELECT
    COUNT(*) AS cse_it_jobs
FROM jobs
WHERE LOWER(title) REGEXP 'software|developer|engineer|data|analyst|cyber|cloud|devops|database|network|machine learning|artificial intelligence|web|programmer|technical';


SELECT title, COUNT(*) AS job_count
FROM jobs
WHERE LOWER(title) REGEXP 'software|developer|engineer|data|analyst|cyber|cloud|devops|database|network|machine learning|artificial intelligence|web|programmer|technical'
GROUP BY title
ORDER BY job_count DESC
LIMIT 20;


SELECT
    minimumExperience,
    maximumExperience,
    ROUND(AVG(minimumSalary), 2) AS avg_min_salary,
    ROUND(AVG(maximumSalary), 2) AS avg_max_salary,
    COUNT(*) AS job_count
FROM jobs
WHERE minimumSalary IS NOT NULL
  AND maximumSalary IS NOT NULL
  AND minimumExperience IS NOT NULL
GROUP BY minimumExperience, maximumExperience
ORDER BY minimumExperience;