Select *
From covid..['Covid Death$']
order by 3,4;

--selecting columns that are going to be used

Select location, date, total_cases, new_cases,total_deaths, population
From covid..['Covid Death$']
order by 1,2;


--Total cases vs Total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From covid..['Covid Death$']
where location like '%states'
order by 1,2;


--Total cases vs Population
--Percentage of population who got infected

Select location, date, total_cases, population, (total_cases/population)*100 as infectedpercentage
From covid..['Covid Death$']
order by 1,2;


--Countries with highest infected rate compared to population

Select location, max(total_cases) as highestpopulationinfected, population, (max(total_cases/population))*100 as infectedpercentage
From covid..['Covid Death$']
Group by location, population
order by infectedpercentage desc;


--Countries with highest death count compared to population

Select location, max(cast(total_deaths as int)) as highestpopulationdeath
From covid..['Covid Death$']
where continent is not null
Group by location
order by highestpopulationdeath desc;


--Breaking things by continent

Select continent, max(cast(total_deaths as int)) as highestpopulationdeath
From covid..['Covid Death$']
where continent is not null
Group by continent
order by highestpopulationdeath desc;


--Joining covid death table with covid vaccination table using inner join

Select *
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date;


--Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3;


-- Locations with death population lesser than vaccinated population

Select dea.location,dea.population, dea.date, dea.total_deaths, vac.total_vaccinations
From covid..['Covid Death$'] as dea
left join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.total_deaths< vac.total_vaccinations

--Population vs Vaccinations (WINDOWS FUNCTION)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as sumnewvaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3;



--Use CTE

With PopvsVac (continent, location, date, population, new_vaccination, sumnewvaccinations)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as sumnewvaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
)
Select * , (sumnewvaccinations/population)*100 as percentageofnewVaccinations
From PopvsVac


--Temp Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
sumnewvaccinations numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as sumnewvaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
	on dea.location= vac.location
	and dea.date= vac.date
where dea.continent is not null
Select * , (sumnewvaccinations/population)*100 as percentageofnewVaccinations
From #PercentPopulationVaccinated


--Creating view to store data for later visualisation

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as sumnewvaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
	  on dea.location= vac.location
	  and dea.date= vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated
