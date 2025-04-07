# Set seed for reproducibility
set.seed(42)

# Number of samples
n_samples <- 10000  

# Simulate from Beta(5,3)
theta_samples <- rbeta(n_samples, 5, 3)

# Compute the odds for each sampled theta
odds_samples <- theta_samples / (1 - theta_samples)

# Compute the posterior mean of the odds
posterior_mean_odds <- mean(odds_samples)

# Print the result rounded to 1 decimal place
round(posterior_mean_odds, 1)

ind <- theta_samples > 0.5
sum(ind)/10000

norm_samples <- rnorm(10000, 0,1)

quantile(norm_samples,probs = 0.3)
qnorm(0.3, 0,1)