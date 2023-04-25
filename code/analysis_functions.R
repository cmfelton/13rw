#install.packages("tidyverse")
#install.packages("forecast")
#install.packages("ggtext")
#install.packages("zoo")
#install.packages("emojifont")
#install.packages("xtable")
#install.packages("urca")

library(tidyverse)
library(forecast)
library(ggtext)
library(zoo)
library(emojifont)
library(xtable)
library(urca)

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
  
  ggsave(here("plots", pred_plot_name), width = 8, height = 5, units = "in")
  
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
  
  ggsave(here("plots", pred_zoom_name), width = 8, height = 5, units = "in")
  
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
  
  ggsave(here("plots", tau_plot_name), width = 8, height = 5, units = "in")
  
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
  
  ggsave(here("plots", tau_zoom_name), width = 8, height = 5, units = "in")  
  
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
    ggsave(here("plots", plotname), width = 8, height = 5, units = "in")
    
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
  
  ggsave(here("plots", plot_name), width = 8, height = 5, unit = "in")

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
  ggsave(here("plots", plot_name), plot = pval_plot, width = 8, height = 5, unit = "in")
  
  return(p_val)
}