
library(tidyverse)
library(janitor)
library(here)
library(readr)
library(readxl)
library(curl)
library(httr)
library(utils)  # For unzipping

#sh_gym_03

#imd-lsoa data
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/datasets/mappingincomedeprivationatalocalauthoritylevel/2019/localincomedeprivationdata.xlsx"

#imd_lsoa <- as_tibble(read_xlsx(curl:curl(url)))    #curl not working


# Download the file using httr
temp_file <- tempfile(fileext = ".xlsx")
GET(url, write_disk(temp_file, overwrite = TRUE))

# Read the Excel file into a tibble
imd_lsoa <- as_tibble(read_excel(temp_file, sheet = 2))

# Clean up by removing the temporary zip file (optional)
unlink(temp_file)


#####
#load in post_code_to_lsoa lookup
url <-  "https://www.arcgis.com/sharing/rest/content/items/3e265c6a114f425fbd92e863977e698a/data"

# Create a temporary file for the downloaded zip
temp_zip <- tempfile(fileext = ".zip")

# Download the zip file
GET(url, write_disk(temp_zip, overwrite = TRUE))

# Create a temporary directory to extract the contents of the zip file
temp_dir <- tempdir()

# Unzip the downloaded file into the temporary directory
unzip(temp_zip, exdir = temp_dir)

# Find the CSV file in the extracted contents
csv_file <- list.files(temp_dir, pattern = "\\.csv$", full.names = TRUE)

# Read the CSV file into a tibble
postcode_lsoa <- read_csv(csv_file)

# Clean up by removing the temporary zip file (optional)
unlink(temp_zip)

#remove temporary objects
rm(list = ls(pattern = "^temp"))
rm(url)
rm(excel_file)



