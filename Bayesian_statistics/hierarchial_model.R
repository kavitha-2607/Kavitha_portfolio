setwd('C:\\Users\\kavit\\Downloads')

library(ggplot2)
library(gridExtra)
library(rjags)

# Load data
dat <- read.csv("pctgrowth.csv", header = TRUE)
dat$grp <- as.numeric(as.factor(dat$grp))  # ensure groups are numeric starting at 1

# Quick EDA
head(dat)
table(dat$grp)
hist(dat$y, main = "Histogram of y", xlab = "y")
boxplot(y ~ grp, data = dat, main = "Boxplot by Group")

# Simulate priors (optional visualization)
n_sim <- 500
tau2_pri <- 1 / rgamma(n_sim, shape = 0.5, rate = 0.65)
sigma2_pri <- 1 / rgamma(n_sim, shape = 1, rate = 1.05)
mu_pri <- rnorm(n_sim, mean = 0, sd = sqrt(1e6))
theta_pri <- matrix(nrow = n_sim, ncol = 5)
for (g in 1:5) {
  theta_pri[, g] <- rnorm(n_sim, mean = mu_pri, sd = sqrt(tau2_pri))
}

mod_string <- "
model {
  for (i in 1:N) {
    y[i] ~ dnorm(theta[grp[i]], 1 / sigma2)
  }

  for (j in 1:G) {
    theta[j] ~ dnorm(mu, 1 / tau2)
  }

  mu ~ dnorm(0.0, 1.0E-6)

  # sigma2 ~ Inverse-Gamma(1, 1.05)
  sigma2_inv ~ dgamma(1.0, 1.05)
  sigma2 <- 1 / sigma2_inv

  # tau2 ~ Inverse-Gamma(0.5, 0.65)
  tau2_inv ~ dgamma(0.5, 0.65)
  tau2 <- 1 / tau2_inv
}
"


# Prepare data for JAGS
data_jags <- list(
  y = dat$y,
  grp = dat$grp,
  N = length(dat$y),
  G = length(unique(dat$grp))
)

# Compile the model
jags_model <- jags.model(
  textConnection(mod_string),
  data = data_jags,
  n.chains = 3,
  n.adapt = 500
)

# Burn-in
update(jags_model, n.iter = 1000)

# Sample from posterior
samples <- coda.samples(
  model = jags_model,
  variable.names = c("mu", "tau2", "sigma2", "theta"),
  n.iter = 5000
)

# Summary
summary(samples)

means_anova = tapply(dat$y, INDEX=dat$grp, FUN=mean)
plot(means_anova)

means_theta <- summary(samples)[1]$statistics[,'Mean'][4: 8]
points(means_theta, col="red") ## where means_theta are the posterior point estimates for the industry means.