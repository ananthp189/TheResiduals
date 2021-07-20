# Load the data
hike_data <- readr::read_rds(url('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-24/hike_data.rds'))

# Libraries
library(rvest)
library(tidyverse)
library(here)
library(ggplot2)
library(plotly)
library(data.table)

# Cleaning script (by TidyTuesday)
clean_hike_data <- hike_data %>% 
  mutate(
    trip = case_when(
      grepl("roundtrip",length) ~ "roundtrip",
      grepl("one-way",length) ~ "one-way",
      grepl("of trails",length) ~ "trails"),
    
    length_total = as.numeric(gsub("(\\d+[.]\\d+).*","\\1", length)) * ((trip == "one-way") + 1),
    
    gain = as.numeric(gain),
    highpoint = as.numeric(highpoint),
    
    location_general = gsub("(.*)\\s[-][-].*","\\1",location)
  )


# Save a single object to a file
saveRDS(clean_hike_data, "clean_hike_data.rds")
# Restore it under a different name
reupload_data <- readRDS("clean_hike_data.rds")

# Save file as csv, this puts features into string
fwrite(clean_hike_data, file ="clean_hike_data.csv")
# Restore csv under a different name
reupload_csv <- read.csv("clean_hike_data.csv")

# Extracting all features of the data
unique(unlist(clean_hike_data$features))
# Extracting all regions in the data
unique(clean_hike_data$location_general)

# Example filtering by region and feature character vector in R
filter.area.feature <- clean_hike_data %>%
  filter(location_general == "Mount Rainier Area") %>%
  dplyr::filter(grepl('Dogs not allowed', features))


