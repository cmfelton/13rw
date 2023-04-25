## This is the script for conducting the sample-splitting, 
## type-M, and measurement error simulations. The script contains
## all the functions required for the simulations so you can
## run it on its own. Some functions are copied from 
## analysis_functions.R to read in the data, produce ts objects, 
## and calculate conformal p-values.

## These take a while to run, so I'd run a few sets of simulations 
## overnight.

#install.packages("tidyverse")
#install.packages("forecast")
#install.packages("urca")
#install.packages("extraDistr")
#install.packages("astsa")

library(tidyverse)
library(forecast)
library(urca)
library(extraDistr)
library(astsa)

#### FUNCTIONS ####

## PREPARING TS OBJECTS

#This function takes in a dataframe
#and outputs several time series
#that can be fed into auto.arima()
#and Arima() for the main analyses

create_ts <- function(df) {
  
  full_ts <- df %>%
    filter(date <= as.Date("2017-12-01")) %>%
    select(self_h) %>%
    ts(start = c(2006,1),
       frequency = 12)
  
  full_ts_fsd <- tg %>%
    filter(date <= as.Date("2017-12-01"),
           date >= as.Date("2007-02-01")) %>%
    select(self_h_sd_fd) %>%
    ts(start = c(2007,2),
       frequency = 12)
  
  pre_ts <- window(full_ts,
                   end = c(2017,3))
  
  pre_ts_fsd <- window(full_ts_fsd,
                       end = c(2017,3))
  
  ts_len <- length(pre_ts_fsd)
  
  ts_full_len <- length(full_ts)
  
  ts_train_fsd <- pre_ts_fsd[1:(ts_len/2)] %>%
    ts(start = c(2007,2),
       frequency = 12)
  
  ts_est_fsd <- pre_ts_fsd[(ts_len/2 + 1):ts_len] %>%
    ts(end = c(2017,3),
       frequency = 12)
  
  ts_est <- pre_ts[(ts_len/2 + 1):(ts_len + 13)] %>%
    ts(end = c(2017,3),
       frequency = 12)
  
  ts_est_full <- full_ts[(ts_len/2 + 1):ts_full_len] %>%
    ts(end = c(2017,12),
       frequency = 12)
  
  ts_full_conf_1 <- window(full_ts,
                           end = c(2017,4))
  
  ts_full_conf_2 <- window(full_ts,
                           end = c(2017,5))
  
  ts_full_conf_3 <- window(full_ts,
                           end = c(2017,6))
  
  ts_full_conf_4 <- window(full_ts,
                           end = c(2017,7))
  
  ts_est_conf_1 <- window(ts_est_full,
                          end = c(2017,4))
  
  ts_est_conf_2 <- window(ts_est_full,
                          end = c(2017,5))
  
  ts_est_conf_3 <- window(ts_est_full,
                          end = c(2017,6))
  
  ts_est_conf_4 <- window(ts_est_full,
                          end = c(2017,7)) 
  
  out <- list(full_ts = full_ts,
              ts_train_fsd = ts_train_fsd,
              ts_est_fsd = ts_est_fsd,
              ts_est = ts_est, 
              pre_ts_fsd = pre_ts_fsd,
              pre_ts = pre_ts,
              ts_full_conf_1 = ts_full_conf_1,
              ts_full_conf_2 = ts_full_conf_2,
              ts_full_conf_3 = ts_full_conf_3,
              ts_full_conf_4 = ts_full_conf_4,
              ts_est_conf_1 = ts_est_conf_1,
              ts_est_conf_2 = ts_est_conf_2,
              ts_est_conf_3 = ts_est_conf_3,
              ts_est_conf_4 = ts_est_conf_4)
  
  return(out)
  
}

## CONFORMAL P-VAL FUNCTION

get_arima_pval <- function(Y1, T1, T0, theta0, block_size, order, seasonal, include.mean){
  
  #Storing the degree of first and seasonal
  #differencing
  d <- order[2]
  D <- seasonal[2]
  
  #End of time series
  T01 <- T0+T1
  
  #Observed outcomes
  Y1_0 <- Y1
  
  #Imputing Y(0) for post-treatment period
  #using null theta
  Y1_0[(T0+1):T01] <- Y1[(T0+1):T01] - theta0
  
  Y1_0 <- ts(Y1_0, frequency = 12)
  
  #Fit ARIMA to augmented dataset and compute residuals
  fit <- Arima(Y1_0, order = order, seasonal = seasonal, include.mean = include.mean, method = "ML")
  u.hat <- as.vector(fit$residuals)
  
  #Removing the residuals for the periods
  #that could not be differenced because
  #they were too early in the time series.
  #These residuals are extremely close to 0,
  #and YOUR P-VALUES / INTERVALS WILL UNDERCOVER
  #IF YOU DO NOT REMOVE THEM.
  u.hat <- u.hat[(1 + d + 12*D):length(u.hat)]
  u.length <- length(u.hat)
  
  #"Double" the residual vector
  u.hat.c <- c(u.hat,u.hat)
  
  #Initiate empty 1-column matrix length of 
  #augmented time series not including differenced
  #observations
  S.vec <- matrix(NA,u.length,1)
  
  #For each overlapping block, 
  #take sum of absolute residuals
  for (s in 1:(u.length)){
    S.vec[s,1]  <- sum(abs(u.hat.c[s:(s + block_size - 1)]))
  }
  
  #Proportion of blocks that post-treatment
  #block is leq to gives you the conformal p-value
  p <- mean(S.vec >= S.vec[T0+1-d-D*12])
  return(p)
}

## Returns table for the sample-splitting
## sims.

give_me_table <- function(dat, n.sims) {
  
  dat <- dat %>%
    filter(error != 1) %>%
    slice_head(n = n.sims) %>%
    mutate(full_ar_sig = ifelse(y < full_ar_lo | y > full_ar_up, 1, 0),
           split_ar_sig = ifelse(y < split_ar_lo | y > split_ar_up, 1, 0),
           safe_ar_sig = ifelse(y < split_ar_lo | y > split_ar_up, 1, 0),
           err_full = y - full,
           err_split = y - split,
           err_safe = y - safe) 
  #%>%
   # rowwise() %>%
  #  mutate(full_mse = mean(c(err_full^2)),
  #         split_mse = mean(c(err_split^2)),
  #         safe_mse = mean(c(err_safe^2)))
  
  perf <- data.frame(matrix(NA, 3, 7))
  colnames(perf) <- c("Approach", "MSE", "RMSE", "ar05", "p05", "p1", "p2")
  
  perf$Approach <- c("Full", "Split", "SAFE")
  
  perf$MSE <- c(mean(dat$err_full^2),
                mean(dat$err_split^2),
                mean(dat$err_safe^2))
  
  perf$RMSE <- sqrt(perf$MSE)
  
  perf$ar05 <- c(mean(dat$full_ar_sig),
                 mean(dat$split_ar_sig),
                 mean(dat$safe_ar_sig))
  
  perf$p05 <- c(mean(dat$full_p < .05),
                mean(dat$split_p < .05),
                mean(dat$safe_p < .05))
  
  perf$p1 <- c(mean(dat$full_p < .1),
               mean(dat$split_p < .1),
               mean(dat$safe_p < .1))
  
  perf$p2 <- c(mean(dat$full_p < .2),
               mean(dat$split_p < .2),
               mean(dat$safe_p < .2))
  
  output = list("dat" = dat, "perf" = perf)
  
  return(output)
  
}

sim_fn <- function(phi, Phi, theta, Theta, burnin,
                       reg.diff, s.diff, ts.freq, 
                       distr = NULL,
                       sig = NULL,
                       uni.min = NULL,
                       uni.max = NULL,
                       gam = NULL,
                       t.df = NULL,
                       sim.order,
                       n.obs,
                       n.sims,
                       block.size) {
  
  #adding cushion because
  #some rows will be NAs
  #due to Arima() errors
  n.sims.plus <- n.sims + 500
  
  #creating empty df
  dat <- data.frame(matrix(NA, n.sims.plus, 22))
  colnames(dat) <- c("y", "full", "split", "safe", 
                     "full2", "split2", "safe2",
                     "full3", "split3", "safe3",
                     "full_p", "split_p", "safe_p",
                     "full_ar_lo", "full_ar_up",
                     "split_ar_lo", "split_ar_up",
                     "safe_ar_lo", "safe_ar_up",
                     "f_mod_mis", "s_mod_mis", "error")
  
  for (i in 1:n.sims.plus) {
    
    if (is.null(distr) == 1) {
      stop("Please specify an error distribution")
    }
    
    if ((n.obs - block.size) %% 2 == 1) {
      stop("n.obs - block.size should be an even number")
    }
    
    #generating errors
    if (distr == "normal") {
      errs <- rnorm(n.obs + burnin + 13, sd = sig)
    } else if (distr == "laplace") {
      errs <- rlaplace(n.obs + burnin + 13, sigma = sig)
    } else if (distr == "uniform") {
      errs <- runif(n.obs + burnin + 13, min = uni.min, max = uni.max)
    } else if (distr == "cauchy") {
      errs <- rcauchy(n.obs + burnin + 13, scale = gam)
    } else if (distr == "student") {
      errs <- rt(n.obs + burnin + 13, df = t.df)
    } 
    
    #generating time series
    y <- sarima.sim(ar = phi,
                    sar = Phi,
                    ma = theta,
                    sma = Theta,
                    d = reg.diff,
                    D = s.diff,
                    S = ts.freq,
                    burnin = burnin,
                    n = n.obs + 13,
                    innov = errs)
    
    #removing trends / seasonality
    y <- diff(y)
    y <- diff(y, 12)
    
    #splitting sample
    y1_end <- (n.obs-1)/2
    y2_start <- y1_end + 1
    y2_end <- n.obs-1
    
    y1 <- ts(y[1:y1_end], freq = ts.freq)
    y2 <- ts(y[y2_start:y2_end], freq = ts.freq)
    y2conf <- ts(y[y2_start:n.obs], freq = ts.freq)
    y_full <- ts(y[1:y2_end], freq = ts.freq)
    
    dat$error[i] <- tryCatch({
      
      #selecting models
      mod_full <- auto.arima(y_full, allowdrift = F, max.d = 0, max.D = 0, allowmean = F)
      mod_split <- auto.arima(y1, allowdrift = F, max.d = 0, max.D = 0, allowmean = F)
      
      #extracting orders
      full_o <- as.numeric(arimaorder(mod_full)[1:3])
      full_s <- as.numeric(arimaorder(mod_full)[4:6])
      
      split_o <- as.numeric(arimaorder(mod_split)[1:3])
      split_s <- as.numeric(arimaorder(mod_split)[4:6])
      
      if (any(is.na(split_s))) {
        split_s <- c(0,0,0)
      }
      
      if (any(is.na(full_s))) {
        full_s <- c(0,0,0)
      }
      
      full_order <- c(full_o, full_s)
      split_order <- c(split_o, split_s)
      
      #checking to see whether 
      #auto.arima() obtained
      #true model specification
      sim.order.alt <- sim.order
      sim.order.alt[2] <- 0
      sim.order.alt[5] <- 0
      
      dat$f_mod_mis[i] <- -1*(as.numeric(identical(full_order, sim.order.alt))-1)
      dat$s_mod_mis[i] <- -1*(as.numeric(identical(split_order, sim.order.alt))-1)
      
      #mod_full already defined earlier
      #creating model objects using
      #diff selected orders
      mod_split <- Arima(y2, order = split_o, seasonal = split_s, 
                         include.mean = F, include.drift = F)
      
      mod_safe <- Arima(y_full, order = split_o, seasonal = split_s, 
                        include.mean = F, include.drift = F)
      
      #observed
      dat$y[i] <- as.numeric(y[n.obs])
      
      #forecasts
      fore_full <- forecast(mod_full, h = 1)
      fore_split <- forecast(mod_split, h = 1)
      fore_safe <- forecast(mod_safe, h = 1)
      
      #predicted
      dat$full[i] <- as.numeric(fore_full$mean)[1]
      dat$split[i] <- as.numeric(fore_split$mean)[1]
      dat$safe[i] <- as.numeric(fore_safe$mean)[1]
      
      #dat$full2[i] <- as.numeric(fore_full$mean)[2]
      #dat$split2[i] <- as.numeric(fore_split$mean)[2]
      #dat$safe2[i] <- as.numeric(fore_safe$mean)[2]
      
      #dat$full3[i] <- as.numeric(fore_full$mean)[3]
      #dat$split3[i] <- as.numeric(fore_split$mean)[3]
      #dat$safe3[i] <- as.numeric(fore_safe$mean)[3]
      
      #inference
      dat$full_p[i] <- get_arima_pval(y, 
                                      T1 = 1, 
                                      T0 = n.obs-1, 
                                      theta0 = 0, 
                                      block_size = block.size, 
                                      order = full_o, 
                                      seasonal = full_s, 
                                      include.mean = F)
      
      dat$split_p[i] <- get_arima_pval(y2conf, 
                                       T1 = 1, 
                                       T0 = (n.obs-1)/2, 
                                       theta0 = 0,
                                       block_size = block.size,
                                       order = split_o, 
                                       seasonal = split_s,
                                       include.mean = F)
      
      dat$safe_p[i] <- get_arima_pval(y, 
                                      T1 = 1, 
                                      T0 = n.obs-1, 
                                      theta0 = 0, 
                                      block_size = block.size,
                                      order = split_o, 
                                      seasonal = split_s,
                                      include.mean = F)
      
      dat$full_ar_lo[i] <- as.numeric(fore_full$lower[1,2])
      dat$full_ar_up[i] <- as.numeric(fore_full$upper[1,2])
      dat$split_ar_lo[i] <- as.numeric(fore_split$lower[1,2])
      dat$split_ar_up[i] <- as.numeric(fore_split$upper[1,2])
      dat$safe_ar_lo[i] <- as.numeric(fore_safe$lower[1,2])
      dat$safe_ar_up[i] <- as.numeric(fore_safe$upper[1,2])
      
    }, error = function(e) 1)
    
  }
  
  raw <- dat
  clean <- give_me_table(dat, n.sims)$dat
  perf <- give_me_table(dat, n.sims)$perf
  
  output <- list("raw" = raw, "clean" = clean, "perf" = perf)
  
  return(output)
  
}

## Measurement error bias sim function

merror_bias_sim_fn <- function(y0, n.sims, block.size, distr, nmean, sig, uni.min, uni.max) {
  
  #adding extra sims because sometimes
  #auto.arima returns an error
  n.sims.plus <- n.sims + 121
  
  post.t <- length(y0)
  
  tau <- 1297
  
  dat <- data.frame(matrix(NA, n.sims.plus-1, 5))
  colnames(dat) <- c("pred", "tau_est", "tau_true",
                     "pval", "error")
  
  dat$tau_true <- tau
  #default block_size for bld.mbb.bootstrap is 2*freq, 24 in this case
  #this generates n.sims.plus bootstrapped time series
  ts_df <- bld.mbb.bootstrap(y0, num = n.sims.plus, block_size = block.size)
  
  for (i in 1:n.sims.plus-1) {
    
    y1.sim <- ts_df[[i+1]]
    
    y1.sim[post.t] <- y1.sim[post.t] + tau
    
    if (distr == "normal") {
      
      merrors <- rnorm(12, mean = nmean, sd = sig)
      merrors <- rep(merrors, each = 12)
      merrors <- merrors[1:136]
      
    } else if (distr == "uniform") {
      
      merrors <- runif(12, min = uni.min, max = uni.max)
      merrors <- rep(merrors, each = 12)
      merrors <- merrors[1:136]
      
    } else if (distr == "both") {
      
      merrors <- runif(12, min = uni.min, max = uni.max)
      merrors <- rep(merrors, each = 12)
      merrors <- rnorm(144, mean = merrors, sd = sig)
      merrors <- merrors[1:136]
      
    }
    
    
    
    y1.sim <- y1.sim + merrors
    
    y1.pre <- y1.sim[1:(post.t-1)] %>%
      ts(freq = 12)
    
    dat$error[i] <- tryCatch({
      
      mod_full <- auto.arima(y1.pre, allowdrift = F, allowmean = F)
      
      full_o <- as.numeric(arimaorder(mod_full)[1:3])
      full_s <- as.numeric(arimaorder(mod_full)[4:6])
      
      if (any(is.na(full_s))) {
        full_s <- c(0,0,0)
      }
      
      fore_full <- forecast(mod_full, h = 1)
      
      pred <- as.numeric(fore_full$mean)[1]
      
      dat$pred[i] <- pred
      
      dat$tau_est[i] <- y1.sim[post.t] - pred
      
      dat$pval[i] <- get_arima_pval(y1.sim, 
                                    T1 = 1, 
                                    T0 = post.t-1, 
                                    theta0 = 0, 
                                    block_size = 1, 
                                    order = full_o, 
                                    seasonal = full_s, 
                                    include.mean = F)
      
    }, error = function(e) 1)
  }
  
  return(dat)
  
}

## Function for type-M, type-S, and power

merror_sim_fn <- function(y0, n.sims, block.size, rw.frac) {
  
  #adding extra sims because sometimes
  #auto.arima returns an error
  n.sims.plus <- n.sims + 121
  
  post.t <- length(y0)
  
  #.183 being the percentage increase in suicide
  #relative to predicted counterfactual
  #for RW effect ages 33-44
  tau <- y0[post.t]*.183*rw.frac
  
  dat <- data.frame(matrix(NA, n.sims.plus-1, 6))
  colnames(dat) <- c("pred", "tau_est", "tau_true",
                     "pval", "rw_frac", "error")
  
  dat$tau_true <- tau
  dat$rw_frac <- rw.frac
  #default block_size for bld.mbb.bootstrap is 2*freq, 24 in this case
  #this generates n.sims.plus bootstrapped time series
  ts_df <- bld.mbb.bootstrap(y0, num = n.sims.plus, block_size = block.size)
  
  for (i in 1:n.sims.plus-1) {
    
    y1.sim <- ts_df[[i+1]]
    
    y1.sim[post.t] <- y1.sim[post.t] + tau
    
    y1.pre <- y1.sim[1:(post.t-1)] %>%
      ts(freq = 12)
    
    dat$error[i] <- tryCatch({
      
      mod_full <- auto.arima(y1.pre, allowdrift = F, allowmean = F)
      
      full_o <- as.numeric(arimaorder(mod_full)[1:3])
      full_s <- as.numeric(arimaorder(mod_full)[4:6])
      
      if (any(is.na(full_s))) {
        full_s <- c(0,0,0)
      }
      
      fore_full <- forecast(mod_full, h = 1)
      
      pred <- as.numeric(fore_full$mean)[1]
      
      dat$pred[i] <- pred
      
      dat$tau_est[i] <- y1.sim[post.t] - pred
      
      dat$pval[i] <- get_arima_pval(y1.sim, 
                                    T1 = 1, 
                                    T0 = post.t-1, 
                                    theta0 = 0, 
                                    block_size = 1, 
                                    order = full_o, 
                                    seasonal = full_s, 
                                    include.mean = F)
      
    }, error = function(e) 1)
  }
  
  return(dat)
  
}



#### RUNNING SIMULATIONS ####

### Reading in data

tg <- readRDS(here("data", "tg_self_harm.rds"))

#Preparing ts objects
tg_all <- create_ts(tg)

#Saving all list items to global environment
list2env(tg_all, globalenv())

y0 <- ts_full_conf_1

full_mod <- auto.arima(pre_ts)

y0[length(y0)] <- forecast(full_mod, h=1)$mean

y0 <- ts(y0[1:136], freq = 12)

### APPENDIX C MEASUREMENT ERROR BIAS ###

set.seed(555)

merr_bias_df <- merror_bias_sim_fn(y0,
                                   n.sims = 5000,
                                   block.size = 3,
                                   distr = "normal",
                                   nmean = 0,
                                   sig = 200)

merr_bias_df_unif <- merror_bias_sim_fn(y0,
                                        n.sims = 5000,
                                        block.size = 3,
                                        distr = "uniform",
                                        uni.min = -300,
                                        uni.max = 300)

merr_bias_df_both <- merror_bias_sim_fn(y0,
                                        n.sims = 5000,
                                        block.size = 3,
                                        distr = "both",
                                        sig = 100,
                                        uni.min = -300,
                                        uni.max = 300)

merr_bias_df %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))

merr_bias_df_unif %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))

merr_bias_df_both %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))


set.seed(333)

merr_bias_df <- merror_bias_sim_fn(y0,
                                   n.sims = 5000,
                                   block.size = 3,
                                   distr = "normal",
                                   nmean = -200,
                                   sig = 200)

merr_bias_df_unif <- merror_bias_sim_fn(y0,
                                        n.sims = 5000,
                                        block.size = 3,
                                        distr = "uniform",
                                        uni.min = -500,
                                        uni.max = 100)

merr_bias_df_both <- merror_bias_sim_fn(y0,
                                        n.sims = 5000,
                                        block.size = 3,
                                        distr = "both",
                                        sig = 100,
                                        uni.min = -500,
                                        uni.max = 100)

merr_bias_df %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))

merr_bias_df_unif %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))

merr_bias_df_both %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  summarize(mean_est = mean(tau_est),
            var_est = var(tau_est))


### APPENDIX D TYPE-M AND TYPE-S ERROR ###



set.seed(632)

merror_df_1 <- merror_sim_fn(y0, 5000, block.size = NULL, rw.frac = 1)

saveRDS(merror_df_1, "merror_df_1.rds")

merror_df_2 <- merror_sim_fn(y0, 5000, block.size = NULL, rw.frac = .8)

saveRDS(merror_df_2, "merror_df_2.rds")

merror_df_3 <- merror_sim_fn(y0, 5000, block.size = NULL, rw.frac = .6)

saveRDS(merror_df_3, "merror_df_3.rds")

merror_df_4 <- merror_sim_fn(y0, 5000, block.size = NULL, rw.frac = .4)

saveRDS(merror_df_4, "merror_df_4.rds")

merror_df_5 <- merror_sim_fn(y0, 5000, block.size = NULL, rw.frac = .2)

saveRDS(merror_df_5, "merror_df_5.rds")

mean(merror_df_5$tau_true)

results <- NULL

#loop should probably just be added to merror_sim_fn()...
for (i in 1:5) {
  
  df <- eval(parse(text = paste0("merror_df_",i)))
  
  typeMS <- df %>%
    filter(error != 1) %>%
    slice_head(n = 5000) %>%
    filter(pval < 0.05) %>%
    summarize(typeM = mean(abs(tau_est)) / mean(tau_true),
              typeS = mean(sign(tau_est) == -1))
  
  pwr <- df %>%
    filter(error != 1) %>%
    slice_head(n = 5000) %>%
    summarize(pwr = mean(pval < 0.05, na.rm = TRUE))
  
  results_iter <- cbind(typeMS, pwr)
  results <- rbind(results, results_iter)
  
}

results$rwFrac <- c(1,0.8,0.6,0.4,0.2)

head(results)

mOrange <- "#FFA400"
sLilac <- "#8D6B94"
pBlue <- "#1A61B1"

ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = typeM), color = mOrange, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = typeM), color = mOrange, shape = 15, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("typeM.png", width = 5, height = 5, unit = "in")

ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = typeS), color = sLilac, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = typeS), color = sLilac, shape = 17, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("typeS.png", width = 5, height = 5, unit = "in")


ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = pwr), color = pBlue, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = pwr), color = pBlue, shape = 19, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("pwr.png", width = 5, height = 5, unit = "in")

set.seed(632)

merror_df_1_3 <- merror_sim_fn(y0, 5000, block.size = 3, rw.frac = 1)

saveRDS(merror_df_1_3, "merror_df_1_3.rds")

merror_df_2_3 <- merror_sim_fn(y0, 5000, block.size = 3, rw.frac = .8)

saveRDS(merror_df_2_3, "merror_df_2_3.rds")

merror_df_3_3 <- merror_sim_fn(y0, 5000, block.size = 3, rw.frac = .6)

saveRDS(merror_df_3_3, "merror_df_3_3.rds")

merror_df_4_3 <- merror_sim_fn(y0, 5000, block.size = 3, rw.frac = .4)

saveRDS(merror_df_4_3, "merror_df_4_3.rds")

merror_df_5_3 <- merror_sim_fn(y0, 5000, block.size = 3, rw.frac = .2)

saveRDS(merror_df_5_3, "merror_df_5_3.rds")

results <- NULL

for (i in 1:5) {
  
  df <- eval(parse(text = paste0("merror_df_",i,"_3")))
  
  typeMS <- df %>%
    filter(error != 1) %>%
    slice_head(n = 5000) %>%
    filter(pval < 0.05) %>%
    summarize(typeM = mean(abs(tau_est)) / mean(tau_true),
              typeS = mean(sign(tau_est) == -1))
  
  pwr <- df %>%
    filter(error != 1) %>%
    slice_head(n = 5000) %>%
    summarize(pwr = mean(pval < 0.05, na.rm = TRUE))
  
  results_iter <- cbind(typeMS, pwr)
  results <- rbind(results, results_iter)
  
}

results$rwFrac <- c(1,0.8,0.6,0.4,0.2)

head(results)

mOrange <- "#FFA400"
sLilac <- "#8D6B94"
pBlue <- "#1A61B1"

ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = typeM), color = mOrange, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = typeM), color = mOrange, shape = 15, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("typeM_3.png", width = 5, height = 5, unit = "in")

ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = typeS), color = sLilac, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = typeS), color = sLilac, shape = 17, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("typeS_3.png", width = 5, height = 5, unit = "in")


ggplot(results) +
  geom_line(mapping = aes(x = rwFrac, y = pwr), color = pBlue, size = 1, alpha = 0.7) +
  geom_point(mapping = aes(x = rwFrac, y = pwr), color = pBlue, shape = 19, size = 5) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylab("") +
  xlab("")

ggsave("pwr_3.png", width = 5, height = 5, unit = "in")



### APPENDIX F SAMPLE-SPLITTING SIMULATIONS ###

set.seed(08540)

arima_sim_n135 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "normal",
                         sig = 1,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 135,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_t135 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "student",
                         t.df = 3,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 135,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_u135 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "uniform",
                         uni.min = -.1,
                         uni.max = 1,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 135,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_n51 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "normal",
                         sig = 1,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 51,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_t51 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "student",
                         t.df = 3,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 51,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_u51 <- sim_fn(phi = NULL,
                         Phi = NULL,
                         theta = -.65,
                         Theta = -.5,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "uniform",
                         uni.min = -.1,
                         uni.max = 1,
                         sim.order = c(0,1,1,0,1,1),
                         n.obs = 51,
                         block.size = 1,
                         n.sims = 5000)



xtable(arima_sim_n135$perf, digits = 4)
xtable(arima_sim_n51$perf, digits = 4)

xtable(arima_sim_t135$perf, digits = 4)
xtable(arima_sim_t51$perf, digits = 4)

xtable(arima_sim_u135$perf, digits = 4)
xtable(arima_sim_u51$perf, digits = 4)

arima_sim_n50 <- sim_fn(phi = c(.7,.2),
                        Phi = -.2,
                        theta = NULL,
                        Theta = NULL,
                        burnin = 100,
                        reg.diff = 1,
                        s.diff = 1,
                        ts.freq = 12,
                        distr = "normal",
                        sig = 1,
                        sim.order = c(2,1,0,1,1,0),
                        n.obs = 51,
                        block.size = 1,
                        n.sims = 5000)

arima_sim_t100 <- sim_fn(phi = c(.7,.2),
                         Phi = -.2,
                         theta = NULL,
                         Theta = NULL,
                         burnin = 100,
                         reg.diff = 1,
                         s.diff = 1,
                         ts.freq = 12,
                         distr = "student",
                         t.df = 3,
                         sim.order = c(2,1,0,1,1,0),
                         n.obs = 101,
                         block.size = 1,
                         n.sims = 5000)

arima_sim_t50 <- sim_fn(phi = c(.7,.2),
                        Phi = -.2,
                        theta = NULL,
                        Theta = NULL,
                        burnin = 100,
                        reg.diff = 1,
                        s.diff = 1,
                        ts.freq = 12,
                        distr = "student",
                        t.df = 3,
                        sim.order = c(2,1,0,1,1,0),
                        n.obs = 51,
                        block.size = 1,
                        n.sims = 5000)

dat <- arima_sim_t50$raw

dat1 <- dat %>%
  filter(error != 1) %>%
  slice_head(n = 5000) %>%
  mutate(full_ar_sig = ifelse(y < full_ar_lo | y > full_ar_up, 1, 0),
         split_ar_sig = ifelse(y < split_ar_lo | y > split_ar_up, 1, 0),
         safe_ar_sig = ifelse(y < split_ar_lo | y > split_ar_up, 1, 0),
         err_full = y - full,
         err_split = y - split,
         err_safe = y - safe) 

mean(dat1$full_ar_sig)
mean(dat1$split_ar_sig)
mean(dat1$safe_ar_sig)

mean(dat1$full_p < .05)
mean(dat1$split_p < .05)
mean(dat1$safe_p < .05)

