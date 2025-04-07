library("MASS")
data("OME")
?OME # background on the data
head(OME)

any(is.na(OME)) # check for missing values
dat = subset(OME, OME != "N/A") # manually remove OME missing values identified with "N/A"
dat$OME = factor(dat$OME)
str(dat)

plot(dat$Age, dat$Correct / dat$Trials )
plot(dat$OME, dat$Correct / dat$Trials )
plot(dat$Loud, dat$Correct / dat$Trials )
plot(dat$Noise, dat$Correct / dat$Trials )

dat_clean <- na.omit(dat)
head(dat_clean)
numeric_vars <- sapply(dat, is.numeric)
Cor <- cor(dat[, numeric_vars], use = "complete.obs")
library(corrplot)

corrplot(Cor, type = "upper", method = "ellipse", tl.pos = "d")
corrplot(Cor, type = "lower", method = "number", col = "black", 
         add = TRUE, diag = FALSE, tl.pos = "n", cl.pos = "n")

mod_glm = glm(Correct/Trials ~ Age + OME + Loud + Noise, data=dat, weights=Trials, family="binomial")
summary(mod_glm)
plot(residuals(mod_glm, type="deviance"))
plot(fitted(mod_glm), dat$Correct/dat$Trials)
X = model.matrix(mod_glm)[,-1] # -1 removes the column of 1s for the intercept
head(X)

mod_string = " model {
	for (i in 1:length(y)) {
		y[i] ~ dbin(phi[i], n[i])
		logit(phi[i]) = b0 + b[1]*Age[i] + b[2]*OMElow[i] + b[3]*Loud[i] + b[4]*Noiseincoherent[i]
	}
	
	b0 ~ dnorm(0.0, 1.0/5.0^2)
	for (j in 1:4) {
		b[j] ~ dnorm(0.0, 1.0/4.0^2)
	}
	
} "



set.seed(92)
head(X)
library(R2jags)  # or 'rjags' if you prefer manual control


# Prepare the list of data for JAGS
data_jags = list(
  y = dat$Correct,
  n = dat$Trials,
  Age = X[, "Age"],
  OMElow = X[, "OMElow"],  # assuming you coded OME as a dummy variable
  Loud = X[, "Loud"],
  Noiseincoherent = X[, "Noiseincoherent"]
)

# Check structure
str(data_jags)

# Initial values (optional, can be randomized)
inits = function() {
  list(b0 = 0, b = rnorm(4, 0, 1))
}

# Parameters to monitor
params = c("b0", "b")

# After jags.model and burn-in (you already have this part)
mod1 = jags.model(textConnection(mod_string), data = data_jags, n.chains = 3)
update(mod1, 1000)  # burn-in

# Now collect posterior samples!
samples = coda.samples(mod1,
                       variable.names = c("b0", "b"),
                       n.iter = 5000)

# Now you can summarize and diagnose:
summary(samples)
plot(samples)
gelman.diag(samples)
raftery.diag(samples)
effectiveSize(samples)

# Values
beta_0    <- -7.26377
beta_age  <- 0.01872 
beta_ome  <- -0.24041
beta_loud <-   0.17120
beta_noise <-  1.57778

AGE       <- 60
OMElow    <- 0    # Because it's High OME
LOUD      <- 50
NOISE     <- 0    # Coherent stimulus

# Compute logit(p)
logit_p <- beta_0 + beta_age * AGE + beta_ome * OMElow + beta_loud * LOUD + beta_noise * NOISE

# Convert to probability
p <- 1 / (1 + exp(-logit_p))

# Round to two decimal places
round(p, 2)


samples_mat <- as.matrix(samples)
colnames(samples_mat)
posterior_means <- colMeans(samples_mat)
print(posterior_means)

b0 <- posterior_means["b0"]
b1 <- posterior_means["b[1]"]  # Age
b2 <- posterior_means["b[2]"]  # OMElow
b3 <- posterior_means["b[3]"]  # Loud
b4 <- posterior_means["b[4]"]
age <- 60
OMElow <- 0
loud <- 50
noiseincoherent <- 0
xb <- b0 + b1 * age + b2 * OMElow + b3 * loud + b4 * noiseincoherent
prob <- 1 / (1 + exp(-xb))
round(prob,2)
prob

# Recreate the model matrix used in JAGS (excluding intercept)
X <- model.matrix(mod_glm)[,-1]

# Calculate linear predictor xb for each row
xb <- b0 + b1 * X[, "Age"] +
           b2 * X[, "OMElow"] +
           b3 * X[, "Loud"] +
           b4 * X[, "Noiseincoherent"]

# Apply inverse logit to get probabilities
phat <- 1 / (1 + exp(-xb))
observed <- dat$Correct / dat$Trials

# Apply classification rule
classified_correctly <- ((phat > 0.7) & (observed > 0.7)) |
                        ((phat <= 0.7) & (observed <= 0.7))

# Proportion correctly classified
accuracy <- mean(classified_correctly)
round(accuracy, 2)