create database global_coups;

use global_coups;

select * from coup_data;

-- Hi, I'm Ore Owolabi. I was moving around the internet and I stumbled (actually searched for it) on this database about coups around the world. Let's examine national stability :)

# let's start with the number of successful coups. But I will initially confirm the number of items/records/records

select count(event_type) as number_of_items
from coup_data;

# i have confirmed that there are 941 rows. Now, how many coups were successful?

select count(event_type) as number_of_items
from coup_data
where event_type = 'coup';

# the answer is 425.  wow. But, between the space of how many years?

select max(year) as mx, min(year) as mn
from coup_data;

# unfortunately mysql workbench does not support minus operations. whyyyy . Let me try timestampdiff

select max(year) as mx, min(year) as mn, timestampdiff(month, max(year),min(year))
from coup_data;

# brought a null value. I think it's cause of the data type i used for my year. so i'll cast as int. 

select max(year) as mx, min(year) as mn, timestampdiff(year, max(cast(year as date)), min(cast(year as date)))
from coup_data;

# casted as date, still didn't work. Seems I'm stuck with latest year being 2019, and oldest year 1945

# what percentage of coups were unsuccessful? I believe I have to name the count ops first, then divide. Nah, stored function would be used

create function successful(year text)
returns integer deterministic
return count(year);

select successful(year) as ess
from coup_data;

# still have work to do with the stored function. to be revisited

select * from coup_data;

# look at number of coups per country

select country, year, event_type, sum(realized) as successful_coups
from coup_data
group by country;

## didnt work. it only organized the countries by what seems to be the number of mentions. i'll try to see how many mentions per country

select country, year, event_type
from  coup_data
where country = 'chad';

#my last assumption was wrong,chad had 4 mentions when i queried realized coups (probably doesnt mean successful). chad total mentions was 14

select country, year, event_type,realized, attempt
from  coup_data
where country = 'chad';

select country, year, event_type, sum(realized) as successful_coups
from coup_data
where country = 'chad';

# the above code worked correctly. let's try again

select country,year, event_type, sum(realized) as successful_coups
from coup_data
group by country
order by successful_coups desc;

# so we see that Bolivia, Haita and Syria have the most coups, although it seems Bolivia hasnt had any for the past 70sh years.

select country, max(year) as year, event_type, sum(realized) as successful_coups
from coup_data
group by country
order by successful_coups desc;
# now you can see that it shows the year of the last coup. Let's rearrange based on coup date

select country, max(year) as year, event_type, sum(realized) as successful_coups
from coup_data
group by country
order by year desc;

# here, we see that Sudan and co had their coups in 2019. This is 2021, and there were 4 or more coup d'etat this year. but let's work with this dataset.
# Let's do same but for latest 10

select country, max(year) as year, event_type, sum(realized) as successful_coups
from coup_data
group by country
order by year desc
limit 10;
-- note top 3. Gabon, Tunisia and Venezuala

select country, max(year) as year, event_type, sum(realized) as successful_coups
from coup_data
group by country
order by year and successful_coups  desc
limit 10;
-- top 3 here are B.Faso, Burundi and Chad

## Now let's look at injuries and deaths per country for successful coups

select country, max(year) as year, event_type, sum(realized) as successful_coups, sum(injured) as injuries, sum(killed) as deaths
from coup_data
group by country
order by successful_coups desc;

# it seems they didnt really keep records or people did not really injure or die.
# do same analysis for failed coups

select country, max(year) as year, event_type, sum(attempt) as failed_coups, sum(injured) as injuries, sum(killed) as deaths
from coup_data
group by country
order by failed_coups desc;

-- Bolivia has the highest number of failed coup attempts. 

select country, max(year) as year, event_type, sum(attempt) as failed_coups, sum(injured) as injuries, sum(killed) as deaths
from coup_data
group by country
order by deaths desc;
-- Nigeria shares the highest number of deaths with Bangladesh. Let's examine same data with successful coups included

select country, max(year) as year, event_type, sum(attempt) as failed_coups, sum(realized) as successful_coups, sum(injured) as injuries, sum(killed) as deaths
from coup_data
group by country
order by deaths desc;

-- Nigeria had a coup conspiracy in 2017, I never knew....
-- again, where is Nigeria's place in number of successful coups?

select country, max(year) as year, event_type, sum(attempt) as failed_coups, sum(realized) as successful_coups, sum(injured) as injuries, sum(killed) as deaths
from coup_data
group by country
order by successful_coups desc;

-- to end, we attempt to solve the challenge encountered earlier on. about the %successful coups vs total coups

select sum(realized)/count(event_type) * 100 
 as coup_percentage_success
from coup_data;

-- so basically, 45% of coups are successful. ehyah

# well, we have examined what we have. More to be done later... bye for now

select * from coup_data;
