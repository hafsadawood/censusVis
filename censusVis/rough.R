
install.packages("maps")
install.packages("stringr")

library(ggplot2)
library(maps)
library(tidyr)
library(dplyr)
library(stringr)
race = readRDS("censusVis/data/counties.rds")


counties_map = map_data("county")

# In order to join both tables we need to make sure we are combining them by both state
# and county as a unique identifier

counties_map = counties_map %>%
                mutate(counties = paste(region, subregion, sep = ","))


counties = left_join(counties_map, race, by = c("counties" = "name"))

counties %>%
  ggplot(aes(x = long, y = lat, group = group, fill = white ))+
  geom_polygon(color = "black")+
  scale_fill_gradient(low = "white", high = "red")




text = "Hafsa"
switch (text,
  "Hafsa" = print("This is Hafsa"),
  "Abbass" = print("This is Abbass")
)