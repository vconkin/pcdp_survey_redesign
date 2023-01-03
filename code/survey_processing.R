### 
### This file pulls transect data from PCDP surveys
### conducted in 2019, 2021, and 2022


library(readxl)        # reading Excel data
library(dplyr)         # manipulating data
library(magrittr)      # for %<>%
library(tidyr)         # transforming data arrangement (tidy data!!)
library(ggplot2)       # visualizations

### Import our data and select the relevant columns
### There's an issue in here with the dates, but I'm going to fix it later
survey <- read_excel("data/2015-Present Surveys_Mod.xlsx", sheet = "Survey_General_Info") %>%
  select ("Date", "Transect", "InitialDistance", "1stObserver", "TotalDolphinsBestEstimate",
          "StartLatitude", "StartLongitude", "StartBeaufort", "EndLatitude", "EndLongitude",
          "EndBeaufort") %>%
  rename("Init_Dist" = "InitialDistance", "Obs" = "1stObserver", "D_Est" = "TotalDolphinsBestEstimate",
         "Start_Lat" = "StartLatitude", "Start_Long" = "StartLongitude", "Start_Beaufort" = "StartBeaufort",
         "End_Latitude" = "EndLatitude", "End_Long" = "EndLongitude", "End_Beaufort" = "EndBeaufort")

# We need to get rid of lots of text values: NA, unknown, Not Recorded
na_data = c("NA", "NR", "UNK")
# Replace all the text NA, UNK, and NR values with NA values
# Then filter those out
transects <- survey %>% mutate(across(where(is.character), ~ replace(., . %in% na_data, NA))) %>%
  filter(Transect > 0) %>%
  mutate(Date = as.Date(Date, origin = "1900-01-01"))
