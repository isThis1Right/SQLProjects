/*
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

SELECT *
FROM PortfolioProject..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY location, date;
*/

--Select data to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

--Examine total cases vs total deaths in United States
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%States%'
	AND continent IS NOT NULL
ORDER BY location, date;

--Examine total cases vs population in United States
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPopPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%States%'
	AND continent IS NOT NULL
ORDER BY location, date;

--Determine countries with highest infection rate with regard to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS InfectedPopPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectedPopPercentage DESC;

--Determine countries with highest death count with regard to population
SELECT location, population, MAX(CAST(total_deaths AS int)) AS HighestDeathCount, MAX((CAST(total_deaths AS int)/population))*100 AS PopDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PopDeathPercentage DESC;

--Examine highest death count by continent
SELECT continent, SUM(TotalDeathCount) AS ContinentDeathCount
FROM (
	SELECT continent, location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
	FROM PortfolioProject..CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY continent, location
	) AS ContinentDeaths
GROUP BY continent
ORDER BY ContinentDeathCount DESC;

--Examine population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;
