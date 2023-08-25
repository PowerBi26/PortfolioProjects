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
-- By countries
Select location, population, MAX(Cast(Total_deaths as int)) as TotalDeathCount --using cast function to make Total_deaths data type(nvarchar) into an integer (int)
From PortfolioProject..CovidDeaths$  
Where continent is not null -- to return only the countries and not the continent in the location column 
Group By location, population
Order By TotalDeathCount desc 

-- By continent. This script returns the correct total death counts but includes location such as World, Europe, European Union and internation, which these are not continenst 
Select location, MAX(Cast(Total_deaths as int)) as TotalDeathCount --using cast function to make Total_deaths data type(nvarchar) into an integer (int)
From PortfolioProject..CovidDeaths$  
Where continent is null -- to return only the countries and not the continent in the location column 
Group By location 
Order By TotalDeathCount desc 

--this script returns the correct continents location but the total death count is not accurate, because of null values in continent column

Select continent, MAX(Cast(Total_deaths as int)) as TotalDeathCount --using cast function to make Total_deaths data type(nvarchar) into an integer (int)
From PortfolioProject..CovidDeaths$  
Where continent is not null -- to return only the countries and not the continent in the location column 
Group By continent
Order By TotalDeathCount desc 

-- Global Numbers

Select date, SUM(new_cases) as TotalCases, SUM(Cast(total_deaths as int)) as TotalDeaths, SUM(Cast(total_deaths as int))/SUM(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths$  
Where continent is not null
Group By date
Order By 1,2


-- Joining CovidDeaths table and CovidVaccinations table

Select * 
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date

-- looking at population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null 
Order By 2,3

--Using Partition by function
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null 
Order By 2,3


--Using CTE
With PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccination)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null 
) 
Select *, (RollingPeopleVaccination/Population)*100 
From PopulationVsVaccination
Where Location = 'Philippines'

-- Using Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Populaton numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null 

Select *, (RollingPeopleVaccinated/Populaton)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations 

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationVaccinated