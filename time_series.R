
#Forcasting in a timeseries model

# Load necessary packages
library(forecast)
library(tidyverse)


#####
# ## Generate data
# # Set random seed for reproducibility
# set.seed(321)
# 
# # Generate sample data for 4 years (48 months)
# months <- seq(as.Date("2019-01-01"), by = "month", length.out = 48)
# years <- as.numeric(format(months, "%Y"))
# seasons <- (as.numeric(format(months, "%m")) %% 12 + 3) %/% 3  # Approximate season mapping: 1=Winter, 2=Spring, 3=Summer, 4=Fall
# 
# # Generate synthetic predictor variables with plausible patterns
# total_population <- 100000 + sample(-500:500, 48, replace = TRUE)
# total_clinic_visits <- sample(3000:7000, 48, replace = TRUE)
# avg_monthly_rainfall <- runif(48, 0, 200)
# avg_temperature <- runif(48, 10, 35)  # Assume degrees Celsius
# monthly_crime_rate_per_1000 <- runif(48, 1, 5)
# 
# 
# # Generate emergency admissions with seasonality and some dependency on the other predictors
# base_admissions <- 1000 + (seasons * 200)  # seasonal effect
# trend <- seq(0, 50, length.out = 48)  # slight trend over the years
# emergency_admission <- (
#   base_admissions +
#     0.03 * total_population / 1000 +             # slight effect from population
#     0.1 * total_clinic_visits +                  # effect from clinic visits
#     -2 * avg_monthly_rainfall +                  # negative effect from rainfall
#     3 * avg_temperature +                        # positive effect from temperature
#     15 * monthly_crime_rate_per_1000 +           # effect from crime rate
#     rnorm(48, 0, 50)                             # random noise
# )
# 
# 
# # convert emergency admission to whole number
# emergency_admission <- round(emergency_admission)
# 
# 
# # Create the DataFrame
# data <- data.frame(
#   Date = months,
#   Year = years,
#   Month = as.numeric(format(months, "%m")),
#   Total_Population = total_population,
#   Total_Clinic_Visits = total_clinic_visits,
#   Season = seasons,
#   Avg_Monthly_Rainfall = avg_monthly_rainfall,
#   Avg_Temperature = avg_temperature,
#   Monthly_Crime_Rate_Per_1000 = monthly_crime_rate_per_1000,
#   Emergency_Admission = emergency_admission
# )
# 


#####

## Dynamic Regression with ARIMAX (using auto.arima from the forecast package)

# load data
data <-  read.csv("hospital_emergency_data.csv")


# Convert Date column to Date format
data$Date <- as.Date(data$Date)
data <- data %>% arrange(Date)



# # Split into training (first 3 years) and testing (final 1 year)
# train_data <- data[1:36, ]
# test_data <- data[37:48, ]


# Separate train and test datasets
train_data <- data %>% filter(Date < as.Date("2022-01-01"))
test_data <- data %>% filter(Date >= as.Date("2022-01-01"))


# Set the time series for emergency admissions (using monthly frequency)
y_train <- ts(train_data$Emergency_Admission, frequency = 12, start = c(2019, 1))


# Prepare exogenous variables
xreg_train <- train_data %>% select(Total_Clinic_Visits, Avg_Monthly_Rainfall, Avg_Temperature, Monthly_Crime_Rate_Per_1000)
xreg_test <- test_data %>% select(Total_Clinic_Visits, Avg_Monthly_Rainfall, Avg_Temperature, Monthly_Crime_Rate_Per_1000)


# Fit ARIMAX model
fit_arimax <- auto.arima(y_train, xreg = as.matrix(xreg_train))


# Forecast for next 12 months using test exogenous variables
forecast_arimax <- forecast(fit_arimax, xreg = as.matrix(xreg_test), h = 12)


# Plot and evaluate
autoplot(forecast_arimax) +
  ggtitle("ARIMAX Forecast of Emergency Admissions")


print(accuracy(forecast_arimax, test_data$Emergency_Admission))


#####

# Display the forecasted values
print(forecast_arimax)

# Extract forecasted values and associated dates
predicted_values <- forecast_arimax$mean           # Forecasted emergency admissions
forecasted_dates <- time(forecast_arimax)          # Time index of the forecast

# Combine into a data frame for easier viewing
results <- data.frame(Date = test_data$Date, 
                      Predicted_Emergency_Admission = predicted_values,
                      lower_95 <- forecast_arimax$lower[, 2] ,  # Lo CI 95
                      upper_95 <- forecast_arimax$upper[, 2] ,  # Hi CI 95
                      Real_Emergency_Admission = test_data$Emergency_Admission )



