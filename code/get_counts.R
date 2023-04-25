####################################################################################
##
## This script will produce monthly counts of ER visits for self-harm among 
## different demographic groups. You MUST run the following scripts BEFORE running 
## this one, in this order:
##
##  1. csv_to_dta_teen_girls.do 
##  2. csv_to_dta_other.do
##  3. cleaning_functions.R
##  4. diagnosis_codes.R
##
## You should have also opened the RStudio Project file 13RW.Rproj, which will
## set the working directory to the location of the Rproj file.
##
## This will result in many .rds files that contain one year of data for a
## particular subgroup (e.g., teen girls who did not die in the ER, or men
## age 40--65 who did die in the ER). The main analysis uses the files marked
## "all," which contain both deaths and non-fatal ER visits. (For teen girls,
## only a very small proportion of visits result in death.) 
##
## The script will also produce .rds files that bind together the different years
## of data. These files are marked "full." E.g., "w40_selfh_all_full.rds" contains
## monthly counts of self-harm visits for women age 40--65 from 2006--2017 and
## includes both deaths and non-fatal visits. analysis.R will primarily read in
## these files.
##
## tg_self_harm.rds contains all the info from tg_selfh_all_full.rds plus
## info on cutting. This is the main dataframe used in analysis.R.
##
####################################################################################

### ER VISITS FOR INTENTIONAL SELF-HARM, GIRLS 10--19 ###

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tg_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, here("data", "tg_selfh_all_2015.rds"))
saveRDS(tg_2015_b, here("data", "alt_teeng15.rds"))

# Not binding deaths vs. non-deaths here b/c deaths
# are such a small proportion of visits.
# I compute the exact proportions later in 
# the script for completion.

clean_16_17("tg_", "selfh", dxlist10_selfh)
bind_ts("tg_selfh_all")

### BOYS 10--19 ###

invisible(lapply(2006:2014, clean_icd9, name = "tb_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tb_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

df_2015q3 <- dfs$q3
df_2015q4 <- dfs$q4

df_2015_a <- rbind(df_2015q3[1:9,], df_2015q4[2:4,])
df_2015_b <- df_2015_a

df_2015_b[9,2] <- df_2015_a[9,2] + df_2015q4[1,2]
df_2015_b[12,2] <- df_2015_a[12,2] + df_2015q3[10,2]

saveRDS(df_2015_a, here("data", "tb_selfh_all_2015.rds"))
saveRDS(df_2015_b, here("data", "alt_teenb15.rds"))

clean_16_17("tb_", "selfh", dxlist10_selfh)
bind_ts("tb_selfh_all")

### MEN 40-65 ###

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

saveRDS(df_2015_a, here("data", "m40_selfh_all_2015.rds"))
saveRDS(df_2015_b, here("data", "alt_men15.rds"))
clean_16_17("m40_", "selfh", dxlist10_selfh)
bind_ts("m40_selfh_all")

### WOMEN 40-65 ###

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

saveRDS(df_2015_a, here("data", "w40_selfh_all_2015.rds"))
saveRDS(df_2015_b, here("data", "alt_women15.rds"))

clean_16_17("w40_", "selfh", dxlist10_selfh)
bind_ts("w40_selfh_all")

### GIRLS 10--19 2016-17 SUICIDE ATTEMPT ###

clean_16_17("tg_", "attempt", dxlist = "^T1491")

tg_attempt_16 <- readRDS(here("data", "tg_attempt_all_2016.rds"))
tg_attempt_17 <- readRDS(here("data", "tg_attempt_all_2017.rds"))

tg_attempt <- rbind(tg_attempt_16, tg_attempt_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_attempt, here("data", "tg_attempt.rds"))

### CUTTING, GIRLS 10--19 ###

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "cut", dxlist = "^E956"))

dfs <- clean_15("tg_", dxlist9 = "^E956", 
                dxlist10 = cutting_intent)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, here("data", "tg_cut_all_2015.rds"))
saveRDS(tg_2015_b, here("data", "alt_c_2015.rds"))

clean_16_17("tg_", "cut", dxlist = cutting_intent)

bind_ts("tg_cut_all")

## Merging cutting and self-harm data ##

tg_self_harm <- readRDS(here("data", "tg_selfh_all_full.rds"))
tg_self_cut <- readRDS(here("data", "tg_cut_all_full.rds"))

tg_self_harm$cut <- tg_self_cut$self_h

tg_self_harm$cut_prop <- tg_self_harm$cut / tg_self_harm$self_h

saveRDS(tg_self_harm, here("data", "tg_self_harm.rds"))

### GIRLS 10--19, INTENTIONAL POISONING AND CUTTING ONLY ###

# This excludes, e.g., asphyxiation. The rationale is that
# the vast majority of visits among teen girls are for
# poisoning and cutting, so we should check that removing
# a small portion of self-harm visits does not substantially
# alter the results. (It doesn't.)

invisible(lapply(2006:2014, clean_icd9, name = "tg_", dxname = "pois_cut", dxlist = dxlist9_pois_cut))

dfs <- clean_15("tg_", dxlist9 = dxlist9_pois_cut, dxlist10 = dxlist10_pois_cut)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, here("data", "tg_pois_cut_all_2015.rds"))

clean_16_17("tg_", "pois_cut", dxlist10_pois_cut)
bind_ts("tg_pois_cut_all")

### GIRLS 10--19, UNINTENTIONAL AND UNDETERMINED SELF-HARM ###

clean_16_17("tg_", "unintent", dxlist_unintent)
clean_16_17("tg_", "undeter", dxlist_undeter)

tg_unintent_16 <- readRDS(here("data", "tg_unintent_all_2016.rds"))
tg_unintent_17 <- readRDS(here("data", "tg_unintent_all_2017.rds"))

tg_unintent <- rbind(tg_unintent_16, tg_unintent_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_unintent, here("data", "tg_unintent.rds"))

tg_undeter_16 <- readRDS(here("data", "tg_undeter_all_2016.rds"))
tg_undeter_17 <- readRDS(here("data", "tg_undeter_all_2017.rds"))

tg_undeter <- rbind(tg_undeter_16, tg_undeter_17) %>%
  mutate(date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y"))

saveRDS(tg_undeter, here("data", "tg_undeter.rds"))

### GIRLS 10--19, CUTTING BROKEN DOWN BY INTENT ###

clean_16_17("tg_", "cut_intent", cutting_intent)
clean_16_17("tg_", "cut_unintent", cutting_unintent)
clean_16_17("tg_", "cut_undeter", cutting_undeter)

cut_intent_df17 <- readRDS(here("data", "tg_cut_intent_all_2017.rds")) %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_intent_df16 <- readRDS(here("data", "tg_cut_intent_all_2016.rds")) %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_unintent_df17 <- readRDS(here("data", "tg_cut_unintent_all_2017.rds")) %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_unintent_df16 <- readRDS(here("data", "tg_cut_unintent_all_2016.rds")) %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_undeter_df17 <- readRDS(here("data", "tg_cut_undeter_all_2017.rds")) %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

cut_undeter_df16 <- readRDS(here("data", "tg_cut_undeter_all_2016.rds")) %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(cutting = self_h)

tg_cut <- rbind(cut_intent_df16, cut_intent_df17,
                cut_unintent_df16, cut_unintent_df17,
                cut_undeter_df16, cut_undeter_df17)

saveRDS(tg_cut, here("data", "tg_cut.rds"))

### GIRLS 10--19, POISONING BY INTENT ###

clean_16_17("tg_", "poison_intent", poisoning_intent)
clean_16_17("tg_", "poison_unintent", poisoning_unintent)
clean_16_17("tg_", "poison_undeter", poisoning_undeter)

poison_intent_df17 <- readRDS(here("data", "tg_poison_intent_all_2017.rds")) %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_intent_df16 <- readRDS(here("data", "tg_poison_intent_all_2016.rds")) %>%
  mutate(type = "intent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_unintent_df17 <- readRDS(here("data", "tg_poison_unintent_all_2017.rds")) %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_unintent_df16 <- readRDS(here("data", "tg_poison_unintent_all_2016.rds")) %>%
  mutate(type = "unintent",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_undeter_df17 <- readRDS(here("data", "tg_poison_undeter_all_2017.rds")) %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

poison_undeter_df16 <- readRDS(here("data", "tg_poison_undeter_all_2016.rds")) %>%
  mutate(type = "undeter",
         date = as.Date(paste(amonth, "01", year, sep = "-"), format = "%m-%d-%Y")) %>%
  rename(poison = self_h)

tg_poison <- rbind(poison_intent_df16, poison_intent_df17,
                   poison_unintent_df16, poison_unintent_df17,
                   poison_undeter_df16, poison_undeter_df17)

saveRDS(tg_poison, here("data", "tg_poison.rds"))

# Combining the poison and cut dataframes

tg_cut_poison <- left_join(tg_poison, tg_cut, by = c("date", "type"),
                           suffix = c("", ".y")) %>%
  select(-ends_with(".y")) %>%
  mutate(cut_poison = cutting + poison)

saveRDS(tg_cut_poison, here("data", "tg_cut_poison.rds"))

### GIRLS 10--19, UNWEIGHTED COUNTS ###

invisible(lapply(2006:2014, clean_icd9_unwt, name = "tg_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15_unwt("tg_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, here("data", "unweighted", "tg_2015_unweighted.rds"))

clean_16_17_unwt("tg_", dxname = "selfh", dxlist = dxlist10_selfh)

setwd(unwt_dir)
bind_ts_unwt("tg_")
setwd(data_dir)

### CHECKING FOR COMMON OBS B/T INTENTIONAL AND ACCIDENTAL

neds <- read.dta13(here("data", "tg_2017.dta"))
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

saveRDS(neds_both, here("data", "tg_cut_both.rds"))

## TEEN GIRLS 10--17

invisible(lapply(2006:2014, clean_icd9, name = "tg17_", dxname = "selfh", dxlist = dxlist9_selfh))

dfs <- clean_15("tg17_", dxlist9 = dxlist9_selfh, dxlist10 = dxlist10_selfh)

tg_2015q3 <- dfs$q3
tg_2015q4 <- dfs$q4

tg_2015_a <- rbind(tg_2015q3[1:9,], tg_2015q4[2:4,])
tg_2015_b <- tg_2015_a

tg_2015_b[9,2] <- tg_2015_a[9,2] + tg_2015q4[1,2]
tg_2015_b[12,2] <- tg_2015_a[12,2] + tg_2015q3[10,2]

saveRDS(tg_2015_a, here("data", "tg17_selfh_all_2015.rds"))
#saveRDS(tg_2015_b, "alt_teeng15.rds")

# Not binding deaths vs. non-deaths b/c deaths
# are such a small proportion of visits

clean_16_17("tg17_", "selfh", dxlist10_selfh)
bind_ts("tg17_selfh_all")

# Calculating proportion that are fatal

bind_ts("tg_selfh_died")
bind_ts("tg_selfh_surv")
 
tg_died <- readRDS(here("data", "tg_selfh_died_full.rds")) 
tg_surv <- readRDS(here("data", "tg_selfh_surv_full.rds")) 

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