/*
Covid 19 Data Exploration using PostgreSql
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

based on Alex The Analyst sql Query, but adjusted to work properly in PostgreSQL

*/

Select *
From table_name
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From table_name
Where continent is not null 
order by 1,2




-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From table_name
Where location like 'Indonesia'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From table_name
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From table_name
where population is not null and total_cases is not null
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths ) as TotalDeathCount
From table_name
--Where location like '%states%'
Where continent is not null and Total_deaths is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From table_name
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
		SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From table_name
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


select 
	continent, location, date, population, new_vaccinations, 
	SUM(new_vaccinations) OVER (Partition by location 
									Order by location, date) as RollingPeopleVaccinated
from table_name
where continent is not null 


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac as(
	select 
		continent, location, date, population, new_vaccinations, 
		SUM(new_vaccinations) OVER (Partition by location 
										Order by location, date) as RollingPeopleVaccinated
	from table_name
	where continent is not null 
	--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationPercentage
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

insert into PercentPopulationVaccinated
(
select 
	continent, location, to_date(date, 'YYYY-MM-DD'), population, new_vaccinations, 
	SUM(new_vaccinations) OVER (Partition by location 
									Order by location, date) as RollingPeopleVaccinated

from table_name
)
--where dea.continent is not null 
--order by 2,3




Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated_view as
select 
	continent, location, date, population, new_vaccinations, 
	SUM(new_vaccinations) OVER (Partition by location 
									Order by location, date) as RollingPeopleVaccinated
from table_name
where continent is not null 