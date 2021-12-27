select * from covid_deaths;

use covid_analysis;

select* from coviddeaths;

drop table coviddeaths;

select * from covid_deaths;

 # to know total cases vs total deaths
 
 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathratio
 from covid_deaths
 order by location, date;
 
 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathratio
 from covid_deaths
 where location is not null
 order by location, date;

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathratio
 from covid_deaths
 where location is not null
 group by location
 order by location, date;
 
 # For Nigeria
 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathratio
 from covid_deaths
 where location = 'Nigeria'
 order by location, date;
 
 #to see what % of population got covid
 select location, date, total_cases, population, (total_cases/population)*100 as infection
 from covid_deaths
 where location = 'Nigeria'
 order by location, date;
 -- you can see that 0.1% of Nigeria's population was infected as at early November 2021. Really low recorded infection rate.
 
 # For Germany; cause I'm in Germany
 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathratio
 from covid_deaths
 where location = 'Germany'
 order by location, date;
 -- currently, about 2% of the infected die. I wonder what their vaccination rate is.
 
 #to see what % of population got covid
 select location, date, total_cases, population, (total_cases/population)*100 as infectionrate
 from covid_deaths
 where location = 'Germany'
 order by location, date;
 -- currently, 6% of the German population has been infected, on record. that's alot 
 
 #Now which country has the highest infection rate compared to population
 select location,  population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100 as infectionrate
 from covid_deaths
 group by location, population
 order by location, date;
 -- see Andorra with 20%... tearssss. but notice they have a relatively small population. 
 -- check with better code 
 
 select location,  population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100 as infectionrate
 from covid_deaths
 group by location, population
 order by infectionrate desc;
 -- Montenegro has the highest infection rate, but this would also be a factor of their small-ish population. 
 
 
 # after restarting PC,...
 
 use covid_analysis;
 
 #for highest death count.. 
 select location, population, max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 group by location, population
 order by h_deathcounts desc;
 
 select * from covid_deaths;

alter table covid_deaths
modify column total_deaths numeric;

-- so converting the column datatype to int didn't work because of the missing 'cells' it seems. okay...
 select location, population, max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 group by location, population
 order by h_deathcounts desc;
 
 -- now, notice that there are locations i.e. countries that are actually continents. Well, we can exclude them from queries by:\
 
 select * from covid_deaths
 where continent is not null
 order by location, date;
-- seems mysql isnt recognizing null values, the internet said it's because it's not in strict mode so let's do that for this session.

SET @@SESSION.SQL_MODE = 'STRICT_ALL_TABLES';

#try again

 select * from covid_deaths
 where continent is not null
 order by location, date;
 
 -- code not working... Oh well
 
  select location, population, max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 where continent is not null
 group by location, population
 order by h_deathcounts desc;
 
 # moving on to breaking stuff down by continent
 
  select location, population, max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 where continent is not null
 group by continent
 order by h_deathcounts desc;
 
 -- to test the continent thingy
 select continent, max(population) as population
 from covid_deaths
 group by continent;
 
select continent,  max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 group by continent
 order by h_deathcounts desc;
 
 
 select * from covid_deaths;
 -- 26/12 the line above didn't work cause i didn't select database to work with. Noted. 
 use covid_analysis;
 
 select * from covid_deaths;
 
 ## now back to where we were - highest deaths per continent
 select continent,  max(cast(total_deaths as decimal)) as h_deathcounts
 from covid_deaths	
 group by continent
 order by h_deathcounts desc;
 
 # btw, I had to cast total_deaths as 'decimal' rather than 'integer' because casting as int just wasn't working. idk why. I'll find out eventually.
 
 -- Global Numbers
 select date, location, sum(new_cases), sum(cast(new_deaths as decimal)), total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from covid_deaths
 where continent is not null
 group by location
 order by deathpercentage desc;
 
select date, location,  sum(new_cases) as total_cases , sum(cast(new_deaths as decimal)) as total_deaths, (total_deaths/total_cases)*100 as DeathPercentage, max((total_deaths/total_cases)*100) as maxdeathperc
 from covid_deaths
 where continent is not null
 group by location
 order by maxdeathperc desc;
 
 -- seems Guyana, Iran, Peru, San Marino, Sudan, etc have some issues...
 
 