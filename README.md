## Short Description

This code analyzes party discipline and the opinion of legislators on party discipline in Brazil’s Chamber of Deputies from 2002 to 2020. Firstly, I wrote a function that automatically downloaded all roll call votes from the Chamber’s website and created a data frame. Then, I cleaned and transformed my data to calculate the Rice Index (a party discipline indicator) for each party-year. I also tidied the Brazilian Legislative Surveys dataset to get the opinion of legislators on party discipline for each party-year. Finally, I merged the two dataframes and visualized the results. 

## Dependencies

1. R version 4.0.2 (2020-06-22) -- "Taking Off Again"
2. Package - tidyverse
3. Package - purrr
4. Package - ggplot2

## Files

#### /

1. Narrative.Rmd: Provides a 3-5 page narrative of the project, main challenges, solutions, and results.
2. Narrative.pdf: A knitted pdf of Narrative.Rmd. 
3. Slides.pptx: My lightning talk slides.

#### Code/
1. 01_collect-data.R: Collects data from the Brazilian Chamber of Deputies and creates the Votes dataframe. Loads the Brazilian Legislative Surveys (BLS) dataset.
2. 02_clean-data.R: Tidies and transforms data from the Votes and BLS datasets to create the Rice and Rice_opinions datasets
3. 03_analysis.R: Conducts descriptive analysis of the data and produces the visualizations found in the Results directory.

#### Data/

1. votes.csv: Contains data from all roll call votes taken in the Brazilian Chamber of Deputies from 2002 to 2020.
2. BLS.RDta: Brazilian Legislative Surveys dataset. Available here: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ARYBJI
3. BLS8_Codebook.txt: Codebook from the BLS dataset.
4. rice.csv: New dataset with the Rice Index for every political party in the Brazilian Chamber of Deputies for every year from 2002 to 2020.
5. rice_opinions.csv: New dataset with Rice Index and opinions on party discipline for political parties in the Brazilian Chamber of Deputies in 2005, 2009, 2013 and 2017.

#### Results/

1. histogram_rice.png: Histogram of Rice Index in the Brazilian Chamber of Deputies from 2002 to 2020.
2. line_rice.png: Line graph of average Rice Index over time in the Brazilian Chamber of Deputies from 2002 to 2020.
3. boxplot_rice.png: Box plot of Rice Index over time in the Brazilian Chamber of Deputies from 2002 to 2020.
4. main_rice.png: Line graph of Rice Index over time for main political parties in the Brazilian Chamber of Deputies from 2002 to 2020.
5. scatter_rice_believe.png: Rice Index and Percentage of party members who believe Deputies should vote with their party (not according to their beliefs). 2005, 2009, 2013, 2017.
6. scatter_rice_expel.png: Rice Index and Percentage of party members who believe parties should expel undisciplined Deputies. 2005, 2009, 2013, 2017.

## More Information

Author: Lautaro Cella. PhD Student in Political Science, University of Chicago.

Email: lcella@uchicago.edu 

Thank you for visiting my repository! 


