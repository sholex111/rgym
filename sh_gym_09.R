#install necessary library

# Load the dataset
data(mtcars)

# Fit the logistic regression model
model <- glm(am ~ disp + hp, data = mtcars, family = binomial)

# Predict probabilities for each observation
mtcars$predicted_prob <- predict(model, type = "response")

# View the first few rows of the dataset with predicted probabilities
head(mtcars)


#Model parameters

# Load necessary library
library(caret)

# Create a confusion matrix
predicted_classes <- ifelse(mtcars$predicted_prob > 0.5, 1, 0)
confusionMatrix(as.factor(predicted_classes), as.factor(mtcars$am))



# Load necessary library
library(pROC)

# Calculate ROC curve and AUC
roc_curve <- roc(mtcars$am, mtcars$predicted_prob)
plot(roc_curve)
auc(roc_curve)

# View model summary
summary(model)


# Calculate McFadden's R-squared
null_model <- glm(am ~ 1, data = mtcars, family = binomial)
1 - logLik(model) / logLik(null_model)

#use model to predict new unseen data

# Example new data
new_data <- data.frame(disp = c(125, 180, 160, 185, 80), hp = c(91, 90, 108, 95, 60))

# Predict probabilities for new data
new_data$predicted_prob <- predict(model, newdata = new_data, type = "response")

# View the new data with predicted probabilities
print(new_data)





