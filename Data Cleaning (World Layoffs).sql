use world_layoffs;

SELECT 
    *
FROM
    layoffs;
    
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT layoffs_staging
SELECT 
    *
FROM
    layoffs;
    
SELECT 
    *
FROM
    layoffs_staging;

-- 1. Removing Duplicates

SELECT 
    *, row_number() over(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM
    layoffs_staging;

WITH duplicate_cte AS
(SELECT 
    *, row_number() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM
    layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging2;
    
INSERT INTO layoffs_staging2
SELECT 
    *, row_number() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM
    layoffs_staging;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    row_num > 1;
    
DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;

-- 2. Standardising the Data

SELECT 
    *
FROM
    layoffs_staging2;

SELECT 
    company, (TRIM(company))
FROM
    layoffs_staging2;
    
UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY 1;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE 'Crypto%';
    
UPDATE layoffs_staging2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'Crypto%';
    
SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY 1;

SELECT DISTINCT
    country
FROM
    layoffs_staging2
ORDER BY 1 DESC;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    country LIKE 'United States%';

SELECT DISTINCT
    country, TRIM(TRAILING '.' FROM country)
FROM
    layoffs_staging2
ORDER BY 1 DESC;

UPDATE layoffs_staging2 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE 'United States%';

SELECT 
    `date`
FROM
    layoffs_staging2
ORDER BY 1;

SELECT 
    `date`, STR_TO_DATE(`date`, '%Y-%m-%d')
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%Y-%m-%d');
    
alter table layoffs_staging2
modify column `date` DATE;

-- 3. Addressing Null/Blank Values

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
        
SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY 1;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL OR industry = '';

SELECT 
    *
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

SELECT 
    t1.company, t1.location, t1.industry, t2.industry
FROM
    layoffs_staging2 AS t1
        INNER JOIN
    layoffs_staging2 AS t2 ON t1.company = t2.company
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';

UPDATE layoffs_staging2 AS t1
        INNER JOIN
    layoffs_staging2 AS t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    (t1.industry IS NULL)
        AND t2.industry IS NOT NULL;

-- 4. Removing Unnecessary Columns/Rows

SELECT 
    *
FROM
    layoffs_staging2;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

alter table layoffs_staging2
drop column row_num;

SELECT 
    *
FROM
    layoffs_staging2;