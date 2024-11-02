


## Forecasting with ARIMAX (using auto.arima from the forecast package)

# Load required libraries
library(forecast)
library(dplyr)


######

## load data
data <-  read.csv("hospital_emergency_data.csv")

## Create time-series object
admissions_ts <- ts(data$Emergency_Admission, start = c(data$Year[1], data$Month[1]), frequency = 12)

# Step 2: Visualize the Data
plot(admissions_ts, main = "Emergency Admissions Over Time", ylab = "Admissions", xlab = "Time")


# Step 3: Fit ARIMA Model
arima_model <- auto.arima(admissions_ts)
summary(arima_model)

# Step 4: Forecast the Next 12 Months with ARIMA
arima_forecast <- forecast(arima_model, h = 12)

print(arima_forecast)

# Optional: Save Forecasted Values
arima_forecasted_values <- arima_forecast$mean

plot(arima_forecast, main = "ARIMA Forecast for Emergency Admissions")


#####
# Step 5: Fit ARIMAX Model with Total_Population as the external variable
# Here, we use 'Total_Population' as the external predictor variable (xreg).
arimax_model <- auto.arima(admissions_ts, xreg = data$Total_Population)
summary(arimax_model)


#####
# Forecast the Next 12 Months with ARIMAX
# Prepare future values for 'Total_Population' for the next 12 months.
# Replace 'future_total_population' with the actual vector of predicted or expected values for the next 12 months.
# future_data <- matrix(future_total_population, ncol = 1)  # Ensure this has 12 rows, one for each month forecasted
## Future data should have all the columns as in the main data, it's a kind of train and test data


## arimax_forecast <- forecast(arimax_model, xreg = future_data, h = 12)

# Plot the ARIMAX forecast
## plot(arimax_forecast, main = "ARIMAX Forecast for Emergency Admissions with Total Population")




# 
# if (exists("arimax_forecast")) {
#   arimax_forecasted_values <- arimax_forecast$mean
# }






#####
## Use ETS model

## Fit ETS Model

ets_model <- ets(admissions_ts)
summary(ets_model)


## Forecast the Next 12 Months
ets_forecast <- forecast(ets_model, h = 12)
plot(ets_forecast, main = "ETS Forecast for Emergency Admissions")

# Optional: Save Forecasted Values
ets_forecasted_values <- ets_forecast$mean
ets_forecasted_values


## Evaluate and Interpret the Forecast
print(ets_forecast)


#####
## Some exploration

avg_adm <- data %>% summarise(avg_mth = mean(Emergency_Admission), .by = Month)

arima_forecasted_df <- as.data.frame(arima_forecasted_values)

ets_forecasted_df <- as.data.frame(ets_forecasted_values)


## combime the dataframes

# Add Month column to arima_forecasted_df and ets_forecasted_df
arima_forecasted_df <- arima_forecasted_df %>%
  mutate(Month = 1:12)

ets_forecasted_df <- ets_forecasted_df %>%
  mutate(Month = 1:12)

# Rename columns in arima_forecasted_df and ets_forecasted_df for clarity
colnames(arima_forecasted_df)[1] <- "arima_forecast"
colnames(ets_forecasted_df)[1] <- "ets_forecast"


# Now, join all three data frames by Month
combined_df <- avg_adm %>%
  left_join(arima_forecasted_df, by = "Month") %>%
  left_join(ets_forecasted_df, by = "Month")

# View the combined data frame
print(combined_df)




