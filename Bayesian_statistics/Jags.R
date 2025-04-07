library("rjags")

library("car")  # load the 'car' package
data("Anscombe")  # load the data set
?Anscombe  # read a description of the data
head(Anscombe)  # look at the first few lines of the data
pairs(Anscombe) 

library("rjags")


mod_string = " model {
    for (i in 1:length(education)) {
        education[i] ~ dnorm(mu[i], prec)
        mu[i] = b0 + b[1]*income[i] + b[2]*young[i] + b[3]*urban[i]
    }
    
    b0 ~ dnorm(0.0, 1.0/1.0e6)
    for (i in 1:3) {
        b[i] ~ dnorm(0.0, 1.0/1.0e6)
    }
    
    prec ~ dgamma(1.0/2.0, 1.0*1500.0/2.0)
    	## Initial guess of variance based on overall
    	## variance of education variable. Uses low prior
    	## effective sample size. Technically, this is not
    	## a true 'prior', but it is not very informative.
    sig2 = 1.0 / prec
    sig = sqrt(sig2)
} "

data_jags = as.list(Anscombe)

# Fit the model
jags_model <- jags.model(textConnection(mod_string), data = data_jags, n.chains = 3, n.adapt = 500)

# Burn-in
update(jags_model, 1000)

# Collect samples
params <- c("b0", "b", "sig")
samples <- coda.samples(jags_model, variable.names = params, n.iter = 5000)

# Generate traceplots
traceplot(samples[, "b0"], main = "Traceplot of b0", col = "blue")
traceplot(samples[, "b[1]"], main = "Traceplot of b1", col = "blue")
traceplot(samples[, "b[2]"], main = "Traceplot of b2", col = "blue")
traceplot(samples[, "b[3]"], main = "Traceplot of b3", col = "blue")
traceplot(samples[, "sig"], main = "Traceplot of sig", col = "blue")

# Check convergence
gelman.diag(samples)

install.packages("arm")
library(arm)

# Fit Bayesian linear model
bayes_model <- bayesglm(education ~ income + young + urban, data = Anscombe, family = gaussian())

# View model summary
summary(bayes_model)

posterior_intercept <- coef(bayes_model)[1]
round(posterior_intercept, 1)  #

display(bayes_model)

library(ggplot2)
lm_model <- lm(education ~ income + young + urban, data = Anscombe)
plot(lm_model)
dic_values <- dic.samples(jags_model, n.iter = 100000)
print(dic_values)
mod_string_1 = " model {
    for (i in 1:length(education)) {
        education[i] ~ dnorm(mu[i], prec)
        mu[i] = b0 + b[1]*income[i] + b[2]*young[i] + b[3]*income[i]*young[i]
    }
    
    b0 ~ dnorm(0.0, 1.0/1.0e6)
    for (i in 1:3) {
        b[i] ~ dnorm(0.0, 1.0/1.0e6)
    }
    
    prec ~ dgamma(1.0/2.0, 1.0*1500.0/2.0)
    	## Initial guess of variance based on overall
    	## variance of education variable. Uses low prior
    	## effective sample size. Technically, this is not
    	## a true 'prior', but it is not very informative.
    sig2 = 1.0 / prec
    sig = sqrt(sig2)
} "

data_jags_1 = as.list(Anscombe)

# Fit the model
jags_model_1 <- jags.model(textConnection(mod_string_1), data = data_jags_1, n.chains = 3, n.adapt = 500)

# Burn-in
update(jags_model_1, 1000)

# Collect samples
params_1 <- c("b0", "b", "sig")
samples_1 <- coda.samples(jags_model_1, variable.names = params, n.iter = 5000)

dic_values_1 <- dic.samples(jags_model_1, n.iter = 100000)
print(dic_values_1)



mod_string_2 = " model {
    for (i in 1:length(education)) {
        education[i] ~ dnorm(mu[i], prec)
        mu[i] = b0 + b[1]*income[i] + b[2]*young[i]
    }
    
    b0 ~ dnorm(0.0, 1.0/1.0e6)
    for (i in 1:3) {
        b[i] ~ dnorm(0.0, 1.0/1.0e6)
    }
    
    prec ~ dgamma(1.0/2.0, 1.0*1500.0/2.0)
    	## Initial guess of variance based on overall
    	## variance of education variable. Uses low prior
    	## effective sample size. Technically, this is not
    	## a true 'prior', but it is not very informative.
    sig2 = 1.0 / prec
    sig = sqrt(sig2)
} "

data_jags_2 = as.list(Anscombe)

# Fit the model
jags_model_2 <- jags.model(textConnection(mod_string_2), data = data_jags_1, n.chains = 3, n.adapt = 500)

# Burn-in
update(jags_model_2, 1000)

# Collect samples
params_1 <- c("b0", "b", "sig")
samples_2 <- coda.samples(jags_model_2, variable.names = params, n.iter = 5000)

dic_values_2 <- dic.samples(jags_model_2, n.iter = 100000)
print(dic_values_2)

income_samples <- as.matrix(samples)[, "b[1]"]

prob_income_positive <- mean(income_samples > 0)

rounded_prob <- round(prob_income_positive, 2)

cat("Posterior probability that the income coefficient is positive:", rounded_prob, "\n")

young_samples <- as.matrix(samples)[, "b[2]"]

prob_youth_positive <- mean(young_samples > 0)

rounded_prob <- round(prob_youth_positive, 2)

cat("Posterior probability that the youth coefficient is positive:", rounded_prob, "\n")



urban_samples <- as.matrix(samples)[, "b[3]"]

prob_urban_positive <- mean(urban_samples > 0)
rounded_prob <- round(prob_urban_positive, 2)


cat("Posterior probability that the urban coefficient is positive:", rounded_prob, "\n")



