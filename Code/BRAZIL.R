require(tidyverse)
require(purrr)
require(ggplot2)

# Download 2020 roll call votes in CSV format from the Chamber of Deputies' website

# votes_2020 <- read.csv("https://dadosabertos.camara.leg.br/arquivos/votacoesVotos/csv/votacoesVotos-2020.csv", head = TRUE, sep = ";")


# Create a function to download roll call votes for any year u

get_csv <- function(u){
  url <- paste0('https://dadosabertos.camara.leg.br/arquivos/votacoesVotos/csv/votacoesVotos-',u,'.csv')
  votes <- read.csv(url, head = TRUE, sep = ";")
  year <- u
  votes <- votes %>%
  mutate (year=as.numeric(u))
  return (votes)}


# Try the function for 2019 to see if it works

# votes_2019<- get_csv(2019)


# Download 19 CSV files with roll call votes from 2002 to 2020
votes <- map_dfr(2002:2020, get_csv)


# Load the Brazilian Legislative Sureys (1990-2017) dataset
load ("BLS8_Data.RData")









# Keep variables of my interest
# Rename variables in English

votes <- votes %>%
  mutate (id_vote = as.factor(ï..idVotacao)) %>%
  select (year, id_vote, id_deputy = deputado_id, name_deputy = deputado_nome,
         party_deputy = deputado_siglaPartido, vote = voto)

# How many unique id_vote?

length(unique(votes$id_vote))


# Create variable n_deputies with number of legislator who voted per id_vote

votes <- votes %>% group_by (id_vote) %>% 
  mutate (n_deputies = n())


# How many id_vote have less than 257 deputies voting?
n_votes <- votes %>% group_by (id_vote) %>% 
count (id_vote)
sum (as.numeric(n_votes$n < 257))


# Drop observations that are not from roll call votes

votes <- votes %>% filter (n_deputies >= 257)


#How many id_vote now?

length(unique(votes$id_vote))


# What are the unique values for variable vote?

unique(votes$vote)


# Translate values of variable vote

votes$vote <- votes$vote %>% 
  recode ("Sim" = "Yes", "NÃ£o" = "No")


# Change the name of some political parties

votes$party_deputy <- votes$party_deputy %>% 
  recode ("PP" = "PP-PPB", "PPB" = "PP-PPB",
          "PMDB" = "PMDB-MDB", "MDB" = "PMDB-MDB",
          "PTN" = "PTN-PODEMOS", "PODE" = "PTN-PODEMOS",
          "PTdoB" = "PTdoB-AVANTE", "AVANTE" = "PTdoB-AVANTE",
          "PFL" = "PFL-DEM","DEM" = "PFL-DEM")


#Calculate percentage of YES and NO per party per id_vote

votes_party <- votes %>%
  group_by (id_vote, party_deputy, year) %>%
  summarise (vote_yes = sum (vote == "Yes"), vote_no = sum (vote == "No")) %>%
  mutate (percent_yes = 100 * vote_yes / (vote_yes + vote_no),
         percent_no= 100 * vote_no / (vote_yes + vote_no),
  abs_dif = abs (percent_yes - percent_no))


# Check that I have not lost any roll call votes
length(unique(votes_party$id_vote))


# Caclulate rice index per party and year
# Create rice dataframe

rice <- votes_party %>%
  group_by (party_deputy, year) %>%
  summarise (rice_index = mean(abs_dif, na.rm=T))


# Create dataframe with rice index for main parties
rice_main_parties <- rice %>%
  filter (party_deputy == "PT" | party_deputy == "PMDB-MDB" | party_deputy == "PSDB")



# Now we turn to the BLS dataframe
# On the variable expel_all, expel undisciplined members is coded as 1.
# Not expel undisciplined members is coded as 2. I change it to 0.
# The NAs are coded as -999. I change them to NA.

bls$expel_all <- na_if (bls$expel_all, -999)

bls$expel_all <- recode (bls$expel_all, `2` = 0)


# On the variable believe, voting with the party is 1.
# Voting according to own believes (not with party) is coded as 2.
# I change it to 0.
# The NAs are coded as -999. I change them to NA.
# I also send neutral answer (coded as 8) to NA.

bls$believe <- recode(bls$believe, `2` = 0)

bls$believe <- na_if (bls$believe, -999)

bls$believe <- na_if (bls$believe, 8)


# Variable party_survey has numbers corresponding to party names
# Replace party_survey with the party names

bls$party_survey <- recode ( bls$party_survey, 
                           '10' = "PRB",
                           '11'= "PP-PPB",
                           '12' =	"PDT",
                           '13' = "PT",
                           '14' =	"PTB",
                           '15' =	"PMDB-MDB",
                           '16' =	"PSTU",
                           '17' =	"PDC",
                           '172' =	"PSL (17 was recycled by the TSE)",
                           '18'	= "REDE",
                           '19' =	"PTN-PODEMOS",
                           '20' =	"PSC",
                           '22'	= "PL-PRONA-PR",
                           '23' =	"PPS",
                           '25' =	"PFL-DEM",
                           '26' = "PMB",
                           '28'	= "PTR",
                           '31'	= "PHS",
                           '33'	= "PMN",
                           '36'	= "PTC",
                           '40'	= "PSB",
                           '43'	= "PV",
                           '44'	= "PRP",
                           '45'	= "PSDB",
                           '50'	= "PSOL",
                           '51'	= "PEN",
                           '52'	= "PST",
                           '55'	= "PSD",
                           '65'	= "PCdoB",
                           '70'	= "PTdoB-AVANTE",
                           '71'	= "PRS",
                           '77'	= "SDD",
                           '90'	= "PROS")


#Create opinions data frame with average believe and expell_all of all parties
# for every survey
# I only care about years after 2001 (I don't have roll calls before that)
# Rename variables

opinions <- bls %>%
  filter (wave > 2001) %>%
  group_by (wave, party_survey) %>%
  summarise (mean_believe = 100 * mean(believe, na.rm = T),
            mean_expel =100 * mean(expel_all, na.rm = T)) %>%
  rename (year = wave, party_deputy = party_survey)


# Merge rice and opinions data frames

rice_opinions <- rice %>%
  inner_join (opinions)


# Filter merged data frame rice_opinions to only include main parties

rice_opinions_main <- rice_opinions %>%
  filter (party_deputy == "PT" | party_deputy == "PMDB-MDB" | party_deputy == "PSDB")













#Summary statistics for rice index

summary (rice$rice_index)


#1. Create histogram of rice index for all parties from 2002 to 2020
# Include vertical line with average rice index 

histogram_rice <- ggplot(rice, aes( x = rice_index)) + 
  labs(title = "Rice Index for Parties in Brazil's Chamber of Deputies 2002-2020",
       x = "Rice Index", y ="Density") + 
  geom_histogram (binwidth=2, colour = "black", fill = "white") +
  geom_vline (aes(xintercept = mean (rice_index)),
             color = "blue", linetype = "dashed", size = 1) +
  theme_bw()

histogram_rice

ggsave("histogram_rice.png", width = 338.666666667, height = 173.83125, units = "mm")



#2.Crete line graph with average rice index for all parties per year
#The horizontal line is the average 

line_rice <- rice  %>% group_by(year)  %>% 
  mutate (rice_year = mean (rice_index)) %>%
  
ggplot(aes(x = year, y = rice_year)) + 
  geom_line () +
  labs (title = "Average Rice Index Over Time in Brazil's Chamber of Deputies",
       x = "Year", y = "Average Rice Index") + 
  geom_hline (aes(yintercept = mean(rice_index)),
             color = "blue", linetype = "dashed", size = 1) +
  scale_y_continuous (limits = c(80, 100)) +
  scale_x_continuous (breaks = c(2002:2020)) +
  theme_bw()
  
line_rice
ggsave("line_rice.png", width = 338.666666667, height = 173.83125, units = "mm")


#3. Create a box plot of rice index over time

boxplot_rice <- ggplot(rice, aes(x = as.factor(year), y = rice_index)) +
  labs( title="Box Plot of Rice Index Over Time in Brazil's Chamber of Deputies",
       x="Year", y ="Rice Index") + 
  geom_boxplot(alpha =  0.7) +
  theme_dark()

boxplot_rice


#4. Graph rice index for Brazil's three main parties
# Assign party colors
# Modify axes

 main_rice <- ggplot (rice_main_parties, aes(x = year, y = rice_index, color = party_deputy)) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2"))+
geom_line ( size=1.5) +
  labs(title="Main Parties Rice Index in Brazil's Chamber of Deputies",
       x="Year", y ="Rice Index") +  
  scale_y_continuous (limits = c(70, 100)) +
  theme(text = element_text(size = 8)) +
  facet_wrap( ~ party_deputy) +
  theme_bw()

 main_rice
 ggsave("main_rice.png", width = 338.666666667, height = 173.83125, units = "mm")
 
 # Summary statistics for mean_believe and mean_expel
 
 summary (opinions$mean_believe)
 summary (opinions$mean_expel)
 
 #5. Create scatter plot with X: mean_believe and Y: rice index
 # Include party color for main parties
 
scatter_rice_believe <- ggplot(rice_opinions, aes(x = mean_believe, y = rice_index)) + 
  geom_point(position = "jitter", size = 2) +
  labs(title = "Parties' Opinion and Rice Index in Brazil's Chamber of Deputies",
       subtitle = " 2005, 2009, 2013, 2017",
       x = "Percentage that Believes Deputies Should Vote with their Party", y ="Rice Index") +
  geom_point (position = "jitter",data = rice_opinions_main, 
             aes(x = mean_believe,y = rice_index, color = party_deputy), size = 3) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2")) +
  theme_bw()+
  geom_smooth(method=lm, se=F)

scatter_rice_believe
ggsave("scatter_rice_believe.png", width = 338.666666667, height = 173.83125, units = "mm")


#6. Create scatter plot with X: mean_believe and Y: rice index
# Include party color for main parties 

scatter_rice_expel <- ggplot(rice_opinions, aes(x = mean_expel, y = rice_index)) + 
  labs(title = "Parties' Opinion and Rice Index in Brazil's Chamber of Deputies",
       subtitle = " 2005, 2009, 2013, 2017",
       x = "Percentage that Believes Parties Should Expel Undisciplined Deputies", y ="Rice Index") +
  geom_point (position="jitter", size=2)+
  geom_point (position="jitter",data=rice_opinions_main, 
             aes(x = mean_expel,y = rice_index, color = party_deputy), size = 3) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2")) +
  theme_bw()+
  geom_smooth(method = lm, se=FALSE)

scatter_rice_expel


#Calculate correlation coefficients

cor(rice_opinions$rice_index, rice_opinions$mean_believe,  method = "pearson", use = "complete.obs")

cor(rice_opinions$rice_index, rice_opinions$mean_expel,  method = "pearson", use = "complete.obs")




