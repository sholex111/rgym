


## Forecasting with ARIMAX (using auto.arima from the forecast package)

# Load required libraries
library(forecast)
library(dplyr)


######
# Assuming 'data' is your data frame and 'Emergency_Admission' is the admissions column
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



