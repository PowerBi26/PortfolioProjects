Select *
From PortfolioProject ..CovidDeaths$
Order By 3,4

--Select *
--From PortfolioProject ..CovidVaccinations$
--Order By 3,4

--Select Data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$ 
Order By 1,2

-- Looking at Total cases vs Total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From PortfolioProject..CovidDeaths$ 
Where location like '%Philippines%' --looking at a specific country 
Order By 1,2

-- Looking at total cases vs population
-- Percentage of total cases in population

Select location, date, total_cases, population , (total_cases/population)*100 as InfectionPercentage 
From PortfolioProject..CovidDeaths$ 
Where location like '%Philippines%' --looking at a specific country 
Order By 1,2

-- Looking at countries with highest infection rate compared to population
-- Using MAX function to return only the highest total_cases from countries 

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentage 
From PortfolioProject..CovidDeaths$  
Group By location, population 
Order By InfectionPercentage desc

-- Showing countries with highest death count per population

Select location, population, MAX(Cast(Total_deaths as int)) as TotalDeathCount --using cast function to make Total_deaths data type(nvarchar) into an integer (int)
From PortfolioProject..CovidDeaths$  
Group By location, population
Order By TotalDeathCount desc 