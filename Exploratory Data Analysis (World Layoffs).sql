use world_layoffs;

-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_staging2;

SELECT 
    MAX(total_laid_off)
FROM
    layoffs_staging2;

SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging2;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY total_laid_off DESC;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_staging2;
    
SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    *
FROM
    layoffs_staging2;
    
SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

-- Rolling Total of Layoffs

SELECT 
    *
FROM
    layoffs_staging2;
    
SELECT 
    SUBSTRING(`date`, 6, 2) AS `MONTH`
FROM
    layoffs_staging2;
    
SELECT 
    SUBSTRING(`date`, 6, 2) AS `MONTH`, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) over(order by `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Finding out which companies laid off the most employees each year

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1 , 2
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1 , 2
), Company_Year_Rank AS
(select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
SELECT *
FROM Company_Year_Rank
where Ranking <= 5;

-- Finding out which industries had the most layoffs each year

SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT 
    industry, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY 1 , 2
), Industry_Year_Rank AS
(select *, dense_rank() over(partition by years order by total_laid_off desc) as Industry_Ranking
from Industry_Year
where years is not null
)
SELECT *
FROM Industry_Year_Rank
WHERE Industry_Ranking <= 5;