SELECT *
From PortfolioProject..CovidDeaths
WHERE continent	is not null
Order by 3,4

--SELECT *
--From PortfolioProject..CovidVaccination
--Order by 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
WHERE continent	is not null
Order by 1,2

--Showing likelihood of dying if you contract covid in your country
SELECT location,date, total_cases,total_deaths, (cast(total_deaths as int)/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--Looking at Total cases Vs Total Population
--Shows what percentage of population got covid

SELECT location,date, total_cases,population, (total_cases/population)*100 as CovidPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
order by 1,2

--Looking at Countries with the Highest Infection Rate compared to population

SELECT location,population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Group BY location,population
order by PercentPopulationInfected DESC

--Showing the Countries with the Highest Death Count per Population

SELECT location,MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--WHERE continent	is not null
Group BY location
order by TotalDeathCount DESC

-- LET"S BREAK THESE THINGS IN CONTINENT

SELECT location,MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent is not null
Group BY continent
order by TotalDeathCount DESC

--Showing continents with the highest Death count per population

SELECT location,MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent is not null
Group BY continent
order by TotalDeathCount DESC

--Global Number
SELECT  SUM (new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null
Group BY date
order by 1,2

SELECT date, SUM (new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null
Group BY date
order by 1,2

SELECT *
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

--looking at Total Population Vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Population_vaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE
with PopVsVacc (continent,date,population,location,new_vaccinations,Population_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Population_vaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(Population_vaccinated/Convert(int,population))*100
from PopVsVacc

--TEMP Table	
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinationc numeric,
Population_Vaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Population_vaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(Population_vaccinated/Convert(int,population))*100
from #PercentPopulationVaccinated

--Creating View to store data for visualisation for later

Create View PercentpopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Population_vaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

SELECT * 
FROM PercentpopulationVaccinated