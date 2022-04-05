--SELECT *
--FROM CovidProject..CovidDeaths
--order by 3,4

--SELECT *
--FROM CovidProject..CovidVaccination
--order by 3,4

-- Total cases vs Toatal Deaths in Germany

SELECT total_cases, total_deaths, location, (total_deaths/total_cases) *100 AS Percentage_Of_Deaths
FROM CovidProject..CovidDeaths
WHERE location = 'Germany' 
ORDER BY 1, 2

-- Percentage of population affected by covid 19 in Germany
SELECT total_cases, total_deaths, population, location, date, (total_cases/population) * 100 AS population_affected
FROM CovidProject..CovidDeaths
WHERE location LIKE '%many'
ORDER BY 1, 2

-- Countries that are infected the most across the world

SELECT location, population, max(total_cases) AS HighestInfectionrate, Max(total_cases/population)*100 AS percentage_population_infected
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY percentage_population_infected DESC

--Countries that reported highest death count
SELECT location, max(cast(total_deaths AS int)) AS Total_Deaths_count
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY Total_Deaths_count DESC

--Total deaths accross the world

SELECT sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) * 100 as percetage_of_deaths
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
--GROUP BY date
ORDER BY 1, 2

SELECT date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) * 100 as percetage_of_deaths
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1, 2

--Total population vaccinated across the world
--CTE

WITH POPVSVAC (continent, location, date, population, new_vaccinations, PeopleVaccinated)
AS 
(
SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations, SUM(cast(Vacc.new_vaccinations as int)) OVER (PARTITION BY Deaths.location
ORDER BY Deaths.location, Deaths.date) AS PeopleVaccinated
FROM CovidProject..CovidDeaths AS Deaths
JOIN CovidProject..CovidVaccination AS Vacc
ON Deaths.location = Vacc.location
AND Deaths.date = Vacc.date
WHERE Deaths.continent is NOT NULL
)
SELECT *,  (PeopleVaccinated/population)*100 AS percentage
FROM POPVSVAC 

--TEMP TABLE

DROP TABLE IF exists #peoplevaccinated
CREATE TABLE #peoplevaccinated
(continent nvarchar(250),
location nvarchar(250),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #peoplevaccinated
SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations, SUM(cast(Vacc.new_vaccinations as bigint)) OVER (PARTITION BY Deaths.location
ORDER BY Deaths.location, Deaths.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths AS Deaths
JOIN CovidProject..CovidVaccination AS Vacc
ON Deaths.location = Vacc.location
AND Deaths.date = Vacc.date
WHERE Deaths.continent is NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100 AS percentage
FROM #peoplevaccinated 


--Create view for visualization
CREATE VIEW peoplevaccinated AS
SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations, SUM(cast(Vacc.new_vaccinations as bigint)) OVER (PARTITION BY Deaths.location
ORDER BY Deaths.location, Deaths.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths AS Deaths
JOIN CovidProject..CovidVaccination AS Vacc
ON Deaths.location = Vacc.location
AND Deaths.date = Vacc.date
WHERE Deaths.continent is NOT NULL


SELECT *
FROM peoplevaccinated
