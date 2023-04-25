* NOTE: This do file is a combination of the do files provided
* by HCUP to load the data, plus a few lines of code to remove missing
* observations and observations that lie outside the target demographic
* group. This results in 2 files per year: a .dta file with unneeded
* variables removed, and a .dta file that contains only observations for
* teen girls. To get files for other demographic groups, see the
* do file called suppclean.do. I obtain counts of self-harm visits in R,
* since that is my primary coding language. Also, please note this do file
* will take a long time to run. The CSV files are massive.

* The original .do files from HCUP can be found here:
* https://hcup-us.ahrq.gov/db/nation/neds/nedsstataloadprog.jsp

cd Z:\NEDS\data

/*****************************************************************************
* Stataload_NEDS_2006_Core.Do
* This program will load the 2006 NEDS CSV Core File into Stata.
* Because Stata loads the entire file into memory, it may not be possible
* to load every data element for large files.  If necessary, edit this
* program to change the memory size or to load only selected data elements.
*****************************************************************************/

*** Set available memory size ***
set mem 1100m

*** Read data elements from the csv file ***
insheet      AGE                                 ///
             AMONTH                              ///
             AWEEKEND                            ///
             CHRON1                              ///
             CHRON2                              ///
             CHRON3                              ///
             CHRON4                              ///
             CHRON5                              ///
             CHRON6                              ///
             CHRON7                              ///
             CHRON8                              ///
             CHRON9                              ///
             CHRON10                             ///
             CHRON11                             ///
             CHRON12                             ///
             CHRON13                             ///
             CHRON14                             ///
             CHRON15                             ///
             DIED_VIS                            ///
             DISCWT                              ///
             DISP_ED                             ///
             DQTR                                ///
             DX1                                 ///
             DX2                                 ///
             DX3                                 ///
             DX4                                 ///
             DX5                                 ///
             DX6                                 ///
             DX7                                 ///
             DX8                                 ///
             DX9                                 ///
             DX10                                ///
             DX11                                ///
             DX12                                ///
             DX13                                ///
             DX14                                ///
             DX15                                ///
             DXCCS1                              ///
             DXCCS2                              ///
             DXCCS3                              ///
             DXCCS4                              ///
             DXCCS5                              ///
             DXCCS6                              ///
             DXCCS7                              ///
             DXCCS8                              ///
             DXCCS9                              ///
             DXCCS10                             ///
             DXCCS11                             ///
             DXCCS12                             ///
             DXCCS13                             ///
             DXCCS14                             ///
             DXCCS15                             ///
             ECODE1                              ///
             ECODE2                              ///
             ECODE3                              ///
             ECODE4                              ///
             EDEVENT                             ///
             E_CCS1                              ///
             E_CCS2                              ///
             E_CCS3                              ///
             E_CCS4                              ///
             FEMALE                              ///
             HCUPFILE                            ///
             HOSP_ED                             ///
             REGION                              ///
             INTENT_S                            ///
             KEY_ED                              ///
             NDX                                 ///
             NECODE                              ///
             NEDS_STR                            ///
             PAY1                                ///
             PAY2                                ///
             PL_NCHS2                            ///
             TOTCHGED                            ///
             YEAR                                ///
             ZIPINC_Q                            ///
      using  "NEDS_2006_Core.csv"

***  Assign labels to the data elements ***
label var age                      "Age in years at admission"
label var amonth                   "Admission month"
label var aweekend                 "Admission day is a weekend"
label var chron1                   "Chronic condition indicator 1"
label var chron2                   "Chronic condition indicator 2"
label var chron3                   "Chronic condition indicator 3"
label var chron4                   "Chronic condition indicator 4"
label var chron5                   "Chronic condition indicator 5"
label var chron6                   "Chronic condition indicator 6"
label var chron7                   "Chronic condition indicator 7"
label var chron8                   "Chronic condition indicator 8"
label var chron9                   "Chronic condition indicator 9"
label var chron10                  "Chronic condition indicator 10"
label var chron11                  "Chronic condition indicator 11"
label var chron12                  "Chronic condition indicator 12"
label var chron13                  "Chronic condition indicator 13"
label var chron14                  "Chronic condition indicator 14"
label var chron15                  "Chronic condition indicator 15"
label var died_vis                 "Died in the ED (1), Died in the hospital (2), did not die (0)"
label var discwt                   "Weight to ED Visits in AHA universe"
label var disp_ed                  "Disposition of patient (uniform) from ED"
label var dqtr                     "Discharge quarter"
label var dx1                      "Principal diagnosis"
label var dx2                      "Diagnosis 2"
label var dx3                      "Diagnosis 3"
label var dx4                      "Diagnosis 4"
label var dx5                      "Diagnosis 5"
label var dx6                      "Diagnosis 6"
label var dx7                      "Diagnosis 7"
label var dx8                      "Diagnosis 8"
label var dx9                      "Diagnosis 9"
label var dx10                     "Diagnosis 10"
label var dx11                     "Diagnosis 11"
label var dx12                     "Diagnosis 12"
label var dx13                     "Diagnosis 13"
label var dx14                     "Diagnosis 14"
label var dx15                     "Diagnosis 15"
label var dxccs1                   "CCS: principal diagnosis"
label var dxccs2                   "CCS: diagnosis 2"
label var dxccs3                   "CCS: diagnosis 3"
label var dxccs4                   "CCS: diagnosis 4"
label var dxccs5                   "CCS: diagnosis 5"
label var dxccs6                   "CCS: diagnosis 6"
label var dxccs7                   "CCS: diagnosis 7"
label var dxccs8                   "CCS: diagnosis 8"
label var dxccs9                   "CCS: diagnosis 9"
label var dxccs10                  "CCS: diagnosis 10"
label var dxccs11                  "CCS: diagnosis 11"
label var dxccs12                  "CCS: diagnosis 12"
label var dxccs13                  "CCS: diagnosis 13"
label var dxccs14                  "CCS: diagnosis 14"
label var dxccs15                  "CCS: diagnosis 15"
label var ecode1                   "E code 1"
label var ecode2                   "E code 2"
label var ecode3                   "E code 3"
label var ecode4                   "E code 4"
label var edevent                  "Type of ED Event"
label var e_ccs1                   "CCS: E Code 1"
label var e_ccs2                   "CCS: E Code 2"
label var e_ccs3                   "CCS: E Code 3"
label var e_ccs4                   "CCS: E Code 4"
label var female                   "Indicator of sex"
label var hcupfile                 "Source of HCUP Record (SID or SEDD)"
label var hosp_ed                  "HCUP ED hospital identifier"
label var region                   "Region of hospital"
label var intent_s                 "Intentional self harm indicated on the record (by diagnosis and/or E codes)"
label var key_ed                   "HCUP NEDS record identifier"
label var ndx                      "Number of diagnoses on this record"
label var necode                   "Number of E codes on this record"
label var neds_str                 "Stratum used to sample hospital"
label var pay1                     "Primary expected payer (uniform)"
label var pay2                     "Secondary expected payer (uniform)"
label var pl_nchs2                 "Patient Location: NCHS Urban-Rural Code (V2006)"
label var totchged                 "Total charge for ED services"
label var year                     "Calendar year"
label var zipinc_q                 "Median household income national quartile for patient ZIP Code"

*** Convert special values to missing values ***
recode age                       (-99 -88 -66=.)
recode amonth                    (-9 -8 -6 -5=.)
recode aweekend                  (-9 -8 -6 -5=.)
recode chron1                    (-99 -88 -66=.)
recode chron2                    (-99 -88 -66=.)
recode chron3                    (-99 -88 -66=.)
recode chron4                    (-99 -88 -66=.)
recode chron5                    (-99 -88 -66=.)
recode chron6                    (-99 -88 -66=.)
recode chron7                    (-99 -88 -66=.)
recode chron8                    (-99 -88 -66=.)
recode chron9                    (-99 -88 -66=.)
recode chron10                   (-99 -88 -66=.)
recode chron11                   (-99 -88 -66=.)
recode chron12                   (-99 -88 -66=.)
recode chron13                   (-99 -88 -66=.)
recode chron14                   (-99 -88 -66=.)
recode chron15                   (-99 -88 -66=.)
recode died_vis                  (-9 -8 -6 -5=.)
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.)
recode disp_ed                   (-9 -8 -6 -5=.)
recode dqtr                      (-9 -8 -6 -5=.)
recode dxccs1                    (-999 -888 -666=.)
recode dxccs2                    (-999 -888 -666=.)
recode dxccs3                    (-999 -888 -666=.)
recode dxccs4                    (-999 -888 -666=.)
recode dxccs5                    (-999 -888 -666=.)
recode dxccs6                    (-999 -888 -666=.)
recode dxccs7                    (-999 -888 -666=.)
recode dxccs8                    (-999 -888 -666=.)
recode dxccs9                    (-999 -888 -666=.)
recode dxccs10                   (-999 -888 -666=.)
recode dxccs11                   (-999 -888 -666=.)
recode dxccs12                   (-999 -888 -666=.)
recode dxccs13                   (-999 -888 -666=.)
recode dxccs14                   (-999 -888 -666=.)
recode dxccs15                   (-999 -888 -666=.)
recode edevent                   (-9 -8 -6 -5=.)
recode e_ccs1                    (-999 -888 -666=.)
recode e_ccs2                    (-999 -888 -666=.)
recode e_ccs3                    (-999 -888 -666=.)
recode e_ccs4                    (-999 -888 -666=.)
recode female                    (-9 -8 -6 -5=.)
recode hosp_ed                   (-9999 -8888 -6666=.)
recode region                    (-9 -8 -6 -5=.)
recode intent_s                  (-9 -8 -6 -5=.)
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.)
recode ndx                       (-9 -8 -6 -5=.)
recode necode                    (-99 -88 -66=.)
recode neds_str                  (-9999 -8888 -6666=.)
recode pay1                      (-9 -8 -6 -5=.)
recode pay2                      (-9 -8 -6 -5=.)
recode pl_nchs2                  (-99 -88 -66=.)
recode totchged                  (-99999999.99 -88888888.88 -66666666.66=.)
recode year                      (-999 -888 -666=.)
recode zipinc_q                  (-9 -8 -6 -5=.)

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_vis

save "NEDS_2006_Core_trim.dta", replace

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 19

drop if age < 10

save "tg_2006.dta", replace

clear

/*****************************************************************************
* Stataload_NEDS_2007_Core.Do
* This program will load the 2007 NEDS CSV Core File into Stata.
* Because Stata loads the entire file into memory, it may not be possible
* to load every data element for large files.  If necessary, edit this
* program to change the memory size or to load only selected data elements.
*****************************************************************************/

*** Set available memory size ***
set mem 1100m

*** Read data elements from the csv file ***
insheet      AGE                                 ///
             AMONTH                              ///
             AWEEKEND                            ///
             CHRON1                              ///
             CHRON2                              ///
             CHRON3                              ///
             CHRON4                              ///
             CHRON5                              ///
             CHRON6                              ///
             CHRON7                              ///
             CHRON8                              ///
             CHRON9                              ///
             CHRON10                             ///
             CHRON11                             ///
             CHRON12                             ///
             CHRON13                             ///
             CHRON14                             ///
             CHRON15                             ///
             DIED_VIS                            ///
             DISCWT                              ///
             DISP_ED                             ///
             DQTR                                ///
             DX1                                 ///
             DX2                                 ///
             DX3                                 ///
             DX4                                 ///
             DX5                                 ///
             DX6                                 ///
             DX7                                 ///
             DX8                                 ///
             DX9                                 ///
             DX10                                ///
             DX11                                ///
             DX12                                ///
             DX13                                ///
             DX14                                ///
             DX15                                ///
             DXCCS1                              ///
             DXCCS2                              ///
             DXCCS3                              ///
             DXCCS4                              ///
             DXCCS5                              ///
             DXCCS6                              ///
             DXCCS7                              ///
             DXCCS8                              ///
             DXCCS9                              ///
             DXCCS10                             ///
             DXCCS11                             ///
             DXCCS12                             ///
             DXCCS13                             ///
             DXCCS14                             ///
             DXCCS15                             ///
             ECODE1                              ///
             ECODE2                              ///
             ECODE3                              ///
             ECODE4                              ///
             EDEVENT                             ///
             E_CCS1                              ///
             E_CCS2                              ///
             E_CCS3                              ///
             E_CCS4                              ///
             FEMALE                              ///
             HCUPFILE                            ///
             HOSP_ED                             ///
             REGION                              ///
             INTENT_S                            ///
             KEY_ED                              ///
             NDX                                 ///
             NECODE                              ///
             NEDS_STR                            ///
             PAY1                                ///
             PAY2                                ///
             PL_NCHS2                            ///
             TOTCHGED                            ///
             YEAR                                ///
             ZIPINC_Q                            ///
      using  "NEDS_2007_Core.csv"

***  Assign labels to the data elements ***
label var age                      "Age in years at admission"
label var amonth                   "Admission month"
label var aweekend                 "Admission day is a weekend"
label var chron1                   "Chronic condition indicator 1"
label var chron2                   "Chronic condition indicator 2"
label var chron3                   "Chronic condition indicator 3"
label var chron4                   "Chronic condition indicator 4"
label var chron5                   "Chronic condition indicator 5"
label var chron6                   "Chronic condition indicator 6"
label var chron7                   "Chronic condition indicator 7"
label var chron8                   "Chronic condition indicator 8"
label var chron9                   "Chronic condition indicator 9"
label var chron10                  "Chronic condition indicator 10"
label var chron11                  "Chronic condition indicator 11"
label var chron12                  "Chronic condition indicator 12"
label var chron13                  "Chronic condition indicator 13"
label var chron14                  "Chronic condition indicator 14"
label var chron15                  "Chronic condition indicator 15"
label var died_vis                 "Died in the ED (1), Died in the hospital (2), did not die (0)"
label var discwt                   "Weight to ED Visits in AHA universe"
label var disp_ed                  "Disposition of patient (uniform) from ED"
label var dqtr                     "Discharge quarter"
label var dx1                      "Diagnosis 1"
label var dx2                      "Diagnosis 2"
label var dx3                      "Diagnosis 3"
label var dx4                      "Diagnosis 4"
label var dx5                      "Diagnosis 5"
label var dx6                      "Diagnosis 6"
label var dx7                      "Diagnosis 7"
label var dx8                      "Diagnosis 8"
label var dx9                      "Diagnosis 9"
label var dx10                     "Diagnosis 10"
label var dx11                     "Diagnosis 11"
label var dx12                     "Diagnosis 12"
label var dx13                     "Diagnosis 13"
label var dx14                     "Diagnosis 14"
label var dx15                     "Diagnosis 15"
label var dxccs1                   "CCS: diagnosis 1"
label var dxccs2                   "CCS: diagnosis 2"
label var dxccs3                   "CCS: diagnosis 3"
label var dxccs4                   "CCS: diagnosis 4"
label var dxccs5                   "CCS: diagnosis 5"
label var dxccs6                   "CCS: diagnosis 6"
label var dxccs7                   "CCS: diagnosis 7"
label var dxccs8                   "CCS: diagnosis 8"
label var dxccs9                   "CCS: diagnosis 9"
label var dxccs10                  "CCS: diagnosis 10"
label var dxccs11                  "CCS: diagnosis 11"
label var dxccs12                  "CCS: diagnosis 12"
label var dxccs13                  "CCS: diagnosis 13"
label var dxccs14                  "CCS: diagnosis 14"
label var dxccs15                  "CCS: diagnosis 15"
label var ecode1                   "E code 1"
label var ecode2                   "E code 2"
label var ecode3                   "E code 3"
label var ecode4                   "E code 4"
label var edevent                  "Type of ED Event"
label var e_ccs1                   "CCS: E Code 1"
label var e_ccs2                   "CCS: E Code 2"
label var e_ccs3                   "CCS: E Code 3"
label var e_ccs4                   "CCS: E Code 4"
label var female                   "Indicator of sex"
label var hcupfile                 "Source of HCUP Record (SID or SEDD)"
label var hosp_ed                  "HCUP ED hospital identifier"
label var region                   "Region of hospital"
label var intent_s                 "Intentional self harm indicated on the record (by diagnosis and/or E codes)"
label var key_ed                   "HCUP NEDS record identifier"
label var ndx                      "Number of diagnoses on this record"
label var necode                   "Number of E codes on this record"
label var neds_str                 "Stratum used to sample hospital"
label var pay1                     "Primary expected payer (uniform)"
label var pay2                     "Secondary expected payer (uniform)"
label var pl_nchs2                 "Patient Location: NCHS Urban-Rural Code (V2006)"
label var totchged                 "Total charge for ED services"
label var year                     "Calendar year"
label var zipinc_q                 "Median household income national quartile for patient ZIP Code"

*** Convert special values to missing values ***
recode age                       (-99 -88 -66=.)
recode amonth                    (-9 -8 -6 -5=.)
recode aweekend                  (-9 -8 -6 -5=.)
recode chron1                    (-99 -88 -66=.)
recode chron2                    (-99 -88 -66=.)
recode chron3                    (-99 -88 -66=.)
recode chron4                    (-99 -88 -66=.)
recode chron5                    (-99 -88 -66=.)
recode chron6                    (-99 -88 -66=.)
recode chron7                    (-99 -88 -66=.)
recode chron8                    (-99 -88 -66=.)
recode chron9                    (-99 -88 -66=.)
recode chron10                   (-99 -88 -66=.)
recode chron11                   (-99 -88 -66=.)
recode chron12                   (-99 -88 -66=.)
recode chron13                   (-99 -88 -66=.)
recode chron14                   (-99 -88 -66=.)
recode chron15                   (-99 -88 -66=.)
recode died_vis                  (-9 -8 -6 -5=.)
recode discwt                    (-999.9999999 -888.8888888 -666.6666666=.)
recode disp_ed                   (-9 -8 -6 -5=.)
recode dqtr                      (-9 -8 -6 -5=.)
recode dxccs1                    (-999 -888 -666=.)
recode dxccs2                    (-999 -888 -666=.)
recode dxccs3                    (-999 -888 -666=.)
recode dxccs4                    (-999 -888 -666=.)
recode dxccs5                    (-999 -888 -666=.)
recode dxccs6                    (-999 -888 -666=.)
recode dxccs7                    (-999 -888 -666=.)
recode dxccs8                    (-999 -888 -666=.)
recode dxccs9                    (-999 -888 -666=.)
recode dxccs10                   (-999 -888 -666=.)
recode dxccs11                   (-999 -888 -666=.)
recode dxccs12                   (-999 -888 -666=.)
recode dxccs13                   (-999 -888 -666=.)
recode dxccs14                   (-999 -888 -666=.)
recode dxccs15                   (-999 -888 -666=.)
recode edevent                   (-9 -8 -6 -5=.)
recode e_ccs1                    (-999 -888 -666=.)
recode e_ccs2                    (-999 -888 -666=.)
recode e_ccs3                    (-999 -888 -666=.)
recode e_ccs4                    (-999 -888 -666=.)
recode female                    (-9 -8 -6 -5=.)
recode hosp_ed                   (-9999 -8888 -6666=.)
recode region                    (-9 -8 -6 -5=.)
recode intent_s                  (-9 -8 -6 -5=.)
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.)
recode ndx                       (-99 -88 -66=.)
recode necode                    (-99 -88 -66=.)
recode neds_str                  (-9999 -8888 -6666=.)
recode pay1                      (-9 -8 -6 -5=.)
recode pay2                      (-9 -8 -6 -5=.)
recode pl_nchs2                  (-99 -88 -66=.)
recode totchged                  (-99999999.99 -88888888.88 -66666666.66=.)
recode year                      (-999 -888 -666=.)
recode zipinc_q                  (-9 -8 -6 -5=.)

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_vis

save "NEDS_2007_Core_trim.dta", replace

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 19

drop if age < 10

save "tg_2007.dta", replace

clear

/*****************************************************************************
 * Stataload_NEDS_2008_Core.Do
 * This program will load the 2008 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * or use "in" option after "using NEDS_2008_Core.csv" to read a subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_vis
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   region
      byte   intent_s
      double key_ed
      int    ndx
      int    necode
      long   neds_str
      byte   pay1
      byte   pay2
      int    pl_nchs2
      double totchged
      int    year
      byte   zipinc_q
using NEDS_2008_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_vis                 "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var region                   "Region of hospital" ;
label var intent_s                 "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_str                 "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs2                 "Patient Location: NCHS Urban-Rural Code (V2006)" ;
label var totchged                 "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_q                 "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_vis                  (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-999 -888 -666=.) ;
recode dxccs2                    (-999 -888 -666=.) ;
recode dxccs3                    (-999 -888 -666=.) ;
recode dxccs4                    (-999 -888 -666=.) ;
recode dxccs5                    (-999 -888 -666=.) ;
recode dxccs6                    (-999 -888 -666=.) ;
recode dxccs7                    (-999 -888 -666=.) ;
recode dxccs8                    (-999 -888 -666=.) ;
recode dxccs9                    (-999 -888 -666=.) ;
recode dxccs10                   (-999 -888 -666=.) ;
recode dxccs11                   (-999 -888 -666=.) ;
recode dxccs12                   (-999 -888 -666=.) ;
recode dxccs13                   (-999 -888 -666=.) ;
recode dxccs14                   (-999 -888 -666=.) ;
recode dxccs15                   (-999 -888 -666=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode region                    (-9 -8 -6 -5=.) ;
recode intent_s                  (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_str                  (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs2                  (-99 -88 -66=.) ;
recode totchged                  (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_q                  (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_vis;

save "NEDS_2008_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2008.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2009_Core.Do
 * This program will load the 2009 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2009_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   hosp_region
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs2006
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2009_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var hosp_region              "Region of hospital" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs2006              "Patient Location: NCHS Urban-Rural Code (V2006)" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode hosp_region               (-9 -8 -6 -5=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs2006               (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2009_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2009.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2010_Core.Do
 * This program will load the 2010 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2010_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   hosp_region
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs2006
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2010_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var hosp_region              "Region of hospital" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs2006              "Patient Location: NCHS Urban-Rural Code (V2006)" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode hosp_region               (-9 -8 -6 -5=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs2006               (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2010_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2010.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2011_Core.Do
 * This program will load the 2011 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2011_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs2006
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2011_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs2006              "Patient Location: NCHS Urban-Rural Code (V2006)" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs2006               (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2011_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2011.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2012_Core.Do
 * This program will load the 2012 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2012_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs2006
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2012_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs2006              "Patient Location: NCHS Urban-Rural Code (V2006)" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs2006               (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2012_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2012.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2013_Core.Do
 * This program will load the 2013 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2013_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2013_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs                  "Patient Location: NCHS Urban-Rural Code" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs                   (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2013_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2013.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2014_Core.Do
 * This program will load the 2014 NEDS CSV Core File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2014_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      int    chron16
      int    chron17
      int    chron18
      int    chron19
      int    chron20
      int    chron21
      int    chron22
      int    chron23
      int    chron24
      int    chron25
      int    chron26
      int    chron27
      int    chron28
      int    chron29
      int    chron30
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      str5   dx1
      str5   dx2
      str5   dx3
      str5   dx4
      str5   dx5
      str5   dx6
      str5   dx7
      str5   dx8
      str5   dx9
      str5   dx10
      str5   dx11
      str5   dx12
      str5   dx13
      str5   dx14
      str5   dx15
      str5   dx16
      str5   dx17
      str5   dx18
      str5   dx19
      str5   dx20
      str5   dx21
      str5   dx22
      str5   dx23
      str5   dx24
      str5   dx25
      str5   dx26
      str5   dx27
      str5   dx28
      str5   dx29
      str5   dx30
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      int    dxccs16
      int    dxccs17
      int    dxccs18
      int    dxccs19
      int    dxccs20
      int    dxccs21
      int    dxccs22
      int    dxccs23
      int    dxccs24
      int    dxccs25
      int    dxccs26
      int    dxccs27
      int    dxccs28
      int    dxccs29
      int    dxccs30
      str5   ecode1
      str5   ecode2
      str5   ecode3
      str5   ecode4
      byte   edevent
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      byte   female
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ndx
      int    necode
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2014_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var chron16                  "Chronic condition indicator 16" ;
label var chron17                  "Chronic condition indicator 17" ;
label var chron18                  "Chronic condition indicator 18" ;
label var chron19                  "Chronic condition indicator 19" ;
label var chron20                  "Chronic condition indicator 20" ;
label var chron21                  "Chronic condition indicator 21" ;
label var chron22                  "Chronic condition indicator 22" ;
label var chron23                  "Chronic condition indicator 23" ;
label var chron24                  "Chronic condition indicator 24" ;
label var chron25                  "Chronic condition indicator 25" ;
label var chron26                  "Chronic condition indicator 26" ;
label var chron27                  "Chronic condition indicator 27" ;
label var chron28                  "Chronic condition indicator 28" ;
label var chron29                  "Chronic condition indicator 29" ;
label var chron30                  "Chronic condition indicator 30" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dx16                     "Diagnosis 16" ;
label var dx17                     "Diagnosis 17" ;
label var dx18                     "Diagnosis 18" ;
label var dx19                     "Diagnosis 19" ;
label var dx20                     "Diagnosis 20" ;
label var dx21                     "Diagnosis 21" ;
label var dx22                     "Diagnosis 22" ;
label var dx23                     "Diagnosis 23" ;
label var dx24                     "Diagnosis 24" ;
label var dx25                     "Diagnosis 25" ;
label var dx26                     "Diagnosis 26" ;
label var dx27                     "Diagnosis 27" ;
label var dx28                     "Diagnosis 28" ;
label var dx29                     "Diagnosis 29" ;
label var dx30                     "Diagnosis 30" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var dxccs16                  "CCS: diagnosis 16" ;
label var dxccs17                  "CCS: diagnosis 17" ;
label var dxccs18                  "CCS: diagnosis 18" ;
label var dxccs19                  "CCS: diagnosis 19" ;
label var dxccs20                  "CCS: diagnosis 20" ;
label var dxccs21                  "CCS: diagnosis 21" ;
label var dxccs22                  "CCS: diagnosis 22" ;
label var dxccs23                  "CCS: diagnosis 23" ;
label var dxccs24                  "CCS: diagnosis 24" ;
label var dxccs25                  "CCS: diagnosis 25" ;
label var dxccs26                  "CCS: diagnosis 26" ;
label var dxccs27                  "CCS: diagnosis 27" ;
label var dxccs28                  "CCS: diagnosis 28" ;
label var dxccs29                  "CCS: diagnosis 29" ;
label var dxccs30                  "CCS: diagnosis 30" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var edevent                  "Type of ED Event" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs                  "Patient Location: NCHS Urban-Rural Code" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode chron16                   (-99 -88 -66=.) ;
recode chron17                   (-99 -88 -66=.) ;
recode chron18                   (-99 -88 -66=.) ;
recode chron19                   (-99 -88 -66=.) ;
recode chron20                   (-99 -88 -66=.) ;
recode chron21                   (-99 -88 -66=.) ;
recode chron22                   (-99 -88 -66=.) ;
recode chron23                   (-99 -88 -66=.) ;
recode chron24                   (-99 -88 -66=.) ;
recode chron25                   (-99 -88 -66=.) ;
recode chron26                   (-99 -88 -66=.) ;
recode chron27                   (-99 -88 -66=.) ;
recode chron28                   (-99 -88 -66=.) ;
recode chron29                   (-99 -88 -66=.) ;
recode chron30                   (-99 -88 -66=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxccs1                    (-99 -88 -66=.) ;
recode dxccs2                    (-99 -88 -66=.) ;
recode dxccs3                    (-99 -88 -66=.) ;
recode dxccs4                    (-99 -88 -66=.) ;
recode dxccs5                    (-99 -88 -66=.) ;
recode dxccs6                    (-99 -88 -66=.) ;
recode dxccs7                    (-99 -88 -66=.) ;
recode dxccs8                    (-99 -88 -66=.) ;
recode dxccs9                    (-99 -88 -66=.) ;
recode dxccs10                   (-99 -88 -66=.) ;
recode dxccs11                   (-99 -88 -66=.) ;
recode dxccs12                   (-99 -88 -66=.) ;
recode dxccs13                   (-99 -88 -66=.) ;
recode dxccs14                   (-99 -88 -66=.) ;
recode dxccs15                   (-99 -88 -66=.) ;
recode dxccs16                   (-99 -88 -66=.) ;
recode dxccs17                   (-99 -88 -66=.) ;
recode dxccs18                   (-99 -88 -66=.) ;
recode dxccs19                   (-99 -88 -66=.) ;
recode dxccs20                   (-99 -88 -66=.) ;
recode dxccs21                   (-99 -88 -66=.) ;
recode dxccs22                   (-99 -88 -66=.) ;
recode dxccs23                   (-99 -88 -66=.) ;
recode dxccs24                   (-99 -88 -66=.) ;
recode dxccs25                   (-99 -88 -66=.) ;
recode dxccs26                   (-99 -88 -66=.) ;
recode dxccs27                   (-99 -88 -66=.) ;
recode dxccs28                   (-99 -88 -66=.) ;
recode dxccs29                   (-99 -88 -66=.) ;
recode dxccs30                   (-99 -88 -66=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs                   (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

keep age amonth discwt ecode1 ecode2 ecode3 ecode4 female hosp_ed key_ed neds_str died_visit;

save "NEDS_2014_Core_trim.dta", replace;

drop if missing(amonth);

drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

save "tg_2014.dta", replace;

#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2015_Core.Do
 * This program will load the NEDS 2015 Core csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2015_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      byte   edevent
      byte   female
      str4   hcupfile
      long   hosp_ed
      double key_ed
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2015_CORE.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var edevent                  "Type of ED Event" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs                  "Patient Location: NCHS Urban-Rural Code" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs                   (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

drop if missing(amonth);

save "NEDS_2015_Core.dta", replace;
#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2015Q1Q3_IP.Do
 * This program will load the NEDS 2015 Q1Q3 IP csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2015Q1Q3_IP.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      int    chron16
      int    chron17
      int    chron18
      int    chron19
      int    chron20
      int    chron21
      int    chron22
      int    chron23
      int    chron24
      int    chron25
      int    chron26
      int    chron27
      int    chron28
      int    chron29
      int    chron30
      byte   disp_ip
      int    drg
      byte   drgver
      int    drg_nopoa
      str7   dx1
      str7   dx2
      str7   dx3
      str7   dx4
      str7   dx5
      str7   dx6
      str7   dx7
      str7   dx8
      str7   dx9
      str7   dx10
      str7   dx11
      str7   dx12
      str7   dx13
      str7   dx14
      str7   dx15
      str7   dx16
      str7   dx17
      str7   dx18
      str7   dx19
      str7   dx20
      str7   dx21
      str7   dx22
      str7   dx23
      str7   dx24
      str7   dx25
      str7   dx26
      str7   dx27
      str7   dx28
      str7   dx29
      str7   dx30
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      int    dxccs16
      int    dxccs17
      int    dxccs18
      int    dxccs19
      int    dxccs20
      int    dxccs21
      int    dxccs22
      int    dxccs23
      int    dxccs24
      int    dxccs25
      int    dxccs26
      int    dxccs27
      int    dxccs28
      int    dxccs29
      int    dxccs30
      byte   dxver
      str7   ecode1
      str7   ecode2
      str7   ecode3
      str7   ecode4
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      long   los_ip
      byte   mdc
      byte   mdc_nopoa
      byte   multinjury
      int    ndx
      int    necode
      int    npr_ip
      int    pclass_ip1
      int    pclass_ip2
      int    pclass_ip3
      int    pclass_ip4
      int    pclass_ip5
      int    pclass_ip6
      int    pclass_ip7
      int    pclass_ip8
      int    pclass_ip9
      int    prccs_ip1
      int    prccs_ip2
      int    prccs_ip3
      int    prccs_ip4
      int    prccs_ip5
      int    prccs_ip6
      int    prccs_ip7
      int    prccs_ip8
      int    prccs_ip9
      byte   prver
      str7   pr_ip1
      str7   pr_ip2
      str7   pr_ip3
      str7   pr_ip4
      str7   pr_ip5
      str7   pr_ip6
      str7   pr_ip7
      str7   pr_ip8
      str7   pr_ip9
      double totchg_ip
using NEDS_2015Q1Q3_IP.csv;

/*  Assign labels to the data elements */
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var chron16                  "Chronic condition indicator 16" ;
label var chron17                  "Chronic condition indicator 17" ;
label var chron18                  "Chronic condition indicator 18" ;
label var chron19                  "Chronic condition indicator 19" ;
label var chron20                  "Chronic condition indicator 20" ;
label var chron21                  "Chronic condition indicator 21" ;
label var chron22                  "Chronic condition indicator 22" ;
label var chron23                  "Chronic condition indicator 23" ;
label var chron24                  "Chronic condition indicator 24" ;
label var chron25                  "Chronic condition indicator 25" ;
label var chron26                  "Chronic condition indicator 26" ;
label var chron27                  "Chronic condition indicator 27" ;
label var chron28                  "Chronic condition indicator 28" ;
label var chron29                  "Chronic condition indicator 29" ;
label var chron30                  "Chronic condition indicator 30" ;
label var disp_ip                  "Disposition of patient (uniform) from IP" ;
label var drg                      "DRG in effect on discharge date" ;
label var drgver                   "DRG grouper version used on discharge date" ;
label var drg_nopoa                "DRG in use on discharge date, calculated without POA" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dx16                     "Diagnosis 16" ;
label var dx17                     "Diagnosis 17" ;
label var dx18                     "Diagnosis 18" ;
label var dx19                     "Diagnosis 19" ;
label var dx20                     "Diagnosis 20" ;
label var dx21                     "Diagnosis 21" ;
label var dx22                     "Diagnosis 22" ;
label var dx23                     "Diagnosis 23" ;
label var dx24                     "Diagnosis 24" ;
label var dx25                     "Diagnosis 25" ;
label var dx26                     "Diagnosis 26" ;
label var dx27                     "Diagnosis 27" ;
label var dx28                     "Diagnosis 28" ;
label var dx29                     "Diagnosis 29" ;
label var dx30                     "Diagnosis 30" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var dxccs16                  "CCS: diagnosis 16" ;
label var dxccs17                  "CCS: diagnosis 17" ;
label var dxccs18                  "CCS: diagnosis 18" ;
label var dxccs19                  "CCS: diagnosis 19" ;
label var dxccs20                  "CCS: diagnosis 20" ;
label var dxccs21                  "CCS: diagnosis 21" ;
label var dxccs22                  "CCS: diagnosis 22" ;
label var dxccs23                  "CCS: diagnosis 23" ;
label var dxccs24                  "CCS: diagnosis 24" ;
label var dxccs25                  "CCS: diagnosis 25" ;
label var dxccs26                  "CCS: diagnosis 26" ;
label var dxccs27                  "CCS: diagnosis 27" ;
label var dxccs28                  "CCS: diagnosis 28" ;
label var dxccs29                  "CCS: diagnosis 29" ;
label var dxccs30                  "CCS: diagnosis 30" ;
label var dxver                    "Diagnosis Version" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var los_ip                   "Length of stay (cleaned) from IP" ;
label var mdc                      "MDC in effect on discharge date" ;
label var mdc_nopoa                "MDC in use on discharge date, calculated without POA" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;
label var npr_ip                   "Number of procedures from inpatient discharge record" ;
label var pclass_ip1               "Principal procedure class for inpatient procedure" ;
label var pclass_ip2               "Procedure class 2 for inpatient procedure" ;
label var pclass_ip3               "Procedure class 3 for inpatient procedure" ;
label var pclass_ip4               "Procedure class 4 for inpatient procedure" ;
label var pclass_ip5               "Procedure class 5 for inpatient procedure" ;
label var pclass_ip6               "Procedure class 6 for inpatient procedure" ;
label var pclass_ip7               "Procedure class 7 for inpatient procedure" ;
label var pclass_ip8               "Procedure class 8 for inpatient procedure" ;
label var pclass_ip9               "Procedure class 9 for inpatient procedure" ;
label var prccs_ip1                "CCS: principal procedure from inpatient discharge record" ;
label var prccs_ip2                "CCS: procedure 2 from inpatient discharge record" ;
label var prccs_ip3                "CCS: procedure 3 from inpatient discharge record" ;
label var prccs_ip4                "CCS: procedure 4 from inpatient discharge record" ;
label var prccs_ip5                "CCS: procedure 5 from inpatient discharge record" ;
label var prccs_ip6                "CCS: procedure 6 from inpatient discharge record" ;
label var prccs_ip7                "CCS: procedure 7 from inpatient discharge record" ;
label var prccs_ip8                "CCS: procedure 8 from inpatient discharge record" ;
label var prccs_ip9                "CCS: procedure 9 from inpatient discharge record" ;
label var prver                    "Procedure Version" ;
label var pr_ip1                   "Principal procedure from inpatient discharge record" ;
label var pr_ip2                   "Procedure 2 from inpatient discharge record" ;
label var pr_ip3                   "Procedure 3 from inpatient discharge record" ;
label var pr_ip4                   "Procedure 4 from inpatient discharge record" ;
label var pr_ip5                   "Procedure 5 from inpatient discharge record" ;
label var pr_ip6                   "Procedure 6 from inpatient discharge record" ;
label var pr_ip7                   "Procedure 7 from inpatient discharge record" ;
label var pr_ip8                   "Procedure 8 from inpatient discharge record" ;
label var pr_ip9                   "Procedure 9 from inpatient discharge record" ;
label var totchg_ip                "Total charge for ED and inpatient services" ;

/* Convert special values to missing values */
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode chron16                   (-99 -88 -66=.) ;
recode chron17                   (-99 -88 -66=.) ;
recode chron18                   (-99 -88 -66=.) ;
recode chron19                   (-99 -88 -66=.) ;
recode chron20                   (-99 -88 -66=.) ;
recode chron21                   (-99 -88 -66=.) ;
recode chron22                   (-99 -88 -66=.) ;
recode chron23                   (-99 -88 -66=.) ;
recode chron24                   (-99 -88 -66=.) ;
recode chron25                   (-99 -88 -66=.) ;
recode chron26                   (-99 -88 -66=.) ;
recode chron27                   (-99 -88 -66=.) ;
recode chron28                   (-99 -88 -66=.) ;
recode chron29                   (-99 -88 -66=.) ;
recode chron30                   (-99 -88 -66=.) ;
recode disp_ip                   (-9 -8 -6 -5=.) ;
recode drg                       (-99 -88 -66=.) ;
recode drgver                    (-9 -8 -6 -5=.) ;
recode drg_nopoa                 (-99 -88 -66=.) ;
recode dxccs1                    (-999 -888 -666=.) ;
recode dxccs2                    (-999 -888 -666=.) ;
recode dxccs3                    (-999 -888 -666=.) ;
recode dxccs4                    (-999 -888 -666=.) ;
recode dxccs5                    (-999 -888 -666=.) ;
recode dxccs6                    (-999 -888 -666=.) ;
recode dxccs7                    (-999 -888 -666=.) ;
recode dxccs8                    (-999 -888 -666=.) ;
recode dxccs9                    (-999 -888 -666=.) ;
recode dxccs10                   (-999 -888 -666=.) ;
recode dxccs11                   (-999 -888 -666=.) ;
recode dxccs12                   (-999 -888 -666=.) ;
recode dxccs13                   (-999 -888 -666=.) ;
recode dxccs14                   (-999 -888 -666=.) ;
recode dxccs15                   (-999 -888 -666=.) ;
recode dxccs16                   (-999 -888 -666=.) ;
recode dxccs17                   (-999 -888 -666=.) ;
recode dxccs18                   (-999 -888 -666=.) ;
recode dxccs19                   (-999 -888 -666=.) ;
recode dxccs20                   (-999 -888 -666=.) ;
recode dxccs21                   (-999 -888 -666=.) ;
recode dxccs22                   (-999 -888 -666=.) ;
recode dxccs23                   (-999 -888 -666=.) ;
recode dxccs24                   (-999 -888 -666=.) ;
recode dxccs25                   (-999 -888 -666=.) ;
recode dxccs26                   (-999 -888 -666=.) ;
recode dxccs27                   (-999 -888 -666=.) ;
recode dxccs28                   (-999 -888 -666=.) ;
recode dxccs29                   (-999 -888 -666=.) ;
recode dxccs30                   (-999 -888 -666=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode los_ip                    (-9999 -8888 -6666=.) ;
recode mdc                       (-9 -8 -6 -5=.) ;
recode mdc_nopoa                 (-9 -8 -6 -5=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;
recode npr_ip                    (-99 -88 -66=.) ;
recode pclass_ip1                (-99 -88 -66=.) ;
recode pclass_ip2                (-99 -88 -66=.) ;
recode pclass_ip3                (-99 -88 -66=.) ;
recode pclass_ip4                (-99 -88 -66=.) ;
recode pclass_ip5                (-99 -88 -66=.) ;
recode pclass_ip6                (-99 -88 -66=.) ;
recode pclass_ip7                (-99 -88 -66=.) ;
recode pclass_ip8                (-99 -88 -66=.) ;
recode pclass_ip9                (-99 -88 -66=.) ;
recode prccs_ip1                 (-99 -88 -66=.) ;
recode prccs_ip2                 (-99 -88 -66=.) ;
recode prccs_ip3                 (-99 -88 -66=.) ;
recode prccs_ip4                 (-99 -88 -66=.) ;
recode prccs_ip5                 (-99 -88 -66=.) ;
recode prccs_ip6                 (-99 -88 -66=.) ;
recode prccs_ip7                 (-99 -88 -66=.) ;
recode prccs_ip8                 (-99 -88 -66=.) ;
recode prccs_ip9                 (-99 -88 -66=.) ;
recode prver                     (-9 -8 -6 -5=.) ;
recode totchg_ip                 (-99999999.99 -88888888.88 -66666666.66=.) ;

describe;

save "NEDS_2015Q1Q3_IP.dta", replace;
#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2015Q1Q3_ED.Do
 * This program will load the NEDS 2015 Q1Q3 ED csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2015Q1Q3_ED.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    chron1
      int    chron2
      int    chron3
      int    chron4
      int    chron5
      int    chron6
      int    chron7
      int    chron8
      int    chron9
      int    chron10
      int    chron11
      int    chron12
      int    chron13
      int    chron14
      int    chron15
      int    chron16
      int    chron17
      int    chron18
      int    chron19
      int    chron20
      int    chron21
      int    chron22
      int    chron23
      int    chron24
      int    chron25
      int    chron26
      int    chron27
      int    chron28
      int    chron29
      int    chron30
      str5   cpt1
      str5   cpt2
      str5   cpt3
      str5   cpt4
      str5   cpt5
      str5   cpt6
      str5   cpt7
      str5   cpt8
      str5   cpt9
      str5   cpt10
      str5   cpt11
      str5   cpt12
      str5   cpt13
      str5   cpt14
      str5   cpt15
      int    cptccs1
      int    cptccs2
      int    cptccs3
      int    cptccs4
      int    cptccs5
      int    cptccs6
      int    cptccs7
      int    cptccs8
      int    cptccs9
      int    cptccs10
      int    cptccs11
      int    cptccs12
      int    cptccs13
      int    cptccs14
      int    cptccs15
      str7   dx1
      str7   dx2
      str7   dx3
      str7   dx4
      str7   dx5
      str7   dx6
      str7   dx7
      str7   dx8
      str7   dx9
      str7   dx10
      str7   dx11
      str7   dx12
      str7   dx13
      str7   dx14
      str7   dx15
      str7   dx16
      str7   dx17
      str7   dx18
      str7   dx19
      str7   dx20
      str7   dx21
      str7   dx22
      str7   dx23
      str7   dx24
      str7   dx25
      str7   dx26
      str7   dx27
      str7   dx28
      str7   dx29
      str7   dx30
      int    dxccs1
      int    dxccs2
      int    dxccs3
      int    dxccs4
      int    dxccs5
      int    dxccs6
      int    dxccs7
      int    dxccs8
      int    dxccs9
      int    dxccs10
      int    dxccs11
      int    dxccs12
      int    dxccs13
      int    dxccs14
      int    dxccs15
      int    dxccs16
      int    dxccs17
      int    dxccs18
      int    dxccs19
      int    dxccs20
      int    dxccs21
      int    dxccs22
      int    dxccs23
      int    dxccs24
      int    dxccs25
      int    dxccs26
      int    dxccs27
      int    dxccs28
      int    dxccs29
      int    dxccs30
      byte   dxver
      str7   ecode1
      str7   ecode2
      str7   ecode3
      str7   ecode4
      int    e_ccs1
      int    e_ccs2
      int    e_ccs3
      int    e_ccs4
      str4   hcupfile
      long   hosp_ed
      byte   injury
      byte   injury_cut
      byte   injury_drown
      byte   injury_fall
      byte   injury_fire
      byte   injury_firearm
      byte   injury_machinery
      byte   injury_mvt
      byte   injury_nature
      byte   injury_poison
      byte   injury_severity
      byte   injury_struck
      byte   injury_suffocation
      byte   intent_assault
      byte   intent_self_harm
      byte   intent_unintentional
      double key_ed
      byte   multinjury
      int    ncpt
      int    ndx
      int    necode
using NEDS_2015Q1Q3_ED.csv;

/*  Assign labels to the data elements */
label var chron1                   "Chronic condition indicator 1" ;
label var chron2                   "Chronic condition indicator 2" ;
label var chron3                   "Chronic condition indicator 3" ;
label var chron4                   "Chronic condition indicator 4" ;
label var chron5                   "Chronic condition indicator 5" ;
label var chron6                   "Chronic condition indicator 6" ;
label var chron7                   "Chronic condition indicator 7" ;
label var chron8                   "Chronic condition indicator 8" ;
label var chron9                   "Chronic condition indicator 9" ;
label var chron10                  "Chronic condition indicator 10" ;
label var chron11                  "Chronic condition indicator 11" ;
label var chron12                  "Chronic condition indicator 12" ;
label var chron13                  "Chronic condition indicator 13" ;
label var chron14                  "Chronic condition indicator 14" ;
label var chron15                  "Chronic condition indicator 15" ;
label var chron16                  "Chronic condition indicator 16" ;
label var chron17                  "Chronic condition indicator 17" ;
label var chron18                  "Chronic condition indicator 18" ;
label var chron19                  "Chronic condition indicator 19" ;
label var chron20                  "Chronic condition indicator 20" ;
label var chron21                  "Chronic condition indicator 21" ;
label var chron22                  "Chronic condition indicator 22" ;
label var chron23                  "Chronic condition indicator 23" ;
label var chron24                  "Chronic condition indicator 24" ;
label var chron25                  "Chronic condition indicator 25" ;
label var chron26                  "Chronic condition indicator 26" ;
label var chron27                  "Chronic condition indicator 27" ;
label var chron28                  "Chronic condition indicator 28" ;
label var chron29                  "Chronic condition indicator 29" ;
label var chron30                  "Chronic condition indicator 30" ;
label var cpt1                     "CPT/HCPCS procedure code 1" ;
label var cpt2                     "CPT/HCPCS procedure code 2" ;
label var cpt3                     "CPT/HCPCS procedure code 3" ;
label var cpt4                     "CPT/HCPCS procedure code 4" ;
label var cpt5                     "CPT/HCPCS procedure code 5" ;
label var cpt6                     "CPT/HCPCS procedure code 6" ;
label var cpt7                     "CPT/HCPCS procedure code 7" ;
label var cpt8                     "CPT/HCPCS procedure code 8" ;
label var cpt9                     "CPT/HCPCS procedure code 9" ;
label var cpt10                    "CPT/HCPCS procedure code 10" ;
label var cpt11                    "CPT/HCPCS procedure code 11" ;
label var cpt12                    "CPT/HCPCS procedure code 12" ;
label var cpt13                    "CPT/HCPCS procedure code 13" ;
label var cpt14                    "CPT/HCPCS procedure code 14" ;
label var cpt15                    "CPT/HCPCS procedure code 15" ;
label var cptccs1                  "CCS: CPT 1" ;
label var cptccs2                  "CCS: CPT 2" ;
label var cptccs3                  "CCS: CPT 3" ;
label var cptccs4                  "CCS: CPT 4" ;
label var cptccs5                  "CCS: CPT 5" ;
label var cptccs6                  "CCS: CPT 6" ;
label var cptccs7                  "CCS: CPT 7" ;
label var cptccs8                  "CCS: CPT 8" ;
label var cptccs9                  "CCS: CPT 9" ;
label var cptccs10                 "CCS: CPT 10" ;
label var cptccs11                 "CCS: CPT 11" ;
label var cptccs12                 "CCS: CPT 12" ;
label var cptccs13                 "CCS: CPT 13" ;
label var cptccs14                 "CCS: CPT 14" ;
label var cptccs15                 "CCS: CPT 15" ;
label var dx1                      "Diagnosis 1" ;
label var dx2                      "Diagnosis 2" ;
label var dx3                      "Diagnosis 3" ;
label var dx4                      "Diagnosis 4" ;
label var dx5                      "Diagnosis 5" ;
label var dx6                      "Diagnosis 6" ;
label var dx7                      "Diagnosis 7" ;
label var dx8                      "Diagnosis 8" ;
label var dx9                      "Diagnosis 9" ;
label var dx10                     "Diagnosis 10" ;
label var dx11                     "Diagnosis 11" ;
label var dx12                     "Diagnosis 12" ;
label var dx13                     "Diagnosis 13" ;
label var dx14                     "Diagnosis 14" ;
label var dx15                     "Diagnosis 15" ;
label var dx16                     "Diagnosis 16" ;
label var dx17                     "Diagnosis 17" ;
label var dx18                     "Diagnosis 18" ;
label var dx19                     "Diagnosis 19" ;
label var dx20                     "Diagnosis 20" ;
label var dx21                     "Diagnosis 21" ;
label var dx22                     "Diagnosis 22" ;
label var dx23                     "Diagnosis 23" ;
label var dx24                     "Diagnosis 24" ;
label var dx25                     "Diagnosis 25" ;
label var dx26                     "Diagnosis 26" ;
label var dx27                     "Diagnosis 27" ;
label var dx28                     "Diagnosis 28" ;
label var dx29                     "Diagnosis 29" ;
label var dx30                     "Diagnosis 30" ;
label var dxccs1                   "CCS: diagnosis 1" ;
label var dxccs2                   "CCS: diagnosis 2" ;
label var dxccs3                   "CCS: diagnosis 3" ;
label var dxccs4                   "CCS: diagnosis 4" ;
label var dxccs5                   "CCS: diagnosis 5" ;
label var dxccs6                   "CCS: diagnosis 6" ;
label var dxccs7                   "CCS: diagnosis 7" ;
label var dxccs8                   "CCS: diagnosis 8" ;
label var dxccs9                   "CCS: diagnosis 9" ;
label var dxccs10                  "CCS: diagnosis 10" ;
label var dxccs11                  "CCS: diagnosis 11" ;
label var dxccs12                  "CCS: diagnosis 12" ;
label var dxccs13                  "CCS: diagnosis 13" ;
label var dxccs14                  "CCS: diagnosis 14" ;
label var dxccs15                  "CCS: diagnosis 15" ;
label var dxccs16                  "CCS: diagnosis 16" ;
label var dxccs17                  "CCS: diagnosis 17" ;
label var dxccs18                  "CCS: diagnosis 18" ;
label var dxccs19                  "CCS: diagnosis 19" ;
label var dxccs20                  "CCS: diagnosis 20" ;
label var dxccs21                  "CCS: diagnosis 21" ;
label var dxccs22                  "CCS: diagnosis 22" ;
label var dxccs23                  "CCS: diagnosis 23" ;
label var dxccs24                  "CCS: diagnosis 24" ;
label var dxccs25                  "CCS: diagnosis 25" ;
label var dxccs26                  "CCS: diagnosis 26" ;
label var dxccs27                  "CCS: diagnosis 27" ;
label var dxccs28                  "CCS: diagnosis 28" ;
label var dxccs29                  "CCS: diagnosis 29" ;
label var dxccs30                  "CCS: diagnosis 30" ;
label var dxver                    "Diagnosis Version" ;
label var ecode1                   "E code 1" ;
label var ecode2                   "E code 2" ;
label var ecode3                   "E code 3" ;
label var ecode4                   "E code 4" ;
label var e_ccs1                   "CCS: E Code 1" ;
label var e_ccs2                   "CCS: E Code 2" ;
label var e_ccs3                   "CCS: E Code 3" ;
label var e_ccs4                   "CCS: E Code 4" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var injury                   "Injury diagnosis reported on record (1:DX1 is an injury; 2:DX2+ is an injury; 0:No injury)" ;
label var injury_cut               "Injury by cutting or piercing (by E codes)" ;
label var injury_drown             "Injury by drowning or submersion (by E codes)" ;
label var injury_fall              "Injury by falling (by E codes)" ;
label var injury_fire              "Injury by fire, flame or hot object (by E codes)" ;
label var injury_firearm           "Injury by firearm (by E codes)" ;
label var injury_machinery         "Injury by machinery (by E codes)" ;
label var injury_mvt               "Injury involving motor vehicle traffic (by E codes)" ;
label var injury_nature            "Injury involving nature or environmental factors (by E codes)" ;
label var injury_poison            "Injury by poison (by E codes)" ;
label var injury_severity          "Injury severity score assigned by ICDPIC Stata program" ;
label var injury_struck            "Injury from being struck by or against (by E codes)" ;
label var injury_suffocation       "Injury by suffocation (by E codes)" ;
label var intent_assault           "Injury by assault indicated on the record (by E codes)" ;
label var intent_self_harm         "Intentional self harm indicated on the record (by diagnosis and/or E codes)" ;
label var intent_unintentional     "Unintentional injury indicated on the record (by E codes)" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var multinjury               "More than one injury diagnosis reported on record" ;
label var ncpt                     "Number of CPT/HCPCS procedures for this visit" ;
label var ndx                      "Number of diagnoses on this record" ;
label var necode                   "Number of E codes on this record" ;

/* Convert special values to missing values */
recode chron1                    (-99 -88 -66=.) ;
recode chron2                    (-99 -88 -66=.) ;
recode chron3                    (-99 -88 -66=.) ;
recode chron4                    (-99 -88 -66=.) ;
recode chron5                    (-99 -88 -66=.) ;
recode chron6                    (-99 -88 -66=.) ;
recode chron7                    (-99 -88 -66=.) ;
recode chron8                    (-99 -88 -66=.) ;
recode chron9                    (-99 -88 -66=.) ;
recode chron10                   (-99 -88 -66=.) ;
recode chron11                   (-99 -88 -66=.) ;
recode chron12                   (-99 -88 -66=.) ;
recode chron13                   (-99 -88 -66=.) ;
recode chron14                   (-99 -88 -66=.) ;
recode chron15                   (-99 -88 -66=.) ;
recode chron16                   (-99 -88 -66=.) ;
recode chron17                   (-99 -88 -66=.) ;
recode chron18                   (-99 -88 -66=.) ;
recode chron19                   (-99 -88 -66=.) ;
recode chron20                   (-99 -88 -66=.) ;
recode chron21                   (-99 -88 -66=.) ;
recode chron22                   (-99 -88 -66=.) ;
recode chron23                   (-99 -88 -66=.) ;
recode chron24                   (-99 -88 -66=.) ;
recode chron25                   (-99 -88 -66=.) ;
recode chron26                   (-99 -88 -66=.) ;
recode chron27                   (-99 -88 -66=.) ;
recode chron28                   (-99 -88 -66=.) ;
recode chron29                   (-99 -88 -66=.) ;
recode chron30                   (-99 -88 -66=.) ;
recode cptccs1                   (-999 -888 -666=.) ;
recode cptccs2                   (-999 -888 -666=.) ;
recode cptccs3                   (-999 -888 -666=.) ;
recode cptccs4                   (-999 -888 -666=.) ;
recode cptccs5                   (-999 -888 -666=.) ;
recode cptccs6                   (-999 -888 -666=.) ;
recode cptccs7                   (-999 -888 -666=.) ;
recode cptccs8                   (-999 -888 -666=.) ;
recode cptccs9                   (-999 -888 -666=.) ;
recode cptccs10                  (-999 -888 -666=.) ;
recode cptccs11                  (-999 -888 -666=.) ;
recode cptccs12                  (-999 -888 -666=.) ;
recode cptccs13                  (-999 -888 -666=.) ;
recode cptccs14                  (-999 -888 -666=.) ;
recode cptccs15                  (-999 -888 -666=.) ;
recode dxccs1                    (-999 -888 -666=.) ;
recode dxccs2                    (-999 -888 -666=.) ;
recode dxccs3                    (-999 -888 -666=.) ;
recode dxccs4                    (-999 -888 -666=.) ;
recode dxccs5                    (-999 -888 -666=.) ;
recode dxccs6                    (-999 -888 -666=.) ;
recode dxccs7                    (-999 -888 -666=.) ;
recode dxccs8                    (-999 -888 -666=.) ;
recode dxccs9                    (-999 -888 -666=.) ;
recode dxccs10                   (-999 -888 -666=.) ;
recode dxccs11                   (-999 -888 -666=.) ;
recode dxccs12                   (-999 -888 -666=.) ;
recode dxccs13                   (-999 -888 -666=.) ;
recode dxccs14                   (-999 -888 -666=.) ;
recode dxccs15                   (-999 -888 -666=.) ;
recode dxccs16                   (-999 -888 -666=.) ;
recode dxccs17                   (-999 -888 -666=.) ;
recode dxccs18                   (-999 -888 -666=.) ;
recode dxccs19                   (-999 -888 -666=.) ;
recode dxccs20                   (-999 -888 -666=.) ;
recode dxccs21                   (-999 -888 -666=.) ;
recode dxccs22                   (-999 -888 -666=.) ;
recode dxccs23                   (-999 -888 -666=.) ;
recode dxccs24                   (-999 -888 -666=.) ;
recode dxccs25                   (-999 -888 -666=.) ;
recode dxccs26                   (-999 -888 -666=.) ;
recode dxccs27                   (-999 -888 -666=.) ;
recode dxccs28                   (-999 -888 -666=.) ;
recode dxccs29                   (-999 -888 -666=.) ;
recode dxccs30                   (-999 -888 -666=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode e_ccs1                    (-999 -888 -666=.) ;
recode e_ccs2                    (-999 -888 -666=.) ;
recode e_ccs3                    (-999 -888 -666=.) ;
recode e_ccs4                    (-999 -888 -666=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode injury                    (-9 -8 -6 -5=.) ;
recode injury_cut                (-9 -8 -6 -5=.) ;
recode injury_drown              (-9 -8 -6 -5=.) ;
recode injury_fall               (-9 -8 -6 -5=.) ;
recode injury_fire               (-9 -8 -6 -5=.) ;
recode injury_firearm            (-9 -8 -6 -5=.) ;
recode injury_machinery          (-9 -8 -6 -5=.) ;
recode injury_mvt                (-9 -8 -6 -5=.) ;
recode injury_nature             (-9 -8 -6 -5=.) ;
recode injury_poison             (-9 -8 -6 -5=.) ;
recode injury_severity           (-9 -8 -6 -5=.) ;
recode injury_struck             (-9 -8 -6 -5=.) ;
recode injury_suffocation        (-9 -8 -6 -5=.) ;
recode intent_assault            (-9 -8 -6 -5=.) ;
recode intent_self_harm          (-9 -8 -6 -5=.) ;
recode intent_unintentional      (-9 -8 -6 -5=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode multinjury                (-9 -8 -6 -5=.) ;
recode ncpt                      (-999 -888 -666=.) ;
recode ndx                       (-99 -88 -66=.) ;
recode necode                    (-99 -88 -66=.) ;

describe;

save "NEDS_2015Q1Q3_ED.dta", replace;
#delimit cr

clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q1Q3_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q1Q3_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 19

drop if age < 10

keep age amonth discwt dx1 dx2 dx3 dx4 ecode1 ecode2 ecode3 ecode4 intent_self_harm died_visit key_ed injury_poison
        
save "tg_2015_q3.dta", replace
 
clear

/*****************************************************************************
 * Stataload_NEDS_2015Q4_ED.Do
 * This program will load the NEDS 2015 Q4 ED csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2015Q4_ED.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      str5   cpt1
      str5   cpt2
      str5   cpt3
      str5   cpt4
      str5   cpt5
      str5   cpt6
      str5   cpt7
      str5   cpt8
      str5   cpt9
      str5   cpt10
      str5   cpt11
      str5   cpt12
      str5   cpt13
      str5   cpt14
      str5   cpt15
      int    cptccs1
      int    cptccs2
      int    cptccs3
      int    cptccs4
      int    cptccs5
      int    cptccs6
      int    cptccs7
      int    cptccs8
      int    cptccs9
      int    cptccs10
      int    cptccs11
      int    cptccs12
      int    cptccs13
      int    cptccs14
      int    cptccs15
      byte   dxver
      str4   hcupfile
      long   hosp_ed
      str7   i10_dx1
      str7   i10_dx2
      str7   i10_dx3
      str7   i10_dx4
      str7   i10_dx5
      str7   i10_dx6
      str7   i10_dx7
      str7   i10_dx8
      str7   i10_dx9
      str7   i10_dx10
      str7   i10_dx11
      str7   i10_dx12
      str7   i10_dx13
      str7   i10_dx14
      str7   i10_dx15
      str7   i10_dx16
      str7   i10_dx17
      str7   i10_dx18
      str7   i10_dx19
      str7   i10_dx20
      str7   i10_dx21
      str7   i10_dx22
      str7   i10_dx23
      str7   i10_dx24
      str7   i10_dx25
      str7   i10_dx26
      str7   i10_dx27
      str7   i10_dx28
      str7   i10_dx29
      str7   i10_dx30
      str7   i10_ecause1
      str7   i10_ecause2
      str7   i10_ecause3
      str7   i10_ecause4
      int    i10_ndx
      int    i10_necause
      double key_ed
      int    ncpt
using NEDS_2015Q4_ED.csv;

/*  Assign labels to the data elements */
label var cpt1                     "CPT/HCPCS procedure code 1" ;
label var cpt2                     "CPT/HCPCS procedure code 2" ;
label var cpt3                     "CPT/HCPCS procedure code 3" ;
label var cpt4                     "CPT/HCPCS procedure code 4" ;
label var cpt5                     "CPT/HCPCS procedure code 5" ;
label var cpt6                     "CPT/HCPCS procedure code 6" ;
label var cpt7                     "CPT/HCPCS procedure code 7" ;
label var cpt8                     "CPT/HCPCS procedure code 8" ;
label var cpt9                     "CPT/HCPCS procedure code 9" ;
label var cpt10                    "CPT/HCPCS procedure code 10" ;
label var cpt11                    "CPT/HCPCS procedure code 11" ;
label var cpt12                    "CPT/HCPCS procedure code 12" ;
label var cpt13                    "CPT/HCPCS procedure code 13" ;
label var cpt14                    "CPT/HCPCS procedure code 14" ;
label var cpt15                    "CPT/HCPCS procedure code 15" ;
label var cptccs1                  "CCS: CPT 1" ;
label var cptccs2                  "CCS: CPT 2" ;
label var cptccs3                  "CCS: CPT 3" ;
label var cptccs4                  "CCS: CPT 4" ;
label var cptccs5                  "CCS: CPT 5" ;
label var cptccs6                  "CCS: CPT 6" ;
label var cptccs7                  "CCS: CPT 7" ;
label var cptccs8                  "CCS: CPT 8" ;
label var cptccs9                  "CCS: CPT 9" ;
label var cptccs10                 "CCS: CPT 10" ;
label var cptccs11                 "CCS: CPT 11" ;
label var cptccs12                 "CCS: CPT 12" ;
label var cptccs13                 "CCS: CPT 13" ;
label var cptccs14                 "CCS: CPT 14" ;
label var cptccs15                 "CCS: CPT 15" ;
label var dxver                    "Diagnosis Version" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var i10_dx1                  "ICD-10-CM Diagnosis 1" ;
label var i10_dx2                  "ICD-10-CM Diagnosis 2" ;
label var i10_dx3                  "ICD-10-CM Diagnosis 3" ;
label var i10_dx4                  "ICD-10-CM Diagnosis 4" ;
label var i10_dx5                  "ICD-10-CM Diagnosis 5" ;
label var i10_dx6                  "ICD-10-CM Diagnosis 6" ;
label var i10_dx7                  "ICD-10-CM Diagnosis 7" ;
label var i10_dx8                  "ICD-10-CM Diagnosis 8" ;
label var i10_dx9                  "ICD-10-CM Diagnosis 9" ;
label var i10_dx10                 "ICD-10-CM Diagnosis 10" ;
label var i10_dx11                 "ICD-10-CM Diagnosis 11" ;
label var i10_dx12                 "ICD-10-CM Diagnosis 12" ;
label var i10_dx13                 "ICD-10-CM Diagnosis 13" ;
label var i10_dx14                 "ICD-10-CM Diagnosis 14" ;
label var i10_dx15                 "ICD-10-CM Diagnosis 15" ;
label var i10_dx16                 "ICD-10-CM Diagnosis 16" ;
label var i10_dx17                 "ICD-10-CM Diagnosis 17" ;
label var i10_dx18                 "ICD-10-CM Diagnosis 18" ;
label var i10_dx19                 "ICD-10-CM Diagnosis 19" ;
label var i10_dx20                 "ICD-10-CM Diagnosis 20" ;
label var i10_dx21                 "ICD-10-CM Diagnosis 21" ;
label var i10_dx22                 "ICD-10-CM Diagnosis 22" ;
label var i10_dx23                 "ICD-10-CM Diagnosis 23" ;
label var i10_dx24                 "ICD-10-CM Diagnosis 24" ;
label var i10_dx25                 "ICD-10-CM Diagnosis 25" ;
label var i10_dx26                 "ICD-10-CM Diagnosis 26" ;
label var i10_dx27                 "ICD-10-CM Diagnosis 27" ;
label var i10_dx28                 "ICD-10-CM Diagnosis 28" ;
label var i10_dx29                 "ICD-10-CM Diagnosis 29" ;
label var i10_dx30                 "ICD-10-CM Diagnosis 30" ;
label var i10_ecause1              "ICD-10-CM External cause 1" ;
label var i10_ecause2              "ICD-10-CM External cause 2" ;
label var i10_ecause3              "ICD-10-CM External cause 3" ;
label var i10_ecause4              "ICD-10-CM External cause 4" ;
label var i10_ndx                  "ICD-10-CM Number of diagnoses on this record" ;
label var i10_necause              "ICD-10-CM Number of external cause codes on this record" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var ncpt                     "Number of CPT/HCPCS procedures for this visit" ;

/* Convert special values to missing values */
recode cptccs1                   (-999 -888 -666=.) ;
recode cptccs2                   (-999 -888 -666=.) ;
recode cptccs3                   (-999 -888 -666=.) ;
recode cptccs4                   (-999 -888 -666=.) ;
recode cptccs5                   (-999 -888 -666=.) ;
recode cptccs6                   (-999 -888 -666=.) ;
recode cptccs7                   (-999 -888 -666=.) ;
recode cptccs8                   (-999 -888 -666=.) ;
recode cptccs9                   (-999 -888 -666=.) ;
recode cptccs10                  (-999 -888 -666=.) ;
recode cptccs11                  (-999 -888 -666=.) ;
recode cptccs12                  (-999 -888 -666=.) ;
recode cptccs13                  (-999 -888 -666=.) ;
recode cptccs14                  (-999 -888 -666=.) ;
recode cptccs15                  (-999 -888 -666=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode i10_ndx                   (-99 -88 -66=.) ;
recode i10_necause               (-99 -88 -66=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode ncpt                      (-999 -888 -666=.) ;

describe;

save "NEDS_2015Q4_ED.dta", replace;
#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2015Q4_IP.Do
 * This program will load the NEDS 2015 Q4 IP csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2015Q4_IP.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      byte   disp_ip
      int    drg
      byte   drgver
      int    drg_nopoa
      byte   dxver
      str4   hcupfile
      long   hosp_ed
      str7   i10_dx1
      str7   i10_dx2
      str7   i10_dx3
      str7   i10_dx4
      str7   i10_dx5
      str7   i10_dx6
      str7   i10_dx7
      str7   i10_dx8
      str7   i10_dx9
      str7   i10_dx10
      str7   i10_dx11
      str7   i10_dx12
      str7   i10_dx13
      str7   i10_dx14
      str7   i10_dx15
      str7   i10_dx16
      str7   i10_dx17
      str7   i10_dx18
      str7   i10_dx19
      str7   i10_dx20
      str7   i10_dx21
      str7   i10_dx22
      str7   i10_dx23
      str7   i10_dx24
      str7   i10_dx25
      str7   i10_dx26
      str7   i10_dx27
      str7   i10_dx28
      str7   i10_dx29
      str7   i10_dx30
      str7   i10_ecause1
      str7   i10_ecause2
      str7   i10_ecause3
      str7   i10_ecause4
      int    i10_ndx
      int    i10_necause
      int    i10_npr_ip
      str7   i10_pr_ip1
      str7   i10_pr_ip2
      str7   i10_pr_ip3
      str7   i10_pr_ip4
      str7   i10_pr_ip5
      str7   i10_pr_ip6
      str7   i10_pr_ip7
      str7   i10_pr_ip8
      str7   i10_pr_ip9
      double key_ed
      long   los_ip
      byte   mdc
      byte   mdc_nopoa
      byte   prver
      double totchg_ip
using NEDS_2015Q4_IP.csv;

/*  Assign labels to the data elements */
label var disp_ip                  "Disposition of patient (uniform) from IP" ;
label var drg                      "DRG in effect on discharge date" ;
label var drgver                   "DRG grouper version used on discharge date" ;
label var drg_nopoa                "DRG in use on discharge date, calculated without POA" ;
label var dxver                    "Diagnosis Version" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var i10_dx1                  "ICD-10-CM Diagnosis 1" ;
label var i10_dx2                  "ICD-10-CM Diagnosis 2" ;
label var i10_dx3                  "ICD-10-CM Diagnosis 3" ;
label var i10_dx4                  "ICD-10-CM Diagnosis 4" ;
label var i10_dx5                  "ICD-10-CM Diagnosis 5" ;
label var i10_dx6                  "ICD-10-CM Diagnosis 6" ;
label var i10_dx7                  "ICD-10-CM Diagnosis 7" ;
label var i10_dx8                  "ICD-10-CM Diagnosis 8" ;
label var i10_dx9                  "ICD-10-CM Diagnosis 9" ;
label var i10_dx10                 "ICD-10-CM Diagnosis 10" ;
label var i10_dx11                 "ICD-10-CM Diagnosis 11" ;
label var i10_dx12                 "ICD-10-CM Diagnosis 12" ;
label var i10_dx13                 "ICD-10-CM Diagnosis 13" ;
label var i10_dx14                 "ICD-10-CM Diagnosis 14" ;
label var i10_dx15                 "ICD-10-CM Diagnosis 15" ;
label var i10_dx16                 "ICD-10-CM Diagnosis 16" ;
label var i10_dx17                 "ICD-10-CM Diagnosis 17" ;
label var i10_dx18                 "ICD-10-CM Diagnosis 18" ;
label var i10_dx19                 "ICD-10-CM Diagnosis 19" ;
label var i10_dx20                 "ICD-10-CM Diagnosis 20" ;
label var i10_dx21                 "ICD-10-CM Diagnosis 21" ;
label var i10_dx22                 "ICD-10-CM Diagnosis 22" ;
label var i10_dx23                 "ICD-10-CM Diagnosis 23" ;
label var i10_dx24                 "ICD-10-CM Diagnosis 24" ;
label var i10_dx25                 "ICD-10-CM Diagnosis 25" ;
label var i10_dx26                 "ICD-10-CM Diagnosis 26" ;
label var i10_dx27                 "ICD-10-CM Diagnosis 27" ;
label var i10_dx28                 "ICD-10-CM Diagnosis 28" ;
label var i10_dx29                 "ICD-10-CM Diagnosis 29" ;
label var i10_dx30                 "ICD-10-CM Diagnosis 30" ;
label var i10_ecause1              "ICD-10-CM External cause 1" ;
label var i10_ecause2              "ICD-10-CM External cause 2" ;
label var i10_ecause3              "ICD-10-CM External cause 3" ;
label var i10_ecause4              "ICD-10-CM External cause 4" ;
label var i10_ndx                  "ICD-10-CM Number of diagnoses on this record" ;
label var i10_necause              "ICD-10-CM Number of external cause codes on this record" ;
label var i10_npr_ip               "ICD-10-PCS Number of procedures on this record" ;
label var i10_pr_ip1               "ICD-10-PCS Principal procedure from inpatient discharge record" ;
label var i10_pr_ip2               "ICD-10-PCS Procedure 2 from inpatient discharge record" ;
label var i10_pr_ip3               "ICD-10-PCS Procedure 3 from inpatient discharge record" ;
label var i10_pr_ip4               "ICD-10-PCS Procedure 4 from inpatient discharge record" ;
label var i10_pr_ip5               "ICD-10-PCS Procedure 5 from inpatient discharge record" ;
label var i10_pr_ip6               "ICD-10-PCS Procedure 6 from inpatient discharge record" ;
label var i10_pr_ip7               "ICD-10-PCS Procedure 7 from inpatient discharge record" ;
label var i10_pr_ip8               "ICD-10-PCS Procedure 8 from inpatient discharge record" ;
label var i10_pr_ip9               "ICD-10-PCS Procedure 9 from inpatient discharge record" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var los_ip                   "Length of stay (cleaned) from IP" ;
label var mdc                      "MDC in effect on discharge date" ;
label var mdc_nopoa                "MDC in use on discharge date, calculated without POA" ;
label var prver                    "Procedure Version" ;
label var totchg_ip                "Total charge for ED and inpatient services" ;

/* Convert special values to missing values */
recode disp_ip                   (-9 -8 -6 -5=.) ;
recode drg                       (-99 -88 -66=.) ;
recode drgver                    (-9 -8 -6 -5=.) ;
recode drg_nopoa                 (-99 -88 -66=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode i10_ndx                   (-99 -88 -66=.) ;
recode i10_necause               (-99 -88 -66=.) ;
recode i10_npr_ip                (-99 -88 -66=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode los_ip                    (-9999 -8888 -6666=.) ;
recode mdc                       (-9 -8 -6 -5=.) ;
recode mdc_nopoa                 (-9 -8 -6 -5=.) ;
recode prver                     (-9 -8 -6 -5=.) ;
recode totchg_ip                 (-99999999.99 -88888888.88 -66666666.66=.) ;

describe;

save "NEDS_2015Q4_IP.dta", replace;
#delimit cr

clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q4_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q4_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 19

drop if age < 10

keep age amonth discwt female hosp_ed neds_stratum i10_dx1 i10_dx2 i10_dx3 i10_dx4 i10_dx5 i10_dx6 i10_dx7 i10_dx8 i10_dx9 i10_dx10 i10_dx11 i10_dx12 i10_dx13 i10_dx14 i10_dx15 i10_dx16 i10_dx17 i10_dx18 i10_dx19 i10_dx20 i10_dx21 i10_dx22 i10_dx23 i10_dx24 i10_dx25 i10_dx26 i10_dx27 i10_dx28 i10_dx29 i10_dx30 i10_ecause1 i10_ecause2 i10_ecause3 i10_ecause4 died_visit
                     
save "tg_2015_q4.dta", replace
 
clear

/*****************************************************************************
 * Stataload_NEDS_2016_Core.Do
 * This program will load the NEDS 2016 Core csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2016_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      byte   dxver
      byte   edevent
      byte   female
      str4   hcupfile
      long   hosp_ed
      str7   i10_dx1
      str7   i10_dx2
      str7   i10_dx3
      str7   i10_dx4
      str7   i10_dx5
      str7   i10_dx6
      str7   i10_dx7
      str7   i10_dx8
      str7   i10_dx9
      str7   i10_dx10
      str7   i10_dx11
      str7   i10_dx12
      str7   i10_dx13
      str7   i10_dx14
      str7   i10_dx15
      str7   i10_dx16
      str7   i10_dx17
      str7   i10_dx18
      str7   i10_dx19
      str7   i10_dx20
      str7   i10_dx21
      str7   i10_dx22
      str7   i10_dx23
      str7   i10_dx24
      str7   i10_dx25
      str7   i10_dx26
      str7   i10_dx27
      str7   i10_dx28
      str7   i10_dx29
      str7   i10_dx30
      str7   i10_ecause1
      str7   i10_ecause2
      str7   i10_ecause3
      str7   i10_ecause4
      int    i10_ndx
      int    i10_necause
      double key_ed
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2016_Core.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dxver                    "Diagnosis Version" ;
label var edevent                  "Type of ED Event" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var i10_dx1                  "ICD-10-CM Diagnosis 1" ;
label var i10_dx2                  "ICD-10-CM Diagnosis 2" ;
label var i10_dx3                  "ICD-10-CM Diagnosis 3" ;
label var i10_dx4                  "ICD-10-CM Diagnosis 4" ;
label var i10_dx5                  "ICD-10-CM Diagnosis 5" ;
label var i10_dx6                  "ICD-10-CM Diagnosis 6" ;
label var i10_dx7                  "ICD-10-CM Diagnosis 7" ;
label var i10_dx8                  "ICD-10-CM Diagnosis 8" ;
label var i10_dx9                  "ICD-10-CM Diagnosis 9" ;
label var i10_dx10                 "ICD-10-CM Diagnosis 10" ;
label var i10_dx11                 "ICD-10-CM Diagnosis 11" ;
label var i10_dx12                 "ICD-10-CM Diagnosis 12" ;
label var i10_dx13                 "ICD-10-CM Diagnosis 13" ;
label var i10_dx14                 "ICD-10-CM Diagnosis 14" ;
label var i10_dx15                 "ICD-10-CM Diagnosis 15" ;
label var i10_dx16                 "ICD-10-CM Diagnosis 16" ;
label var i10_dx17                 "ICD-10-CM Diagnosis 17" ;
label var i10_dx18                 "ICD-10-CM Diagnosis 18" ;
label var i10_dx19                 "ICD-10-CM Diagnosis 19" ;
label var i10_dx20                 "ICD-10-CM Diagnosis 20" ;
label var i10_dx21                 "ICD-10-CM Diagnosis 21" ;
label var i10_dx22                 "ICD-10-CM Diagnosis 22" ;
label var i10_dx23                 "ICD-10-CM Diagnosis 23" ;
label var i10_dx24                 "ICD-10-CM Diagnosis 24" ;
label var i10_dx25                 "ICD-10-CM Diagnosis 25" ;
label var i10_dx26                 "ICD-10-CM Diagnosis 26" ;
label var i10_dx27                 "ICD-10-CM Diagnosis 27" ;
label var i10_dx28                 "ICD-10-CM Diagnosis 28" ;
label var i10_dx29                 "ICD-10-CM Diagnosis 29" ;
label var i10_dx30                 "ICD-10-CM Diagnosis 30" ;
label var i10_ecause1              "ICD-10-CM E Cause 1" ;
label var i10_ecause2              "ICD-10-CM E Cause 2" ;
label var i10_ecause3              "ICD-10-CM E Cause 3" ;
label var i10_ecause4              "ICD-10-CM E Cause 4" ;
label var i10_ndx                  "ICD-10-CM Number of diagnoses on this record" ;
label var i10_necause              "ICD-10-CM Number of E Causes on this record" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs                  "Patient Location: NCHS Urban-Rural Code" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode i10_ndx                   (-99 -88 -66=.) ;
recode i10_necause               (-99 -88 -66=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs                   (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

save "NEDS_2016_Core_trim.dta", replace;

drop if missing(amonth);
 
drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_ecause1 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_ecause2 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_ecause3 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_ecause4 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 neds_stratum i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit;

save "tg_2016.dta", replace;
#delimit cr

clear

/*****************************************************************************
 * Stataload_NEDS_2017_Core.Do
 * This program will load the NEDS 2017 Core csv File into Stata.
 * Because Stata loads the entire file into memory, it may not be possible
 * to load every data element for large files.  If necessary, edit this
 * program to change the memory size or to load only selected data elements.
 * The Stata INFILE command with the _SKIP option is used to select a subset of variables.
 * _skip (N) tells Stata to skip the next consecutive N variables.
 * Also can use "in" option after "using NEDS_2017_Core.csv" to read subset of the data.
 *****************************************************************************/

#delimit ;

/* Set available memory size */
set mem 1400m;

/* Read data elements from the csv file */
infile
      int    age
      byte   amonth
      byte   aweekend
      byte   died_visit
      double discwt
      byte   disp_ed
      byte   dqtr
      byte   dxver
      byte   edevent
      byte   female
      str4   hcupfile
      long   hosp_ed
      str7   i10_dx1
      str7   i10_dx2
      str7   i10_dx3
      str7   i10_dx4
      str7   i10_dx5
      str7   i10_dx6
      str7   i10_dx7
      str7   i10_dx8
      str7   i10_dx9
      str7   i10_dx10
      str7   i10_dx11
      str7   i10_dx12
      str7   i10_dx13
      str7   i10_dx14
      str7   i10_dx15
      str7   i10_dx16
      str7   i10_dx17
      str7   i10_dx18
      str7   i10_dx19
      str7   i10_dx20
      str7   i10_dx21
      str7   i10_dx22
      str7   i10_dx23
      str7   i10_dx24
      str7   i10_dx25
      str7   i10_dx26
      str7   i10_dx27
      str7   i10_dx28
      str7   i10_dx29
      str7   i10_dx30
      str7   i10_dx31
      str7   i10_dx32
      str7   i10_dx33
      str7   i10_dx34
      str7   i10_dx35
      byte   i10_injury
      byte   i10_multinjury
      int    i10_ndx
      double key_ed
      long   neds_stratum
      byte   pay1
      byte   pay2
      int    pl_nchs
      double totchg_ed
      int    year
      byte   zipinc_qrtl
using NEDS_2017_CORE.csv;

/*  Assign labels to the data elements */
label var age                      "Age in years at admission" ;
label var amonth                   "Admission month" ;
label var aweekend                 "Admission day is a weekend" ;
label var died_visit               "Died in the ED (1), Died in the hospital (2), did not die (0)" ;
label var discwt                   "Weight to ED Visits in AHA universe" ;
label var disp_ed                  "Disposition of patient (uniform) from ED" ;
label var dqtr                     "Discharge quarter" ;
label var dxver                    "Diagnosis Version" ;
label var edevent                  "Type of ED Event" ;
label var female                   "Indicator of sex" ;
label var hcupfile                 "Source of HCUP Record (SID or SEDD)" ;
label var hosp_ed                  "HCUP ED hospital identifier" ;
label var i10_dx1                  "ICD-10-CM Diagnosis 1" ;
label var i10_dx2                  "ICD-10-CM Diagnosis 2" ;
label var i10_dx3                  "ICD-10-CM Diagnosis 3" ;
label var i10_dx4                  "ICD-10-CM Diagnosis 4" ;
label var i10_dx5                  "ICD-10-CM Diagnosis 5" ;
label var i10_dx6                  "ICD-10-CM Diagnosis 6" ;
label var i10_dx7                  "ICD-10-CM Diagnosis 7" ;
label var i10_dx8                  "ICD-10-CM Diagnosis 8" ;
label var i10_dx9                  "ICD-10-CM Diagnosis 9" ;
label var i10_dx10                 "ICD-10-CM Diagnosis 10" ;
label var i10_dx11                 "ICD-10-CM Diagnosis 11" ;
label var i10_dx12                 "ICD-10-CM Diagnosis 12" ;
label var i10_dx13                 "ICD-10-CM Diagnosis 13" ;
label var i10_dx14                 "ICD-10-CM Diagnosis 14" ;
label var i10_dx15                 "ICD-10-CM Diagnosis 15" ;
label var i10_dx16                 "ICD-10-CM Diagnosis 16" ;
label var i10_dx17                 "ICD-10-CM Diagnosis 17" ;
label var i10_dx18                 "ICD-10-CM Diagnosis 18" ;
label var i10_dx19                 "ICD-10-CM Diagnosis 19" ;
label var i10_dx20                 "ICD-10-CM Diagnosis 20" ;
label var i10_dx21                 "ICD-10-CM Diagnosis 21" ;
label var i10_dx22                 "ICD-10-CM Diagnosis 22" ;
label var i10_dx23                 "ICD-10-CM Diagnosis 23" ;
label var i10_dx24                 "ICD-10-CM Diagnosis 24" ;
label var i10_dx25                 "ICD-10-CM Diagnosis 25" ;
label var i10_dx26                 "ICD-10-CM Diagnosis 26" ;
label var i10_dx27                 "ICD-10-CM Diagnosis 27" ;
label var i10_dx28                 "ICD-10-CM Diagnosis 28" ;
label var i10_dx29                 "ICD-10-CM Diagnosis 29" ;
label var i10_dx30                 "ICD-10-CM Diagnosis 30" ;
label var i10_dx31                 "ICD-10-CM Diagnosis 31" ;
label var i10_dx32                 "ICD-10-CM Diagnosis 32" ;
label var i10_dx33                 "ICD-10-CM Diagnosis 33" ;
label var i10_dx34                 "ICD-10-CM Diagnosis 34" ;
label var i10_dx35                 "ICD-10-CM Diagnosis 35" ;
label var i10_injury
    "Injury ICD-10-CM diagnosis reported on record (1: First-listed injury; 2: Other than first-listed injury; 0: No injury)" ;
label var i10_multinjury           "Multiple ICD-10-CM injuries reported on record" ;
label var i10_ndx                  "ICD-10-CM Number of diagnoses on this record" ;
label var key_ed                   "HCUP NEDS record identifier" ;
label var neds_stratum             "Stratum used to sample hospital" ;
label var pay1                     "Primary expected payer (uniform)" ;
label var pay2                     "Secondary expected payer (uniform)" ;
label var pl_nchs                  "Patient Location: NCHS Urban-Rural Code" ;
label var totchg_ed                "Total charge for ED services" ;
label var year                     "Calendar year" ;
label var zipinc_qrtl              "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode age                       (-99 -88 -66=.) ;
recode amonth                    (-9 -8 -6 -5=.) ;
recode aweekend                  (-9 -8 -6 -5=.) ;
recode died_visit                (-9 -8 -6 -5=.) ;
recode discwt                    (-99.9999999 -88.8888888 -66.6666666=.) ;
recode disp_ed                   (-9 -8 -6 -5=.) ;
recode dqtr                      (-9 -8 -6 -5=.) ;
recode dxver                     (-9 -8 -6 -5=.) ;
recode edevent                   (-9 -8 -6 -5=.) ;
recode female                    (-9 -8 -6 -5=.) ;
recode hosp_ed                   (-9999 -8888 -6666=.) ;
recode i10_injury                (-9 -8 -6 -5=.) ;
recode i10_multinjury            (-9 -8 -6 -5=.) ;
recode i10_ndx                   (-99 -88 -66=.) ;
recode key_ed                    (-999999999999999 -888888888888888 -666666666666666=.) ;
recode neds_stratum              (-9999 -8888 -6666=.) ;
recode pay1                      (-9 -8 -6 -5=.) ;
recode pay2                      (-9 -8 -6 -5=.) ;
recode pl_nchs                   (-99 -88 -66=.) ;
recode totchg_ed                 (-99999999.99 -88888888.88 -66666666.66=.) ;
recode year                      (-999 -888 -666=.) ;
recode zipinc_qrtl               (-9 -8 -6 -5=.) ;

describe;

save "NEDS_2017_Core_trim.dta", replace;

drop if missing(amonth);
 
drop if female == 0;

drop if missing(female);

drop if age > 19;

drop if age < 10;

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_dx31 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_dx32 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_dx33 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_dx34 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 i10_dx35 i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 neds_stratum i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit;

save "tg_2017.dta", replace;
#delimit cr

clear