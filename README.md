# COVID-19 Data Exploration using SQL

## 📊 Project Overview

This project explores global COVID-19 data using SQL to analyze infection rates, death percentages, and vaccination progress across countries and continents.

The objective of this analysis is to demonstrate core data analyst skills such as data exploration, aggregation, window functions, and joining multiple datasets to derive insights from real-world data.

The project focuses on identifying trends such as:

* likelihood of death if infected
* infection rates relative to population
* countries with the highest death counts
* continent-level COVID impact
* global COVID trends over time
* vaccination progress compared to population

---

## 📁 Dataset

The dataset contains global COVID-19 statistics including:

* Total COVID cases
* New daily cases
* Total deaths
* New deaths
* Population by country
* Vaccination data

Two tables were used for the analysis:

**coviddeaths**

* location
* continent
* date
* population
* total_cases
* new_cases
* total_deaths
* new_deaths

**covidvaccinations**

* location
* date
* new_vaccinations

These datasets were joined to analyze vaccination progress relative to population.

---

## 🛠 SQL Skills Demonstrated

This project demonstrates several SQL concepts used in real data analytics workflows:

* Joins
* Common Table Expressions (CTEs)
* Window Functions
* Aggregate Functions
* Data Type Conversion
* Data Filtering
* Creating Views

---

## 🔎 Key Analysis Performed

### 1. Initial Data Exploration

Basic exploration of the dataset to understand available fields.

```sql
SELECT *
FROM `Covid Project`.Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;
```

---

### 2. Total Cases vs Total Deaths

Calculates the death percentage for infected individuals.

```sql
SELECT location, date, total_cases, total_deaths,
ROUND((total_deaths/total_cases)*100,2) as Death_percentage
FROM coviddeaths
WHERE locatio
```
