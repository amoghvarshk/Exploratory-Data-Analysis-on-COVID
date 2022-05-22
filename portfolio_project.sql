--select * from PortfolioProject..CovidDeaths$
--select * from PortfolioProject..CovidVaccinations$

select location, date,total_cases,total_deaths,population , (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2

select location, date,total_cases,total_deaths,population , (total_cases/population)*100 as population_percentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--countries with high death rate
select continent, max(cast(total_deaths as int)) as highestdeaths
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by highestdeaths desc

--looking at total population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 and vac.new_vaccinations is not null
	 order by 1,2,3

	 -- CTE

	 with popvsvac (continent, location,date,population, new_vaccinations, rollingvaccinations)
	 as
	 (
	 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 and vac.new_vaccinations is not null
	 )
	 select*, (rollingvaccinations/population)*100 as rollingvaccinationspercentage
	 from popvsvac

	 -- creating views - permanent creating of table
	 create view rollingvaccinationspercentage as
	 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 and vac.new_vaccinations is not null

	 select * from rollingvaccinationspercentage

