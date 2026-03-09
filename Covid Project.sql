/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


SELECT *
FROM `Covid Project`.Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- Select the data that we are going to be using 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of death if you contract covid in your country

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) as Death_percentage
FROM coviddeaths
WHERE location = 'United states'
order by 1,2


-- Looking at the Total Cases vs Population
-- Shows what percentage of Population got Covid

SELECT location, date, population, total_cases, ROUND((total_cases/population)*100,2) as Infected_percentage
FROM coviddeaths
order by 1,2


-- Looking at countyries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as Highest_Infection_Count, ROUND(MAX((total_cases/population)*100),2) as Infected_percentage
FROM coviddeaths
GROUP By Population, location
order by Infected_percentage desc


-- Showing the countries with the highest death count per population

SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS Total_death_count
FROM coviddeaths
WHERE continent <> ''
GROUP BY location
ORDER BY Total_death_count DESC;


-- Lets break things down by continent
-- Showing the continents with the highest death count 

SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS Total_death_count
FROM coviddeaths
WHERE continent = ''
GROUP BY location
ORDER BY Total_death_count DESC;


-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as SIGNED)) as total_deaths, SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)*100 as Death_percentage
FROM coviddeaths
WHERE continent = ''
GROUP BY date
order by 1,2


-- Total Cases vs Total Deaths

SELECT  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as SIGNED)) as total_deaths, SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)*100 as Death_percentage
FROM coviddeaths
WHERE continent = ''
order by 1,2 


-- Looking at Total Population vs Vaccinations

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as SIGNED)) OVER(Partition by cd.location ORDER BY cd.location, cd.date) as Rolling_people_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
and cd.date = cv.date
WHERE cd.continent <> ''
order by 2,3
 

-- Rolling Vaccination Percentage 


 -- USE CTE
 With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_people_vaccinated)
 as
 (
 SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as SIGNED)) OVER(Partition by cd.location ORDER BY cd.location, cd.date) as Rolling_people_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
and cd.date = cv.date
WHERE cd.continent <> ''
)
SELECT *, (Rolling_people_vaccinated/Population)*100 as Rolling_Vaccination_Percentage
FROM PopvsVac


-- Creating View to store data for later visualizations

CREATE VIEW TotalPopulationvsVaccinations AS
SELECT 
cd.continent,
cd.location,
cd.date,
cd.population,
cv.new_vaccinations,

SUM(CAST(cv.new_vaccinations AS SIGNED)) 
OVER (PARTITION BY cd.location ORDER BY cd.date) 
AS Rolling_people_vaccinated,

(
SUM(CAST(cv.new_vaccinations AS SIGNED)) 
OVER (PARTITION BY cd.location ORDER BY cd.date)
/ cd.population
) * 100 AS Vaccinated_Percentage

FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date

WHERE cd.continent <> '';

