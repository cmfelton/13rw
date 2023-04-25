#install.packages("readstata13")
#install.packages("data.table")
#install.packages("dplyr")
#install.packages("purrr")
#install.packages("stringr")
#install.packages("here")

library(readstata13)
library(data.table)
library(tidyverse)
library(here)

## FUNCTIONS

#cleaning function for data using icd9 codes (2006--2015q3)
clean_icd9 <- function(df_year, name, dxname, dxlist) {
  
  dta_name <- paste0(name, df_year, ".dta")
  rds_name_all <- paste0(name, dxname, "_all_", df_year, ".rds")
  rds_name_died <- paste0(name, dxname, "_died_", df_year, ".rds")
  rds_name_surv <- paste0(name, dxname, "_surv_", df_year, ".rds")
  neds <- read.dta13(here("data", dta_name))
  setDT(neds)
  
  #all row numbers where an ecode matches a dx from dxlist
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("ecode", 1:4))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  
  rnums <- unique(unlist(rnums))
  
  #subsetting to self-harm visits
  neds <- neds[rnums, ]
  setnames(neds, "died_vis", "died_visit", skip_absent = T)
  
  #subsetting to deaths and non-deaths
  neds_died <- neds[died_visit == 1 | died_visit == 2,]
  neds_surv <- neds[died_visit == 0,]
  
  #with deaths and non-deaths
  neds <- neds[, .(self_h = sum(discwt)), by = amonth]
  neds[, year:=df_year]
  neds <- neds[order(amonth),]
  
  #just deaths
  neds_died <- neds_died[, .(self_h = sum(discwt)), by = amonth]
  neds_died[, year:=df_year]
  neds_died <- neds_died[order(amonth),]
  
  #just non-deaths
  neds_surv <- neds_surv[, .(self_h = sum(discwt)), by = amonth]
  neds_surv[, year:=df_year]
  neds_surv <- neds_surv[order(amonth),]
  
  saveRDS(neds, here("data", rds_name_all))
  saveRDS(neds_died, here("data", rds_name_died))
  saveRDS(neds_surv, here("data", rds_name_surv))
  
}

#cleaning function for 2015 data, intentional self-harm

clean_15 <- function(name, dxlist9, dxlist10) {
  
  name15q3dta <- paste0(name, "2015_q3.dta")
  name15q4dta <- paste0(name, "2015_q4.dta")
  
  neds <- read.dta13(here("data", name15q3dta))
  setDT(neds)
  
  #finding row nums with dxlist codes
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("ecode", 1:4))], 
                  grep, pattern = paste(dxlist9, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  #subsetting to cases
  neds <- neds[rnums, ]
  
  #subsetting to deaths and non-deaths
  neds_died <- neds[died_visit == 1 | died_visit == 2,]
  neds_surv <- neds[died_visit == 0,]
  
  #all
  df_2015q3 <- neds[, .(self_h = sum(discwt)), by = amonth]
  df_2015q3[, year:=2015]
  df_2015q3 <- df_2015q3[order(amonth),]
  
  #deaths
  df_2015q3_died <- neds_died[, .(self_h = sum(discwt)), by = amonth]
  df_2015q3_died[, year:=2015]
  df_2015q3_died <- df_2015q3_died[order(amonth),]
  
  #non-deaths
  df_2015q3_surv <- neds_surv[, .(self_h = sum(discwt)), by = amonth]
  df_2015q3_surv[, year:=2015]
  df_2015q3_surv <- df_2015q3_surv[order(amonth),]
  
  #2015q4
  neds <- read.dta13(here("data", name15q4dta))
  setDT(neds)
  
  #findings row nums with dxlist codes
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:30), paste0("i10_ecause", 1:4))], 
                  grep, pattern = paste(dxlist10, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  #subsetting to cases
  neds <- neds[rnums, ]
  
  #subsetting to deaths and non-deaths
  neds_died <- neds[died_visit == 1 | died_visit == 2,]
  neds_surv <- neds[died_visit == 0,]
  
  #all
  df_2015q4 <- neds[, .(self_h = sum(discwt)), by = amonth]
  df_2015q4[, year:=2015]
  df_2015q4 <- df_2015q4[order(amonth),]
  
  #deaths
  df_2015q4_died <- neds_died[, .(self_h = sum(discwt)), by = amonth]
  df_2015q4_died[, year:=2015]
  df_2015q4_died <- df_2015q4_died[order(amonth),]
  
  #non-deaths
  df_2015q4_surv <- neds_surv[, .(self_h = sum(discwt)), by = amonth]
  df_2015q4_surv[, year:=2015]
  df_2015q4_surv <- df_2015q4_surv[order(amonth),]
  
  dfs <- list(q3 = df_2015q3,
              q3_died = df_2015q3_died,
              q3_surv = df_2015q3_surv,
              q4 = df_2015q4,
              q4_died = df_2015q4_died,
              q4_surv = df_2015q4_surv)
  
  return(dfs)
  
}

#cleaning function for 2016/17 data

clean_16_17 <- function(name, dxname, dxlist) {
  
  name16dta <- paste0(name, "2016.dta")
  name17dta <- paste0(name, "2017.dta")
  
  name16rds_all <- paste0(name, dxname, "_all_", "2016.rds")
  name16rds_died <- paste0(name, dxname, "_died_", "2016.rds")
  name16rds_surv <- paste0(name, dxname, "_surv_", "2016.rds")
  
  name17rds_all <- paste0(name, dxname, "_all_", "2017.rds")
  name17rds_died <- paste0(name, dxname, "_died_", "2017.rds")
  name17rds_surv <- paste0(name, dxname, "_surv_", "2017.rds")
  
  #2016
  
  neds <- read.dta13(here("data", name16dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:30), paste0("i10_ecause", 1:4))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  #subsetting to cases
  neds <- neds[rnums, ]
  
  #subsetting to deaths and non-deaths
  neds_died <- neds[died_visit == 1 | died_visit == 2,]
  neds_surv <- neds[died_visit == 0,]
  
  
  #all
  df_2016 <- neds[, .(self_h = sum(discwt)), by = amonth]
  df_2016[, year:=2016]
  df_2016 <- df_2016[order(amonth),]
  
  #deaths
  df_2016_died <- neds_died[, .(self_h = sum(discwt)), by = amonth]
  df_2016_died[, year:=2016]
  df_2016_died <- df_2016_died[order(amonth),]
  
  #non-deaths
  df_2016_surv <- neds_surv[, .(self_h = sum(discwt)), by = amonth]
  df_2016_surv[, year:=2016]
  df_2016_surv <- df_2016_surv[order(amonth),]
  
  saveRDS(df_2016, here("data", name16rds_all))
  saveRDS(df_2016_died, here("data", name16rds_died))
  saveRDS(df_2016_surv, here("data", name16rds_surv))
  
  #2017 uses different varnames for diagnosis codes
  
  neds <- read.dta13(here("data", name17dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:35))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  #subsetting to cases
  neds <- neds[rnums, ]
  
  #subsetting to deaths and non-deaths
  neds_died <- neds[died_visit == 1 | died_visit == 2,]
  neds_surv <- neds[died_visit == 0,]
  
  #all
  df_2017 <- neds[, .(self_h = sum(discwt)), by = amonth]
  df_2017[, year:=2017]
  df_2017 <- df_2017[order(amonth),]
  
  #died
  df_2017_died <- neds_died[, .(self_h = sum(discwt)), by = amonth]
  df_2017_died[, year:=2017]
  df_2017_died <- df_2017_died[order(amonth),]
  
  #surv
  df_2017_surv <- neds_surv[, .(self_h = sum(discwt)), by = amonth]
  df_2017_surv[, year:=2017]
  df_2017_surv <- df_2017_surv[order(amonth),]
  
  saveRDS(df_2017, here("data", name17rds_all))
  saveRDS(df_2017_died, here("data", name17rds_died))
  saveRDS(df_2017_surv, here("data", name17rds_surv))
  
}

#function for binding together the different years of data

bind_ts <- function(name) {
  
  name_full <- paste0(name, "_full.rds")
  
  df_self_harm <- list.files(path = here("data"), pattern = name) %>%
    map_dfr(readRDS) %>%
    mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"),
           self_h_fd = self_h - lag(self_h),
           self_h_sd = self_h - lag(self_h, 12),
           self_h_sd_fd = self_h_fd - lag(self_h_fd, 12))
  
  saveRDS(df_self_harm, here("data", name_full))
  
}

# functions for getting unweighted counts later on

# cleaning function for data using icd9 codes (2006--2015q3), unweighted

clean_icd9_unwt <- function(df_year, name, dxname, dxlist) {
  
  dta_name <- paste0(name, df_year, ".dta")
  rds_name <- paste0(name, dxname, df_year, "_unweighted.rds")
  neds <- read.dta13(here("data", dta_name))
  setDT(neds)
  
  #all row numbers where an ecode matches a dx from dxlist
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("ecode", 1:4))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  
  rnums <- unique(unlist(rnums))
  
  #subsetting, summarizing, and ordering
  neds <- neds[rnums, ]
  neds <- neds[, .(self_h = .N), by = amonth]
  neds[, year:=df_year]
  neds <- neds[order(amonth),]
  
  saveRDS(neds, here("data", "unweighted", rds_name))
  
}

#cleaning function for 2015 data, unweighted

clean_15_unwt <- function(name, dxlist9, dxlist10) {
  
  name15q3dta <- paste0(name, "2015_q3.dta")
  name15q4dta <- paste0(name, "2015_q4.dta")
  
  name15rds <- paste0(name, "2015_unweighted.rds")
  
  neds <- read.dta13(here("data", name15q3dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("ecode", 1:4))], 
                  grep, pattern = paste(dxlist9, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2015q3 <- neds[, .(self_h = .N), by = amonth]
  df_2015q3[, year:=2015]
  df_2015q3 <- df_2015q3[order(amonth),]
  
  #2015q4
  neds <- read.dta13(here("data", name15q4dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:30), paste0("i10_ecause", 1:4))], 
                  grep, pattern = paste(dxlist10, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2015q4 <- neds[, .(self_h = .N), by = amonth]
  df_2015q4[, year:=2015]
  df_2015q4 <- df_2015q4[order(amonth),]
  
  dfs <- list(q3 = df_2015q3, q4 = df_2015q4)
  
  return(dfs)
  
}

#cleaning function for 2016/17 data, unweighted

clean_16_17_unwt <- function(name, dxname, dxlist) {
  
  name16dta <- paste0(name, "2016.dta")
  name17dta <- paste0(name, "2017.dta")
  
  name16rds <- paste0(name, dxname, "2016_unweighted.rds")
  name17rds <- paste0(name, dxname, "2017_unweighted.rds")
  
  #2016
  neds <- read.dta13(here("data", name16dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:30), paste0("i10_ecause", 1:4))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2016 <- neds[, .(self_h = .N), by = amonth]
  df_2016[, year:=2016]
  df_2016 <- df_2016[order(amonth),]
  
  saveRDS(df_2016, here("data", "unweighted", name16rds))
  
  #2017 uses different varnames for diagnosis codes
  
  neds <- read.dta13(here("data", name17dta))
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:35))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2017 <- neds[, .(self_h = .N), by = amonth]
  df_2017[, year:=2017]
  df_2017 <- df_2017[order(amonth),]
  
  saveRDS(df_2017, here("data", "unweighted", name17rds))
  
}

#rbind for all the unweighted data, note that these
#will be in their own folder so just using .rds in pattern

bind_ts_unwt <- function(name) {
  
  name_full <- paste0(name, "selfh_unweighted.rds")
  
  df_self_harm <- list.files(path = here("data", "unweighted"), pattern = paste0(name, ".*\\.rds")) %>%
    map_dfr(readRDS) %>%
    mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"),
           self_h_fd = self_h - lag(self_h),
           self_h_sd = self_h - lag(self_h, 12),
           self_h_sd_fd = self_h_fd - lag(self_h_fd, 12))
  
  saveRDS(df_self_harm, here("data", "unweighted", name_full))
  
}