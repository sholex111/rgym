#r-gym is my teaching,learning and practice field created by sholex111


#install libraries

#load libraries
library(here)
library(janitor)
library(readxl)
library(readr)
library(tidyverse)

#create output directory/folder
dir.create("gym_output")

#download data from https://www.kaggle.com/datasets/dhruvildave/covid19-deaths-dataset

#load data
covd <- read_csv(here('input','covid_death','all_weekly_excess_deaths.csv'))

#How many countries are there (unique countries)
total_countries <- covd %>% select(country) %>% n_distinct()


#show individual countries and region
countries <- covd %>% distinct(country)
regions <- covd %>% distinct(region)


#check for empty cells
sum(is.na(covd))


#Create a table for each country min date to max data and total number of death
country_death <- covd %>% group_by(country) %>% 
                          summarise(start_date = min(start_date),
                                    end_date = max(end_date),
                                    total_deaths = sum(total_deaths))
                          






