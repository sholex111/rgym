# Load tidyverse package
library(tidyverse)

# Step 1: Create a dataframe with 20 observations and some missing values
set.seed(123)  # For reproducibility

df <- tibble(
  ID = 1:20,
  Age = sample(c(25:35, NA), 20, replace = TRUE),
  Height = sample(c(160:180, NA), 20, replace = TRUE),
  Weight = sample(c(60:90, NA), 20, replace = TRUE),
  Gender = sample(c("Male", "Female","unknown"), 20, replace = TRUE)
)

# Step 2: View the dataframe
print(df)

# Step 3: Check for missing values
# Check which cells are NA (missing)
is.na(df)     #produce true or false

# Count the number of missing values in the dataframe
sum(is.na(df))      #check total df
sum(is.na(df$Age))  #check individual column
#print(paste("Number of missing values in the dataframe:", missing_count))

# Step 4: Remove missing values from single column
df_cleaned <- df %>%
  drop_na(Age)


# Step 4: Remove rows with any missing values
df_cleaned <- df %>%
  drop_na()

#count the number of observations
df %>% count()
nrow(df)


#write.csv(df, file = "dummy_df.csv", row.names = FALSE)
#df <- read.csv("dummy_df.csv")

