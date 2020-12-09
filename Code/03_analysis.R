
#Summary statistics for rice index

summary (rice$rice_index)


#1. Create histogram of rice index for all parties from 2002 to 2020
# Include vertical line with average rice index 

histogram_rice <- ggplot(rice, aes( x = rice_index)) + 
  labs(title = "Rice Index in Brazil's Chamber of Deputies 2002-2020",
       x = "Rice Index", y ="Density") + 
  geom_histogram (binwidth=2, colour = "black", fill = "white") +
  geom_vline (aes(xintercept = mean (rice_index)),
              color = "blue", linetype = "dashed", size = 1) +
  theme_bw()

histogram_rice

# Save graph
ggsave("Results/histogram_rice.png", width = 338.666666667, height = 173.83125, units = "mm")


#2.Crete line graph with average rice index for all parties per year
#The horizontal line is the average 

line_rice <- rice  %>% group_by(year)  %>% 
  mutate (rice_year = mean (rice_index)) %>%
  
  ggplot(aes(x = year, y = rice_year)) + 
  geom_line () +
  labs (title = "Average Rice Index Over Time in Brazil's Chamber of Deputies 2002-2020",
        x = "Year", y = "Average Rice Index") + 
  geom_hline (aes(yintercept = mean(rice_index)),
              color = "blue", linetype = "dashed", size = 1) +
  scale_y_continuous (limits = c(80, 100)) +
  scale_x_continuous (breaks = c(2002:2020)) +
  theme_bw()

line_rice

# Save graph
ggsave("Results/line_rice.png", width = 338.666666667, height = 173.83125, units = "mm")


#3. Create a box plot of rice index over time

boxplot_rice <- ggplot(rice, aes(x = as.factor(year), y = rice_index)) +
  labs( title="Box Plot of Rice Index Over Time in Brazil's Chamber of Deputies 2002-2020",
        x="Year", y ="Rice Index") + 
  geom_boxplot(alpha =  0.7) +
  theme_dark()

boxplot_rice

# Save graph
ggsave("Results/boxplot_rice.png", width = 338.666666667, height = 173.83125, units = "mm")


#4. Graph rice index for Brazil's three main parties
# Assign party colors
# Modify axes

main_rice <- ggplot (rice_main_parties, aes(x = year, y = rice_index, color = party_deputy)) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2"))+
  geom_line ( size=1.5) +
  labs(title="Rice Index for Main Parties in Brazil's Chamber of Deputies 2002-2020",
       x="Year", y ="Rice Index") +  
  scale_y_continuous (limits = c(70, 100)) +
  theme(text = element_text(size = 8)) +
  facet_wrap( ~ party_deputy) +
  theme_bw()

main_rice

# Save graph
ggsave("Results/main_rice.png", width = 338.666666667, height = 173.83125, units = "mm")


# Summary statistics for mean_believe and mean_expel

summary (opinions$mean_believe)
summary (opinions$mean_expel)


#5. Create scatter plot with X: mean_believe and Y: rice index
# Include party color for main parties

scatter_rice_believe <- ggplot(rice_opinions, aes(x = mean_believe, y = rice_index)) + 
  geom_point(position = "jitter", size = 2) +
  labs(title = "Parties' Opinion and Rice Index in Brazil's Chamber of Deputies",
       subtitle = " 2005, 2009, 2013, 2017",
       x = "Percentage of Members who Believe Deputies Should Vote with their Party", y ="Rice Index") +
  geom_point (position = "jitter",data = rice_opinions_main, 
              aes(x = mean_believe,y = rice_index, color = party_deputy), size = 3) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2")) +
  theme_bw()+
  geom_smooth(method=lm, se=F)

scatter_rice_believe

# Save graph
ggsave("Results/scatter_rice_believe.png", width = 338.666666667, height = 173.83125, units = "mm")


#6. Create scatter plot with X: mean_believe and Y: rice index
# Include party color for main parties 

scatter_rice_expel <- ggplot(rice_opinions, aes(x = mean_expel, y = rice_index)) + 
  labs(title = "Parties' Opinion and Rice Index in Brazil's Chamber of Deputies",
       subtitle = " 2005, 2009, 2013, 2017",
       x = "Percentage of Members who Believe Parties Should Expel Undisciplined Deputies", y ="Rice Index") +
  geom_point (position="jitter", size=2)+
  geom_point (position="jitter",data=rice_opinions_main, 
              aes(x = mean_expel,y = rice_index, color = party_deputy), size = 3) +
  scale_color_manual(name = "Party", values = c("green4", "mediumblue", "red2")) +
  theme_bw()+
  geom_smooth(method = lm, se=FALSE)

scatter_rice_expel

# Save graph
ggsave("Results/scatter_rice_expel.png", width = 338.666666667, height = 173.83125, units = "mm")


# Calculate correlation coefficients

cor(rice_opinions$rice_index, rice_opinions$mean_believe,  method = "pearson", use = "complete.obs")

cor(rice_opinions$rice_index, rice_opinions$mean_expel,  method = "pearson", use = "complete.obs")


