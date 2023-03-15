## This script will produce counts of ER visits for
## self-harm among various demographic groups. You must
## run BOTH tgclean.do AND suppclean.do before running
## this to obtain all counts. 

rm(list = ls())

setwd("Z:/NEDS")

library(readstata13)
library(data.table)
library(dplyr)
library(purrr)
library(stringr)

## FUNCTIONS

#cleaning function for data using icd9 codes (2006--2015q3)
clean_icd9 <- function(df_year, name, dxname, dxlist) {
  
  dta_name <- paste0(name, df_year, ".dta")
  rds_name_all <- paste0(name, dxname, "_all_", df_year, ".rds")
  rds_name_died <- paste0(name, dxname, "_died_", df_year, ".rds")
  rds_name_surv <- paste0(name, dxname, "_surv_", df_year, ".rds")
  neds <- read.dta13(dta_name)
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
  
  saveRDS(neds, rds_name_all)
  saveRDS(neds_died, rds_name_died)
  saveRDS(neds_surv, rds_name_surv)
  
}

#cleaning function for 2015 data, intentional self-harm

clean_15 <- function(name, dxlist9, dxlist10) {
  
  name15q3dta <- paste0(name, "2015_q3.dta")
  name15q4dta <- paste0(name, "2015_q4.dta")
  
  neds <- read.dta13(name15q3dta)
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
  neds <- read.dta13(name15q4dta)
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
  
  neds <- read.dta13(name16dta)
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
  
  saveRDS(df_2016, name16rds_all)
  saveRDS(df_2016_died, name16rds_died)
  saveRDS(df_2016_surv, name16rds_surv)
  
  #2017 uses different varnames for diagnosis codes
  
  neds <- read.dta13(name17dta)
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
  
  saveRDS(df_2017, name17rds_all)
  saveRDS(df_2017_died, name17rds_died)
  saveRDS(df_2017_surv, name17rds_surv)
  
}

#function for binding together the different years of data

bind_ts <- function(name) {
  
  name_full <- paste0(name, "_full.rds")
  
  df_self_harm <- list.files(pattern = name) %>%
    map_dfr(readRDS) %>%
    mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"),
           self_h_fd = self_h - lag(self_h),
           self_h_sd = self_h - lag(self_h, 12),
           self_h_sd_fd = self_h_fd - lag(self_h_fd, 12))
  
  saveRDS(df_self_harm, name_full)
  
}

# functions for getting unweighted counts later on

# cleaning function for data using icd9 codes (2006--2015q3), unweighted

clean_icd9_unwt <- function(df_year, name, dxname, dxlist) {
  
  dta_name <- paste0(name, df_year, ".dta")
  rds_name <- paste0(name, dxname, df_year, "_unweighted.rds")
  neds <- read.dta13(dta_name)
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
  
  setwd("Z:/NEDS/unweighted")
  saveRDS(neds, rds_name)
  setwd("Z:/NEDS")
  
}

#cleaning function for 2015 data, unweighted

clean_15_unwt <- function(name, dxlist9, dxlist10) {
  
  name15q3dta <- paste0(name, "2015_q3.dta")
  name15q4dta <- paste0(name, "2015_q4.dta")
  
  name15rds <- paste0(name, "2015_unweighted.rds")
  
  neds <- read.dta13(name15q3dta)
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("ecode", 1:4))], 
                  grep, pattern = paste(dxlist9, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2015q3 <- neds[, .(self_h = .N), by = amonth]
  df_2015q3[, year:=2015]
  df_2015q3 <- df_2015q3[order(amonth),]
  
  #2015q4
  neds <- read.dta13(name15q4dta)
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
  neds <- read.dta13(name16dta)
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:30), paste0("i10_ecause", 1:4))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2016 <- neds[, .(self_h = .N), by = amonth]
  df_2016[, year:=2016]
  df_2016 <- df_2016[order(amonth),]
  
  setwd("Z:/NEDS/unweighted")
  saveRDS(df_2016, name16rds)
  setwd("Z:/NEDS")
  
  #2017 uses different varnames for diagnosis codes
  
  neds <- read.dta13(name17dta)
  setDT(neds)
  
  rnums <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:35))], 
                  grep, pattern = paste(dxlist, collapse = "|"))
  rnums <- unique(unlist(rnums))
  
  neds <- neds[rnums, ]
  df_2017 <- neds[, .(self_h = .N), by = amonth]
  df_2017[, year:=2017]
  df_2017 <- df_2017[order(amonth),]
  
  setwd("Z:/NEDS/unweighted")
  saveRDS(df_2017, name17rds)
  setwd("Z:/NEDS")
  
}

#rbind for all the unweighted data, note that these
#will be in their own folder so just using .rds in pattern

bind_ts_unwt <- function(name) {
  
  name_full <- paste0(name, "selfh_unweighted.rds")
  
  df_self_harm <- list.files(pattern = paste0(name, ".*\\.rds")) %>%
    map_dfr(readRDS) %>%
    mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"),
           self_h_fd = self_h - lag(self_h),
           self_h_sd = self_h - lag(self_h, 12),
           self_h_sd_fd = self_h_fd - lag(self_h_fd, 12))
  
  saveRDS(df_self_harm, name_full)
  
}

## DIAGNOSIS CODES

#icd-9 diagnosis codes for intentional self-harm
dxlist9_selfh <- c("^E950", "^E951", "^E952", "^E953",
                   "^E954", "^E955", "^E956", "^E957",
                   "^E958")

#icd-10 diagnosis codes for intentional self-harm
dxlist10_selfh <- c("T360X2A", "T361X2A", "T362X2A", "T363X2A", "T364X2A", "T365X2A",
                    "T366X2A", "T367X2A", "T368X2A", "T3692XA", "T370X2A", "T371X2A",
                    "T372X2A", "T373X2A", "T374X2A", "T375X2A", "T378X2A", "T3792XA",
                    "T380X2A", "T381X2A", "T382X2A", "T383X2A", "T384X2A", "T385X2A",
                    "T386X2A", "T387X2A", "T38802A", "T38812A", "T38892A", "T38902A",
                    "T38992A", "T39012A", "T39092A", "T391X2A", "T392X2A", "T39312A",
                    "T39392A", "T394X2A", "T398X2A", "T3992XA", "T400X2A", "T401X2A",
                    "T402X2A", "T403X2A", "T404X2A", "T405X2A", "T40602A", "T40692A",
                    "T407X2A", "T408X2A", "T40902A", "T40992A", "T410X2A", "T411X2A",
                    "T41202A", "T41292A", "T413X2A", "T4142XA", "T415X2A", "T420X2A",
                    "T421X2A", "T422X2A", "T423X2A", "T424X2A", "T425X2A", "T426X2A",
                    "T4272XA", "T428X2A", "T43012A", "T43022A", "T431X2A", "T43202A",
                    "T43212A", "T43222A", "T43292A", "T433X2A", "T434X2A", "T43502A",
                    "T43592A", "T43602A", "T43612A", "T43622A", "T43632A", "T43692A",
                    "T438X2A", "T4392XA", "T440X2A", "T441X2A", "T442X2A", "T443X2A",
                    "T444X2A", "T445X2A", "T446X2A", "T447X2A", "T448X2A", "T44902A",
                    "T44992A", "T450X2A", "T451X2A", "T452X2A", "T453X2A", "T454X2A",
                    "T45512A", "T45522A", "T45602A", "T45612A", "T45622A", "T45692A",
                    "T457X2A", "T458X2A", "T4592XA", "T460X2A", "T461X2A", "T462X2A",
                    "T463X2A", "T464X2A", "T465X2A", "T466X2A", "T467X2A", "T468X2A",
                    "T46902A", "T46992A", "T470X2A", "T471X2A", "T472X2A", "T473X2A",
                    "T474X2A", "T475X2A", "T476X2A", "T477X2A", "T478X2A", "T4792XA",
                    "T480X2A", "T481X2A", "T48202A", "T48292A", "T483X2A", "T484X2A",
                    "T485X2A", "T486X2A", "T48902A", "T48992A", "T490X2A", "T491X2A",
                    "T492X2A", "T493X2A", "T494X2A", "T495X2A", "T496X2A", "T497X2A",
                    "T498X2A", "T4992XA", "T500X2A", "T501X2A", "T502X2A", "T503X2A",
                    "T504X2A", "T505X2A", "T506X2A", "T507X2A", "T508X2A", "T50902A",
                    "T50992A", "T50A12A", "T50A22A", "T50A92A", "T50B12A", "T50B92A",
                    "T50Z12A", "T50Z92A", "T510X2A", "T511X2A", "T512X2A", "T513X2A",
                    "T518X2A", "T5192XA", "T520X2A", "T521X2A", "T522X2A", "T523X2A",
                    "T524X2A", "T528X2A", "T5292XA", "T530X2A", "T531X2A", "T532X2A",
                    "T533X2A", "T534X2A", "T535X2A", "T536X2A", "T537X2A", "T5392XA",
                    "T540X2A", "T541X2A", "T542X2A", "T543X2A", "T5492XA", "T550X2A",
                    "T551X2A", "T560X2A", "T561X2A", "T562X2A", "T563X2A", "T564X2A",
                    "T565X2A", "T566X2A", "T567X2A", "T56812A", "T56892A", "T5692XA",
                    "T570X2A", "T571X2A", "T572X2A", "T573X2A", "T578X2A", "T5792XA",
                    "T5802XA", "T5812XA", "T582X2A", "T588X2A", "T5892XA", "T590X2A",
                    "T591X2A", "T592X2A", "T593X2A", "T594X2A", "T595X2A", "T596X2A",
                    "T597X2A", "T59812A", "T59892A", "T5992XA", "T600X2A", "T601X2A",
                    "T602X2A", "T603X2A", "T604X2A", "T608X2A", "T6092XA", "T6102XA",
                    "T6112XA", "T61772A", "T61782A", "T618X2A", "T6192XA", "T620X2A",
                    "T621X2A", "T622X2A", "T628X2A", "T6292XA", "T63002A", "T63012A",
                    "T63022A", "T63032A", "T63042A", "T63062A", "T63072A", "T63082A",
                    "T63092A", "T63112A", "T63122A", "T63192A", "T632X2A", "T63302A",
                    "T63312A", "T63322A", "T63332A", "T63392A", "T63412A", "T63422A",
                    "T63432A", "T63442A", "T63452A", "T63462A", "T63482A", "T63512A",
                    "T63592A", "T63612A", "T63622A", "T63632A", "T63692A", "T63712A",
                    "T63792A", "T63812A", "T63822A", "T63832A", "T63892A", "T6392XA", 
                    "T6402XA", "T6482XA", "T650X2A", "T651X2A", "T65212A", "T65222A",
                    "T65292A", "T653X2A", "T654X2A", "T655X2A", "T656X2A", "T65812A",
                    "T65822A", "T65832A", "T65892A", "T6592XA", "T71112A", "T71122A",
                    "T71132A", "T71152A", "T71162A", "T71192A", "T71222A", "T71232A",
                    "X710XXA", "X711XXA", "X712XXA", "X713XXA", "X718XXA", "X719XXA",
                    "X72XXXA", "X730XXA", "X731XXA", "X732XXA", "X738XXA", "X739XXA",
                    "X7401XA", "X7402XA", "X7409XA", "X748XXA", "X749XXA", "X75XXXA",
                    "X76XXXA", "X770XXA", "X771XXA", "X772XXA", "X773XXA", "X778XXA",
                    "X779XXA", "X780XXA", "X781XXA", "X782XXA", "X788XXA", "X789XXA",
                    "X79XXXA", "X80XXXA", "X810XXA", "X811XXA", "X818XXA", "X820XXA",
                    "X821XXA", "X822XXA", "X828XXA", "X830XXA", "X831XXA", "X832XXA",
                    "X838XXA")

#unintentional, idc10
dxlist_unintent <- str_replace(dxlist10_selfh, "2XA", "1XA") %>%
  str_replace("2A", "1A")

dxlist_unintent <- dxlist_unintent[-grep("^X", dxlist_unintent)]

dxlist_undeter <- str_replace(dxlist10_selfh, "2XA", "4XA") %>%
  str_replace("2A", "4A")

dxlist_undeter <- dxlist_undeter[-grep("^X", dxlist_undeter)]

#intentional poisoning or intentional cutting, icd9
dxlist9_pois_cut <- c("^E950", "^E951", "^E952","^E956")

#icd10
dxlist10_pois_cut <- c("T360X2A", "T361X2A", "T362X2A", "T363X2A", "T364X2A", "T365X2A",
                       "T366X2A", "T367X2A", "T368X2A", "T3692XA", "T370X2A", "T371X2A",
                       "T372X2A", "T373X2A", "T374X2A", "T375X2A", "T378X2A", "T3792XA",
                       "T380X2A", "T381X2A", "T382X2A", "T383X2A", "T384X2A", "T385X2A",
                       "T386X2A", "T387X2A", "T38802A", "T38812A", "T38892A", "T38902A",
                       "T38992A", "T39012A", "T39092A", "T391X2A", "T392X2A", "T39312A",
                       "T39392A", "T394X2A", "T398X2A", "T3992XA", "T400X2A", "T401X2A",
                       "T402X2A", "T403X2A", "T404X2A", "T405X2A", "T40602A", "T40692A",
                       "T407X2A", "T408X2A", "T40902A", "T40992A", "T410X2A", "T411X2A",
                       "T41202A", "T41292A", "T413X2A", "T4142XA", "T415X2A", "T420X2A",
                       "T421X2A", "T422X2A", "T423X2A", "T424X2A", "T425X2A", "T426X2A",
                       "T4272XA", "T428X2A", "T43012A", "T43022A", "T431X2A", "T43202A",
                       "T43212A", "T43222A", "T43292A", "T433X2A", "T434X2A", "T43502A",
                       "T43592A", "T43602A", "T43612A", "T43622A", "T43632A", "T43692A",
                       "T438X2A", "T4392XA", "T440X2A", "T441X2A", "T442X2A", "T443X2A",
                       "T444X2A", "T445X2A", "T446X2A", "T447X2A", "T448X2A", "T44902A",
                       "T44992A", "T450X2A", "T451X2A", "T452X2A", "T453X2A", "T454X2A",
                       "T45512A", "T45522A", "T45602A", "T45612A", "T45622A", "T45692A",
                       "T457X2A", "T458X2A", "T4592XA", "T460X2A", "T461X2A", "T462X2A",
                       "T463X2A", "T464X2A", "T465X2A", "T466X2A", "T467X2A", "T468X2A",
                       "T46902A", "T46992A", "T470X2A", "T471X2A", "T472X2A", "T473X2A",
                       "T474X2A", "T475X2A", "T476X2A", "T477X2A", "T478X2A", "T4792XA",
                       "T480X2A", "T481X2A", "T48202A", "T48292A", "T483X2A", "T484X2A",
                       "T485X2A", "T486X2A", "T48902A", "T48992A", "T490X2A", "T491X2A",
                       "T492X2A", "T493X2A", "T494X2A", "T495X2A", "T496X2A", "T497X2A",
                       "T498X2A", "T4992XA", "T500X2A", "T501X2A", "T502X2A", "T503X2A",
                       "T504X2A", "T505X2A", "T506X2A", "T507X2A", "T508X2A", "T50902A",
                       "T50992A", "T50A12A", "T50A22A", "T50A92A", "T50B12A", "T50B92A",
                       "T50Z12A", "T50Z92A", "T510X2A", "T511X2A", "T512X2A", "T513X2A",
                       "T518X2A", "T5192XA", "T520X2A", "T521X2A", "T522X2A", "T523X2A",
                       "T524X2A", "T528X2A", "T5292XA", "T530X2A", "T531X2A", "T532X2A",
                       "T533X2A", "T534X2A", "T535X2A", "T536X2A", "T537X2A", "T5392XA",
                       "T540X2A", "T541X2A", "T542X2A", "T543X2A", "T5492XA", "T550X2A",
                       "T551X2A", "T560X2A", "T561X2A", "T562X2A", "T563X2A", "T564X2A",
                       "T565X2A", "T566X2A", "T567X2A", "T56812A", "T56892A", "T5692XA",
                       "T570X2A", "T571X2A", "T572X2A", "T573X2A", "T578X2A", "T5792XA",
                       "T5802XA", "T5812XA", "T582X2A", "T588X2A", "T5892XA", "T590X2A",
                       "T591X2A", "T592X2A", "T593X2A", "T594X2A", "T595X2A", "T596X2A",
                       "T597X2A", "T59812A", "T59892A", "T5992XA", "T600X2A", "T601X2A",
                       "T602X2A", "T603X2A", "T604X2A", "T608X2A", "T6092XA", "T6102XA",
                       "T6112XA", "T61772A", "T61782A", "T618X2A", "T6192XA", "T620X2A",
                       "T621X2A", "T622X2A", "T628X2A", "T6292XA", "T63002A", "T63012A",
                       "T63022A", "T63032A", "T63042A", "T63062A", "T63072A", "T63082A",
                       "T63092A", "T63112A", "T63122A", "T63192A", "T632X2A", "T63302A",
                       "T63312A", "T63322A", "T63332A", "T63392A", "T63412A", "T63422A",
                       "T63432A", "T63442A", "T63452A", "T63462A", "T63482A", "T63512A",
                       "T63592A", "T63612A", "T63622A", "T63632A", "T63692A", "T63712A",
                       "T63792A", "T63812A", "T63822A", "T63832A", "T63892A", "T6392XA", 
                       "T6402XA", "T6482XA", "T650X2A", "T651X2A", "T65212A", "T65222A",
                       "T65292A", "T653X2A", "T654X2A", "T655X2A", "T656X2A", "T65812A",
                       "T65822A", "T65832A", "T65892A", "T6592XA", "X780XXA", "X781XXA", 
                       "X782XXA", "X788XXA", "X789XXA")

#cutting by intent, icd10
cutting_intent <- c("X780XXA", "X781XXA", "X782XXA", "X788XXA" , "X789XXA")
cutting_unintent <- c("W25XXXA", "W260XXA", "W261XXA", "W262XXA", "W268XXA", "W269XXA")
cutting_undeter <- c("Y280XXA", "Y281XXA", "Y282XXA", "Y288XXA", "Y289XXA")

#poisoning by intent, icd10
poisoning_intent <- c("T360X2A", "T361X2A", "T362X2A", "T363X2A", "T364X2A", "T365X2A",
                      "T366X2A", "T367X2A", "T368X2A", "T3692XA", "T370X2A", "T371X2A",
                      "T372X2A", "T373X2A", "T374X2A", "T375X2A", "T378X2A", "T3792XA",
                      "T380X2A", "T381X2A", "T382X2A", "T383X2A", "T384X2A", "T385X2A",
                      "T386X2A", "T387X2A", "T38802A", "T38812A", "T38892A", "T38902A",
                      "T38992A", "T39012A", "T39092A", "T391X2A", "T392X2A", "T39312A",
                      "T39392A", "T394X2A", "T398X2A", "T3992XA", "T400X2A", "T401X2A",
                      "T402X2A", "T403X2A", "T404X2A", "T405X2A", "T40602A", "T40692A",
                      "T407X2A", "T408X2A", "T40902A", "T40992A", "T410X2A", "T411X2A",
                      "T41202A", "T41292A", "T413X2A", "T4142XA", "T415X2A", "T420X2A",
                      "T421X2A", "T422X2A", "T423X2A", "T424X2A", "T425X2A", "T426X2A",
                      "T4272XA", "T428X2A", "T43012A", "T43022A", "T431X2A", "T43202A",
                      "T43212A", "T43222A", "T43292A", "T433X2A", "T434X2A", "T43502A",
                      "T43592A", "T43602A", "T43612A", "T43622A", "T43632A", "T43692A",
                      "T438X2A", "T4392XA", "T440X2A", "T441X2A", "T442X2A", "T443X2A",
                      "T444X2A", "T445X2A", "T446X2A", "T447X2A", "T448X2A", "T44902A",
                      "T44992A", "T450X2A", "T451X2A", "T452X2A", "T453X2A", "T454X2A",
                      "T45512A", "T45522A", "T45602A", "T45612A", "T45622A", "T45692A",
                      "T457X2A", "T458X2A", "T4592XA", "T460X2A", "T461X2A", "T462X2A",
                      "T463X2A", "T464X2A", "T465X2A", "T466X2A", "T467X2A", "T468X2A",
                      "T46902A", "T46992A", "T470X2A", "T471X2A", "T472X2A", "T473X2A",
                      "T474X2A", "T475X2A", "T476X2A", "T477X2A", "T478X2A", "T4792XA",
                      "T480X2A", "T481X2A", "T48202A", "T48292A", "T483X2A", "T484X2A",
                      "T485X2A", "T486X2A", "T48902A", "T48992A", "T490X2A", "T491X2A",
                      "T492X2A", "T493X2A", "T494X2A", "T495X2A", "T496X2A", "T497X2A",
                      "T498X2A", "T4992XA", "T500X2A", "T501X2A", "T502X2A", "T503X2A",
                      "T504X2A", "T505X2A", "T506X2A", "T507X2A", "T508X2A", "T50902A",
                      "T50992A", "T50A12A", "T50A22A", "T50A92A", "T50B12A", "T50B92A",
                      "T50Z12A", "T50Z92A", "T510X2A", "T511X2A", "T512X2A", "T513X2A",
                      "T518X2A", "T5192XA", "T520X2A", "T521X2A", "T522X2A", "T523X2A",
                      "T524X2A", "T528X2A", "T5292XA", "T530X2A", "T531X2A", "T532X2A",
                      "T533X2A", "T534X2A", "T535X2A", "T536X2A", "T537X2A", "T5392XA",
                      "T540X2A", "T541X2A", "T542X2A", "T543X2A", "T5492XA", "T550X2A",
                      "T551X2A", "T560X2A", "T561X2A", "T562X2A", "T563X2A", "T564X2A",
                      "T565X2A", "T566X2A", "T567X2A", "T56812A", "T56892A", "T5692XA",
                      "T570X2A", "T571X2A", "T572X2A", "T573X2A", "T578X2A", "T5792XA",
                      "T5802XA", "T5812XA", "T582X2A", "T588X2A", "T5892XA", "T590X2A",
                      "T591X2A", "T592X2A", "T593X2A", "T594X2A", "T595X2A", "T596X2A",
                      "T597X2A", "T59812A", "T59892A", "T5992XA", "T600X2A", "T601X2A",
                      "T602X2A", "T603X2A", "T604X2A", "T608X2A", "T6092XA", "T6102XA",
                      "T6112XA", "T61772A", "T61782A", "T618X2A", "T6192XA", "T620X2A",
                      "T621X2A", "T622X2A", "T628X2A", "T6292XA", "T63002A", "T63012A",
                      "T63022A", "T63032A", "T63042A", "T63062A", "T63072A", "T63082A",
                      "T63092A", "T63112A", "T63122A", "T63192A", "T632X2A", "T63302A",
                      "T63312A", "T63322A", "T63332A", "T63392A", "T63412A", "T63422A",
                      "T63432A", "T63442A", "T63452A", "T63462A", "T63482A", "T63512A",
                      "T63592A", "T63612A", "T63622A", "T63632A", "T63692A", "T63712A",
                      "T63792A", "T63812A", "T63822A", "T63832A", "T63892A", "T6392XA", 
                      "T6402XA", "T6482XA", "T650X2A", "T651X2A", "T65212A", "T65222A",
                      "T65292A", "T653X2A", "T654X2A", "T655X2A", "T656X2A", "T65812A",
                      "T65822A", "T65832A", "T65892A", "T6592XA")

poisoning_unintent <- str_replace(poisoning_intent, "2XA", "1XA") %>%
  str_replace("2A", "1A")

poisoning_undeter <- str_replace(poisoning_intent, "2XA", "4XA") %>%
  str_replace("2A", "4A")

##ER VISITS FOR INTENTIONAL SELF-HARM, GIRLS 10--19

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tg_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, "tg_selfh_all_2015.rds")
saveRDS(tg_2015_b, "alt_teeng15.rds")

# Not binding deaths vs. non-deaths here b/c deaths
# are such a small proportion of visits.
# I compute the exact proportions later in 
# the script for completion

clean_16_17("tg_", "selfh", dxlist10_selfh)
bind_ts("tg_selfh_all")

##BOYS 10--19

invisible(lapply(2006:2014, clean_icd9, name = "tb_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tb_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

df_2015q3 <- dfs$q3
df_2015q4 <- dfs$q4

df_2015_a <- rbind(df_2015q3[1:9,], df_2015q4[2:4,])
df_2015_b <- df_2015_a

df_2015_b[9,2] <- df_2015_a[9,2] + df_2015q4[1,2]
df_2015_b[12,2] <- df_2015_a[12,2] + df_2015q3[10,2]

saveRDS(df_2015_a, "tb_selfh_all_2015.rds")
saveRDS(df_2015_b, "alt_teenb15.rds")

clean_16_17("tb_", "selfh", dxlist10_selfh)
bind_ts("tb_selfh_all")

##MEN 40-65

invisible(lapply(2006:2014, clean_icd9, name = "m40_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("m40_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

df_2015q3 <- dfs$q3
df_2015q4 <- dfs$q4

df_2015_a <- rbind(df_2015q3[1:9,], df_2015q4[4:6,])
df_2015_b <- df_2015_a

df_2015_b[9,2] <- df_2015_a[9,2] + df_2015q4[3,2]
df_2015_b[10,2] <- df_2015_a[10,2] + df_2015q3[10,2]
df_2015_b[11,2] <- df_2015_a[11,2] + df_2015q3[11,2]
df_2015_b[12,2] <- df_2015_a[12,2] + df_2015q3[12,2]

saveRDS(df_2015_a, "m40_selfh_all_2015.rds")
saveRDS(df_2015_b, "alt_men15.rds")
clean_16_17("m40_", "selfh", dxlist10_selfh)
bind_ts("m40_selfh_all")

##WOMEN 40-65

invisible(lapply(2006:2014, clean_icd9, name = "w40_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("w40_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

df_2015q3 <- dfs$q3
df_2015q4 <- dfs$q4

df_2015_a <- rbind(df_2015q3[1:9,], df_2015q4[3:5,])
df_2015_b <- df_2015_a

df_2015_b[8,2] <- df_2015_a[8,2] + df_2015q4[1,2]
df_2015_b[9,2] <- df_2015_a[9,2] + df_2015q4[2,2]
df_2015_b[11,2] <- df_2015_a[11,2] + df_2015q3[10,2]
df_2015_b[12,2] <- df_2015_a[12,2] + df_2015q3[11,2]

saveRDS(df_2015_a, "w40_selfh_all_2015.rds")
saveRDS(df_2015_b, "alt_women15.rds")

clean_16_17("w40_", "selfh", dxlist10_selfh)
bind_ts("w40_selfh_all")

## TG 2016-17 SUICIDE ATTEMPT CODE

clean_16_17("tg_", "attempt", dxlist = "^T1491")

tg_attempt_16 <- readRDS("tg_attempt_all_2016.rds")
tg_attempt_17 <- readRDS("tg_attempt_all_2017.rds")

tg_attempt <- rbind(tg_attempt_16, tg_attempt_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_attempt, "tg_attempt.rds")

##CUTTING, GIRLS 10--19

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "cut", dxlist = "^E956"))

dfs <- clean_15("tg_", dxlist9 = "^E956", 
                dxlist10 = cutting_intent)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, "tg_cut_all_2015.rds")
saveRDS(tg_2015_b, "alt_c_2015.rds")

clean_16_17("tg_", "cut", dxlist = cutting_intent)

bind_ts("tg_cut_all")

# Merging cut and selfh data
tg_self_harm <- readRDS("tg_selfh_all_full.rds")
tg_self_cut <- readRDS("tg_cut_all_full.rds")

tg_self_harm$cut <- tg_self_cut$self_h

tg_self_harm$cut_prop <- tg_self_harm$cut / tg_self_harm$self_h

saveRDS(tg_self_harm, "tg_self_harm.rds")

## TG SERIES USING ONLY POISON AND CUTTING DX

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "pois_cut", dxlist = dxlist9_pois_cut))

dfs <- clean_15("tg_", dxlist9 = dxlist9_pois_cut, dxlist10 = dxlist10_pois_cut)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, "tg_pois_cut_all_2015.rds")

clean_16_17("tg_", "pois_cut", dxlist10_pois_cut)
bind_ts("tg_pois_cut_all")

### UNINTENTIONAL AND UNDETERMINED SELF-HARM

clean_16_17("tg_", "unintent", dxlist_unintent)
clean_16_17("tg_", "undeter", dxlist_undeter)

tg_unintent_16 <- readRDS("tg_unintent_all_2016.rds")
tg_unintent_17 <- readRDS("tg_unintent_all_2016.rds")

tg_unintent <- rbind(tg_unintent_16, tg_unintent_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_unintent, "tg_unintent.rds")

tg_undeter_16 <- readRDS("tg_undeter_all_2016.rds")
tg_undeter_17 <- readRDS("tg_undeter_all_2017.rds")

tg_undeter <- rbind(tg_undeter_16, tg_undeter_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_undeter, "tg_undeter.rds")

## CUTTING BY INTENT

clean_16_17("tg_", "cut_intent", cutting_intent)
clean_16_17("tg_", "cut_unintent", cutting_unintent)
clean_16_17("tg_", "cut_undeter", cutting_undeter)

cut_intent_df17 <- readRDS("tg_cut_intent_all_2017.rds") %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_intent_df16 <- readRDS("tg_cut_intent_all_2016.rds") %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_unintent_df17 <- readRDS("tg_cut_unintent_all_2017.rds") %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_unintent_df16 <- readRDS("tg_cut_unintent_all_2016.rds") %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_undeter_df17 <- readRDS("tg_cut_undeter_all_2017.rds") %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_undeter_df16 <- readRDS("tg_cut_undeter_all_2016.rds") %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

tg_cut <- rbind(cut_intent_df16, cut_intent_df17,
                cut_unintent_df16, cut_unintent_df17,
                cut_undeter_df16, cut_undeter_df17)

saveRDS(tg_cut, "tg_cut.rds")

## POISONING BY INTENT

clean_16_17("tg_", "poison_intent", poisoning_intent)
clean_16_17("tg_", "poison_unintent", poisoning_unintent)
clean_16_17("tg_", "poison_undeter", poisoning_undeter)

poison_intent_df17 <- readRDS("tg_poison_intent_all_2017.rds") %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_intent_df16 <- readRDS("tg_poison_intent_all_2016.rds") %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_unintent_df17 <- readRDS("tg_poison_unintent_all_2017.rds") %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_unintent_df16 <- readRDS("tg_poison_unintent_all_2016.rds") %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_undeter_df17 <- readRDS("tg_poison_undeter_all_2017.rds") %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_undeter_df16 <- readRDS("tg_poison_undeter_all_2016.rds") %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

tg_poison <- rbind(poison_intent_df16, poison_intent_df17,
                   poison_unintent_df16, poison_unintent_df17,
                   poison_undeter_df16, poison_undeter_df17)

saveRDS(tg_poison, "tg_poison.rds")

# combining the poison and cut dataframes
tg_cut_poison <- left_join(tg_poison, tg_cut, by = c("date", "type"),
                           suffix = c("", ".y")) %>%
  select(-ends_with(".y")) %>%
  mutate(cut_poison = cutting + poison)

saveRDS(tg_cut_poison, "tg_cut_poison.rds")  

## UNWEIGHTED COUNTS

invisible(lapply(2006:2014, clean_icd9_unwt, name = "tg_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15_unwt("tg_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

setwd("Z:/NEDS/unweighted")
saveRDS(tg_2015_a, "tg_2015_unweighted.rds")
setwd("Z:/NEDS")

clean_16_17_unwt("tg_", dxname = "selfh", dxlist = dxlist10_selfh)

setwd("Z:/NEDS/unweighted")
bind_ts_unwt("tg_")
setwd("Z:/NEDS")

### CHECKING FOR COMMON OBS B/T INTENTIONAL AND ACCIDENTAL

neds <- read.dta13("tg_2017.dta")
setDT(neds)

## dxlist for INTENTIONAL cutting

cutting_intent <- c("X780XXA", "X781XXA", "X782XXA", "X788XXA" , "X789XXA")

## dxlist for ACCIDENTAL cutting

cutting_unintent <- c("W25XXXA", "W260XXA", "W261XXA", "W262XXA", "W268XXA", "W269XXA")

rnums_intent <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:35))], 
                       grep, pattern = paste(cutting_intent, collapse = "|"))
rnums_intent <- unique(unlist(rnums_intent))

rnums_unintent <- lapply(neds[, .SD, .SDcols = c(paste0("i10_dx", 1:35))], 
                         grep, pattern = paste(cutting_unintent, collapse = "|"))
rnums_unintent <- unique(unlist(rnums_unintent))

rnums_both <- intersect(rnums_unintent, rnums_intent)

neds_both <- neds[rnums_both,]

sum(neds_both$discwt)
sum(neds_both[-c(4,7)]$discwt)

saveRDS(neds_both, "tg_cut_both.rds")

## TEEN GIRLS 10--17

invisible(lapply(2006:2014, clean_icd9, name = "tg17_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tg17_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, "tg17_selfh_all_2015.rds")
#saveRDS(tg_2015_b, "alt_teeng15.rds")

# Not binding deaths vs. non-deaths b/c deaths
# are such a small proportion of visits

clean_16_17("tg17_", "selfh", dxlist10_selfh)
bind_ts("tg17_selfh_all")

tg17 <- readRDS("tg17_selfh_all_full.rds")

# Calculating proportion that are fatal

bind_ts("tg_selfh_died")
bind_ts("tg_selfh_surv")

tg_died <- readRDS("tg_selfh_died_full.rds")
tg_surv <- readRDS("tg_selfh_surv_full.rds")

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2017) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2017) %>%
  select(self_h)

# proportion fatal by month in 2017
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

# same for 2016

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2016) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2016) %>%
  select(self_h)

# proportion fatal by month in 2016
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

# same for 2006

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2006) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2006) %>%
  select(self_h)

# proportion fatal by month in 2006
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2007) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2007) %>%
  select(self_h)

# proportion fatal by month in 2007
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2008) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2008) %>%
  select(self_h)

# proportion fatal by month in 2008
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2009) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2009) %>%
  select(self_h)

# proportion fatal by month in 2009
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))

tg_selfh_all <- tg_self_harm %>%
  filter(year == 2013) %>%
  select(self_h)

tg_selfh_surv <- tg_surv %>%
  filter(year == 2013) %>%
  select(self_h)

# proportion fatal by month in 
props <- (tg_selfh_all - tg_selfh_surv) / tg_selfh_all
props

# avg across months
mean(unlist(props))