use "NEDS_2006_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2006.dta", replace

clear

use "NEDS_2006_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2006.dta", replace

clear

use "NEDS_2006_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2006.dta", replace

clear

use "NEDS_2007_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2007.dta", replace

clear

use "NEDS_2007_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2007.dta", replace

clear

use "NEDS_2007_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2007.dta", replace

clear

use "NEDS_2008_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2008.dta", replace

clear

use "NEDS_2008_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2008.dta", replace

clear

use "NEDS_2008_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2008.dta", replace

clear

use "NEDS_2009_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2009.dta", replace

clear

use "NEDS_2009_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2009.dta", replace

clear

use "NEDS_2009_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2009.dta", replace

clear

use "NEDS_2010_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2010.dta", replace

clear

use "NEDS_2010_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2010.dta", replace

clear

use "NEDS_2010_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2010.dta", replace

clear

use "NEDS_2011_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2011.dta", replace

clear

use "NEDS_2011_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2011.dta", replace

clear

use "NEDS_2011_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2011.dta", replace

clear

use "NEDS_2012_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2012.dta", replace

clear

use "NEDS_2012_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2012.dta", replace

clear

use "NEDS_2012_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2012.dta", replace

clear

use "NEDS_2013_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2013.dta", replace

clear

use "NEDS_2013_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2013.dta", replace

clear

use "NEDS_2013_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2013.dta", replace

clear

use "NEDS_2014_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

save "w40_2014.dta", replace

clear

use "NEDS_2014_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

save "m40_2014.dta", replace

clear

use "NEDS_2014_Core_trim.dta"

drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

save "tb_2014.dta", replace

clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q1Q3_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q1Q3_ED.dta, update
 
drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

keep age amonth discwt dx1 dx2 dx3 dx4 ecode1 ecode2 ecode3 ecode4 intent_self_harm died_visit key_ed injury_poison
        
save "tb_2015_q3.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q1Q3_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q1Q3_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

keep age amonth discwt dx1 dx2 dx3 dx4 ecode1 ecode2 ecode3 ecode4 intent_self_harm died_visit key_ed injury_poison
        
save "w40_2015_q3.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q1Q3_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q1Q3_ED.dta, update
 
drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

keep age amonth discwt dx1 dx2 dx3 dx4 ecode1 ecode2 ecode3 ecode4 intent_self_harm died_visit key_ed injury_poison
        
save "m40_2015_q3.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q4_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q4_ED.dta, update
 
drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

keep age amonth discwt female hosp_ed neds_stratum i10_dx1 i10_dx2 i10_dx3 i10_dx4 i10_dx5 i10_dx6 i10_dx7 i10_dx8 i10_dx9 i10_dx10 i10_dx11 i10_dx12 i10_dx13 i10_dx14 i10_dx15 i10_dx16 i10_dx17 i10_dx18 i10_dx19 i10_dx20 i10_dx21 i10_dx22 i10_dx23 i10_dx24 i10_dx25 i10_dx26 i10_dx27 i10_dx28 i10_dx29 i10_dx30 i10_ecause1 i10_ecause2 i10_ecause3 i10_ecause4 died_visit
                     
save "tb_2015_q4.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q4_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q4_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

keep age amonth discwt female hosp_ed neds_stratum i10_dx1 i10_dx2 i10_dx3 i10_dx4 i10_dx5 i10_dx6 i10_dx7 i10_dx8 i10_dx9 i10_dx10 i10_dx11 i10_dx12 i10_dx13 i10_dx14 i10_dx15 i10_dx16 i10_dx17 i10_dx18 i10_dx19 i10_dx20 i10_dx21 i10_dx22 i10_dx23 i10_dx24 i10_dx25 i10_dx26 i10_dx27 i10_dx28 i10_dx29 i10_dx30 i10_ecause1 i10_ecause2 i10_ecause3 i10_ecause4 died_visit
                     
save "w40_2015_q4.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q4_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q4_ED.dta, update
 
drop if missing(amonth)

drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

keep age amonth discwt female hosp_ed neds_stratum i10_dx1 i10_dx2 i10_dx3 i10_dx4 i10_dx5 i10_dx6 i10_dx7 i10_dx8 i10_dx9 i10_dx10 i10_dx11 i10_dx12 i10_dx13 i10_dx14 i10_dx15 i10_dx16 i10_dx17 i10_dx18 i10_dx19 i10_dx20 i10_dx21 i10_dx22 i10_dx23 i10_dx24 i10_dx25 i10_dx26 i10_dx27 i10_dx28 i10_dx29 i10_dx30 i10_ecause1 i10_ecause2 i10_ecause3 i10_ecause4 died_visit
                     
save "m40_2015_q4.dta", replace
 
clear

use "NEDS_2016_Core_trim.dta", replace

drop if missing(amonth)
 
drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_ecause1 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_ecause2 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_ecause3 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_ecause4 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 neds_stratum i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "tb_2016.dta", replace

clear

use "NEDS_2016_Core_trim.dta", replace

drop if missing(amonth)
 
drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_ecause1 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_ecause2 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_ecause3 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_ecause4 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 neds_stratum i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "m40_2016.dta", replace

clear

use "NEDS_2016_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_ecause1 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_ecause2 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_ecause3 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_ecause4 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 neds_stratum i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "w40_2016.dta", replace

clear

use "NEDS_2017_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 1

drop if missing(female)

drop if age > 19

drop if age < 10

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_dx31 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_dx32 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_dx33 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_dx34 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 i10_dx35 i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 neds_stratum i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "tb_2017.dta", replace

clear

use "NEDS_2017_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 1

drop if missing(female)

drop if age > 65

drop if age < 40

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_dx31 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_dx32 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_dx33 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_dx34 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 i10_dx35 i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 neds_stratum i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "m40_2017.dta", replace

clear

use "NEDS_2017_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 0

drop if missing(female)

drop if age > 65

drop if age < 40

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_dx31 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_dx32 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_dx33 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_dx34 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 i10_dx35 i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 neds_stratum i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "w40_2017.dta", replace

clear

**girls 10--17**

use "NEDS_2006_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2006.dta", replace

clear

use "NEDS_2007_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2007.dta", replace

clear

use "NEDS_2008_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2008.dta", replace

clear

use "NEDS_2009_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2009.dta", replace

clear

use "NEDS_2010_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2010.dta", replace

clear

use "NEDS_2011_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2011.dta", replace

clear

use "NEDS_2012_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2012.dta", replace

clear


use "NEDS_2013_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2013.dta", replace

clear

use "NEDS_2014_Core_trim.dta"

drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

save "tg17_2014.dta", replace

clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q1Q3_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q1Q3_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

keep age amonth discwt dx1 dx2 dx3 dx4 ecode1 ecode2 ecode3 ecode4 intent_self_harm died_visit key_ed injury_poison
        
save "tg17_2015_q3.dta", replace
 
clear

use "NEDS_2015_Core.dta"
 
merge 1:1 key_ed using NEDS_2015Q4_IP.dta
 
drop _merge
 
merge 1:1 key_ed using NEDS_2015Q4_ED.dta, update
 
drop if missing(amonth)

drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

keep age amonth discwt female hosp_ed neds_stratum i10_dx1 i10_dx2 i10_dx3 i10_dx4 i10_dx5 i10_dx6 i10_dx7 i10_dx8 i10_dx9 i10_dx10 i10_dx11 i10_dx12 i10_dx13 i10_dx14 i10_dx15 i10_dx16 i10_dx17 i10_dx18 i10_dx19 i10_dx20 i10_dx21 i10_dx22 i10_dx23 i10_dx24 i10_dx25 i10_dx26 i10_dx27 i10_dx28 i10_dx29 i10_dx30 i10_ecause1 i10_ecause2 i10_ecause3 i10_ecause4 died_visit
                     
save "tg17_2015_q4.dta", replace
 
clear

use "NEDS_2016_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_ecause1 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_ecause2 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_ecause3 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_ecause4 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 neds_stratum i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "tg17_2016.dta", replace

clear

use "NEDS_2017_Core_trim.dta"

drop if missing(amonth)
 
drop if female == 0

drop if missing(female)

drop if age > 17

drop if age < 10

keep age i10_dx3 i10_dx10 i10_dx17 i10_dx24 i10_dx31 amonth i10_dx4 i10_dx11 i10_dx18 i10_dx25 i10_dx32 discwt i10_dx5 i10_dx12 i10_dx19 i10_dx26 i10_dx33 female i10_dx6 i10_dx13 i10_dx20 i10_dx27 i10_dx34 hosp_ed i10_dx7 i10_dx14 i10_dx21 i10_dx28 i10_dx35 i10_dx1 i10_dx8 i10_dx15 i10_dx22 i10_dx29 neds_stratum i10_dx2 i10_dx9 i10_dx16 i10_dx23 i10_dx30 died_visit

save "tg17_2017.dta", replace

clear