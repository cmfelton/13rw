## This script will take in the dataframes produced by
## getcounts.R and conduct all the analyses and 
## generate all the plots shown in the paper.

## NOTE: I wouldn't advise running the entire script
## all at once, because the repeated placebo tests
## take a very long time to run since the prediction
## intervals are computed through test inversion.

rm(list = ls())

#install.packages("tidyverse")
#install.packages("forecast)
#install.packages("ggtext")
#install.packages("gridtext")
#install.packages("remotes")

library(tidyverse)
library(forecast)
library(ggtext)
library(zoo)
library(emojifont)
library(xtable)
library(urca)

setwd("~/Documents/projects/ITS/13RW/data")

### FUNCTIONS

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

## MODEL SELECTION

#This function just takes in a ts
#and outputs a list containing
#the model and orders

give_me_order <- function(ts, d = NULL, D = NULL) {
  
  if (is.null(d)) {
    
    mod <- auto.arima(ts)
    
  } else {
  
    mod <- auto.arima(ts, d, D)
  
  }
  
  order <- as.numeric(arimaorder(mod)[1:3])
  seasonal <- as.numeric(arimaorder(mod)[4:6])
  
  out <- list(mod = mod,
              order = order,
              seasonal = seasonal)
  
  return(out)
  
}

## CONFORMAL PVAL FUNCTION

#Conformal p-value function adapted from 
#https://github.com/kwuthrich/scinference/blob/main/R/conformal.R

#This function calculates a conformal
#p-value given a time series and the
#observed post-treatment values

#No Y0 because no control units
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


## CONFORMAL PI FUNCTION

#Conformal PI function adapted from 
#https://github.com/kwuthrich/scinference/blob/main/R/conformal.R

#This function computes one-step-ahead
#conformal prediction intervals. As of
#now you have to check whether the PI grid
#is wide enough after the fact by checking 
#whether the final PI contains the max 
#or min of the grid. Future function
#will check that and automatically expand
#the grid if need be

get_arima_PI <- function(Y1, T1, T0, alpha, pi_grid, block_size, order, seasonal, include.mean) {
  
  #Initiating empty vector of
  #upper and lower bounds
  lb <- ub <- rep(NA,T1)
  
  for (t in 1:T1){
    
    indices <- c(1:T0,T0+t)
    Y1_temp <- Y1[indices]
    
    ps_temp <- rep(NA,length(pi_grid))
    
    #Looping through grid
    #and obtaining p-val
    #for each value
    for (i in 1:length(pi_grid)){
      Y1_0_temp <- Y1_temp
      Y1_0_temp[(T0+1)] <- pi_grid[i]
      
      Y1_0_temp <- ts(Y1_0_temp, frequency = 12)
      
      ps_temp[i] <- get_arima_pval(Y1_0_temp, 
                                   T1, 
                                   T0, 
                                   theta0 = 0, 
                                   block_size, 
                                   order, 
                                   seasonal,
                                   include.mean)
    }
    
    pi_temp <- pi_grid[ps_temp>alpha]
    lb[t] <- min(pi_temp,na.rm=TRUE)
    ub[t] <- max(pi_temp,na.rm=TRUE)
    
  }
  
  return(list(lb=lb,ub=ub,ps_temp = ps_temp))
  
}

## CONFORMAL CI FUNCTION

#Same as above but for CIs

get_arima_CI <- function(Y1, T1, T0, alpha, ci_grid, block_size, order, seasonal, include.mean) {
  
  #Initiating empty vector of
  #upper and lower bounds
  lb <- ub <- rep(NA,T1)
  
  for (t in 1:T1){
    
    indices <- c(1:T0,T0+t)
    Y1_temp <- Y1[indices]
    
    ps_temp <- rep(NA,length(ci_grid))
    
    #Looping through grid
    #and obtaining p-val
    #for each value
    for (i in 1:length(ci_grid)){
      Y1_0_temp <- Y1_temp
      Y1_0_temp[(T0+1)] <- Y1_temp[(T0+1)] - ci_grid[i]
      
      Y1_0_temp <- ts(Y1_0_temp, frequency = 12)
      
      ps_temp[i] <- get_arima_pval(Y1_0_temp, 
                                   T1, 
                                   T0, 
                                   theta0 = 0, 
                                   block_size, 
                                   order, 
                                   seasonal,
                                   include.mean)
    }
    
    ci_temp <- ci_grid[ps_temp>alpha]
    lb[t] <- min(ci_temp,na.rm=TRUE)
    ub[t] <- max(ci_temp,na.rm=TRUE)
    
  }
  
  return(list(lb=lb,ub=ub))
  
}

## PVAL DF FUNCTION

#This function calculates
#multiple conformal p-values
#based on a range of block
#sizes and post-treatment-period
#lengths

get_pval_df <- function(y, T0, order, seasonal, include.mean,
                        block_vec, post_vec,
                        ts_start) {
  
  pval_df <- as.data.frame(expand.grid(block_vec, post_vec)) %>%
    rename(block_size = Var1, post_D_length = Var2) %>%
    mutate(pval = NA)
  
  for (i in 1:nrow(pval_df)) {
    
    if (pval_df$post_D_length[i] <= pval_df$block_size[i]) {
    
      y_iter <- y[1:(T0 + pval_df$post_D_length[i])] %>%
        ts(start = ts_start,
           frequency = 12)
    
      pval_df$pval[i] <- get_arima_pval(y_iter, T1 = pval_df$post_D_length[i], 
                                        block_size = pval_df$block_size[i], 
                                        T0 = T0, theta0 = 0, 
                                        order = order, 
                                        seasonal = seasonal,
                                        include.mean = include.mean)
    
    } else {
      
      pval_df$pval[i] <- NA_integer_
      
    }
    
    
  }
  
  pval_df <- pval_df %>%
    pivot_wider(names_from = post_D_length,
                values_from = pval,
                names_prefix = "post_D_length")
  
  return(pval_df)
  
}

## REPEATED PLACEBO TEST FUNCTION

#This function conducts a series of
#(one-step-ahead) placebo tests and 
#outputs a df containing all the 
#point forecasts and PIs

get_placebo_df <- function(y, pre_ts_len, post_ts_len, order, 
                           seasonal, alpha, block_size, 
                           pi_grid_width, tscv_type) {
  
  full_ts_len <- length(y)
  placebo_len <- full_ts_len - pre_ts_len
  
  #initiate empty vectors for forecasts and PIs
  preds <- upper <- lower <- rep(NA, placebo_len)
  
  if (tscv_type == "move") {
    
    for (i in 1:placebo_len) {
      
      #create ts for forecasting
      ts_forecast <- y[i:(i + pre_ts_len - 1)] %>%
        ts(frequency = 12)
      
      #create ts for prediction intervals
      ts_PI <- y[i:(i + pre_ts_len)] %>%
        ts(frequency = 12)
      
      #fit arima model to ts_forecast
      mod_forecast <- Arima(ts_forecast, order = order, seasonal = seasonal)
      
      #store one-step-ahead forecast
      preds[i] <- forecast(mod_forecast, h = 1)$mean
      
      #creating PI grid
      pi_grid <- (preds[i] - (pi_grid_width/2)):(preds[i] + (pi_grid_width/2))
      
      #obtain PI
      PI_iter <- get_arima_PI(ts_PI, T1 = post_ts_len, T0 = pre_ts_len,
                              alpha = alpha, pi_grid = pi_grid, block_size = block_size,
                              order = order, seasonal = seasonal, include.mean = F)
      
      #store lower and upper bounds
      lower[i] <- PI_iter$lb
      upper[i] <- PI_iter$ub
      
      print(i)
      
    }
    
  } else if (tscv_type == "expand") {
    
    for (i in 1:placebo_len) {
      
      ts_forecast <- y[1:(i + pre_ts_len - 1)] %>%
        ts(frequency = 12)
      
      ts_PI <- y[1:(i + pre_ts_len)] %>%
        ts(frequency = 12)
      
      mod_forecast <- Arima(ts_forecast, order = order, seasonal = seasonal)
      
      preds[i] <- forecast(mod_forecast, h = 1)$mean
      
      pi_grid <- (preds[i] - (pi_grid_width/2)):(preds[i] + (pi_grid_width/2))
      
      PI_iter <- get_arima_PI(ts_PI, T1 = post_ts_len, T0 = pre_ts_len + i - 1,
                              alpha = alpha, pi_grid = pi_grid,
                              block_size = block_size,
                              order = order, seasonal = seasonal, include.mean = F)
      
      lower[i] <- PI_iter$lb
      upper[i] <- PI_iter$ub
      
      print(i)
      
    }
    
  }
  
  #combine vecs into df
  tscv_df <- data.frame(preds, upper, lower)
  
  #return df
  return(tscv_df)
  
}

get_placebo_df_arima <- function(y, pre_ts_len, post_ts_len, order, 
                           seasonal, tscv_type) {
  
  full_ts_len <- length(y)
  placebo_len <- full_ts_len - pre_ts_len
  
  #initiate empty vectors for forecasts and PIs
  preds <- upper <- lower <- rep(NA, placebo_len)
  
  if (tscv_type == "move") {
    
    for (i in 1:placebo_len) {
      
      #create ts for forecasting
      ts_forecast <- y[i:(i + pre_ts_len - 1)] %>%
        ts(frequency = 12)
      
      #create ts for prediction intervals
      ts_PI <- y[i:(i + pre_ts_len)] %>%
        ts(frequency = 12)
      
      #fit arima model to ts_forecast
      mod_forecast <- Arima(ts_forecast, order = order, seasonal = seasonal)
      
      #store one-step-ahead forecast
      preds[i] <- forecast(mod_forecast, h = 1)$mean
      
      #creating PI grid
      #pi_grid <- (preds[i] - (pi_grid_width/2)):(preds[i] + (pi_grid_width/2))
      
      #obtain PI
      #PI_iter <- get_arima_PI(ts_PI, T1 = post_ts_len, T0 = pre_ts_len,
      #                        alpha = alpha, pi_grid = pi_grid, block_size = block_size,
      #                        order = order, seasonal = seasonal, include.mean = F)
      
      #store lower and upper bounds
      lower[i] <- forecast(mod_forecast, h = 1)$lower[2]
      upper[i] <- forecast(mod_forecast, h = 1)$upper[2]
      
      print(i)
      
    }
    
  } else if (tscv_type == "expand") {
    
    for (i in 1:placebo_len) {
      
      ts_forecast <- y[1:(i + pre_ts_len - 1)] %>%
        ts(frequency = 12)
      
      ts_PI <- y[1:(i + pre_ts_len)] %>%
        ts(frequency = 12)
      
      mod_forecast <- Arima(ts_forecast, order = order, seasonal = seasonal)
      
      preds[i] <- forecast(mod_forecast, h = 1)$mean
      
      #pi_grid <- (preds[i] - (pi_grid_width/2)):(preds[i] + (pi_grid_width/2))
      
      #PI_iter <- get_arima_PI(ts_PI, T1 = post_ts_len, T0 = pre_ts_len + i - 1,
      #                        alpha = alpha, pi_grid = pi_grid,
      #                        block_size = block_size,
      #                        order = order, seasonal = seasonal, include.mean = F)
      
      lower[i] <- forecast(mod_forecast, h = 1)$lower[2]
      upper[i] <- forecast(mod_forecast, h = 1)$upper[2]
      
      print(i)
      
    }
    
  }
  
  #combine vecs into df
  tscv_df <- data.frame(preds, upper, lower)
  
  #return df
  return(tscv_df)
  
}

## REPEATED PLACEBO TEST PLOT FUNCTION

#This function takes in a df
#from get_placebo_df() and saves
#several plots in your directory

get_placebo_plot <- function(df) {
  
  name <- deparse(substitute(df))
  
  pred_plot_name <- paste0(name, ".png")
  pred_zoom_name <- paste0(name, "_zoom.png")
  tau_plot_name <- paste0(name, "_tau.png")
  tau_zoom_name <- paste0(name, "_zoom_tau.png")
  
  placebo_df <- df %>%
    mutate(observed = as.numeric(window(full_ts, start = c(2012,3), end = c(2017,4))),
           date = seq.Date(from = as.Date("2012-03-01"),
                           to = as.Date("2017-04-01"),
                           by = "1 month"),
           tau = observed - preds,
           tau_upper = observed - lower,
           tau_lower = observed - upper,
           treat = date == as.Date("2017-04-01"),
           fail = (observed <= lower | observed >= upper) & treat == 0,
           point_type = ifelse(treat == 1, "treat",
                               ifelse(fail == 1, "fail", "covered")))
  
  my_blue <- "#077b8a"
  my_red <- "#d72631"
  my_light_blue <- "#a2d5c6"
  blue_ribbon <- "#6699CC"
  blue_obs <- "#96b8da"
  my_green <- "#389150"
  
  ggplot(placebo_df) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
    geom_ribbon(mapping = aes(x = date, ymin = lower, ymax = upper), fill = blue_ribbon, alpha = .2) +
    geom_line(mapping = aes(x = date, y = preds), color = "black", size = 1) +
    geom_point(mapping = aes(x = date, y = observed, color = point_type, shape = point_type, size = point_type), alpha = .7) +
    scale_color_manual(values = c(blue_obs, my_red, my_green)) +
    scale_shape_manual(values = c("\u25cf", "\u2716", "\u25b2")) +
    scale_size_manual(values = c(8,10, 10)) +
    theme_classic() +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 20)) +
    scale_x_date(breaks = c(as.Date("2012-09-01"), as.Date("2014-03-01"), as.Date("2015-09-01"), as.Date("2017-03-01")),
                 date_labels = "%b %Y",
                 limits = c(as.Date("2012-03-01"), as.Date("2017-04-01"))) +
    ylim(3500,11000) +
    labs(x = "",
         y = "")
  
  ggsave(pred_plot_name, width = 8, height = 5, units = "in")
  
  ggplot(placebo_df) +
    geom_ribbon(mapping = aes(x = date, ymin = lower, ymax = upper), fill = blue_ribbon, alpha = .2) +
    geom_line(mapping = aes(x = date, y = preds), color = "black", size = 1) +
    geom_point(mapping = aes(x = date, y = observed, color = point_type, shape = point_type, size = point_type), alpha = .7) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed") +
    geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed") +
    scale_color_manual(values = c(blue_obs, my_red, my_green)) +
    scale_shape_manual(values = c("\u25cf", "\u2716", "\u25b2")) +
    scale_size_manual(values = c(8,10, 10)) +
    theme_classic() +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 20)) +
    scale_x_date(breaks = c(as.Date("2016-03-01"), as.Date("2016-09-01"), as.Date("2017-03-01")),
      date_labels = "%b %Y",
      limits = c(as.Date("2016-01-01"), as.Date("2017-04-01")),
      expand = c(0,30)) +
    ylim(3500,11000) +
    labs(x = "",
         y = "")
  
  ggsave(pred_zoom_name, width = 8, height = 5, units = "in")
  
  ggplot(placebo_df) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
    geom_hline(aes(yintercept = 0)) + 
    geom_point(mapping = aes(x = date, y = tau, color = point_type)) +
    geom_errorbar(mapping = aes(x = date, ymin = tau_lower, 
                                ymax = tau_upper, color = point_type),
                  width = 0) +
    scale_color_manual(values = c(blue_obs, my_red, my_green)) +
    theme_classic() +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 20)) +
    scale_x_date(breaks = c(as.Date("2012-09-01"), as.Date("2014-03-01"), as.Date("2015-09-01"), as.Date("2017-03-01")),
                 limits = c(as.Date("2012-03-01"), as.Date("2017-04-01")),
                 date_labels = "%b %Y") +
    labs(x = "",
         y = "")
  
  ggsave(tau_plot_name, width = 8, height = 5, units = "in")
  
  ggplot(subset(placebo_df, date > as.Date("2016-10-01") & date < as.Date("2017-05-01"))) +
    geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed") +
    geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed") +
    geom_hline(aes(yintercept = 0)) + 
    geom_point(mapping = aes(x = date, y = tau, color = point_type)) +
    geom_errorbar(mapping = aes(x = date, ymin = tau_lower, 
                                ymax = tau_upper, color = point_type, width = 7)) +
    scale_color_manual(values = c(blue_obs, my_red, my_green)) +    
    theme_classic() +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 20)) +
    scale_x_date(
      date_labels = "%b %Y", breaks = "2 months")+
    labs(x = "",
         y = "")
  
  ggsave(tau_zoom_name, width = 8, height = 5, units = "in")  
  
}

## function for testing whether any of the
## PIs hit the max / min vals in PI grid

elementwise.all.equal <- Vectorize(function(x, y) {isTRUE(all.equal(x, y))})

check_max <- function(df, PI_width) {
  
  df <- df %>%
    mutate(lower_width = preds - lower,
           upper_width = upper - preds,
           maxed1 = ifelse(elementwise.all.equal(lower_width, PI_width/2), T, F),
           maxed2 = ifelse(elementwise.all.equal(upper_width, PI_width/2), T, F))
  
  if (sum(df$maxed1) == 0 & sum(df$maxed2) == 0) {
    return("Passed!")
  } else {
    return("Failed.")
  }
  
}

## GET DFs FOR MULTI-STEP-AHEAD PREDICTIONS

#This function outputs a list of dataframes 
#containing results for several multi-step-ahead
#placebo tests. The prediction intervals
#are based on simulated trajectories
#using randomly sampled model residuals

get_multi_dfs <- function(np, start_date, full_ts) {
  
  dates <- seq.Date(from = start_date, by = "1 month", length.out = np)
  
  years <- as.numeric(format(dates, format = "%Y"))
  mons <- as.numeric(format(dates, format = "%m"))
  
  multi_df <- matrix(NA,np+1,np*3, dimnames = list(NULL, paste0(c("forecast","lower","upper"),rep(1:6, each = 3))))
  
  mods <- vector(mode = "list", length = np)
  
  for (i in 1:np) {
    
    ts_iter <- window(full_ts, end = c(years[i], mons[i]))
    mod_iter <- auto.arima(ts_iter)
    fore_iter <- forecast(mod_iter, h = np - i + 2, level = 95, bootstrap = T)
    multi_df[,(3*i - 2)] <- c(rep(NA, i-1), as.numeric(fore_iter$mean))
    multi_df[,(3*i - 1)] <- c(rep(NA, i-1), as.numeric(fore_iter$lower))
    multi_df[,(3*i)] <- c(rep(NA, i-1), as.numeric(fore_iter$upper))
    
    mods[[i]] <- mod_iter
    
  }
  
  multi_df <- (as.data.frame(multi_df))
  out <- list(mods, multi_df)
  
  return(out)
  
}

## MAKE MULTI-STEP-AHEAD PREDICTION PLOTS

#This function uses dataframes saved
#in the global environment to generate
#several multi-step-ahead prediction
#plots. It saves the plots to the directory

make_multi_plots <- function(start_date, np) {
  
  dates <- seq.Date(from = start_date, by = "1 month", length.out = np + 1)
  
  years <- as.numeric(format(dates, format = "%Y"))
  mons <- as.numeric(format(dates, format = "%m"))
  
  for (i in 1:np) {
    
    mod_df <- eval(parse(text = paste0("mod",i)))
    
    pre_df <- data.frame(date = seq.Date(from = as.Date("2016-02-01"), by = "1 month", length.out = 8 + i),
                         obs = c(as.numeric(window(full_ts, start = c(2016, 2), end = c(years[i], mons[i]))), NA),
                         fitted = as.numeric(window(fitted(mod_df), start = c(2016, 2), end = c(years[i + 1], mons[i + 1]))))
    
    date_placebo <- paste(years[i + 1], mons[i + 1], "01", sep = "-")
    
    post_df <- data.frame(date = seq.Date(from = as.Date(date_placebo), to = as.Date("2017-05-01"), by = "1 month"),
                          obs = as.numeric(window(full_ts, start = c(years[i + 1], mons[i + 1]), end = c(2017, 5))),
                          pred = c(pre_df$fitted[8 + i], inf_df[(i:7),(3*i - 2)]),
                          lower = c(pre_df$fitted[8 + i], inf_df[(i:7),(3*i-1)]),
                          upper = c(pre_df$fitted[8 + i], inf_df[(i:7),(3*i)]),
                          treat = c(rep(0, 7-i), rep(1, 2)))
    
    ggplot() + 
      #geom_vline(aes(xintercept = as.Date(date_placebo)), linetype = "dashed") +
      geom_line(pre_df, mapping = aes(x = date, y = fitted)) +
      geom_point(pre_df, mapping = aes(x = date, y = obs), color = blue_obs, size = 8, alpha = .7, shape ="\u25cf") +
      geom_line(post_df, mapping = aes(x = date, y = pred), linetype = "dashed") +
      geom_ribbon(post_df, mapping = aes(x = date, ymin = lower, ymax = upper), fill = blue_ribbon, alpha = .2) +
      geom_point(post_df, mapping = aes(x = date, y = obs, color = factor(treat), shape = factor(treat), size = factor(treat)),
                 alpha = .7) +
      scale_color_manual(values = c(blue_obs, my_green)) +
      scale_shape_manual(values = c("\u25cf", "\u25b2")) +
      scale_size_manual(values = c(8,10)) +
      theme_classic() +
      theme(legend.title = element_blank(),
            legend.position = "none",
            text = element_text(size = 20)) +
      scale_x_date(
        date_labels = "%b %Y") +
      ylab("") +
      xlab("")
    
    plotname <- paste0("multi", i, ".png")
    ggsave(plotname, width = 8, height = 5, units = "in")
    
  }
  
}

## GET ONE-STEP-AHEAD FORECAST DFs 
## FOR CONTROL GROUPS

#This function produces different
#dataframes needed for the control
#group plots

get_plot_dfs <- function(ts, mod, PI_upper, PI_lower) {
  
  pre_dates <- as.Date(c("2016-10-01", "2016-11-01", "2016-12-01", 
                         "2017-01-01", "2017-02-01", "2017-03-01"))
  
  obs <- as.numeric(window(ts, 
                           start = c(2016, 10), 
                           end = c(2017, 3)))
  
  tg_fitted <- as.numeric(window(fitted(mod),
                                 start = c(2016, 10), 
                                 end = c(2017, 3)))
  
  pre_df <- data.frame(pre_dates, obs, tg_fitted)
  
  post_dates <- as.Date(c("2017-03-01", "2017-04-01"))
  
  obs <- as.numeric(window(ts,
                           start = c(2017, 3), 
                           end = c(2017, 4)))
  
  tg_pred <- c(as.numeric(window(fitted(mod),
                                 start = c(2017, 3), 
                                 end = c(2017, 3))),
               as.numeric(forecast(mod, h = 1)$mean))
  
  upper <- c(NA, PI_upper)
  lower <- c(NA, PI_lower)
  
  treat <- c(0,1)
  
  post_df <- data.frame(post_dates, obs, tg_pred, upper, lower,treat)
  
  out <- list(pre_df = pre_df, post_df = post_df)
  
  return(out)
  
}

## MAKE ONE-STEP-AHEAD PREDICTION PLOTS

#This function takes in dfs from
#the get_plot_dfs() function
#and produces a plot showing the
#ITS analysis for teen girls
#vs. the ITS analysis for the 
#control group

get_control_plot <- function(pre_df, post_df, name, y_min, y_max) {
  
  plot_name <- paste0(name, "_pred_plot.png")
  
  my_blue <- "#80A4ED"
  #my_orange <- "#f16141"
  my_orange <- "#f57a00"
  
  ggplot() +
    geom_vline(xintercept = as.Date("2017-02-15"), linetype = "dashed") +
    geom_vline(xintercept = as.Date("2017-03-15"), linetype = "dashed") +
    geom_point(data = pre_df, mapping = aes(x = pre_dates, y = tg_fitted), shape = 15, color = my_blue, size = 3) +
    geom_line(data = pre_df, mapping = aes(x = pre_dates, y = tg_fitted), color = my_blue, size = 0.7, alpha = 0.7) +
    geom_point(data = post_df, mapping = aes(x = post_dates, y = tg_pred, shape = factor(treat)), color = my_blue, size = 3, stroke = 1) +
    scale_shape_manual(values = c(NA, 4)) +
    geom_line(data = post_df, mapping = aes(x = post_dates, y = tg_pred), linetype = "dashed", color = my_blue, size = 0.7, alpha = 0.7) +
    geom_errorbar(data = post_df, mapping = aes(x = post_dates, ymin = lower, ymax = upper), color = my_blue, width = 10, size = 0.7) +
    geom_point(data = pre_df, mapping = aes(x = pre_dates, y = obs), shape = 17, color = my_orange, size = 3) +
    geom_line(data = pre_df, mapping = aes(x = pre_dates, y = obs), color = my_orange, size = 0.7, alpha = 0.7) +
    geom_point(data = post_df, mapping = aes(x = post_dates, y = obs), shape = 17, color = my_orange, size = 3) +
    geom_line(data = post_df, mapping = aes(x = post_dates, y = obs), color = my_orange, size = 0.7, alpha = 0.7) +
    theme_classic() +
    scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 20)) +
    labs(x = "",
         y = "") +
    ylim(y_min, y_max)
  
  setwd("~/Documents/projects/ITS/13RW/plots")
  ggsave(plot_name, width = 8, height = 5, unit = "in")
  setwd("~/Documents/projects/ITS/13RW/data")
  
}

## ARIMA pval functions w/ different optimization function for w40 time series

get_arima_pval_CSS <- function(Y1, T1, T0, theta0, block_size, order, seasonal, include.mean){
  
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
  fit <- Arima(Y1_0, order = order, seasonal = seasonal, include.mean = include.mean, method = "CSS")
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


# Conformal PI function with different
# ARIMA optimization function

get_arima_PI_CSS <- function(Y1, T1, T0, alpha, pi_grid, block_size, order, seasonal, include.mean) {
  
  #Initiating empty vector of
  #upper and lower bounds
  lb <- ub <- rep(NA,T1)
  
  for (t in 1:T1){
    
    indices <- c(1:T0,T0+t)
    Y1_temp <- Y1[indices]
    
    ps_temp <- rep(NA,length(pi_grid))
    
    #Looping through grid
    #and obtaining p-val
    #for each value
    for (i in 1:length(pi_grid)){
      Y1_0_temp <- Y1_temp
      Y1_0_temp[(T0+1)] <- pi_grid[i]
      
      Y1_0_temp <- ts(Y1_0_temp, frequency = 12)
      
      ps_temp[i] <- get_arima_pval_CSS(Y1_0_temp, 
                                   T1, 
                                   T0, 
                                   theta0 = 0, 
                                   block_size, 
                                   order, 
                                   seasonal,
                                   include.mean)
    }
    
    pi_temp <- pi_grid[ps_temp>alpha]
    lb[t] <- min(pi_temp,na.rm=TRUE)
    ub[t] <- max(pi_temp,na.rm=TRUE)
    
  }
  
  return(list(lb=lb,ub=ub,ps_temp = ps_temp))
  
}

# Colors

my_blue <- "#077b8a"
my_red <- "#d72631"
my_light_blue <- "#a2d5c6"
blue_ribbon <- "#6699CC"
blue_obs <- "#96b8da"
my_green <- "#389150"
my_light_gray <- "#a0a6ac"

### MAIN ANALYSIS

#Reading in data from tg_clean.R
tg <- readRDS("tg_self_harm.rds")

#Preparing ts objects
tg_all <- create_ts(tg)

#Saving all list items to global environment
list2env(tg_all, globalenv())

#Obtaining split model order
split_mod <- give_me_order(ts_train_fsd)

split_order_fsd <- split_mod$order
split_seasonal_fsd <- split_mod$seasonal

#Adjusting ARIMA order for non-differenced
#data. This does not change the results; it
#just makes it easier to present plots with 
#raw (rather than differenced) data

split_order <- split_order_fsd
split_order[2] <- 1

split_seasonal <- split_seasonal_fsd
split_seasonal[2] <- 1

#Selecting model using full pre-treatment ts.
#Here I'm just letting the ARIMA do the differencing
#from the outset so I don't have to add in the d / D
#parameters later (as I do above)

full_mod <- give_me_order(pre_ts)

full_order <- full_mod$order
full_seasonal <- full_mod$seasonal

full_mod <- auto.arima(pre_ts)
full_order <- as.numeric(arimaorder(full_mod)[1:3])
full_seasonal <- as.numeric(arimaorder(full_mod)[4:6])

## P-VAL TABLES

# P-val tables from the appendix

split_pval_df <- get_pval_df(ts_est_conf_4,
                             T0 = length(ts_est_conf_1) - 1,
                             order = split_order,
                             seasonal = split_seasonal,
                             block_vec = c(1:4),
                             post_vec = c(1:3),
                             ts_start = c(2006,1),
                             include.mean = F)

safe_pval_df <- get_pval_df(ts_full_conf_4,
                            T0 = length(ts_full_conf_1) - 1,
                            order = split_order,
                            seasonal = split_seasonal,
                            block_vec = c(1:4),
                            post_vec = c(1:3),
                            ts_start = c(2006,1),
                            include.mean = F)

full_pval_df <- get_pval_df(ts_full_conf_4,
                            T0 = length(ts_full_conf_1) - 1,
                            order = full_order,
                            seasonal = full_seasonal,
                            block_vec = c(1:4),
                            post_vec = c(1:3),
                            ts_start = c(2006,1),
                            include.mean = F)


print(xtable(split_pval_df, digits = 4), include.rownames = F)
print(xtable(safe_pval_df, digits = 4), include.rownames = F)
print(xtable(full_pval_df, digits = 4), include.rownames = F)

## PEDAGOGICAL CONFORMAL PLOTS

# Pedagogical p-val plots for the appendix

setwd("~/Documents/projects/ITS/13RW/plots")

y_star <- 11000

ts_aug <- ts(c(ts_est, y_star), 
             start = start(ts_est),  
             frequency = frequency(ts_est))

#Fitting model to augmented ts
mod_aug <- Arima(ts_aug, 
                 order = split_order,
                 seasonal = split_seasonal)

#Extracting fitted values
fit_aug <- fitted(mod_aug)

res_aug <- residuals(mod_aug)

#Creating df for ggplot2
conf_plot_df <- data.frame(fit = fit_aug,
                           res = res_aug,
                           obs = ts_aug, 
                           date = as.Date(ts_aug))

conf_plot_df$aug <- ifelse(conf_plot_df$date == as.Date("2017-04-01"), 1, 0)
conf_plot_df$pre_obs <- conf_plot_df$obs

conf_plot_df <- conf_plot_df[14:75,]
conf_plot_df$pre_obs[62] <- NA_integer_

red_seg_df <- conf_plot_df[abs(conf_plot_df$res) >= abs(conf_plot_df$res[62]),]
blue_seg_df <- conf_plot_df[abs(conf_plot_df$res) < abs(conf_plot_df$res[62]),]

post_df <- conf_plot_df[62,]

my_red <- "#d72631"
my_blue <- "#1786bd"
my_light_blue <- "#8ec6e1"
my_gray <- "#7a8086"

min(conf_plot_df$fit)
min(conf_plot_df$obs)

y_lims <- c(3800, 11000)

#Plot with just pre-treatment series in gray
ggplot() +
  geom_point(conf_plot_df, 
             mapping = aes(x = date, y = pre_obs), 
             size = 2.5, color = my_gray) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(limits = c(as.Date("2012-03-01"), as.Date("2017-05-01")), expand = c(0,50)) +
  scale_y_continuous(limits = y_lims) +
  ylab("") +
  xlab("")

ggsave("confplot1.png", width = 8, height = 5, unit = "in")

ggplot() +
  geom_point(conf_plot_df, 
             mapping = aes(x = date, y = pre_obs), 
             size = 2.5, color = my_gray) +
  geom_point(post_df, 
             mapping = aes(x = date, y = obs), 
             size = 2.5, color = my_red) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(limits = c(as.Date("2012-03-01"), as.Date("2017-05-01")), expand = c(0,50)) +
  scale_y_continuous(limits = y_lims) +
  ylab("") +
  xlab("")

ggsave("confplot2.png", width = 8, height = 5, unit = "in")

ggplot() +
  geom_segment(conf_plot_df, 
               mapping = aes(x = date, xend = date, y = pre_obs, yend = fit), 
               color = my_light_blue) +
  geom_segment(post_df, 
               mapping = aes(x = date, xend = date, y = obs, yend = fit), 
               color = my_light_blue) +
  geom_line(conf_plot_df, 
            mapping = aes(x = date, y = fit)) +
  geom_point(conf_plot_df, 
             mapping = aes(x = date, y = pre_obs), 
             size = 2.5, color =  my_blue) +
  geom_point(post_df, 
             mapping = aes(x = date, y = obs), 
             size = 2.5, color = my_blue) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(limits = c(as.Date("2012-03-01"), as.Date("2017-05-01")), expand = c(0,50)) +
  scale_y_continuous(limits = y_lims) +
  ylab("") +
  xlab("")

ggsave("confplot3.png", width = 8, height = 5, unit = "in")

ggplot() +
  geom_segment(conf_plot_df, 
               mapping = aes(x = date, xend = date, y = pre_obs, yend = fit), 
               color = my_light_blue) +
  geom_segment(post_df, 
               mapping = aes(x = date, xend = date, y = obs, yend = fit), 
               color = my_light_blue) +
  geom_line(conf_plot_df, 
            mapping = aes(x = date, y = fit)) +
  geom_point(conf_plot_df, 
             mapping = aes(x = date, y = pre_obs), 
             size = 2.5, color =  my_blue) +
  geom_point(post_df, 
             mapping = aes(x = date, y = obs), 
             size = 2.5, color = my_red) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(limits = c(as.Date("2012-03-01"), as.Date("2017-05-01")), expand = c(0,50)) +
  scale_y_continuous(limits = y_lims) +
  ylab("") +
  xlab("")

ggsave("confplot4.png", width = 8, height = 5, unit = "in")

# Pedagogical test inversion plots

make_pval_plot <- function(y_star) {
  
  #Creating augmented ts
  ts_aug <- ts(c(ts_est, y_star), 
               start = start(ts_est),  
               frequency = frequency(ts_est))
  
  p_val <- get_arima_pval(Y1 = ts_aug,
                          T1 = 1,
                          T0 = length(ts_aug) - 1,
                          theta0 = 0,
                          block_size = 1,
                          order = split_order,
                          seasonal = split_seasonal,
                          include.mean = F)
  
  #Fitting model to augmented ts
  mod_aug <- Arima(ts_aug, 
                   order = split_order,
                   seasonal = split_seasonal,
                   include.mean = F)
  
  #Extracting fitted values
  fit_aug <- fitted(mod_aug)
  
  res_aug <- residuals(mod_aug)
  
  #Creating df for ggplot2
  conf_plot_df <- data.frame(fit = fit_aug,
                             res = res_aug,
                             obs = ts_aug, 
                             date = as.Date(ts_aug))
  
  conf_plot_df$aug <- ifelse(conf_plot_df$date == as.Date("2017-04-01"), 1, 0)
  conf_plot_df$pre_obs <- conf_plot_df$obs
  conf_plot_df <- conf_plot_df[14:75,]
  conf_plot_df$pre_obs[62] <- NA_integer_
  
  red_seg_df <- conf_plot_df[abs(conf_plot_df$res) >= abs(conf_plot_df$res[62]),]
  blue_seg_df <- conf_plot_df[abs(conf_plot_df$res) < abs(conf_plot_df$res[62]),]
  
  #Separate df for post-treatment res
  post_df <- conf_plot_df[62,]
  
  #Generating plot
  pval_plot <- ggplot() +
    geom_segment(blue_seg_df, 
                 mapping = aes(x = date, xend = date, y = pre_obs, yend = fit), 
                 color = my_light_blue) +
    geom_segment(red_seg_df, 
                 mapping = aes(x = date, xend = date, y = obs, yend = fit), 
                 color = my_red) +
    geom_line(conf_plot_df, 
              mapping = aes(x = date, y = fit)) +
    geom_point(conf_plot_df, 
               mapping = aes(x = date, y = pre_obs), 
               size = 2.5, color =  my_blue) +
    geom_point(post_df, 
               mapping = aes(x = date, y = obs), 
               size = 2.5, color = my_red) +
    theme_classic() +
    theme(text = element_text(size = 20)) +
    scale_x_date(limits = c(as.Date("2012-03-01"), as.Date("2017-05-01")), expand = c(0,50)) +
    scale_y_continuous(limits = c(3800, 11000)) +
    ylab("") +
    xlab("")
  
  plot_name <- paste0("confplot", y_star, ".png")
  
  #Saving plot
  ggsave(plot_name, plot = pval_plot, width = 8, height = 5, unit = "in")
  
  return(p_val)
}

#Generating test-inversion plots
#Figure XXXXXX in paper
lapply(c(11000, 10000, 9750, 9500), make_pval_plot)

## REPEATED PLACEBO TEST PLOTS

## NOTE: These take a long time to run

expand_df_1 <- get_placebo_df(y = ts_full_conf_1,
                              pre_ts_len = 74,
                              post_ts_len = 1,
                              order = split_order,
                              seasonal = split_seasonal,
                              alpha = .05,
                              block_size = 1,
                              pi_grid_width = 3500,
                              tscv_type = "expand")

check_max(expand_df_1, 3500)

# With alpha = 0.05 and block_size > 1, PIs are quite unstable.
# Here I instead compute 90% PIs 

moving_df_1_90 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .1,
                                 block_size = 1,
                                 pi_grid_width = 4000,
                                 tscv_type = "move")

check_max(moving_df_1_90, 4000)

expand_df_1_90 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .1,
                                 block_size = 1,
                                 pi_grid_width = 4000,
                                 tscv_type = "expand")

check_max(expand_df_1_90, 4000)


moving_df_2_90 <- get_placebo_df(y = ts_full_conf_1,
                            pre_ts_len = 74,
                            post_ts_len = 1,
                            order = split_order,
                            seasonal = split_seasonal,
                            alpha = .1,
                            block_size = 2,
                            pi_grid_width = 4000,
                            tscv_type = "move")

check_max(moving_df_2_90, 4000)
#24th placebo test has -Inf / Inf as limits,
#so redoing just that one with larger PI width...

ts_forecast <- ts_full_conf_1[24:(24 + 74 - 1)] %>%
  ts(frequency = 12)

ts_PI <- ts_full_conf_1[24:(24 + 74)] %>%
  ts(frequency = 12)

mod_forecast <- Arima(ts_forecast, order = split_order, seasonal = split_seasonal)

pred <- forecast(mod_forecast, h = 1)$mean

pi_grid <- (pred - (4500/2)):(pred + (4500/2))

PI_iter <- get_arima_PI(ts_PI, T1 = 1, T0 = 74,
                        alpha = 0.1, pi_grid = pi_grid, block_size = 2,
                        order = split_order, seasonal = split_seasonal, include.mean = F)

#examining PI_iter here shows that the p-value is always less than .1,
#so you cannot construct a prediction interval...

#replacing -Inf and Inf with pred...

moving_df_2_90[24,2] <- moving_df_2_90[24,3] <- pred

moving_df_3_90 <- get_placebo_df(y = ts_full_conf_1,
                            pre_ts_len = 74,
                            post_ts_len = 1,
                            order = split_order,
                            seasonal = split_seasonal,
                            alpha = .1,
                            block_size = 3,
                            pi_grid_width = 4000,
                            tscv_type = "move")

check_max(moving_df_3_90, 4000)
#24th placebo test has -Inf / Inf as limits,
#so also replacing with the pred...

moving_df_3_90[24,2] <- moving_df_3_90[24,3] <- pred

expand_df_2_90 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .1,
                                 block_size = 2,
                                 pi_grid_width = 4000,
                                 tscv_type = "expand")

check_max(expand_df_2_90, 4000)

expand_df_3_90 <- get_placebo_df(y = ts_full_conf_1,
                            pre_ts_len = 74,
                            post_ts_len = 1,
                            order = split_order,
                            seasonal = split_seasonal,
                            alpha = .1,
                            block_size = 3,
                            pi_grid_width = 4000,
                            tscv_type = "expand")

check_max(expand_df_3_90, 4000)

saveRDS(moving_df_1, "moving_df_1.rds")
saveRDS(expand_df_1, "expand_df_1.rds")

## MAKING PLACEBO PLOTS

#lapply() doesn't work here since the function
#deparses the df name, and lapply doesn't pass
#the name to the function...I'm sure there's
#a way to make it work but here I just copy and paste

setwd("~/Documents/projects/ITS/13RW/plots")

get_placebo_plot(expand_df_1)
get_placebo_plot(moving_df_1)

setwd("~/Documents/projects/ITS/13RW/plots/more_placebo_plots")

saveRDS(moving_df_1_90, "moving_df_1_90.rds")
saveRDS(moving_df_2_90, "moving_df_2_90.rds")
saveRDS(moving_df_3_90, "moving_df_3_90.rds")

saveRDS(expand_df_1_90, "expand_df_1_90.rds")
saveRDS(expand_df_2_90, "expand_df_2_90.rds")
saveRDS(expand_df_3_90, "expand_df_3_90.rds")

get_placebo_plot(moving_df_1_90)
get_placebo_plot(moving_df_2_90)
get_placebo_plot(moving_df_3_90)

get_placebo_plot(expand_df_1_90)
get_placebo_plot(expand_df_2_90)
get_placebo_plot(expand_df_3_90)

## using standard ARIMA intervals, yields
## basically same results
get_placebo_df_arima <- function(y, pre_ts_len, post_ts_len, order, 
                                 seasonal, tscv_type)
  
moving_df_arima <- get_placebo_df_arima(y = ts_full_conf_1,
                                   pre_ts_len = 74,
                                   post_ts_len = 1,
                                   order = split_order,
                                   seasonal = split_seasonal,
                                   #block_size = 1,
                                   #pi_grid_width = 4000,
                                   tscv_type = "move")

expand_df_arima <- get_placebo_df_arima(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 #alpha = .1,
                                 #block_size = 1,
                                 #pi_grid_width = 4000,
                                 tscv_type = "expand")  

get_placebo_plot(moving_df_arima)
get_placebo_plot(expand_df_arima)

### SUPPLEMENTARY PLACEBO TEST PLOTS

## NOW DOING AT 80%

setwd("/Users/problemtester/Documents/projects/ITS/13RW/plots/more_placebo_plots")

moving_df_1_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 1,
                                 pi_grid_width = 3500,
                                 tscv_type = "move")

moving_df_2_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 2,
                                 pi_grid_width = 5000,
                                 tscv_type = "move")

moving_df_3_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 3,
                                 pi_grid_width = 5000,
                                 tscv_type = "move")

expand_df_1_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 1,
                                 pi_grid_width = 3500,
                                 tscv_type = "expand")

expand_df_2_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 2,
                                 pi_grid_width = 4000,
                                 tscv_type = "expand")

expand_df_3_80 <- get_placebo_df(y = ts_full_conf_1,
                                 pre_ts_len = 74,
                                 post_ts_len = 1,
                                 order = split_order,
                                 seasonal = split_seasonal,
                                 alpha = .2,
                                 block_size = 3,
                                 pi_grid_width = 4500,
                                 tscv_type = "expand")

saveRDS(moving_df_1_80, "moving_df_1_80.rds")
saveRDS(moving_df_2_80, "moving_df_2_80.rds")
saveRDS(moving_df_3_80, "moving_df_3_80.rds")

saveRDS(expand_df_1_80, "expand_df_1_80.rds")
saveRDS(expand_df_2_80, "expand_df_2_80.rds")
saveRDS(expand_df_3_80, "expand_df_3_80.rds")

check_max(moving_df_1_80, 3500)
check_max(moving_df_2_80, 5000)
check_max(moving_df_3_80, 5000)

check_max(expand_df_1_80, 3500)
check_max(expand_df_2_80, 4000)
check_max(expand_df_3_80, 4500)

## DO CHECK MAX STUFF

expand_df_1_80 <- expand_df_1_80[13:74,]
expand_df_2_80 <- expand_df_2_80[13:74,]
expand_df_3_80 <- expand_df_3_80[13:74,]

moving_df_1_80 <- moving_df_1_80[13:74,]
moving_df_2_80 <- moving_df_2_80[13:74,]
moving_df_3_80 <- moving_df_3_80[13:74,]

get_placebo_plot(expand_df_1_80)
get_placebo_plot(expand_df_2_80)
get_placebo_plot(expand_df_3_80)

get_placebo_plot(moving_df_1_80)
get_placebo_plot(moving_df_2_80)
get_placebo_plot(moving_df_3_80)


### PLOTTING PLACEBO TEST RESULTS BY MONTH

setwd("~/Documents/projects/ITS/13RW/plots")

placebo_df <- expand_df_1 %>%
  mutate(observed = as.numeric(window(full_ts, start = c(2012,3), end = c(2017,4))),
         date = seq.Date(from = as.Date("2012-03-01"),
                         to = as.Date("2017-04-01"),
                         by = "1 month"),
         tau = observed - preds,
         tau_upper = observed - lower,
         tau_lower = observed - upper,
         treat = date == as.Date("2017-04-01"),
         fail = (observed <= lower | observed >= upper) & treat == 0,
         point_type = ifelse(treat == 1, "treat",
                             ifelse(fail == 1, "fail", "covered")))

placebo_df_NEW <- placebo_df %>%
  mutate(abs_tau = abs(tau),
         mon = format(date, "%b"),
         year = format(date, "%Y")) %>%
  filter(date < as.Date("2017-05-01"))

placebo_17 <- placebo_df_NEW %>%
  filter(year == "2017",
         date != as.Date("2017-02-01"))

placebo_1216 <- placebo_df_NEW %>%
  filter(year != "2017", date != as.Date("2015-02-01"))

placebo_jitter_15 <- placebo_df_NEW %>%
  filter(date == as.Date("2015-02-01"))

placebo_jitter_17 <- placebo_df_NEW %>%
  filter(date == as.Date("2017-02-01"))


ggplot() +
  geom_point(placebo_1216, mapping = aes(x = mon, y = abs_tau), size = 3.3, shape = 16, color = my_light_gray, alpha = 0.6) +
  geom_text(placebo_1216, mapping = aes(x = mon, y = abs_tau, label = year), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 3, alpha = 0.6) +
  geom_point(placebo_17, mapping = aes(x = mon, y = abs_tau, shape = factor(treat), color = factor(treat), size = factor(treat))) +
  scale_shape_manual(values = c(16, 17)) +
  scale_color_manual(values = c(my_red, my_green)) +
  scale_size_manual(values = c(3.3,3)) +
  geom_text(placebo_17, mapping = aes(x = mon, y = abs_tau, label = year, color = factor(treat)), 
            hjust = -.5, vjust = ifelse(placebo_17$treat == 1, 0.25, 0.45), size = 3) +
  geom_point(placebo_jitter_15, mapping = aes(x = mon, y = abs_tau), shape = 16, size = 3.3, color = my_light_gray,
             position = position_jitter(width = 0.2, seed = 123), alpha = 0.6) +
  geom_text(placebo_jitter_15, mapping = aes(x = mon, y = abs_tau, label = year), 
            color = my_light_gray, hjust = 1.5, vjust = 0.45, size = 3, alpha = 0.6) +
  geom_point(placebo_jitter_17, mapping = aes(x = mon, y = abs_tau), size = 3.3, shape = 16, color = my_red,
             position = position_jitter(width = 0.2, seed = 12345)) +
  geom_text(placebo_jitter_17, mapping = aes(x = mon, y = abs_tau, label = year), 
            color = my_red, hjust = -.5, vjust = 0.45, size = 3) +
  #scale_color_manual(values = c(my_red, my_green)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  scale_x_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May",
                              "Jun", "Jul", "Aug", "Sep", "Oct",
                              "Nov", "Dec"),
                   expand = c(0,1)) + 
  scale_y_continuous(breaks = c(0,450,900,1350), limits = c(0,1350),
                     expand = c(0,30)) +
  labs(x = "",
       y = "")

ggsave("placebo_month_exp.png", width = 8, height = 5, unit = "in")

placebo_df %>%
  filter(date != as.Date("2014-08-01") & date != as.Date("2017-04-01")) %>%
  summarize(mean = mean(tau), sd = sd(tau),
            hundred = sum(abs(tau) > 100))


## RESIDUAL PLOTS

# main mod
  
complete_mod <- Arima(full_ts, order = full_order, seasonal = full_seasonal)

abs_res <- abs(as.numeric(complete_mod$residuals))[14:length(complete_mod$residuals)]

res <- as.numeric(complete_mod$residuals)[14:length(complete_mod$residuals)]

dates <- seq.Date(from = as.Date("2007-02-01"),
                  to = as.Date("2017-12-01"),
                  by = "1 month")

plot_month_df <- data.frame(abs_res, res, dates) %>%
  mutate(mon = format(dates, "%b"),
  year = format(dates, "%Y"),
  shcolor = ifelse(dates < as.Date("2017-04-01"), 1,
                   ifelse(dates < as.Date("2017-06-01"), 2, 3)))

plot_month_0916 <- plot_month_df %>%
  filter(year != "2017")

plot_month_17 <- plot_month_df %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(dates < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_point(plot_month_0916, mapping = aes(x = mon, y = abs_res), shape = 16, size = 3.3, 
             color = my_light_gray, alpha = 0.6) +
  geom_text(plot_month_0916, mapping = aes(x = mon, y = abs_res, label = year), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 3, alpha = 0.6) +
  geom_point(plot_month_17, mapping = aes(x = mon, y = abs_res, shape = factor(treat), color = factor(treat), size = factor(treat))) +
  scale_shape_manual(values = c(16, 17)) +
  scale_color_manual(values = c(my_red, my_green)) +
  scale_size_manual(values = c(3.3,3)) +
  geom_text(plot_month_17, mapping = aes(x = mon, y = abs_res, label = year, color = factor(treat)), 
            hjust = -.5, vjust = 0.45, size = 3) +
  #scale_color_manual(values = c(my_red, my_green)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  scale_x_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May",
                              "Jun", "Jul", "Aug", "Sep", "Oct",
                              "Nov", "Dec"),
                   expand = c(0,1)) + 
  scale_y_continuous(limits = c(0,1500), expand = c(0,40)) +
  labs(x = "",
       y = "")

ggsave("month_res_plot.png", width = 8, height = 5, unit = "in")

dgray <- "#7e8082"
lgray <- "#b5b9bc"

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_point(plot_month_df, mapping = aes(x = dates, y = res, shape = factor(shcolor), color = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylim(-1400, 1400) +
  labs(x = "",
       y = "")

ggsave("res_plot.png", width = 8, height = 5, unit = "in")

# mod selected on full ts

complete_mod_s <- auto.arima(full_ts)

abs_res_s <- abs(as.numeric(complete_mod_s$residuals))[14:length(complete_mod_s$residuals)]

res_s <- as.numeric(complete_mod_s$residuals)[14:length(complete_mod_s$residuals)]

dates <- seq.Date(from = as.Date("2007-02-01"),
                  to = as.Date("2017-12-01"),
                  by = "1 month")

plot_month_df <- data.frame(abs_res_s, res_s, dates) %>%
  mutate(mon = format(dates, "%b"),
         year = format(dates, "%Y"),
         shcolor = ifelse(dates < as.Date("2017-04-01"), 1,
                          ifelse(dates < as.Date("2017-06-01"), 2, 3)))

plot_month_0916 <- plot_month_df %>%
  filter(year != "2017")

plot_month_17 <- plot_month_df %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(dates < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_point(plot_month_0916, mapping = aes(x = mon, y = abs_res_s), shape = 16, size = 3.3, 
             color = my_light_gray, alpha = 0.6) +
  geom_text(plot_month_0916, mapping = aes(x = mon, y = abs_res_s, label = year), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 3, alpha = 0.6) +
  geom_point(plot_month_17, mapping = aes(x = mon, y = abs_res_s, shape = factor(treat), color = factor(treat), size = factor(treat))) +
  scale_shape_manual(values = c(16, 17)) +
  scale_color_manual(values = c(my_red, my_green)) +
  scale_size_manual(values = c(3.3,3)) +
  geom_text(plot_month_17, mapping = aes(x = mon, y = abs_res_s, label = year, color = factor(treat)), 
            hjust = -.5, vjust = 0.45, size = 3) +
  #scale_color_manual(values = c(my_red, my_green)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  scale_x_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May",
                              "Jun", "Jul", "Aug", "Sep", "Oct",
                              "Nov", "Dec"),
                   expand = c(0,1)) + 
  scale_y_continuous(limits = c(0,1500), expand = c(0,40)) +
  labs(x = "",
       y = "")

ggsave("month_res_plot_s.png", width = 8, height = 5, unit = "in")

dgray <- "#7e8082"
lgray <- "#b5b9bc"

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_point(plot_month_df, mapping = aes(x = dates, y = res_s, shape = factor(shcolor), color = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylim(-1400, 1400) +
  labs(x = "",
       y = "")

ggsave("res_plot_s.png", width = 8, height = 5, unit = "in")

# mod using more complex ARIMA specification

complex_mod <- Arima(full_ts, order = c(3,1,1), seasonal = c(1,1,0))

abs_res <- abs(as.numeric(complex_mod$residuals))[14:length(complex_mod$residuals)]

res <- as.numeric(complex_mod$residuals)[14:length(complex_mod$residuals)]

dates <- seq.Date(from = as.Date("2007-02-01"),
                  to = as.Date("2017-12-01"),
                  by = "1 month")

plot_month_df <- data.frame(abs_res, res, dates) %>%
  mutate(mon = format(dates, "%b"),
         year = format(dates, "%Y"),
         shcolor = ifelse(dates < as.Date("2017-04-01"), 1,
                          ifelse(dates < as.Date("2017-06-01"), 2, 3)))

plot_month_0916 <- plot_month_df %>%
  filter(year != "2017")

plot_month_17 <- plot_month_df %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(dates < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_point(plot_month_df, mapping = aes(x = dates, y = res, shape = factor(shcolor), color = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylim(-1400, 1400) +
  labs(x = "",
       y = "")

ggsave("res_plot_c.png", width = 8, height = 5, unit = "in")

# mod using another, more complex ARIMA specification

complex_mod <- Arima(full_ts, order = c(4,1,2), seasonal = c(1,1,0))

abs_res <- abs(as.numeric(complex_mod$residuals))[14:length(complex_mod$residuals)]

res <- as.numeric(complex_mod$residuals)[14:length(complex_mod$residuals)]

dates <- seq.Date(from = as.Date("2007-02-01"),
                  to = as.Date("2017-12-01"),
                  by = "1 month")

plot_month_df <- data.frame(abs_res, res, dates) %>%
  mutate(mon = format(dates, "%b"),
         year = format(dates, "%Y"),
         shcolor = ifelse(dates < as.Date("2017-04-01"), 1,
                          ifelse(dates < as.Date("2017-06-01"), 2, 3)))

plot_month_0916 <- plot_month_df %>%
  filter(year != "2017")

plot_month_17 <- plot_month_df %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(dates < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_point(plot_month_df, mapping = aes(x = dates, y = res, shape = factor(shcolor), color = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylim(-1400, 1400) +
  labs(x = "",
       y = "")

ggsave("res_plot_c2.png", width = 8, height = 5, unit = "in")

# split mod

simple_mod <- Arima(full_ts, order = split_order, seasonal = split_seasonal)

abs_res <- abs(as.numeric(simple_mod$residuals))[14:length(simple_mod$residuals)]

res <- as.numeric(simple_mod$residuals)[14:length(simple_mod$residuals)]

dates <- seq.Date(from = as.Date("2007-02-01"),
                  to = as.Date("2017-12-01"),
                  by = "1 month")

plot_month_df <- data.frame(abs_res, res, dates) %>%
  mutate(mon = format(dates, "%b"),
         year = format(dates, "%Y"),
         shcolor = ifelse(dates < as.Date("2017-04-01"), 1,
                          ifelse(dates < as.Date("2017-06-01"), 2, 3)))

plot_month_0916 <- plot_month_df %>%
  filter(year != "2017")

plot_month_17 <- plot_month_df %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(dates < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_point(plot_month_df, mapping = aes(x = dates, y = res, shape = factor(shcolor), color = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  ylim(-1400, 1400) +
  labs(x = "",
       y = "")

ggsave("res_plot_split.png", width = 8, height = 5, unit = "in")

### FIRST-DIFFERENCE MONTH PLOT

df_fd <- na.omit(data.frame(date = tg$date, selfh = tg$self_h_fd, month = tg$amonth)) %>%
  mutate(mon = format(date, "%b"),
         year = format(date, "%Y"),
         shcolor = ifelse(date < as.Date("2017-04-01"), 1,
                          ifelse(date < as.Date("2017-06-01"), 2, 3)))

df_fd_0916 <- df_fd %>%
  filter(year != "2017")

df_fd_17 <- df_fd %>%
  filter(year == "2017") %>%
  mutate(treat = ifelse(date < as.Date("2017-04-01"), 0, 1))

ggplot() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point(df_fd_0916, mapping = aes(x = mon, y = selfh), shape = 16, size = 3.3, 
             color = my_light_gray, alpha = 0.6) +
  geom_text(df_fd_0916, mapping = aes(x = mon, y = selfh, label = year), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 3, alpha = 0.6) +
  geom_point(df_fd_17, mapping = aes(x = mon, y = selfh, shape = factor(treat), color = factor(treat), size = factor(treat))) +
  scale_shape_manual(values = c(16, 17)) +
  scale_color_manual(values = c(my_red, my_green)) +
  scale_size_manual(values = c(3.3,3)) +
  geom_text(df_fd_17, mapping = aes(x = mon, y = selfh, label = year, color = factor(treat)), 
            hjust = -.5, vjust = 0.45, size = 3) +
  #scale_color_manual(values = c(my_red, my_green)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  scale_x_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May",
                              "Jun", "Jul", "Aug", "Sep", "Oct",
                              "Nov", "Dec"),
                   expand = c(0,1)) + 
  scale_y_continuous(limits = c(-3500,3500), expand = c(0,40),
                     breaks = c(-3000,-1500,0,1500,3000)) +
  labs(x = "",
       y = "")

ggsave("fd.png", width = 8, height = 5, unit = "in")

## MULTI-STEP-AHEAD PLOTS

# for main analysis

post_df <- data.frame(matrix(NA, nrow = 5, ncol = 5))

colnames(post_df) <- c("date", "obs", "forecast", "upper", "lower", "treat")

msa_forecast <- forecast(full_mod, h = 4, level = 95, bootstrap = T)

#the df will contain one pre-forecast row for ggplot purposes
post_df$date <- seq.Date(from = as.Date("2017-03-01"), to = as.Date("2017-07-01"), by = "1 month")
post_df$obs <- full_ts[135:139]
post_df$forecast <- c(fitted(full_mod)[135], as.numeric(msa_forecast$mean))
post_df$upper <- c(fitted(full_mod)[135], as.numeric(msa_forecast$upper))
post_df$lower <- c(fitted(full_mod)[135], as.numeric(msa_forecast$lower))

post_df$treat <- c(0,1,1,1,1)

pre_df <- data.frame(date = seq.Date(from = as.Date("2016-11-01"), to = as.Date("2017-03-01"), by = "1 month"),
                     obs = c(full_ts[131:134], NA),
                     fitted = fitted(full_mod)[131:135])

ggplot() + 
  geom_vline(aes(xintercept = as.Date("2017-02-15")), linetype = "dotted") +
  geom_vline(aes(xintercept = as.Date("2017-03-15")), linetype = "dotted") +
  geom_line(pre_df, mapping = aes(x = date, y = fitted), size = 0.7) +
  geom_point(pre_df, mapping = aes(x = date, y = obs), color = blue_obs, size = 8, alpha = .7, shape ="\u25cf") +
  geom_line(post_df, mapping = aes(x = date, y = forecast), linetype = "dashed", size = 0.7) +
  geom_ribbon(post_df, mapping = aes(x = date, ymin = lower, ymax = upper), fill = blue_ribbon, alpha = .2) +
  geom_point(post_df, mapping = aes(x = date, y = obs, color = factor(treat), shape = factor(treat), size = factor(treat)),
             alpha = .7) +
  scale_color_manual(values = c(blue_obs, my_green)) +
  scale_shape_manual(values = c("\u25cf", "\u25b2")) +
  scale_size_manual(values = c(8,10)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = "none",
        text = element_text(size = 20)) +
  scale_x_date(
    date_labels = "%b %Y",
    breaks = c(as.Date("2016-12-01"),
               as.Date("2017-03-01"),
               as.Date("2017-06-01"))) +
  scale_y_continuous(limits = c(6300, 12300),
                     breaks = c(7000, 9000, 11000)) +
  ylab("") +
  xlab("")

setwd("~/Documents/projects/ITS/13RW/plots")

ggsave("tau_length.png", width = 8, height = 6, units = "in")

# for alternative cut-off points

multi_df <- (as.data.frame(multi_df))

multi_dfs <- get_multi_dfs(np = 6, start_date = as.Date("2016-10-01"), full_ts = full_ts)

inf_df <- multi_dfs[[2]]

mod1 <- multi_dfs[[1]][[1]]
mod2 <- multi_dfs[[1]][[2]]
mod3 <- multi_dfs[[1]][[3]]
mod4 <- multi_dfs[[1]][[4]]
mod5 <- multi_dfs[[1]][[5]]
mod6 <- multi_dfs[[1]][[6]]

make_multi_plots(start_date = as.Date("2016-09-01"), 6)

## MODEL-FREE PLOTS

start_dates <- seq.Date(from = as.Date("2011-09-01"), to = as.Date("2016-09-01"), by = "1 year")
end_dates <- seq.Date(from = as.Date("2012-06-01"), to = as.Date("2017-06-01"), by = "1 year")
for_names <- 12:17

#These are not the actual dates, just dates to make plotting in ggplot
#easier, since we're plotting a different line for each year
ggplot_dates <- seq.Date(from = as.Date("2016-10-01"), to = as.Date("2017-05-01"), by = "1 month")

for (i in 1:length(for_names)) {

  df_temp <- tg %>%
    filter(date > start_dates[i] & date < end_dates[i]) %>%
    select(self_h, self_h_fd, date) %>%
    mutate(date = ggplot_dates,
           year = paste0("20", for_names[i]))

  df_name <- paste0("df_", for_names[i])
  eval(call("<-", as.name(df_name), df_temp))

}

my_light_gray <- "#a0a6ac"
another_blue <- "#3080d0"

#using wide ylims to make room for labels in latex

ggplot() +
  geom_vline(df_17, mapping = aes(x = date, xintercept = as.Date("2017-02-15")), linetype = "dashed") +
  geom_vline(df_17, mapping = aes(x = date, xintercept = as.Date("2017-03-15")), linetype = "dashed") +
  geom_line(df_16, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_16, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_16, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_15, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_15, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_15, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_14, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_14, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_14, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.35, color = my_light_gray, size = 5) +
  geom_line(df_13, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_13, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_13, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.6, color = my_light_gray, size = 5) +
  geom_line(df_12, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_12, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_12, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_17, mapping = aes(x = date, y = self_h), color = another_blue, alpha = 0.5) +
  geom_point(df_17, mapping = aes(x = date, y = self_h, label = year), color = another_blue, size = 3, shape = 17) +
  geom_text(df_17, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-05-01"), year, "")), 
            hjust = -.5, vjust = 0.33, color = another_blue, size = 5) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(expand = c(0,30)) +
  scale_y_continuous(limits = c(3900, 13000)) +
  ylab("") +
  xlab("")

ggsave("model_free_labs.png", width = 8, height = 5, unit = "in")  

for_names <- c("06", "07", "08", "09", "10", "11", 
               "12", "13", "14", "15", "16", "17")

## Feb-Mar plot
ggplot_dates <- c(as.Date("2017-02-01"), as.Date("2017-03-01"))

start_dates <- seq.Date(from = as.Date("2006-02-01"), to = as.Date("2017-02-01"), by = "1 year")
end_dates <- seq.Date(from = as.Date("2006-03-01"), to = as.Date("2017-03-01"), by = "1 year")

for (i in 1:length(for_names)) {
  
  df_temp <- tg %>%
    filter(date >= start_dates[i] & date <= end_dates[i]) %>%
    select(self_h, date) %>%
    mutate(date = ggplot_dates,
           year = paste0("20", for_names[i]))
  
  df_name <- paste0("df_", for_names[i], "_feb")
  eval(call("<-", as.name(df_name), df_temp))
  
}

ggplot() +
  geom_line(df_06_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_06_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_06_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_07_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_07_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_07_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_08_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_08_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_08_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_09_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_09_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_09_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_10_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_10_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_10_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_11_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_11_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_11_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_12_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_12_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_12_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_13_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_13_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_13_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_14_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_14_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_14_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_15_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_15_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_15_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_16_feb, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_16_feb, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_16_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_17_feb, mapping = aes(x = date, y = self_h), color = another_blue, alpha = 0.5) +
  geom_point(df_17_feb, mapping = aes(x = date, y = self_h, label = year), color = another_blue, size = 3, shape = 17) +
  geom_text(df_17_feb, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-03-01"), year, "")), 
            hjust = -.5, vjust = 0.33, color = another_blue, size = 5) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(expand = c(0,10),
               date_labels = "%b",
               limits = c(as.Date("2017-02-01"), as.Date("2017-03-01")),
               breaks = c(as.Date("2017-02-01"), as.Date("2017-03-01"))) +
  scale_y_continuous(limits = c(4000, 10000)) +
  ylab("") +
  xlab("")

ggsave("feb.png", width = 5, height = 5, units = "in")

## Mar-Apr plot
ggplot_dates <- c(as.Date("2017-03-01"), as.Date("2017-04-01"))

start_dates <- seq.Date(from = as.Date("2006-03-01"), to = as.Date("2017-03-01"), by = "1 year")
end_dates <- seq.Date(from = as.Date("2006-04-01"), to = as.Date("2017-04-01"), by = "1 year")

for (i in 1:length(for_names)) {
  
  df_temp <- tg %>%
    filter(date >= start_dates[i] & date <= end_dates[i]) %>%
    select(self_h, date) %>%
    mutate(date = ggplot_dates,
           year = paste0("20", for_names[i]))
  
  df_name <- paste0("df_", for_names[i], "_mar")
  eval(call("<-", as.name(df_name), df_temp))
  
}

ggplot() +
  geom_line(df_06_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_06_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_06_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_07_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_07_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_07_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_08_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_08_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_08_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_09_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_09_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_09_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_10_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_10_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_10_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_11_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_11_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_11_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_12_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_12_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_12_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_13_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_13_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_13_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_14_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_14_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_14_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_15_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_15_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_15_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_16_mar, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_16_mar, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_16_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_17_mar, mapping = aes(x = date, y = self_h), color = another_blue, alpha = 0.5) +
  geom_point(df_17_mar, mapping = aes(x = date, y = self_h, label = year), color = another_blue, size = 3, shape = 17) +
  geom_text(df_17_mar, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-04-01"), year, "")), 
            hjust = -.5, vjust = 0.33, color = another_blue, size = 5) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(expand = c(0,10),
               date_labels = "%b",
               limits = c(as.Date("2017-03-01"), as.Date("2017-04-01")),
               breaks = c(as.Date("2017-03-01"), as.Date("2017-04-01"))) +
  scale_y_continuous(limits = c(4000, 11000)) +
  ylab("") +
  xlab("")

ggsave("mar.png", width = 5, height = 5, units = "in")


### SUPPLEMENTARY ANALYSIS: SELF-HARM 
### VISITS FOR CUTTING

tg <- tg %>%
  mutate(treat = ifelse(date == as.Date("2017-04-01"), 1, 0),
         treat2 = ifelse(date == as.Date("2017-04-01"), 1,
                         ifelse(date == as.Date("2017-05-01"), 1, 0)),
         cut_prop_fd = cut_prop - lag(cut_prop),
         cut_prop_sfd = cut_prop_fd - lag(cut_prop_fd, n = 12),
         shcolor = ifelse(date < as.Date("2017-04-01"), 1,
                          ifelse(date < as.Date("2017-06-01"), 2, 3)))

prop_lower <- quantile(tg$cut_prop, probs = .05)
prop_upper <- quantile(tg$cut_prop, probs = .95)

tg <- tg %>%
  group_by(year) %>%
  mutate(cut_prop_demeaned = cut_prop - mean(cut_prop)) %>%
  ungroup()

which(order(tg$cut_prop, decreasing = T) == 136)
which(order(tg$cut_prop, decreasing = T) == 137)

length(tg$cut_prop[tg$cut_prop <= tg$cut_prop[136]])/length(tg$cut_prop)*100
length(tg$cut_prop[tg$cut_prop <= tg$cut_prop[137]])/length(tg$cut_prop)*100

which(order(tg$cut_prop_demeaned, decreasing = T) == 136)
which(order(tg$cut_prop_demeaned, decreasing = T) == 137)

length(tg$cut_prop_demeaned[tg$cut_prop_demeaned <= tg$cut_prop_demeaned[136]])/length(tg$cut_prop_demeaned)*100
length(tg$cut_prop_demeaned[tg$cut_prop_demeaned <= tg$cut_prop_demeaned[137]])/length(tg$cut_prop_demeaned)*100

order(tg$cut_prop, decreasing = T)
order(tg$cut_prop_demeaned, decreasing = T)

tg_cut_pre <- tg$cut_prop[1:137]

which(order(tg_cut_pre, decreasing = T) == 136)
which(order(tg_cut_pre, decreasing = T) == 137)

length(tg_cut_pre[tg_cut_pre <= tg_cut_pre[136]])/length(tg_cut_pre)*100
length(tg_cut_pre[tg_cut_pre <= tg_cut_pre[137]])/length(tg_cut_pre)*100

dgray <- "#7e8082"
lgray <- "#b5b9bc"

ggplot(tg) +
  geom_hline(yintercept = prop_lower, linetype = "dashed") +
  geom_hline(yintercept = prop_upper, linetype = "dashed") +
  geom_point(mapping = aes(x = date, y = cut_prop, color = factor(shcolor), shape = factor(shcolor)), size = 4) +
  scale_shape_manual(values = c(19, 17, 15)) +
  scale_color_manual(values = c(dgray, my_red, lgray)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(breaks = c(as.Date("2008-01-01"), as.Date("2012-01-01"), as.Date("2016-01-01")),
               date_labels = "%b %Y") +
  ylab("") +
  xlab("")

ggsave("cut_prop_raw.png", width = 8, height = 5, unit = "in")

tg_for_supp <- tg %>%
  mutate(mon = format(tg$date, "%b"),
         apr_may = ifelse(mon == "Apr", 1,
                          ifelse(mon == "May", 1, 0)))

tg_apr_may <- tg_for_supp[tg_for_supp$mon == "Apr" | tg_for_supp$mon == "May",]
tg_no_apr <- tg_for_supp[tg_for_supp$mon != "Apr" & tg_for_supp$mon != "May",]

ggplot() +
  #geom_point(mapping = aes(x = year, y = cut_prop, label = mon)) +
  geom_text(tg_no_apr, mapping = aes(x = year, y = cut_prop, label = mon), alpha = 0.5) +
  geom_text(tg_apr_may, mapping = aes(x = year, y = cut_prop, label = mon), color = "red", fontface = "bold") +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_continuous(labels = as.character(2006:2017), breaks = 2006:2017) +
  ylab("") +
  xlab("")

ggsave("text_plot.png", width = 8, height = 5, unit = "in")

### SUPPLEMENTARY ANALYSIS: SELF-HARM 
### VISITS FOR OTHER DEMOGRAPHIC GROUPS

setwd("~/Documents/projects/ITS/13RW/data")

# TEEN GIRLS
tg_PI <- get_arima_PI(ts_full_conf_1,
                      T1 = 1,
                      T0 = length(pre_ts),
                      alpha = 0.05,
                      pi_grid = 8000:10000, 
                      block_size = 1,
                      order = full_order,
                      seasonal = full_seasonal,
                      include.mean = F)

tg_upper <- tg_PI$ub
tg_lower <- tg_PI$lb

tg_dfs <- get_plot_dfs(ts_full_conf_1, full_mod, tg_upper, tg_lower)

get_control_plot(pre_df = tg_dfs$pre_df,
                 post_df = tg_dfs$post_df,
                 name = "tg",
                 y_min = 6500,
                 y_max = 10500)

## TEEN BOYS

tb <- readRDS("tb_selfh_all_full.rds")
tb_ts <- create_ts(tb)
tb_ts_pre <- tb_ts$pre_ts
tb_ts_post <- tb_ts$ts_full_conf_1

# auto.arima alone doesn't choose both forms of differencing for tb,
# so here I force it to be consistent with the rest of the analyses
# by setting d = 1, D = 1

# however, this changes the results very little

ords <- give_me_order(tb_ts_pre, d = 1, D = 1)

tb_mod <- Arima(tb_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tb_PI <- get_arima_PI(tb_ts_post, 
                       T1 = 1, 
                       T0 = length(tb_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 2500:3800, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

tb_upper <- tb_PI$ub
tb_lower <- tb_PI$lb

tb_dfs <- get_plot_dfs(tb_ts_post, tb_mod, tb_upper, tb_lower)

get_control_plot(pre_df = tb_dfs$pre_df,
                 post_df = tb_dfs$post_df,
                 name = "tb",
                 y_min = 1000,
                 y_max = 5000)

# without forced diff'ing

ords <- give_me_order(tb_ts_pre)

tb_mod <- Arima(tb_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tb_PI <- get_arima_PI(tb_ts_post, 
                      T1 = 1, 
                      T0 = length(tb_ts_pre),
                      alpha = 0.05, 
                      pi_grid = 2500:3800, 
                      block_size = 1,
                      order = ords$order, 
                      seasonal = ords$seasonal, 
                      include.mean = F)

tb_upper <- tb_PI$ub
tb_lower <- tb_PI$lb

tb_dfs <- get_plot_dfs(tb_ts_post, tb_mod, tb_upper, tb_lower)

get_control_plot(pre_df = tb_dfs$pre_df,
                 post_df = tb_dfs$post_df,
                 name = "tb_alt",
                 y_min = 1000,
                 y_max = 5000)

## MEN 40-65

m40 <- readRDS("m40_selfh_all_full.rds")
m40_ts <- create_ts(m40)
m40_ts_pre <- m40_ts$pre_ts
m40_ts_post <- m40_ts$ts_full_conf_1
ords <- give_me_order(m40_ts_pre)

m40_mod <- Arima(m40_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

m40_PI <- get_arima_PI_CSS(m40_ts_post, 
                       T1 = 1, 
                       T0 = length(m40_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 3500:5000, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

m40_upper <- m40_PI$ub
m40_lower <- m40_PI$lb

m40_dfs <- get_plot_dfs(m40_ts_post, m40_mod, m40_upper, m40_lower)

get_control_plot(pre_df = m40_dfs$pre_df,
                 post_df = m40_dfs$post_df,
                 name = "m40",
                 y_min = 2000,
                 y_max = 6000)

## WOMEN 40-65

w40 <- readRDS("w40_selfh_all_full.rds")
w40_ts <- create_ts(w40)
w40_ts_pre <- w40_ts$pre_ts
w40_ts_post <- w40_ts$ts_full_conf_1
ords <- give_me_order(w40_ts_pre)

w40_mod <- Arima(w40_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

w40_PI <- get_arima_PI(w40_ts_post, 
                       T1 = 1, 
                       T0 = length(w40_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 4500:6000, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

w40_upper <- w40_PI$ub
w40_lower <- w40_PI$lb

w40_dfs <- get_plot_dfs(w40_ts_post, w40_mod, w40_upper, w40_lower)

get_control_plot(pre_df = w40_dfs$pre_df,
                 post_df = w40_dfs$post_df,
                 name = "w40",
                 y_min = 3000,
                 y_max = 7000)

## TEEN GIRLS cutting and poison only

tg_poiscut <- readRDS("tg_pois_cut_all_full.rds")
tg_poiscut_ts <- create_ts(tg_poiscut)
tg_poiscut_ts_pre <- tg_poiscut_ts$pre_ts
tg_poiscut_ts_post <- tg_poiscut_ts$ts_full_conf_1
ords <- give_me_order(tg_poiscut_ts_pre)

tg_poiscut_mod <- Arima(tg_poiscut_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tg_poiscut_PI <- get_arima_PI(tg_poiscut_ts_post, 
                       T1 = 1, 
                       T0 = length(tg_poiscut_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 7000:10000, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

tg_poiscut_upper <- tg_poiscut_PI$ub
tg_poiscut_lower <- tg_poiscut_PI$lb

tg_poiscut_dfs <- get_plot_dfs(tg_poiscut_ts_post, tg_poiscut_mod, tg_poiscut_upper, tg_poiscut_lower)

get_control_plot(pre_df = tg_poiscut_dfs$pre_df,
                 post_df = tg_poiscut_dfs$post_df,
                 name = "tg_poiscut",
                 y_min = 6000,
                 y_max = 10000)

## GIRLS 10--17

tg17 <- readRDS("tg17_selfh_all_full.rds")
tg17_ts <- create_ts(tg17)
tg17_ts_pre <- tg17_ts$pre_ts
tg17_ts_post <- tg17_ts$ts_full_conf_1
ords <- give_me_order(tg17_ts_pre)

tg17_mod <- Arima(tg17_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tg17_PI <- get_arima_PI(tg17_ts_post, 
                       T1 = 1, 
                       T0 = length(tg17_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 5000:8000, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

tg17_upper <- tg17_PI$ub
tg17_lower <- tg17_PI$lb

tg17_dfs <- get_plot_dfs(tg17_ts_post, tg17_mod, tg17_upper, tg17_lower)

get_control_plot(pre_df = tg17_dfs$pre_df,
                 post_df = tg17_dfs$post_df,
                 name = "tg17",
                 y_min = 5000,
                 y_max = 9000)

## TG STARTING 2013

tg2013 <- readRDS("tg_self_harm.rds")
tg2013_ts <- create_ts(tg2013)
tg2013_ts_pre <- tg2013_ts$pre_ts %>%
  window(start = c(2013,1))
tg2013_ts_post <- tg2013_ts$ts_full_conf_1 %>%
  window(start = c(2013,1))
ords <- give_me_order(tg2013_ts_pre)

tg2013_mod <- Arima(tg2013_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tg2013_PI <- get_arima_PI(tg2013_ts_post, 
                        T1 = 1, 
                        T0 = length(tg2013_ts_pre),
                        alpha = 0.05, 
                        pi_grid = 7000:11000, 
                        block_size = 1,
                        order = ords$order, 
                        seasonal = ords$seasonal, 
                        include.mean = F)

tg2013_upper <- tg2013_PI$ub
tg2013_lower <- tg2013_PI$lb

tg2013_dfs <- get_plot_dfs(tg2013_ts_post, tg2013_mod, tg2013_upper, tg2013_lower)

get_control_plot(pre_df = tg2013_dfs$pre_df,
                 post_df = tg2013_dfs$post_df,
                 name = "tg2013",
                 y_min = 6500,
                 y_max = 10500)

## TG STARTING 2014

tg2014 <- readRDS("tg_self_harm.rds")
tg2014_ts <- create_ts(tg2014)
tg2014_ts_pre <- tg2014_ts$pre_ts %>%
  window(start = c(2014,1))
tg2014_ts_post <- tg2014_ts$ts_full_conf_1 %>%
  window(start = c(2014,1))
ords <- give_me_order(tg2014_ts_pre)

tg2014_mod <- Arima(tg2014_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

tg2014_PI <- get_arima_PI(tg2014_ts_post, 
                          T1 = 1, 
                          T0 = length(tg2014_ts_pre),
                          alpha = 0.05, 
                          pi_grid = 7000:11000, 
                          block_size = 1,
                          order = ords$order, 
                          seasonal = ords$seasonal, 
                          include.mean = F)

tg2014_upper <- tg2014_PI$ub
tg2014_lower <- tg2014_PI$lb

tg2014_dfs <- get_plot_dfs(tg2014_ts_post, tg2014_mod, tg2014_upper, tg2014_lower)

get_control_plot(pre_df = tg2014_dfs$pre_df,
                 post_df = tg2014_dfs$post_df,
                 name = "tg2014",
                 y_min = 6500,
                 y_max = 10500)

### SUPPLEMENTARY ANALYSIS: REPEATED
### DIFF-IN-DIFF ANALYSES

tg <- tg %>%
  mutate(self_h_m = m40$self_h,
         self_h_w = w40$self_h,
         self_h_tb = tb$self_h,
         did_m = (self_h - lag(self_h)) - (self_h_m - lag(self_h_m)),
         did_w = (self_h - lag(self_h)) - (self_h_w - lag(self_h_w)),
         did_tb = (self_h - lag(self_h)) - (self_h_tb - lag(self_h_tb)),
         shcolor = ifelse(date < as.Date("2017-04-01"), 1,
                         ifelse(date < as.Date("2017-05-01"), 2, 3)))

tg_for_did <- tg[tg$date > as.Date("2006-01-01"),]

setwd("~/Documents/projects/ITS/13RW/plots")

de_blue <- "#3E5C76"
mblue <- "#7EBDC2"
amaranth <- "#E83151"  
  
ggplot(tg_for_did) +
  geom_hline(yintercept = quantile(tg_for_did$did_m, probs = .05), linetype = "dashed") +
  geom_hline(yintercept = quantile(tg_for_did$did_m, probs = .95), linetype = "dashed") +
  geom_point(mapping = aes(x = date, y = did_m, color = factor(shcolor), shape = factor(shcolor)), size = 5) +
  scale_color_manual(values = c(de_blue, amaranth, mblue)) +
  scale_shape_manual(values = c(19, 17, 15)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(breaks = c(seq.Date(from = as.Date("2006-10-01"), to = as.Date("2017-12-01"), by = "42 months")),
                     date_labels = "%b %Y") +
  ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("did_m.png", width = 9, height = 5, unit = "in")

ggplot(tg_for_did) +
  geom_hline(yintercept = quantile(tg_for_did$did_w, probs = .05), linetype = "dashed") +
  geom_hline(yintercept = quantile(tg_for_did$did_w, probs = .95), linetype = "dashed") +
  geom_point(mapping = aes(x = date, y = did_w, color = factor(shcolor), shape = factor(shcolor)), size = 5) +
  scale_color_manual(values = c(de_blue, amaranth, mblue)) +
  scale_shape_manual(values = c(19, 17, 15)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(breaks = c(seq.Date(from = as.Date("2006-10-01"), to = as.Date("2017-12-01"), by = "42 months")),
               date_labels = "%b %Y") +
  ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("did_w.png", width = 9, height = 5, unit = "in")

ggplot(tg_for_did) +
  geom_hline(yintercept = quantile(tg_for_did$did_tb, probs = .05), linetype = "dashed") +
  geom_hline(yintercept = quantile(tg_for_did$did_tb, probs = .95), linetype = "dashed") +
  geom_point(mapping = aes(x = date, y = did_tb, color = factor(shcolor), shape = factor(shcolor)), size = 5) +
  scale_color_manual(values = c(de_blue, amaranth, mblue)) +
  scale_shape_manual(values = c(19, 17, 15)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(breaks = c(seq.Date(from = as.Date("2006-10-01"), to = as.Date("2017-12-01"), by = "42 months")),
               date_labels = "%b %Y") +
  ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("did_tb.png", width = 9, height = 5, unit = "in")

## PLACEBO TEST SIM

vec <- rep(NA,5000)
for (i in 1:5000) {
  
  x <- runif(60)
  vec[i] <- sum(x < 0.05)
  
}

table(vec)

mean(vec >= 6)

## DIFFERENTIAL MISCLASSIFICATION ANALYSIS

setwd("~/Documents/projects/ITS/13RW/data")

tg_cut_poison <- readRDS("tg_cut_poison.rds")

setwd("~/Documents/projects/ITS/13RW/plots")

tg_cut_poison_17 <- tg_cut_poison %>%
  filter(date > as.Date("2016-12-01") & date < as.Date("2017-06-01"))

tg_cut_poison_16 <- tg_cut_poison %>%
  filter(date >= as.Date("2016-01-01") & date < as.Date("2016-06-01")) %>%
  mutate(date = as.Date(str_replace(as.character(date), "2016", "2017")))

ggplot() +
  geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
  geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
  geom_line(data = tg_cut_poison_16, mapping = aes(x = date, y=cut_poison, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_16, mapping = aes(x = date, y=cut_poison, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_16, mapping = aes(x = date, y = cut_poison, 
                                                 label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_16$type == "undeter", -0.1, 0.45)) +
  geom_line(data = tg_cut_poison_17, mapping = aes(x = date, y=cut_poison, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_17, mapping = aes(x = date, y=cut_poison, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_17, mapping = aes(x = date, y = cut_poison, 
                                                 label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_17$type == "undeter", 0.95, 0.45)) +
  scale_color_manual(values = c(intentBlue, undeterOrange, unintentRed)) +
  scale_shape_manual(values = c(15, 17, 19)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(
    #date_labels = "%b %Y",
    #limits = c(as.Date("2016-01-01"), as.Date("2017-04-01")),
    expand = c(0,11)) +
  #ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("tg_cut_poison.png", width = 8, height = 5, unit = "in")

ggplot() +
  geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
  geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
  geom_line(data = tg_cut_poison_16, mapping = aes(x = date, y=cutting, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_16, mapping = aes(x = date, y=cutting, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_16, mapping = aes(x = date, y = cutting, 
                                                   label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_16$type == "undeter", 0.95, 0.45)) +
  geom_line(data = tg_cut_poison_17, mapping = aes(x = date, y=cutting, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_17, mapping = aes(x = date, y=cutting, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_17, mapping = aes(x = date, y = cutting, 
                                                   label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_17$type == "undeter", -0.1, 0.45)) +
  scale_color_manual(values = c(intentBlue, undeterOrange, unintentRed)) +
  scale_shape_manual(values = c(15, 17, 19)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(
    #date_labels = "%b %Y",
    #limits = c(as.Date("2016-01-01"), as.Date("2017-04-01")),
    expand = c(0,11)) +
  #ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("tg_cut.png", width = 8, height = 5, unit = "in")

ggplot() +
  geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
  geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
  geom_line(data = tg_cut_poison_16, mapping = aes(x = date, y=poison, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_16, mapping = aes(x = date, y=poison, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_16, mapping = aes(x = date, y = poison, 
                                                   label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_16$type == "undeter", -0.1, 
                                        ifelse(tg_cut_poison_16$type == "unintent", 0.95, 0.45))) +
  geom_line(data = tg_cut_poison_17, mapping = aes(x = date, y=poison, color = type), alpha = 0.6) +
  geom_point(data = tg_cut_poison_17, mapping = aes(x = date, y=poison, shape = type, color = type), size = 3) +
  geom_text(data = tg_cut_poison_17, mapping = aes(x = date, y = poison, 
                                                   label = ifelse(date == as.Date("2017-05-01"), year, ""), color = type),
            hjust = -.5, vjust = ifelse(tg_cut_poison_17$type == "undeter", 0.95,
                                        ifelse(tg_cut_poison_17$type == "unintent", -0.2, 0.45))) +
  scale_color_manual(values = c(intentBlue, undeterOrange, unintentRed)) +
  scale_shape_manual(values = c(15, 17, 19)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(
    #date_labels = "%b %Y",
    #limits = c(as.Date("2016-01-01"), as.Date("2017-04-01")),
    expand = c(0,11)) +
  #ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("tg_poison.png", width = 8, height = 5, unit = "in")

dat <- data.frame(type = as.factor(c(1,2,3)), x = c(1,2,3), y = c(1,2,3))

ggplot(dat) +
  geom_point(mapping = aes(x,y, color = type, shape = type), size = 3) +
  scale_color_manual(values = c(intentBlue, undeterOrange, unintentRed)) +
  scale_shape_manual(values = c(15, 17, 19)) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  #ylim(-2900,2900) +
  ylab("") +
  xlab("")

ggsave("forlegend.png", height = 5, width = 8, unit = "in")


### UNWEIGHTED SUPPLEMENT

setwd("~/Documents/projects/ITS/13RW/data")

unweighted <- readRDS("tg_selfh_unweighted.rds")

unw_ts <- create_ts(unweighted)
unw_ts_pre <- unw_ts$pre_ts
unw_ts_post <- unw_ts$ts_full_conf_1
ords <- give_me_order(unw_ts_pre)

unw_mod <- Arima(unw_ts_pre, order = ords$order, seasonal = ords$seasonal, include.mean = F)

unw_PI <- get_arima_PI(unw_ts_post, 
                       T1 = 1, 
                       T0 = length(unw_ts_pre),
                       alpha = 0.05, 
                       pi_grid = 1700:2500, 
                       block_size = 1,
                       order = ords$order, 
                       seasonal = ords$seasonal, 
                       include.mean = F)

unw_upper <- unw_PI$ub
unw_lower <- unw_PI$lb

unw_dfs <- get_plot_dfs(unw_ts_post, unw_mod, unw_upper, unw_lower)

get_control_plot(pre_df = unw_dfs$pre_df,
                 post_df = unw_dfs$post_df,
                 name = "unw",
                 y_min = 1250,
                 y_max = 2500)

### ATTEMPT SUPPLEMENT

attempt <- readRDS("tg_attempt.rds")

date_vec <- seq.Date(from = as.Date("2017-01-01"), to = as.Date("2017-05-01"), by = "1 month")

attempt_16 <- attempt %>%
  filter(date < as.Date("2016-06-01")) %>%
  mutate(date = date_vec)

attempt_17 <- attempt %>%
  filter(year == 2017,
         date < as.Date("2017-06-01"))

ggplot() +
  geom_vline(mapping = aes(xintercept = as.Date("2017-02-15")), linetype = "dashed", size =.3) +
  geom_vline(mapping = aes(xintercept = as.Date("2017-03-15")), linetype = "dashed", size = .3) +
  geom_line(data = attempt_16, mapping = aes(x = date, y=self_h), color = my_gray, alpha = 0.6) +
  geom_point(data = attempt_16, mapping = aes(x = date, y=self_h), size = 3, shape = 19, color = my_gray) +
  geom_text(data = attempt_16, mapping = aes(x = date, y = self_h, 
                                                   label = ifelse(date == as.Date("2017-05-01"), year, "")),
            hjust = -.5, vjust = 0.45, color = my_gray) +
  geom_line(data = attempt_17, mapping = aes(x = date, y=self_h), alpha = 0.6, color = unintentRed) +
  geom_point(data = attempt_17, mapping = aes(x = date, y=self_h), size = 3, shape = 15, color = unintentRed) +
  geom_text(data = attempt_17, mapping = aes(x = date, y = self_h, 
                                             label = ifelse(date == as.Date("2017-05-01"), year, "")),
            hjust = -.5, vjust = 0.45, color = unintentRed) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "none") +
  scale_x_date(
    #date_labels = "%b %Y",
    #limits = c(as.Date("2016-01-01"), as.Date("2017-04-01")),
    expand = c(0,11)) +
  #ylim(-2900,2900) +
  ylab("") +
  xlab("")

setwd("~/Documents/projects/ITS/13RW/plots")

ggsave("attempt.png", width = 8, height = 5, units = "in")

### MODEL-FREE SUPPLEMENT

for_names <- c("06", "07", "08", "09", "10", "11", 
               "12", "13", "14", "15", "16", "17")

#These are not the actual dates, just dates to make plotting in ggplot
#easier, since we're plotting a different line for each year
ggplot_dates <- seq.Date(from = as.Date("2017-01-01"), to = as.Date("2017-12-01"), by = "1 month")

for (i in 1:length(for_names)) {
  
  df_temp <- tg %>%
    filter(year == as.numeric(paste0("20", for_names[i]))) %>%
    select(self_h, date) %>%
    mutate(date = ggplot_dates,
           year = paste0("20", for_names[i]))
  
  df_name <- paste0("df_", for_names[i], "_full")
  eval(call("<-", as.name(df_name), df_temp))
  
}

my_light_gray <- "#a0a6ac"
another_blue <- "#3080d0"

#using wide ylims to make room for labels in latex

ggplot() +
  geom_vline(df_17_full, mapping = aes(x = date, xintercept = as.Date("2017-02-15")), linetype = "dashed") +
  geom_vline(df_17_full, mapping = aes(x = date, xintercept = as.Date("2017-03-15")), linetype = "dashed") +
  geom_line(df_06_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_06_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_06_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_07_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_07_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_07_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_08_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_08_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_08_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_09_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_09_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_09_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_10_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_10_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_10_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_11_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_11_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_11_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_12_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_12_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_12_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_13_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_13_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_13_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_14_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_14_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_14_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_15_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_15_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_15_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_16_full, mapping = aes(x = date, y = self_h), color = my_light_gray, alpha = 0.5) +
  geom_point(df_16_full, mapping = aes(x = date, y = self_h, label = year), color = my_light_gray, size = 3, shape = 15) +
  geom_text(df_16_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.45, color = my_light_gray, size = 5) +
  geom_line(df_17_full, mapping = aes(x = date, y = self_h), color = another_blue, alpha = 0.5) +
  geom_point(df_17_full, mapping = aes(x = date, y = self_h, label = year), color = another_blue, size = 3, shape = 17) +
  geom_text(df_17_full, mapping = aes(x = date, y = self_h, label = ifelse(date == as.Date("2017-12-01"), year, "")), 
            hjust = -.5, vjust = 0.33, color = another_blue, size = 5) +
  theme_classic() +
  theme(text = element_text(size = 20)) +
  scale_x_date(expand = c(0,40),
               date_labels = "%b",
               breaks = c(as.Date("2017-01-01"),
                          as.Date("2017-04-01"),
                          as.Date("2017-07-01"),
                          as.Date("2017-10-01"))) +
  scale_y_continuous(limits = c(3500, 11700)) +
  ylab("") +
  xlab("")

ggsave("model_free_full.png", width = 8, height = 5, unit = "in")  

### ARIMA tables

full_mod
split_mod

ts_train <- ts(ts_full_conf_1[1:74], start = c(2006, 1), freq = 12)

auto.arima(ts_train)

Arima(ts_train, order = split_order, seasonal = split_seasonal)
split_mod
split_order
split_seasonal

Arima(ts_est, order = split_order, seasonal = split_seasonal)
Arima(pre_ts, order = split_order, seasonal = split_seasonal)
Arima(pre_ts, order = full_order, seasonal = full_seasonal)

### TREATMENT EFFECTS WITH CONFIDENCE INTERVALS

split_CI_3 <- get_arima_CI(Y1 = ts_est_conf_1, 
                           T1 = 1,
                           T0 = length(ts_est_conf_1) - 1,
                           alpha = 0.05,
                           ci_grid = -1000:2500,
                           block_size = 3,
                           order = split_order,
                           seasonal = split_seasonal,
                           include.mean = F)

split_CI_2 <- get_arima_CI(Y1 = ts_est_conf_1, 
                           T1 = 1,
                           T0 = length(ts_est_conf_1) - 1,
                           alpha = 0.05,
                           ci_grid = 0:2165,
                           block_size = 2,
                           order = split_order,
                           seasonal = split_seasonal,
                           include.mean = F)

split_CI_1 <- get_arima_CI(Y1 = ts_est_conf_1, 
                           T1 = 1,
                           T0 = length(ts_est_conf_1) - 1,
                           alpha = 0.05,
                           ci_grid = 0:2165,
                           block_size = 1,
                           order = split_order,
                           seasonal = split_seasonal,
                           include.mean = F)

split_mod <- Arima(ts_est,
                   order = split_order,
                   seasonal = split_seasonal, method = "ML",
                   include.mean = F)

split_tau <- ts_est_conf_1[length(ts_est_conf_1)] - as.numeric(forecast(split_mod,h=1)$mean)

safe_CI_3 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = -100:2500,
                          block_size = 3,
                          order = split_order,
                          seasonal = split_seasonal,
                          include.mean = F)

safe_CI_2 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = -100:2500,
                          block_size = 2,
                          order = split_order,
                          seasonal = split_seasonal,
                          include.mean = F)

safe_CI_1 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = -100:2500,
                          block_size = 1,
                          order = split_order,
                          seasonal = split_seasonal,
                          include.mean = F)

safe_mod <- Arima(pre_ts,
                  order = split_order,
                  seasonal = split_seasonal, method = "ML",
                  include.mean = F)

safe_tau <- ts_est_conf_1[length(ts_est_conf_1)] - as.numeric(forecast(safe_mod,h=1)$mean)

full_CI_3 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = 0:2700,
                          block_size = 3,
                          order = full_order,
                          seasonal = full_seasonal,
                          include.mean = F)

full_CI_2 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = 0:2700,
                          block_size = 2,
                          order = full_order,
                          seasonal = full_seasonal,
                          include.mean = F)

full_CI_1 <- get_arima_CI(Y1 = ts_full_conf_1, 
                          T1 = 1,
                          T0 = length(ts_full_conf_1) - 1,
                          alpha = 0.05,
                          ci_grid = 0:2700,
                          block_size = 1,
                          order = full_order,
                          seasonal = full_seasonal,
                          include.mean = F)

full_mod <- Arima(pre_ts,
                  order = full_order,
                  seasonal = full_seasonal, method = "ML",
                  include.mean = F)

full_tau <- ts_est_conf_1[length(ts_est_conf_1)] - as.numeric(forecast(full_mod,h=1)$mean)

block_size <- rep(c(1,2,3),3)
est_method <- c(rep("Split",3), rep("SAFE",3), rep("Full",3))
tau <- c(rep(split_tau,3), rep(safe_tau,3), rep(full_tau,3))
upper <- c(split_CI_1$ub, split_CI_2$ub, split_CI_3$ub,
           safe_CI_1$ub,safe_CI_2$ub,safe_CI_3$ub,
           full_CI_1$ub,full_CI_2$ub,full_CI_3$ub)
lower <- c(split_CI_1$lb, split_CI_2$lb, split_CI_3$lb,
           safe_CI_1$lb,safe_CI_2$lb,safe_CI_3$lb,
           full_CI_1$lb,full_CI_2$lb,full_CI_3$lb)

tau_df <- data.frame(block_size, est_method, tau, upper, lower)

ggplot(tau_df) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point(mapping = aes(x = factor(block_size), y = tau), size = 3) +
  geom_errorbar(mapping = aes(x = block_size, y = tau, ymin = lower, ymax = upper), width = 0, size = .75) +
  facet_wrap(vars(est_method)) +
  theme_bw() +
  theme(text = element_text(size = 20),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  #scale_x_date(expand = c(0,40),
               #date_labels = "%b") +
  #scale_y_continuous(limits = c(3500, 11700)) +
  ylab("") +
  xlab("")

ggsave("tau_plot.png", width = 8, height = 5, units = "in")
