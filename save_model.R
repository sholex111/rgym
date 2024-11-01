

#save model and predict with saved model



# Poission regression


# Load necessary libraries
library(dplyr)


hospital_data <- read.csv("C:/Users/shole/OneDrive/Data Bank/poisson regression/hospital_admission.csv")

# View the first few rows of the data
head(hospital_data)



# Fit Poisson regression model
poisson_model <- glm(admissions ~ weekday + temperature + holiday, 
                     family = poisson(link = "log"), 
                     data = hospital_data)

# View the model summary
summary(poisson_model)


# save model
# saveRDS(poisson_model, "predict_admission.rds")


#Load the model
model <- readRDS("predict_admission.rds")



# Create new data for prediction
new_hosp_data <- data.frame(
  weekday = c("Mon", "Tue", "Wed", "Sat"),
  temperature = c(68, 72, 75, 80),
  holiday = c(0, 1, 0, 0)
)


# Predict admissions
predicted_admissions <- predict(model, newdata = new_hosp_data, type = "response")
predicted_admissions


#create new dataframe with the predicted data
predicted_hosp_adm_merged <- data.frame(new_hosp_data, predicted_admissions)
predicted_hosp_adm_merged





