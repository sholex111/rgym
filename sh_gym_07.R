##Simple predictive modelling by Shotech


# Set seed for reproducibility
set.seed(123)

# Create a sequence for the years (past 20 years)
years <- seq(2004, 2023)

# Create hypothetical data for total population (in thousands)
total_population <- round(runif(20, min = 500, max = 1000)) # between 500k and 1000k

# Create hypothetical data for population over 65 years (in thousands)
population_over_65 <- round(total_population * runif(20, min = 0.10, max = 0.20)) # 10%-20% over 65

# Create a hypothetical disease population based on some relationship with total population and population over 65
disease_population <- round(0.05 * total_population + 0.1 * population_over_65 + rnorm(20, mean = 0, sd = 10)) # Disease depends on both variables

# Create a data frame
data <- data.frame(years, total_population, population_over_65, disease_population)

# Display the data
print(data)





# Perform regression analysis
model <- lm(disease_population ~ total_population + population_over_65, data = data)

# View the summary of the regression model
summary(model)


######
# predict

# Create a new data frame with the values for prediction
new_data <- data.frame(total_population = 900, population_over_65 = 200)
new_data <- data.frame(total_population = c(500,600, 700), population_over_65 = c(130, 140, 150))



# Use the predict function to estimate disease_population for the new data
predicted_dx_pop <- predict(model, newdata = new_data)


# Print the predicted disease population
print(predicted_dx_pop)

new_predicted <- data.frame(new_data,predicted_dx_pop)

#compare both side by side
print(data)
print(new_predicted)

