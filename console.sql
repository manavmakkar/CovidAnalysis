select *
from covid_deaths
order by 3,4;

#
# select *
# from covid_Vaccinations
# order by 3,4;

# Select the data that we will be using

select location, date , total_cases, new_cases, total_deaths, population
from covid_deaths order by location,total_cases ASC ;

# Now we look at total cases vs total deaths for India
# Showing on what date with highest death rate
select location, date , total_cases,  total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from covid_deaths
where location = 'India'
order by Death_Percentage desc;

# Looking at total cases vs population
select location,date, total_cases,population, (total_cases/covid_deaths.population)*100 as casePercentage

from covid_deaths
where location = 'India'
order by casePercentage desc ;

# Looking at countries at highest infection rate compared to Population

select location, population, max(total_cases) as highestInfectionCount, max((total_cases/covid_deaths.population))*100 as InfectedPopulationPercentage
from covid_deaths
group by population, location
# having location = 'India'
order by InfectedPopulationPercentage desc;

# Looking at highest death count per Population

select location, population, max(total_deaths) as highestDeathCount, max((total_deaths/covid_deaths.population)*100) as PopulationDiedPercentage
from covid_deaths
where continent is not null
group by population, location
# having location = 'India'
order by PopulationDiedPercentage desc ;

# Looking at total cases and  deaths everyday

select date, sum(new_cases) as totalCases, sum(new_deaths) as totalDeaths
from covid_deaths
where continent is not null
group by date;

# looking at total population vs vaccinations

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       cv.total_vaccinations
from covid_deaths cd
inner join covid_Vaccinations cv
    on cd.location = cv.location
    and cd.date = cv.date
    where cd.continent is not null
    order by cd.location asc;


# Making a CTE

with popvsvac (continent, location,date,population,new_vaccinations,total_vaccinations)as
    ( select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       cv.total_vaccinations
from covid_deaths cd
inner join covid_Vaccinations cv
    on cd.location = cv.location
    and cd.date = cv.date
    where cd.continent is not null)
select *, (total_vaccinations/population)*100 as vacpercentage
from popvsvac;
#     order by cd.location asc; )

# Temp Table

Drop TABLE if exists PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated(
    continent nvarchar(255),
    location nvarchar(255),
    Date nvarchar(255),
    population numeric,
    new_vaccination numeric,
    total_vaccination numeric
);


insert into PercentPopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       cv.total_vaccinations
from covid_deaths cd
inner join covid_Vaccinations cv
    on cd.location = cv.location
    and cd.date = cv.date
    where cd.continent is not null;




# Creating View to store data for later visualisations

create view PercentPopulationVaccinatedo as
    select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       cv.total_vaccinations
from covid_deaths cd
inner join covid_Vaccinations cv
    on cd.location = cv.location
    and cd.date = cv.date
    where cd.continent is not null
    order by cd.location asc;








