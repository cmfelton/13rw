#library(stringr)

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