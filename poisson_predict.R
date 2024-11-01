# Poission regression


# Load necessary libraries
library(dplyr)

# Create a hypothetical dataset
# set.seed(333)
# hospital_data <- data.frame(
#   day = 1:100,  # Days numbered from 1 to 100
#   weekday = sample(c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"), 100, replace = TRUE),
#   temperature = rnorm(100, mean = 70, sd = 10),  # Random temperature data
#   holiday = sample(c(0, 1), 100, replace = TRUE),  # 1 if it's a holiday, 0 otherwise
#   admissions = rpois(100, lambda = 20)  # Simulated admissions using a Poisson distribution
# )

#write.csv(hospital_data, "C:xxxx.csv")     #write to your pc for data consistency

#hospital_data <- read.csv("C:/xxxx.csv")


# View the first few rows of the data
head(hospital_data)



# Fit Poisson regression model
poisson_model <- glm(admissions ~ weekday + temperature + holiday, 
                     family = poisson(link = "log"), 
                     data = hospital_data)

# View the model summary
summary(poisson_model)


#Go to prediction
# Create new data for prediction
new_hosp_data <- data.frame(
  weekday = c("Mon", "Tue", "Wed"),
  temperature = c(68, 72, 75),
  holiday = c(0, 1, 0)
)

# Predict admissions
predicted_admissions <- predict(poisson_model, newdata = new_hosp_data, type = "response")
predicted_admissions

predicted_admissions_merged <- data.frame(new_hosp_data, predicted_admissions)












