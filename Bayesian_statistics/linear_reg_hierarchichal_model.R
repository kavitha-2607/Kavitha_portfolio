library("MASS")
data("OME")

dat = subset(OME, OME != "N/A")
dat$OME = factor(dat$OME) # relabel OME
dat$ID = as.numeric(factor(dat$ID)) # relabel ID so there are no gaps in numbers (they now go from 1 to 63)

## Original reference model and covariate matrix
mod_glm = glm(Correct/Trials ~ Age + OME + Loud + Noise, data=dat, weights=Trials, family="binomial")
X = model.matrix(mod_glm)[,-1]

## Original model (that needs to be extended)
mod_string1 = " model {
	for (i in 1:length(y)) {
		y[i] ~ dbin(phi[i], n[i])
		logit(phi[i]) = b0 + b[1]*Age[i] + b[2]*OMElow[i] + b[3]*Loud[i] + b[4]*Noiseincoherent[i]
	}
	
	b0 ~ dnorm(0.0, 1.0/5.0^2)
	for (j in 1:4) {
		b[j] ~ dnorm(0.0, 1.0/4.0^2)
	}
	
} "

data_jags = as.list(as.data.frame(X))
data_jags$y = dat$Correct
data_jags$n = dat$Trials
data_jags$ID = dat$ID
data_jags$N_ID = length(unique(dat$ID))


library("rjags")

# Set initial values
inits = function() {
  list(b0 = 0, b = rep(0, 4), sigma_u = 1, u = rep(0, data_jags$N_ID))
}

# Parameters to monitor
params = c("b0", "b", "sigma_u")

# Compile the model
model = jags.model(textConnection(mod_string), data = data_jags, inits = inits, n.chains = 3)

# Burn-in
update(model, 1000)

# Sample from the posterior
samples = coda.samples(model, variable.names = params, n.iter = 5000)

# Check summary
summary(samples)

plot(samples)          # Trace plots and density plots
gelman.diag(samples)

dic.samples(model, n.iter = 1000)


mod_string1 = "
model {
  for (i in 1:length(y)) {
    y[i] ~ dbin(phi[i], n[i])
    logit(phi[i]) <- alpha[ID[i]] + b[1]*Age[i] + b[2]*OMElow[i] + b[3]*Loud[i] + b[4]*Noiseincoherent[i]
  }

  for (j in 1:N_ID) {
    alpha[j] ~ dnorm(mu, dtau)
  }

  mu ~ dnorm(0.0, 1.0/100.0)
  dtau ~ dgamma(0.5, 0.5)
  tau <- 1 / sqrt(dtau)

  for (k in 1:4) {
    b[k] ~ dnorm(0.0, 1.0/16.0)
  }
}
"

data_jags = list(
  y = dat$Correct,
  n = dat$Trials,
  Age = X$Age,
  OMElow = X$OMElow,
  Loud = X$Loud,
  Noiseincoherent = X$Noiseincoherent,
  ID = dat$ID,
  N_ID = length(unique(dat$ID))
)



library("rjags")

# Set initial values
inits = function() {
  list(
    b = rep(0, 4),
    mu = 0,
    dtau = 1,
    alpha = rep(0, data_jags$N_ID)
  )
}

# Parameters to monitor
params = c("b", "mu", "tau", "alpha")

# Compile the model
model1 = jags.model(textConnection(mod_string1), data = data_jags, inits = inits, n.chains = 3)

# Burn-in
update(model1, 1000)

# Sample from the posterior
samples1 = coda.samples(model1, variable.names = params, n.iter = 5000)

# Check summary
summary(samples1)

plot(samples)          # Trace plots and density plots
gelman.diag(samples1)

dic.samples(model1, n.iter = 1000)


