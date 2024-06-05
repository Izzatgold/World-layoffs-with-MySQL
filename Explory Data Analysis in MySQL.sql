-- Explory Data Analysis in MySQL


Select *
from layoffs_staging2;

Select max(total_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
where percentage_laid_off = 1
order by 9 desc;

Select stage, sum(funds_raised_millions)
from layoffs_staging2
group by stage
order by 1, 2;

Update layoffs_staging2
set stage = 'Unknown'
where stage is null;

Select country, sum(funds_raised_millions)
from layoffs_staging2
group by country
;

Select company, sum(funds_raised_millions)
from layoffs_staging2
group by company;

Select sum(total_laid_off)
from layoffs_staging2
where company = 'Twitter';

Select min(`date`), max(`date`)
from layoffs_staging2;

Select  *
from layoffs_staging2;

Select industry, sum(total_laid_off)
from layoffs_staging2
group by industry;

Update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 asc;

Select substring(`date`, 1, 7) `month`, sum(total_laid_off) monthly_total, 
sum(sum(total_laid_off)) over (order by substring(`date`, 1, 7)) as rolling_monthly_total 
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by substring(`date`, 1, 7)
order by 1;

With Rolling_sum as
(
Select substring(`date`, 1, 7) `month`, sum(total_laid_off) monthly_total
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by substring(`date`, 1, 7)
order by 1
)
select `month`, monthly_total, sum(monthly_total) over (order by `month`) as rolling_monthly_total
from Rolling_sum; 

Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
where year(`date`) is not null
group by company, year(`date`)
order by 2 asc;

With Company_year (company, years, laid_off) as 
(
Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
where year(`date`) is not null
group by company, year(`date`)
order by 2 asc
), Company_year_ranking as
(
select *, dense_rank() over (partition by years order by laid_off desc) ranking
from Company_year
where laid_off is not null
order by ranking asc)

select *
from Company_year_ranking
where ranking <= 5;
