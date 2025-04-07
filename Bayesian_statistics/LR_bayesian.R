# Load necessary package
library(rstanarm)

# Read data
data <- read.table("https://users.stat.ufl.edu/~winner/data/pgalpga2008.dat")

# Subset for female golfers (V3 == 1) and select relevant columns
datF <- subset(data, V3 == 1, select = 1:2)
colnames(datF) <- c("drive_distance", "accuracy")

# Fit Bayesian linear regression with non-informative priors
modelF <- stan_glm(accuracy ~ drive_distance, data = datF, 
                   prior = NULL, prior_intercept = NULL)

# Create new data frame for prediction (x = 260 yards)
new_distance <- data.frame(drive_distance = 260)

# Obtain posterior predictive mean estimate
predicted_accuracy <- posterior_epred(modelF, newdata = new_distance)

# Compute the mean of the posterior predictions
posterior_mean_accuracy <- mean(predicted_accuracy)

# Print rounded result to one decimal place
print(round(posterior_mean_accuracy, 1))

posterior_predictions <- posterior_predict(modelF, newdata = new_distance)

interval <- quantile(posterior_predictions, probs = c(0.025, 0.975))
