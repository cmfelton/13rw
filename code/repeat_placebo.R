### REPEATED PLACEBO TEST PLOTS ###

## NOTE: This script contains code for the main placebo test
## plot in the paper, AND the placebo test plots in the appendix,
## AND additional unreported placebo tests. I wouldn't advise
## running the entire script at once. Even if you're just 
## replicating the main placebo test results, I suggest running
## the script overnight. 

# FIGURES 9 AND 10

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

get_placebo_plot(expand_df_1)

# FIGURE 11 AND MEAN PLACEBO EFFECT ESTIMATE

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

# These two estimates are right on top of each other so I 
# horizontally jitter each.
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

ggsave(here("plots", "placebo_month_exp.png"), width = 8, height = 5, unit = "in")

## Numbers reported in text in Section 7.3

placebo_df %>%
  filter(date != as.Date("2014-08-01") & date != as.Date("2017-04-01")) %>%
  summarize(mean = mean(tau), sd = sd(tau),
            hundred = sum(abs(tau) > 100))

### APPENDIX B.3 MORE PLACEBO TEST RESULTS

# With alpha = 0.05 and block_size > 1, PIs are quite unstable.
# Here I instead compute 90% PIs 

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

# 24th placebo test has -Inf / Inf as limits because
# all conformal p-vals are < 0.1...very odd and points
# to the instability of the intervals when (i) n is small
# and (ii) block size > 1

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

# examining PI_iter here shows that the p-value is always less than .1,
# so you cannot construct a prediction interval

#replacing -Inf and Inf with point prediction

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
# 24th placebo test has -Inf / Inf as limits,
# so also replacing with the pred...

moving_df_3_90[24,2] <- moving_df_3_90[24,3] <- pred

#lapply() doesn't work here since the function
#deparses the df name, and lapply doesn't pass
#the name to the function...I'm sure there's
#a way to make it work but here I just copy and paste

get_placebo_plot(moving_df_1_90)
get_placebo_plot(moving_df_2_90)
get_placebo_plot(moving_df_3_90)

get_placebo_plot(expand_df_1_90)
get_placebo_plot(expand_df_2_90)
get_placebo_plot(expand_df_3_90)

### UNREPORTED

## Using standard ARIMA intervals yields
## basically same results.

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

## Placebo test results at the 80% level. Doesn't provide
## much additional info about over / undercoverage beyond
## what the 90% intervals provide.

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

check_max(moving_df_1_80, 3500)
check_max(moving_df_2_80, 5000)
check_max(moving_df_3_80, 5000)

check_max(expand_df_1_80, 3500)
check_max(expand_df_2_80, 4000)
check_max(expand_df_3_80, 4500)

get_placebo_plot(expand_df_1_80)
get_placebo_plot(expand_df_2_80)
get_placebo_plot(expand_df_3_80)

get_placebo_plot(moving_df_1_80)
get_placebo_plot(moving_df_2_80)
get_placebo_plot(moving_df_3_80)
