setwd('C:\\Users\\kavit\\Downloads\\global_health_stats_1')
library("MASS")
library("rjags")

# Load and clean data
dat <- read.csv('Global Health Statistics.csv', header = TRUE)
df <- dat[complete.cases(dat), ]

head(df)

colnames(df) <- tolower(gsub("\\.+", "_", colnames(df)))
head(df)
df$population_affected <- as.integer(df$population_affected)
df$year <- as.integer(df$year)
df <- subset(df, year >= 2019 & disease_name == 'COVID-19')

head(df)
hist(prob = TRUE, df$population_affected , main = "Histogram of Population Affected")
df$deaths <- df$mortality_rate_ * df$population_affected/100
hist(prob = TRUE, df$deaths , main = "Histogram of Deaths")

boxplot(deaths ~ country, data = df, main = "Deaths vs. Country")
boxplot(deaths ~ age_group , data = df,main = "Deaths vs. Age Group" )
boxplot(deaths~ year, data = df, main = "Deaths vs. Year")
plot(x = df$deaths, y = df$urbanization_rate_,
     main = "Scatterplot of Deaths vs Urbanization Rate",
     xlab = "Deaths",
     ylab = "Urbanization Rate",
     pch = 19,        # solid circle
     col = "blue") 
abline(lm(urbanization_rate_ ~ deaths, data = df), col = "red", lwd = 2)

boxplot(deaths~ availability_of_vaccines_treatment, data = df, main = "Deaths vs. Availability of Vacccines")
boxplot(deaths~ age_group + gender, data = df, main = "Deaths vs. Age Group and Gender")
boxplot(deaths~ year, data = df, main = "Deaths vs. Year")
boxplot(deaths~ gender, data = df, main = "Deaths vs. Gender")

df$country <- as.numeric(factor(df$country))

# Convert categoricals to numeric
cat_cols <- c("age_group", "year")  
df[cat_cols] <- lapply(df[cat_cols], function(x) as.integer(factor(x)))


# Check distribution
hist(df$deaths, prob = TRUE,
     main = "Histogram of Deaths with Density Curve",
     xlab = "Deaths",
     col = "lightblue", border = "white")
lines(density(df$deaths), col = "red", lwd = 2)

df$deaths <- as.integer(df$deaths)
# Create design matrix
mod_glm <- glm(deaths ~ age_group + country + year, data = df, family = "poisson")
X <- model.matrix(mod_glm)[, -1]  # remove intercept

head(X)

# JAGS Data
data_jags <- list(
  X = X,
  y = df$deaths,  # Poisson response: count data
  N = nrow(df),
  P = ncol(X),
  age_group = as.numeric(factor(df$age_group)),
  country = as.numeric(factor(df$country)),
  year = as.numeric(factor(df$year)),  # optional if you want to model year-specific effects
  N_age_group = length(unique(df$age_group)),
  N_country = length(unique(df$country)),
  N_year = length(unique(df$year))  # optional
)

# JAGS Model
mod_string <- "
model {
  for (i in 1:N) {
    log(mu[i]) <- b0 +
                  inprod(b[], X[i,]) +
                  u_age_group[age_group[i]] +
                  u_country[country[i]] +
                  u_year[year[i]]
    y[i] ~ dpois(mu[i])
  }

  # Priors for fixed effects
  b0 ~ dnorm(0.0, 1.0E-4)
  for (j in 1:P) {
    b[j] ~ dnorm(0.0, 1.0E-4)
  }

  # Random effects for age_group
  for (g in 1:N_age_group) {
    z_age_group[g] ~ dnorm(0.0, 1.0)
    u_age_group[g] <- z_age_group[g] * sigma_age_group
  }

  # Random effects for country
  for (c in 1:N_country) {
    z_country[c] ~ dnorm(0.0, 1.0)
    u_country[c] <- z_country[c] * sigma_country
  }

  # Random effects for year
  for (y in 1:N_year) {
    z_year[y] ~ dnorm(0.0, 1.0)
    u_year[y] <- z_year[y] * sigma_year
  }

  # Priors for standard deviations
  sigma_age_group ~ dunif(0, 10)
  sigma_country ~ dunif(0, 10)
  sigma_year ~ dunif(0, 10)
}
"


# Init values
inits <- function() {
  list(
    b0 = 0,
    b = rep(0, data_jags$P),
    sigma_age_group = 1,
    sigma_country = 1,
    sigma_year = 1
  )
}


# Parameters to monitor
params <- c("b0", "b", "sigma_age_group", "sigma_country", "sigma_year")

# Compile model
library('rjags')
model <- jags.model(textConnection(mod_string), data = data_jags, inits = inits, n.chains = 3)

# Burn-in
update(model, 1000)

# Sampling
samples <- coda.samples(model, variable.names = params, n.iter = 5000)

# Output
summary(samples)
plot(samples)
gelman.diag(samples)
dic.samples(model, n.iter = 1000)
