library(rstan)

# Bernoulli Logistic Regression for Ungrouped Data
nasa <- '
data {                          
int<lower=0> N;                       // number of observations
int<lower=0,upper=1> y[N];            // setting the dependent variable (damage) as binary
vector[N] x;                          // independent variable 
}
parameters {
real b_0;                           // intercept
real b_1;                            // beta for thermal
}
model {
b_0  ~ normal(0,100);
b_1 ~ normal(0,100);
for (n in 1:N)
      y[n] ~ bernoulli(inv_logit(b_0 + b_1 * x[n]));
}
'

thermal = c(53,57,58,63,66,67,67,67,68,69,70,70,70,70,72,73,75,75,76,76,78,79,81)
damage  = c(1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0)
rings   = data.frame(thermal,damage);head(rings)
data    = list(N = nrow(rings), y = rings$damage, x= rings$thermal)

# Estimate the model
fit =  stan(model_code = nasa, 
            data       = data, 
            iter       = 4000, 
            chains     = 4,
            seed       =1234,
            control = list(max_treedepth = 15))

print(fit, digits = 3)
plot(fit)

stan_dens(fit)
stan_hist(fit)
pairs(fit)
plot(fit, plotfun = "trace")
