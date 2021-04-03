/*
Replication Do File for Dugan and Chenoweth's "Moving Beyond Deterrence: The Effectiveness of Raising the Expected Utility of Abstaining from Terrorism in Israel" (2012)

Ensure the following are installed prior to running:
// https://www.stata.com/statalist/archive/2008-03/msg01053.html
ssc desc gam
net get gam
!unzip gam.zip
ssc install estout
ssc install dups

Primary replication data contained in "GATE_GTD_Israel_monthly_data_STATA.dta", which was provided in replication zip folder by Dugan and Chenoweth. Replication code using this dataset were provided in Dugan and Chenoweth's Online Appendix and copied into this Do file. 

Data for recreating Dugan and Chenoweth's GTD dataset were downloaded from https://www.start.umd.edu/gtd/access/ as an excel file: "globalterrorismdb_0221dist.xlsx". This file is used to create a dataset of GTD terrorist attacks according to Dugan and Chenoweth's parameters: "GTD_personal_rep_87-04.dta". 
	This dataset is used to consider observation-level terrorist attack data and to differentiate Palestinian from Unknown perpetrators.
	This dataset is combined with Dugan and Chenoweth's GATE-Israel records to produce "GATE_GTD_Israel_monthly_data_ext.dta" as a direct 	replica of their provided dataset.
	
Data for expanding Dugan and Chenoweth's work using the RAND Database of Worldwide Terrorism Incidents (RDWTI) was downloaded from https://www.rand.org/nsrd/projects/terrorism-incidents/download.html as a csv: "RAND_Database_of_Worldwide_Terrorism_Incidents.csv". This file is used to create a dataset of RAND terrorist attacks according to parameters of Dugan and Chenoweth's study: "rand_terrorism_87-04.dta"
	This dataset is combined with Dugan and Chenoweth's GATE-Israel records to produce "GATE_RAND_Israel_monthly_data.dta" for the extension portion of the report.
*/

/*Dugan and Chenoweth Direct Replication Code*/
ssc install estout
ssc install dups

log using replication_log

use "GATE_GTD_Israel_monthly_data_STATA.dta" 

sort mcount

/* All Actions */
nbreg att93miss L.allact firstint secondint GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss, exposure(popthou)
est sto m1

* By Tactical Regime;
nbreg att93miss L.allact L.att93miss L2.att93miss L3.att93miss L4.att93miss if firstint==1, exposure(popthou)
nbreg att93miss L.allact GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss if oslolull==1, exposure(popthou)
nbreg att93miss L.allact L.att93miss L2.att93miss L3.att93miss L4.att93miss if secondint==1, exposure(popthou)

/* Conciliatory and Repressive Actions */
nbreg att93miss L.concil concla2 L.repress firstint secondint GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss, exposure(popthou)
est sto m2

* By Tactical Regime;
nbreg att93miss L.concil concla2 L.repress L.att93miss L2.att93miss L3.att93miss L4.att93miss if firstint==1, exposure(popthou)
nbreg att93miss L.concil concla2 L.repress GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss if oslolull==1, exposure(popthou)
nbreg att93miss L.concil L.repress L.att93miss L2.att93miss L3.att93miss L4.att93miss if secondint==1, exposure(popthou)

/* Conciliatory/Repressive and Discriminate/Indiscriminate */
nbreg att93miss L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss, exposure(popthou)
est sto m3

* By Tactical Regime;
nbreg att93miss L.concdisc cdisla2 L.concindisc L.reprdisc L.reprindisc L.att93miss L2.att93miss L3.att93miss L4.att93miss if firstint==1, exposure(popthou)
nbreg att93miss L.concdisc L.concindisc cindla2 L.reprdisc rdisla2 L.reprindisc GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss if oslolull==1, exposure(popthou)
nbreg att93miss L.concdisc L.concindisc L.reprdisc L.reprindisc L.att93miss L2.att93miss L3.att93miss L4.att93miss if secondint==1, exposure(popthou)


/* Create table of results for publication */
esttab m1 m2 m3 using dug_chen_orig.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att93miss L2.att93miss L3.att93miss L4.att93miss) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" firstint "First Intifada" secondint "Second Intifada" GTD2 "GTD2" L.att93miss "First Lagged Attacks" L2.att93miss "Second Lagged Attacks" L3.att93miss "Third Lagged Attacks" L4.att93miss "Fourth Lagged Attacks") title({\b Table 1.} Negative Binomial Coefficients and (SE), June 1987 through December 2004, n = 191 (Dugan Chenoweth Replication Data)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

clear


// Recreate Dugan & Chenoweth GTD counts from updated GTD data; add flag for Palestinian vs unknown perpetrators

import excel "globalterrorismdb_0221dist.xlsx", firstrow

keep eventid iyear imonth iday approxdate extended resolution country country_txt region region_txt provstate city latitude longitude specificity vicinity location summary crit1 crit2 crit3 doubtterr alternative multiple success attacktype1 attacktype1_txt attacktype2 attacktype2_txt attacktype3 attacktype3_txt targtype1 targtype1_txt targsubtype1 corp1 target1 natlty1 natlty1_txt targtype2 targtype2_txt targsubtype2 corp2 target2 natlty2 natlty2_txt targtype3 targtype3_txt corp3 target3 natlty3 natlty3_txt gname gname2 gname3 guncertain1 guncertain2 individual claimed weaptype1 weaptype2 nkill nkillter nwound nwoundte addnotes scite1 scite2 scite3 dbsource

keep if (country == 97 | country == 155 ) & ( natlty1 == 97 | natlty2 == 97 | natlty3 == 97 )

save "GTD_personal_rep.dta", replace

keep if ((iyear == 1987 & imonth >= 6) | iyear > 1987) & (iyear <= 2004)

save "GTD_personal_rep_87-04.dta", replace

clear

// Terrorist Group Names.xlsx created by manually assigning each gname in the above dataset as a Palestine affiliate, Unknown, or non-Palestinian //
import excel "Terrorist Group Names.xlsx", firstrow
save "gname_affiliations.dta", replace

use "GTD_personal_rep_87-04.dta"

merge m:1 gname using "gname_affiliations.dta"

egen mo_yr = concat(imonth iyear), punct(-)

egen att_pal = sum(palestineaffiliate), by(mo_yr)
egen att_unk = sum(unknown), by(mo_yr)
egen att_palunk = rowtotal(att_pal-att_unk)
egen att_tot = count(eventid), by(mo_yr)

save "GTD_personal_rep_87-04.dta", replace


// Aggregate GTD records by month and year to merge with GATE-Israel data in "GATE_GTD_Israel_monthly_data_STATA.dta"
keep iyear imonth mo_yr att_pal att_unk att_palunk att_tot

dups, drop key(mo_yr)
drop _expand

save "GTD_personal_rep_tomerge.dta", replace

use "GATE_GTD_Israel_monthly_data_STATA.dta"

egen mo_yr = concat(month year), punct(-)
merge 1:1 mo_yr using "GTD_personal_rep_tomerge.dta"

replace att_pal = 0 if missing(att_pal) & !missing(att93miss)
replace att_unk = 0 if missing(att_unk) & !missing(att93miss)
replace att_palunk = 0 if missing(att_palunk) & !missing(att93miss)
replace att_tot = 0 if missing(att_tot) & !missing(att93miss)

drop mo_yr imonth iyear

save "GATE_GTD_Israel_monthly_data_ext.dta", replace

// Run if want to compare Dugan & Chenoweth's counts with generated GTD counts
gen cnt_diff = att93miss - att_palunk
tab cnt_diff

// Percent of Palestinian-perpetrated attacks from all known perpetrators
summ att_pal
sca tot_pal = r(sum)
gen att_known = att_tot - att_unk
summ att_known
sca tot_known = r(sum)
display tot_pal / tot_known

// Avg % Palestinian-perpetrated attacks per month for all known perpetrators
gen pal_perc_kn = att_pal / att_known
mean(pal_perc_kn)

// Percent of Palestinian-perpetrated attacks from all perpetrators
summ att_pal
sca tot_pal = r(sum)
summ att_tot
sca tot_att = r(sum)
display tot_pal / tot_att

// Avg % Palestinian-perpetrated attacks per month for all perpetrators
gen pal_perc = att_pal / att_tot
mean(pal_perc)

// Percent of Known-Perpetrator attacks
summ att_known
sca tot_known = r(sum)
summ att_tot
sca tot_att = r(sum)
display tot_known / tot_att

// Generate summary statistics
total(att_palunk)
mean(att_palunk)
total(att_tot)
mean(att_tot)
total(att_pal)
mean(att_pal)
total(att_known)



// Run models with recreated GTD counts for Palestinian-only attacks (att_pal) and Palestinian and Unknown attacks (att_palunk)


/* Conciliatory/Repressive and Discriminate/Indiscriminate */
sort mcount

nbreg att_palunk L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m3

nbreg att_pal L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m3_pal

/* Conciliatory and Repressive Actions */

nbreg att_palunk L.concil concla2 L.repress firstint secondint GTD2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m2

nbreg att_pal L.concil concla2 L.repress firstint secondint GTD2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m2_pal

/* All Actions */

nbreg att_palunk L.allact firstint secondint GTD2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m1

nbreg att_pal L.allact firstint secondint GTD2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m1_pal


// Combine model results of Palestinian and Unknown attacks for presentation

esttab m1 m2 m3 using gtd_rep.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" firstint "First Intifada" secondint "Second Intifada" GTD2 "GTD2" L.att_palunk "First Lagged Attacks" L2.att_palunk "Second Lagged Attacks" L3.att_palunk "Third Lagged Attacks" L4.att_palunk "Fourth Lagged Attacks") title({\b Table 2.} Negative Binomial Coefficients and (SE), June 1987 through December 2004, n = 191 (Recreated GTD dataset)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

// Combine model results of Palestinian-only attacks for presentation

esttab m1_pal m2_pal m3_pal using gtd_rep_pal.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint GTD2 L.att_pal L2.att_pal L3.att_pal L4.att_pal) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" firstint "First Intifada" secondint "Second Intifada" GTD2 "GTD2" L.att_pal "First Lagged Attacks" L2.att_pal "Second Lagged Attacks" L3.att_pal "Third Lagged Attacks" L4.att_pal "Fourth Lagged Attacks") title({\b Table 2.} Negative Binomial Coefficients and (SE), June 1987 through December 2004, n = 191 (Recreated GTD dataset, only Palestinian actors)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

clear


// Create monthly terrorist attack counts from RAND database

import delimited "RAND_Database_of_Worldwide_Terrorism_Incidents.csv"

keep if (country == "Israel" | country == "West Bank/Gaza" )

gen inc_date = date(date, "DMY", 2009)

keep if inrange(inc_date,td(01jun1987),td(31dec2004))

save "rand_terrorism_87-04.dta", replace

clear

// rand_perpetrator_affiliations.xlsx created by manually assigning each Perpetrator in the above dataset as a Palestine affiliate, Unknown, or non-Palestinian
import excel "rand_perpetrator_affiliations.xlsx", firstrow

save "rand_perp_affiliations.dta", replace


use "rand_terrorism_87-04.dta"

merge m:1 perpetrator using "rand_perp_affiliations.dta"

gen month=month(inc_date)
gen yr=year(inc_date)
egen mo_yr = concat(month yr), punct(-)

egen att_pal = sum(palestineaffiliate), by(mo_yr)
egen att_unk = sum(unknown), by(mo_yr)
egen att_tot = count(description), by(mo_yr)
egen att_palunk = rowtotal(att_pal-att_unk)

save "rand_terrorism_87-04.dta", replace


// Aggregate RAND terrorist attacks to month-year level to merge with GATE-Israel data in "GATE_GTD_Israel_monthly_data_STATA.dta"
keep yr month mo_yr att_pal att_unk att_palunk att_tot

dups, drop key(mo_yr)
drop _expand

save "rand_terrorism_tomerge.dta", replace

use "GATE_GTD_Israel_monthly_data_STATA.dta"

egen mo_yr = concat(month year), punct(-)
merge 1:1 mo_yr using "rand_terrorism_tomerge.dta"

replace att_pal = 0 if missing(att_pal) 
replace att_unk = 0 if missing(att_unk)
replace att_palunk = 0 if missing(att_palunk)
replace att_tot = 0 if missing(att_tot)
gen RAND2 = 1 if year >= 1998
replace RAND2 = 0 if missing(RAND2)

drop mo_yr month yr GTD2

save "GATE_RAND_Israel_monthly_data.dta", replace



// Run if want to compare RAND with Dugan and Chenoweth's GTD counts
gen pers_diff = att93miss - att_palunk
tab pers_diff

// Generate summary statistics - all years
total(att_palunk)
mean(att_palunk)
total(att_tot)
mean(att_tot)
total(att_pal)
mean(att_pal)

// Generate summary statistics - post-1998
total(att_palunk) if year >= 1998
mean(att_palunk) if year >= 1998
total(att_tot) if year >= 1998
mean(att_tot) if year >= 1998
total(att_pal) if year >= 1998
mean(att_pal) if year >= 1998

// Percent of Known-Perpetrator attacks - post-1998
summ att_tot
sca tot_att = r(sum)
gen att_known = att_tot - att_unk
summ att_known
sca tot_known = r(sum)
display tot_known / tot_att

// Percent of Palestinian-perpetrated attacks of known - post-1998
summ att_pal
sca tot_pal = r(sum)
//gen att_known = att_tot - att_unk
summ att_known
sca tot_known = r(sum)
display tot_pal / tot_known

// Avg % Palestinian-perpetrated attacks per month
gen pal_perc = att_pal / att_known
mean(pal_perc)


// Run RAND data models - all years

/* Conciliatory/Repressive and Discriminate/Indiscriminate */

sort mcount

nbreg att_palunk L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint RAND2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m3

nbreg att_pal L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint RAND2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m3_pal

/* Conciliatory and Repressive Actions */

nbreg att_palunk L.concil concla2 L.repress firstint secondint RAND2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m2

nbreg att_pal L.concil concla2 L.repress firstint secondint RAND2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m2_pal

/* All Actions */

nbreg att_palunk L.allact firstint secondint RAND2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk, exposure(popthou)
est sto m1

nbreg att_pal L.allact firstint secondint RAND2 L.att_pal L2.att_pal L3.att_pal L4.att_pal, exposure(popthou)
est sto m1_pal

// Combine model results of Palestine-only attacks for publication
esttab m1_pal m2_pal m3_pal using rand_pal.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint RAND2 L.att_pal L2.att_pal L3.att_pal L4.att_pal) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" firstint "First Intifada" secondint "Second Intifada" RAND2 "RAND2" L.att_pal "First Lagged Attacks" L2.att_pal "Second Lagged Attacks" L3.att_pal "Third Lagged Attacks" L4.att_pal "Fourth Lagged Attacks") title({\b Table 3.} Negative Binomial Coefficients and (SE), June 1987 through December 2004, n = 207 (RAND Terrorism Database, confirmed Palestinian-affiliated)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

// Combine model results of Palestine and Unknown attacks for publication
esttab m1 m2 m3 using rand_palunk.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc firstint secondint RAND2 L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" firstint "First Intifada" secondint "Second Intifada" RAND2 "RAND2" L.att_palunk "First Lagged Attacks" L2.att_palunk "Second Lagged Attacks" L3.att_palunk "Third Lagged Attacks" L4.att_palunk "Fourth Lagged Attacks") title({\b Table 4.} Negative Binomial Coefficients and (SE), June 1987 through December 2004, n = 207 (RAND Terrorism Database)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace


// Run Models - post-1998

/* Conciliatory/Repressive and Discriminate/Indiscriminate */

sort mcount

nbreg att_palunk L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc secondint L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk if year >= 1998, exposure(popthou)
est sto m3_trim

nbreg att_pal L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc secondint L.att_pal L2.att_pal L3.att_pal L4.att_pal if year >= 1998, exposure(popthou)
est sto m3_trimpal

/* Conciliatory and Repressive Actions */

nbreg att_palunk L.concil concla2 L.repress secondint L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk if year >= 1998, exposure(popthou)
est sto m2_trim

nbreg att_pal L.concil concla2 L.repress secondint L.att_pal L2.att_pal L3.att_pal L4.att_pal if year >= 1998, exposure(popthou)
est sto m2_trimpal

/* All Actions */

nbreg att_palunk L.allact secondint L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk if year >= 1998, exposure(popthou)
est sto m1_trim

nbreg att_pal L.allact secondint L.att_pal L2.att_pal L3.att_pal L4.att_pal if year >= 1998, exposure(popthou)
est sto m1_trimpal


// Combine models of Palestine-only attacks post-1998 for publication
esttab m1_trimpal m2_trimpal m3_trimpal using rand_pal_98.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc secondint L.att_pal L2.att_pal L3.att_pal L4.att_pal) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" secondint "Second Intifada" L.att_pal "First Lagged Attacks" L2.att_pal "Second Lagged Attacks" L3.att_pal "Third Lagged Attacks" L4.att_pal "Fourth Lagged Attacks") title({\b Table 3.} Negative Binomial Coefficients and (SE), Jan 1998 through December 2004, n = 84 (RAND Terrorism Database, confirmed Palestinian-affiliated)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

// Combine models of Palestine and Unknown attacks post-1998 for publication
esttab m1_trim m2_trim m3_trim using rand_palunk_98.rtf, se varwidth(32) order(L.allact L.concil concla2 L.repress L.concdisc L.concindisc cindla2 L.reprdisc L.reprindisc secondint L.att_palunk L2.att_palunk L3.att_palunk L4.att_palunk) coeflabel(L.allact "All Actions" L.concil "Conciliatory" concla2 "Conciliatory^2" L.repress "Repressive" L.concdisc "Conciliatory-Discriminate" L.concindisc "Conciliatory-Indiscriminate" cindla2 "(Conciliatory-Indiscriminate)^2" L.reprdisc "Repressive-Discriminate" L.reprindisc "Repressive-Indiscriminate" secondint "Second Intifada" L.att_palunk "First Lagged Attacks" L2.att_palunk "Second Lagged Attacks" L3.att_palunk "Third Lagged Attacks" L4.att_palunk "Fourth Lagged Attacks") title({\b Table 4.} Negative Binomial Coefficients and (SE), Jan 1998 through December 2004, n = 84 (RAND Terrorism Database)) drop(_cons lnalpha) noobs nonumbers mtitle("Model 1" "Model 2" "Model 3") replace

log close
translate replication_log.smcl replication_log.log