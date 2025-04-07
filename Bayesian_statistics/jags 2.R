data('PlantGrowth')

head(PlantGrowth)

boxplot(weight ~ group, data=PlantGrowth)

lmod = lm(weight ~ group, data=PlantGrowth)
summary(lmod)

library("rjags")

mod_string = " model {
    for (i in 1:length(y)) {
        y[i] ~ dnorm(mu[grp[i]], prec)
    }
    
    for (j in 1:3) {
        mu[j] ~ dnorm(0.0, 1.0/1.0e6)
    }
    
    prec ~ dgamma(5/2.0, 5*1.0/2.0)
    sig = sqrt( 1.0 / prec )
} "

set.seed(82)
str(PlantGrowth)
data_jags = list(y=PlantGrowth$weight, 
              grp=as.numeric(PlantGrowth$group))

params = c("mu", "sig")

inits = function() {
    inits = list("mu"=rnorm(3,0.0,100.0), "prec"=rgamma(1,1.0,1.0))
}

set.seed(82)
str(PlantGrowth)
data_jags = list(y=PlantGrowth$weight, 
              grp=as.numeric(PlantGrowth$group))

params = c("mu", "sig")

inits = function() {
    inits = list("mu"=rnorm(3,0.0,100.0), "prec"=rgamma(1,1.0,1.0))
}

mod = jags.model(textConnection(mod_string), data=data_jags, inits=inits, n.chains=3)
update(mod, 1e3)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=5e3)
mod_csim = as.mcmc(do.call(rbind, mod_sim)) 


plot(mod_sim)

gelman.diag(mod_sim)
autocorr.diag(mod_sim)
effectiveSize(mod_sim)


summary(mod_sim)





mod_string_var = " 
model {
    for (i in 1:length(y)) {
        y[i] ~ dnorm(mu[grp[i]], prec[grp[i]])
    }

    for (j in 1:3) {
        mu[j] ~ dnorm(0.0, 1.0/1.0e6)  # Weakly informative prior for means
        prec[j] ~ dgamma(5/2.0, 5*1.0/2.0)  # Separate priors for each group's variance
        sig[j] = sqrt(1.0 / prec[j])  # Convert precision to standard deviation
    }
} "

set.seed(82)
data_jags = list(
    y = PlantGrowth$weight, 
    grp = as.numeric(PlantGrowth$group)
)

params = c("mu", "sig")

inits = function() {
    list("mu" = rnorm(3, 0.0, 100.0), "prec" = rgamma(3, 1.0, 1.0))  # 3 independent precisions
}
library(rjags)

# Initialize the model
jags_model_1 <- jags.model(textConnection(mod_string_var), data = data_jags, inits = inits, n.chains = 3, n.adapt = 500)

# Burn-in
update(jags_model_1, 1000)

# Collect samples
samples_1 <- coda.samples(jags_model_1, variable.names = params, n.iter = 5000)

# Summarize results
summary(samples_1)
summary(mod_sim)
dic1 <- dic.samples(mod,  n.iter = 100000)
dic2 <- dic.samples(jags_model_1,  n.iter = 100000)

dic1 - dic2

mu_samples <- as.matrix(mod_sim)  # Convert coda object to matrix
mu_1 <- mu_samples[, "mu[1]"]
mu_3 <- mu_samples[, "mu[3]"]

mu_diff <- mu_3 - mu_1

hpd_interval <- HPDinterval(as.mcmc(mu_diff), prob = 0.95)
print(hpd_interval)
