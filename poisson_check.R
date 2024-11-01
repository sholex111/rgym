##check poisson distribution


library(ggplot2)
library(dplyr)
library(vcd)


hospital_data <- read.csv("C:/xxxx.csv")

# View the first few rows of the data
head(hospital_data)


##  A Poisson distribution has specific properties you can test:
  
##  Mean ≈ Variance: In a Poisson distribution, the mean and variance should be close. Calculate the mean and variance of admissions and compare them.

mean_admissions <- mean(hospital_data$admissions)
var_admissions <- var(hospital_data$admissions)


mean_admissions #20
var_admissions  #24.24


## If the variance is substantially larger than the mean (overdispersion), 
## This suggests that the data might not be Poisson-distributed, 
## and an alternative model like negative binomial regression might be more appropriate.



##Visualize the Distribution of admissions
##Create a histogram or density plot of admissions to visually assess if it resembles a Poisson distribution, 
##which typically has a right-skewed shape.


hist(hospital_data$admissions, main = "Histogram of Admissions", xlab = "Admissions", breaks = 10)




# write it with ggplot

# ggplot(hospital_data, aes(x = admissions)) +
#   geom_histogram(bins = 10, fill = "steelblue", color = "black", alpha = 0.7) +
#   stat_ecdf(geom = "line", color = "red", size = 1) +
#   labs(title = "Histogram of Admissions with Ogive", 
#        x = "Admissions", y = "Frequency") +
#   theme_minimal()
# 


## You can also plot the observed frequencies against expected Poisson frequencies 
## using a goodness-of-fit test like the Chi-square test.

## Statistical Tests for Poisson Fit
## The Goodness-of-Fit Test can statistically assess if admissions follows a Poisson distribution. 
## In R, you can use the chisq.test() function on binned data, 
## comparing observed counts to expected counts from a Poisson distribution.


# Use goodness-of-fit test for Poisson distribution fit

# Perform the goodness-of-fit test
fit <- goodfit(hospital_data$admissions, type = "poisson")

# Summary of the goodness-of-fit test
summary(fit)




plot(fit, main = "Goodness-of-Fit for Poisson Distribution")


## Assessing Model Fit for Poisson Regression
## Once you've verified that the admissions data is roughly Poisson-distributed, 
## you can assess if a Poisson regression model fits well by:

## Checking the Residual Deviance: In the Poisson regression summary output, 
## if the residual deviance is close to the degrees of freedom, it suggests a good model fit.

## Overdispersion Test: Compute a dispersion statistic by dividing the 
## residual deviance by the degrees of freedom. 
## If this value is close to 1, it suggests an appropriate Poisson model. 
## If it’s significantly larger, negative binomial regression might be better.



# Fit Poisson regression model
poisson_model <- glm(admissions ~ weekday + temperature + holiday, 
                     family = poisson(link = "log"), 
                     data = hospital_data)


# Dispersion statistic
dispersion_statistic <- deviance(poisson_model) / df.residual(poisson_model)
dispersion_statistic





