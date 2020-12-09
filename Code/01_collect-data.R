require(tidyverse)
require(purrr)
require(ggplot2)

# Download 2020 roll call votes in CSV format from the Chamber of Deputies' website

# votes_2020 <- read.csv("https://dadosabertos.camara.leg.br/arquivos/votacoesVotos/csv/votacoesVotos-2020.csv", head = TRUE, sep = ";")

# I comment the above code to avoid wasting time. It was the base for my function get_csv


# Create a function to download roll call votes for any year u

get_csv <- function(u){
  url <- paste0('https://dadosabertos.camara.leg.br/arquivos/votacoesVotos/csv/votacoesVotos-',u,'.csv')
  votes <- read.csv(url, head = TRUE, sep = ";")
  year <- u
  votes <- votes %>%
    mutate (year=as.numeric(u))
  return (votes)}


# Download 19 CSV files with roll call votes from 2002 to 2020
votes <- map_dfr(2002:2020, get_csv)


# Save votes dataframe as CSV file
write.csv(votes, "Data/votes.csv")


# Load the Brazilian Legislative Sureys (1990-2017) dataset
load ("Data/BLS8_Data.RData")
