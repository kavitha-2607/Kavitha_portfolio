x1 <- 0.8 
x2 <- 1.2
b0 <- 1.5
b1 <- -0.3
b2 <- 1.0

ey <- exp(b0 + b1 * x1 + b2 * x2)

round(ey, 1)
install.packages("COUNT")
library("COUNT")
data("badhealth")
?badhealth
head(badhealth)
library("rjags")
mod_string = " model {
    for (i in 1:length(numvisit)) {
        numvisit[i] ~ dpois(lam[i])
        log(lam[i]) = int + b_badh*badh[i] + b_age*age[i] + b_intx*age[i]*badh[i]
    }
    
    int ~ dnorm(0.0, 1.0/1e6)
    b_badh ~ dnorm(0.0, 1.0/1e4)
    b_age ~ dnorm(0.0, 1.0/1e4)
    b_intx ~ dnorm(0.0, 1.0/1e4)
} "

set.seed(102)

data_jags = as.list(badhealth)

params = c("int", "b_badh", "b_age", "b_intx")

mod = jags.model(textConnection(mod_string), data=data_jags, n.chains=3)
update(mod, 1e3)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=5e3)
mod_csim = as.mcmc(do.call(rbind, mod_sim))

## convergence diagnostics
plot(mod_sim)

gelman.diag(mod_sim)
autocorr.diag(mod_sim)
autocorr.plot(mod_sim)
effectiveSize(mod_sim)

## compute DIC
dic = dic.samples(mod, n.iter=1e3)

print(dic)


mod_string_1 = " model {
    for (i in 1:length(numvisit)) {
        numvisit[i] ~ dpois(lam[i])
        log(lam[i]) = int + b_badh*badh[i] + b_age*age[i]
    }
    
    int ~ dnorm(0.0, 1.0/1e6)
    b_badh ~ dnorm(0.0, 1.0/1e4)
    b_age ~ dnorm(0.0, 1.0/1e4)
    b_intx ~ dnorm(0.0, 1.0/1e4)
} "
set.seed(102)

data_jags = as.list(badhealth)

params = c("int", "b_badh", "b_age", "b_intx")

mod1 = jags.model(textConnection(mod_string_1), data=data_jags, n.chains=3)
update(mod1, 1e3)

mod_sim_1 = coda.samples(model=mod1,
                        variable.names=params,
                        n.iter=5e3)
mod_csim_1 = as.mcmc(do.call(rbind, mod_sim_1))

## convergence diagnostics
plot(mod_sim_1)
dic1 <- dic.samples(mod1, n.iter=1e3)
print(dic)
print(dic1)

p22 <- ppois(21, lambda = 30)
round(p22, 2)

dat = read.csv(file="C:\\Users\\kavit\\Downloads\\callers_csv.csv", header=TRUE)
head(dat)

boxplot(calls / days_active ~ isgroup2, data = dat,
        xlab = "Group", ylab = "Average Calls per Day",
        main = "Boxplot of Calls per Day by Group")

library(R2jags)
model_string <- "
model {
  for (i in 1:N) {
    calls[i] ~ dpois(lambda[i])
    log(lambda[i]) <- log(days_active[i]) + b0 + b1 * age[i] + b2 * isgroup2[i]
  }

  # Priors
  b0 ~ dnorm(0, 0.01)
  b1 ~ dnorm(0, 0.01)
  b2 ~ dnorm(0, 0.01)
}
"
inits <- function() {
  list(b0 = 0, b1 = 0, b2 = 0)
}

params <- c("b0", "b1", "b2")

set.seed(123)
data_jags <- list(
  N = nrow(dat),
  calls = dat$calls,
  days_active = dat$days_active,
  age = dat$age,
  isgroup2 = dat$isgroup2
)
fit <- jags(
  data = data_jags,
  inits = inits,
  parameters.to.save = params,
  model.file = textConnection(model_string),
  n.chains = 3,
  n.iter = 5000,
  n.burnin = 1000
)

print(fit)
samples <- as.mcmc(fit)
plot(samples)
gelman.diag(samples)

samples_matrix <- as.matrix(samples)
prob_beta2_gt0 <- mean(samples_matrix[, "b2"] > 0)
round(prob_beta2_gt0, 2)