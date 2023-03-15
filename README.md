# 13rw
Replication code for Felton working paper on 13 Reasons Why

To get all time series used in the analysis, run tgclean.do and suppclean.do on the NEDS .csv files, and then run getcounts.R in the same directory. NEDS data is available for purchase here: https://hcup-us.ahrq.gov/nedsoverview.jsp. analysis.R will produce all the plots and tables in both the main paper and Appendix B using the .rds files produced by getcounts.R. sims.R will conduct the type-M, measurement error, and sample-splitting simulations. tgmisscount.do is for counting the number of observations before and after removing missing observations for the table in Appendix C.
