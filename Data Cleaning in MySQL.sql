-- Data Cleaning in MySQL Project


-- 1. Remove Duplicates
-- 2. Standardize The Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns

Drop table if exists layoffs_staging;

Create table layoffs_staging
like layoffs;

Select *
from layoffs_staging;

Insert layoffs_staging
Select *
from layoffs;

Select *,
row_number () over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
from layoffs_staging;

With duplicate_layoffs_staging as
(
Select *,
row_number () over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_staging
)
select *
from duplicate_layoffs_staging
where row_num > 1
;

drop table if exists layoffs_staging2;
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoffs_staging2;

Insert layoffs_staging2
Select *,
row_number () over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_staging;

Delete
from layoffs_staging2
where `row_number` > 1;

Select *
from layoffs_staging2;

-- Standardizing data

Select company, trim(company)
from layoffs_staging2;

Update layoffs_staging2
set company = trim(company);

Select distinct (industry)
from layoffs_staging2
order by 1;

Select *
from layoffs_staging2
where industry like 'Crypto%';

Update layoffs_staging2
set industry = 'Crypto'
where industry = 'Crypto Currency';

Select distinct country
from layoffs_staging2
order by 1;

Update layoffs_staging2
set country = 'United States'
where country like 'United States%';

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2
order by location;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
modify column `date` date;

Update layoffs_staging2
set industry = null
where industry = '';

Select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Select *
from layoffs_staging2
where industry = '' or industry is null;

Select *
from layoffs_staging2
where company like 'Airbnb';

Select q1.company, q1.location, q1.industry, q2.company, q2.location, q2.industry 
from layoffs_staging2 q1
join layoffs_staging2 q2
	on q1.company =q2.company
where (q1.industry is null) and q2.industry is not null;

Update layoffs_staging2 q1
join layoffs_staging2 q2
	on q1.company =q2.company
set q1.industry =q2.industry
where (q1.industry is null) and q2.industry is not null;

Select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

Delete
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

Select *
from layoffs_staging2;

Alter table layoffs_staging2
drop column `row_number`;

