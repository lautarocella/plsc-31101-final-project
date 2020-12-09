
# Keep variables of my interest
# Rename variables in English

votes <- votes %>%
  mutate (id_vote = as.factor(ï..idVotacao)) %>%
  select (year, id_vote, id_deputy = deputado_id, name_deputy = deputado_nome,
          party_deputy = deputado_siglaPartido, vote = voto)


# How many unique id_vote?

length(unique(votes$id_vote))


# Create variable n_deputies with number of legislators who voted per id_vote

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


# Save rice dataframe as CSV file
write.csv(rice, "Data/rice.csv")


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


# Save rice_opinions dataframe as CSV file
write.csv(rice_opinions, "Data/rice_opinions.csv")


# Filter merged data frame rice_opinions to only include main parties

rice_opinions_main <- rice_opinions %>%
  filter (party_deputy == "PT" | party_deputy == "PMDB-MDB" | party_deputy == "PSDB")