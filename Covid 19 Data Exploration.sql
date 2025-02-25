
/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/




--STARING POINT
--OUR FIRST EXCEL DATASET
SELECT *
FROM [Portfolio-Project].dbo.CovidDeaths
Order by 3,4





--OUR SECOND EXCEL DATASET
SELECT *
FROM [Portfolio-Project].dbo.CovidVaccination
Order by 3,4






--# Select the data we are going to use
--What columns we are going to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio-Project]..CovidDeaths
ORDER BY 1,2





--# Looking at Total cases vs Total Deaths
--What is the total cases vs total deaths
--shows  the likelihood of dying if you contract covid in your country
--total deaths vs population

Select Location, date,population, total_cases,total_deaths, (total_deaths/population)*100 as  DeathPercentage
From [Portfolio-Project]..CovidDeaths
Where location like '%france%'
order by 1,2



--#Looking at Total cases vs Population
--Shows what percentage of population infected with covid

Select Location, date, total_cases,population, (total_cases/population)*100 as  populationPercentage
From [Portfolio-Project]..CovidDeaths
Where location like '%france%'
order by 1,2




--# Looking at countries with the highest infection rate compared to population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((new_cases/population))*100 as PopulationPercentage
From [Portfolio-Project]..CovidDeaths
Where location like '%france%'
Group by location, population
order by 1,2



Select Location, population, Max(total_cases) as HighestInfectionCount, Max((new_cases/population))*100 as PopulationPercentage
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Group by location, population
order by 1,2



Select Location, population, Max(total_cases) as HighestInfectionCount, Max((new_cases/population))*100 as PopulationPercentinfection
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Group by location, population
order by PopulationPercentinfection desc




--#Showing countries with highest death count per population

Select Location, Max(total_deaths) as Totaldeathcount
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Group by location
order by Totaldeathcount desc


Select Location, Max(total_deaths) as Totaldeathcount
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Group by location
order by Totaldeathcount asc





--##Changing highest death count into a interger
-- Countries with Highest Death Count per Population

Select Location, Max(cast(total_deaths as int)) as Totaldeathcount
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Group by location
order by Totaldeathcount asc




--# Lets break Things by continent since others have NULL
--# Showing contints with the highest death count per population

Select Location, Max(cast(total_deaths as int)) as Totaldeathcount
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Where continent is not null
Group by location
order by Totaldeathcount asc


Select Location, Max(cast(total_deaths as int)) as Totaldeathcount
From [Portfolio-Project]..CovidDeaths
--Where location like '%france%'
Where continent is null
Group by location
order by Totaldeathcount asc



--#Global numbers

Select date, population, total_cases,total_deaths, (total_deaths/population)*100 as  DeathPercentage
From [Portfolio-Project]..CovidDeaths
Where location like '%france%'
order by 1,2

Select date, population, total_cases,total_deaths, (total_deaths/population)*100 as  DeathPercentage
From [Portfolio-Project]..CovidDeaths
Where continent is not null
order by 1,2

Select date, population, total_cases,total_deaths, (total_deaths/population)*100 as  DeathPercentage
From [Portfolio-Project]..CovidDeaths
Where continent is null
order by 1,2

Select date, location, population, sum(new_cases) as newcovidcases
From [Portfolio-Project]..CovidDeaths
Where continent is not null
Group by date, location, population
order by 1,2

Select date, location, population, sum(new_cases) as newcovidcases
From [Portfolio-Project]..CovidDeaths
Where continent is not null
Group by date, location, population
order by newcovidcases

Select date, location, population, sum(new_cases) as newcovidcases
From [Portfolio-Project]..CovidDeaths
Where continent is null
Group by date, location, population
order by newcovidcases


Select date, Sum(new_cases)as covidnewcases,sum(cast( total_deaths as int)) as total_deaths,Sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
From [Portfolio-Project]..CovidDeaths
------Where location like '%france%'
Where continent is null
Group by date
order by 1,2







--JOINING TWO EXCEL DATASETS
--#Joining  two tables

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select *
From [Portfolio-Project]..CovidDeaths dea
Join [Portfolio-Project]..CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date


Select *
From CovidDeaths
Join CovidVaccination
     On CovidDeaths.location = CovidVaccination.location
	 and CovidDeaths.date = CovidVaccination.date





--##Looking at the total population

Select *
From [Portfolio-Project]..CovidDeaths dea
Join [Portfolio-Project]..CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio-Project]..CovidDeaths dea
Join [Portfolio-Project]..CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3








-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac








-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 












