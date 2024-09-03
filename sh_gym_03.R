#Create a big sheet that is a lookup of postcode to ward level


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

#lsoa to ward lookup
url = "https://stg-arcgisazurecdataprod1.az.arcgis.com/exportfiles-1559-8208/LSOA11_WD20_LAD20_EW_LU_v2_f514a75a131249caa65227cdc6275a21_1937901728930244416.csv?sv=2018-03-28&sr=b&sig=X%2FrPXcskKwJBKzaMbsV2TGQ3zvsAyNvtbn8PTr4ze9c%3D&se=2024-09-03T07%3A51%3A38Z&sp=r"

# Download the file using httr
temp_file <- tempfile(fileext = ".csv")
GET(url, write_disk(temp_file, overwrite = TRUE))

# Read the Excel file into a tibble
lsoa_ward <- read_csv(temp_file)

# Clean up by removing the temporary zip file (optional)
unlink(temp_file)


#remove temporary objects
rm(list = ls(pattern = "^temp"))
rm(url)
rm(excel_file)

#clean column names
imd_lsoa <- imd_lsoa %>% clean_names()
names(imd_lsoa) <- substr(names(imd_lsoa), 1, 15)

#make names unique
names(imd_lsoa) <- make.unique(names(imd_lsoa))

#rename the imd column
imd_lsoa <- imd_lsoa %>% rename(imd = index_of_multip.1)

#join the df to create a giant postcode-lsoa -imd -ward-LAD

postcode_lsoa <- postcode_lsoa %>%  select(pcds,lsoa11cd, lsoa11nm, ladcd, ladnm) %>%
  left_join(imd_lsoa %>% select(lsoa_code_2011,imd), 
            by = c('lsoa11cd' = 'lsoa_code_2011')) %>% 
  left_join(lsoa_ward %>% select(LSOA11CD,WD20CD,WD20NM),
            by = c('lsoa11cd'= 'LSOA11CD'))


#create a compressed/spaceless post code
postcode_lsoa <- postcode_lsoa %>%
  mutate(pcds2 = str_replace_all(pcds, " ", ""))



#Create function to find postcode and return the postcode row
find_postcode <- function(pc_to_find, df = postcode_lsoa ) {
  # Convert the search term to uppercase
  pc_to_find <- toupper(pc_to_find)
  
  # Filter rows where there's a match in either 'pcds' or 'pcds2' column
  result <- postcode_lsoa[postcode_lsoa$pcds == pc_to_find | postcode_lsoa$pcds2 == pc_to_find, ]
  
  # Check if any matches were found
  if (nrow(result) == 0) {
    return("Not found")
  } else {
    return(result)
  }
}

# Example usage
result <- find_postcode("SS6 9hw")





