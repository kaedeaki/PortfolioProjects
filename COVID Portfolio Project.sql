Select *
from PortfoiloProject..CoivdDeaths
where continent is not null
order by 3,4

--Select *
--from PortfoiloProject..CoivdVaccinations
--order by 3,4

--Selct Data that we are going to be using

Select  Location, date, total_cases, new_cases,total_deaths, population
from PortfoiloProject..CoivdDeaths
where continent is not null
order by 1, 2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select  Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfoiloProject..CoivdDeaths
where location like '%states%'
and continent is not null
order by 1, 2

--Looing at Total Cases vs Population
--Shows what percentage of population got covid

Select  Location, date, population,total_cases,  (total_cases/population)*100 as PercentpopulationInfected
from PortfoiloProject..CoivdDeaths
--where location like '%states%'
where continent is not null
order by 1, 2

-- Looking at Countries with Highest Infection rate compared to Population
Select  Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentpopulationInfected
from PortfoiloProject..CoivdDeaths
--where location like '%states%'
where continent is not null
Group by Location, population
order by PercentpopulationInfected desc

--Let's break things down by continent

Select  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfoiloProject..CoivdDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--showing continents with the highest death count per population

Select  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfoiloProject..CoivdDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global numbers 
Select  SUM(total_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfoiloProject..CoivdDeaths
--where location like '%states%'
where continent is not null
--Group By date
order by 1, 2

--Looking at Total Population vs Vaccinations
--Use CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(bigint, vac.new_vaccinations)) over(Partition by dea.Location order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfoiloProject.dbo.CoivdDeaths dea
join PortfoiloProject.dbo.CoivdVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
)

Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE
DROP Table if exists #PercentPopulartionVaccinated
Create Table #PercentPopulartionVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulartionVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(bigint, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfoiloProject.dbo.CoivdDeaths dea
join PortfoiloProject.dbo.CoivdVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulartionVaccinated






