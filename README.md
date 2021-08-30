
# Using SQL for Data Exploration of worldwide Covid-19 along with vaccination progress

In this project we used SQL to operate different queries to get a clear picture of the provided dataset as per our requirement. The list of the queries used are as follows



## Queries

1. Total cases vs Total deaths

```bash
  Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From covid..['Covid Death$']
where location like '%states'
order by 1,2
```

  2. Total cases vs Population 
     Percentage of population who got infected
```bash
 Select location, date, total_cases, population, (total_cases/population)*100 as infectedpercentage
From covid..['Covid Death$']
order by 1,2;
```
3. Countries with highest infected rate compared to population

```bash
 Select location, max(total_cases) as highestpopulationinfected, population, (max(total_cases/population))*100 as infectedpercentage
From covid..['Covid Death$']
Group by location, population
order by infectedpercentage desc;

```
4. Countries with highest death count compared to population
```bash
 Select location, max(cast(total_deaths as int)) as highestpopulationdeath
From covid..['Covid Death$']
where continent is not null
Group by location
order by highestpopulationdeath desc;

```
5. Breaking things by continent

```bash
 Select continent, max(cast(total_deaths as int)) as highestpopulationdeath
From covid..['Covid Death$']
where continent is not null
Group by continent
order by highestpopulationdeath desc;
```
6. Joining covid death table with covid vaccination table using inner join

```bash
 Select *
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date;

```
7.Population vs Vaccinations

```bash
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From covid..['Covid Death$'] as dea
Inner join covid..['covidvaccinations$'] as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3;

```

and so on

## Lessons Learned

Using the dataset one can perform a number of queries. In this project , I have performed the necessary queries using limited columns required to get a clear picture of covid cases, deaths, vaccinations etc. in different countries during different time. This indeed helped me boost my experience with SQL.

  
