



###Logistic regression conditions

# # Set seed for reproducibility
# set.seed(321)
# 
# # Generate 100 observations
# n <- 100
# 
# # Predictor variables
# Age <- round(rnorm(n, mean = 50, sd = 10))            # Age, centered around 50
# Cholesterol <- round(rnorm(n, mean = 200, sd = 30))    # Cholesterol, centered around 200
# BloodPressure <- round(rnorm(n, mean = 120, sd = 15))  # BloodPressure, centered around 120
# 
# # Logistic regression parameters
# beta_0 <- -10              # Intercept
# beta_age <- 0.05           # Coefficient for Age
# beta_cholesterol <- 0.02   # Coefficient for Cholesterol
# beta_blood_pressure <- 0.03 # Coefficient for BloodPressure
# 
# # Calculate logit and probability
# logit <- beta_0 + beta_age * Age + beta_cholesterol * Cholesterol + beta_blood_pressure * BloodPressure
# prob <- 1 / (1 + exp(-logit))
# 
# # Generate binary outcome Y based on the calculated probabilities
# Y <- rbinom(n, size = 1, prob = prob)
# 
# # Combine into a data frame
# patient_df <- data.frame(Age = Age, Cholesterol = Cholesterol, BloodPressure = BloodPressure, Y = Y)
# 
# # Display the first few rows
# head(patient_df)


#pt_data <-  read.csv("C:/xxxxx.csv")


# Fit an Initial Logistic Regression Model
model <- glm(Y ~ Age + Cholesterol + BloodPressure, data = pt_data, family = "binomial")




## Check Linearity with the Box-Tidwell Transformation:

## The Box-Tidwell transformation is a common method to test for linearity of the logit. 
## This involves adding interaction terms between each continuous predictor and its log-transformed version.


# Check Linearity with the Box-Tidwell Transformation
pt_data$log_Age <- log(pt_data$Age)
pt_data$log_Cholesterol <- log(pt_data$Cholesterol)
pt_data$log_BloodPressure <- log(pt_data$BloodPressure)


model_test <- glm(Y ~ Age * log_Age + Cholesterol * log_Cholesterol + BloodPressure * log_BloodPressure, 
                  data = pt_data, family = "binomial")


summary(model_test)



## If the interaction terms (Age:log_Age, Cholesterol:log_Cholesterol, BloodPressure:log_BloodPressure) 
## are significant, this suggests a non-linear relationship with the logit.


# Plotting to Check Linearity Visually:

## Another way is to create logit plots for each predictor. 
## This involves plotting the log-odds of the outcome (obtained by a logistic regression fit) 
#against each predictor.


# Visual Check for Linearity of the Logit
library(ggplot2)


# Predict logit values
pt_data$logit <- predict(model, type = "link")



ggplot(pt_data, aes(x = Age, y = logit)) +
  geom_point() + geom_smooth(method = "loess") +
  labs(title = "Linearity Check for Age")

ggplot(pt_data, aes(x = Cholesterol, y = logit)) +
  geom_point() + geom_smooth(method = "loess") +
  labs(title = "Linearity Check for Cholesterol")

ggplot(pt_data, aes(x = BloodPressure, y = logit)) +
  geom_point() + geom_smooth(method = "loess") +
  labs(title = "Linearity Check for Blood Pressure")


## if linearity is not met. Consider transforming the variables (Square, log etc)
## The AIC is a common measure to compare model fit, 
## with lower AIC values indicating a better model fit (while accounting for model complexity).

model_trans_1 <- glm(Y ~ Age + Cholesterol + poly(BloodPressure, 2), data = pt_data, family = "binomial")
summary(model_trans_1)



##other transformations:
model_trans_2 <- glm(Y ~ Age + sqrt(Cholesterol) + log(BloodPressure), 
             data = pt_data, family = "binomial")
summary(model_trans_2)

model_trans_3 <- glm(Y ~ Age + sqrt(Cholesterol) + BloodPressure, 
             data = pt_data, family = "binomial")
summary(model_trans_3)


model_trans_4 <- glm(Y ~ I(Age^2) + sqrt(Cholesterol) + log(BloodPressure), 
             data = pt_data, family = "binomial")
summary(model_trans_4)




## Likelihood Ratio Test
## The likelihood ratio test compares the fit of two nested models. 
## In this case, if the transformed model has additional terms compared to the original model, you can use this test.

## Use the anova function with test = "Chisq" to compare the models:

## A significant p-value indicates that the transformed model provides
## a statistically better fit to the data than the original model.


## Use Splines or Binning: Add spline terms or create bins (categories) for non-linear predictors.


library(splines)
model_trans_2 <- glm(Y ~ ns(Age, df = 3) + Cholesterol + BloodPressure, data = pt_data, family = "binomial")



## Consider Generalized Additive Models (GAMs): If the non-linearity is complex, 
## a GAM might be more suitable as it allows non-linear relationships without specifying the exact form.


library(mgcv)
model_trans_3 <- gam(Y ~ s(Age) + Cholesterol + BloodPressure, data = pt_data, family = "binomial")



#Compare models for performance

anova(model, model_trans_1, test = "Chisq")



## Pseudo R-squared
## Pseudo R-squared measures like McFadden’s R² provide a way to assess 
## model fit in logistic regression. Higher values indicate better model performance.

## You can calculate it using packages like pscl:

# Pseudo R-squared

library(pscl)

pR2(model)
pR2(model_trans_1)




# Residual Deviance
## The residual deviance measures how well the model fits the data; lower values indicate better fit.

## You can check the residual deviance of each model using the summary function:
  

summary(model)$deviance
summary(model_trans_1)$deviance


