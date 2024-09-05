#Sh Gym04 Linear regression and outputs.


library(tidyverse)
library(here)
library(janitor)
library(readxl)
library(openxlsx)


library(broom)

df = read_xlsx('Th_An_Test_2.xlsx', sheet = 1, range = "A5:AM34", col_names = FALSE)


# Read the headers separately
headers <- read_excel("Th_An_Test_2.xlsx", sheet = 2, range = "A6:AM6", col_names = FALSE)


#add headers to df
names(df) <- as_tibble(headers)

#Clean the data

# Ensure unique column names
colnames(df) <- make.unique(colnames(df))

# Remove columns with name "_"
df <- df %>% select(-matches("^_"))


#clean column names
df <-  df %>% clean_names()

#create new decile column
df <- df %>%
  mutate(
    decile_1 = str_extract(decile, "\\d+")
  )

#rename long column names
df <- df %>% rename("all_death_rate" = "x5_month_march_to_july_rate" )

#check structure of the data
str(df)

#convert decile 1 to factor and cause of death to factor
df <- df %>%
  mutate(
    decile_1 = as.factor(decile_1)
  )


#convert cause_of_death to factor
df <- df %>%
  mutate(
    cause_of_death = as.factor(cause_of_death)
  )


#build model

model <- lm(all_death_rate ~ cause_of_death + decile_1, data = df)
summary(model)


#Output the model to an excel sheet

# Use broom's tidy function to get the model summary as a data frame
tidy_summary <- tidy(model)

# Get additional model statistics like R-squared, F-statistic, etc.
tidy_model_stats <- glance(model)

#transpose for a better view
tidy_model_stats <- as.data.frame(t(tidy_model_stats)) 

#further cleaning
tidy_model_stats <- cbind(rownames(tidy_model_stats), estimate = tidy_model_stats)
row.names(tidy_model_stats) <- NULL
colnames(tidy_model_stats) <-  c("Term", "Estimates")



# Combine the two: model summary and detailed result
#combined_model <- rbind(tidy_summary, tidy_model_stats)


#create and Put the two tables on one excel sheet using openxlsx2 package

# Create a new workbook and add the dataframes as tables
wb <- createWorkbook()

# Add a worksheet
addWorksheet(wb, "Sheet1")

# Write df1 to the worksheet
writeDataTable(wb, sheet = "Sheet1", x = tidy_model_stats, startCol = 1, startRow = 1, tableStyle = "TableStyleMedium9")

# Write df2 to the worksheet, starting two rows below df1
writeDataTable(wb, sheet = "Sheet1", x = tidy_summary, startCol = ncol(tidy_model_stats) + 3, startRow = 1, tableStyle = "TableStyleMedium9")

# Save the workbook
saveWorkbook(wb, "lm_summary.xlsx", overwrite = TRUE)


#check the lm_summary file
lm_summary <- read_excel("lm_summary.xlsx")
