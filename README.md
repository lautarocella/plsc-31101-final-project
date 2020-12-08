## Short Description

This code analyzes party discipline and the opinion of legislators on party discipline in Brazil’s Chamber of Deputies between 2002 and 2020. Firstly, I wrote a function that automatically downloaded all roll call votes from the Chamber’s website and created a data frame. Then, I cleaned my data and calculated the Rice Index (a party discipline indicator) for each party-year. I also downloaded and I tidied the Brazilian Legislative Surveys dataset to get the opinion of legislators on party discipline for each party-year. Finally, I merged the two dataframes and visualized the results. 

## Dependencies

List what software your code depends on, as well as version numbers, like so:.

1. R version 4.0.2 (2020-06-22) -- "Taking Off Again"
2. Package - tidyverse
3. Package - purrr
4. Package - ggplot2

## Files
List all files (other than `README.md` and `Final-Project.RProj`) contained in the repo, along with a brief description of each one, like so:

#### /

1. Narrative.Rmd: Provides a 3-5 page narrative of the project, main challenges, solutions, and results.
2. Narrative.pdf: A knitted pdf of 00_Narrative.Rmd. 
3. Slides.XXX: Your lightning talk slides, in whatever format you prefer.

#### Code/
1. 01_collect-nyt.R: Collects data from New York Times API and exports data to the file nyt.csv
2. 02_merge-data.R: Loads, cleans, and merges the raw Polity and NYT datasets into the Analysis Dataset.
3. 03_analysis.R: Conducts descriptive analysis of the data, producing the tables and visualizations found in the Results directory.

#### Data/

1. polity.csv: The PolityVI dataset, available here: http://www.systemicpeace.org/inscrdata.html
2. nyt.csv: Contains data from the New York Times API collected via collect-nyt.ipynb . Includes information on all articles containing the term "Programmer Cat", 1980-2010.
3. analysis-dataset.csv: The final Analysis Dataset derived from the raw data above. It includes country-year values for all UN countries 1980-2010, with observations for the following variables: 
    - *ccode*: Correlates of War numeric code for country observation
    - *year*: Year of observation
    - *polity*: PolityVI score
    - *nyt*: Number of New York Times articles about "Programmer Cat"

#### Results/

1. coverage-over-time.jpeg: Graphs the number of articles about each region over time.
2. regression-table.txt: Summarizes the results of OLS regression, modelling *nyt* on a number of covariates.

## More Information

Author name: Lautaro Cella. PhD Student in Political Science, University of Chicago

Email: lcella@ uchicago.edu 

Thank you for visiting my repository! 


