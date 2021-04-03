This folder contains the necessary files to recreate the datasets and analyses in "Natalie Ayers - Quantiative Security Final Paper.pdf"
	This paper is a replication of the main results of Dugan and Chenoweth's "Moving Beyond Deterrence: The Effectiveness of Raising the Expected Utility of Abstaining from Terrorism in Israel" (2013) in the American Sociological Review.
	In addition to replicating the main results, I performed an extension using the RAND Database of Worldwide Terrorism Incidents in place of the Global Terrorism Database.



The contents of this folder are as follows:

Natalie Ayers - Quantiative Security Final Paper.pdf
	Research paper containing replication and extension of Dugan and Chenoweth's study.
	
Appendix 2 - Ayers Quantitative Security Paper.pdf
	Appendix 2 to the above paper; contains Stata moving_beyond_deterrence_replication.do contents and output

moving_beyond_deterrence_replication.do
	Stata Do file to create the datasets from raw data, run all analyses, and produce tabular outputs
	
GATE_GTD_Israel_monthly_data_STATA.dta
	Original Dugan and Chenoweth data file provided in their replication materials
	
globalterrorismdb_0221dist.xlsx
	Full GTD data downloaded from https://www.start.umd.edu/gtd
	
GTD_personal_rep_87-04.dta
	GTD data filtered to include only attacks in Israel or Palestinian terrotories targeted against Israelis; 
	an observation-level dataset which parallels Dugan and Chenoweth's GATE_GTD_Israel_monthly_data_STATA.dta contents
	
Terrorist Group Names.xlsx
	A list of terrorist group names (gname) in the GTD database for 1987-2004 Israeli/Palestinian attacks;
	flagged as either Palestinian, Not Palestinian or Unknown
	
gname_affiliations.dta
	The stata dta file of Terrorist Group Names.xlsx
	
GATE_GTD_Israel_monthly_data_ext.dta
	The contents of the GATE_GTD_Israel_monthly_data_STATA.dta file with the addition of recreated GTD counts aggregated from GTD_personal_rep_87-04.dta;
	represents the GTD count of attacks over the observation period according to updated GTD data
	
RAND_Database_of_Worldwide_Terrorism_Incidents.csv
	Full RAND data downloaded from https://www.rand.org/nsrd/projects/terrorism-incidents.html
	
rand_terrorism_87-04.dta
	RAND data filtered to include only attacks in Israel or Palestinian territories;
	an observation-level dataset which parallels Dugan and Chenoweth's GATE_GTD_Israel_monthly_data_STATA.dta contents
	
rand_perpetrator_affiliations.xlsx
	A list of Perpetrators in the RAND database for 1987-2004 Israeli/Palestinian attacks;
	flagged as either Palestinian, Not Palestinian, or Unknown

rand_perp_affiliations.dta
	The stata dta file of rand_perpetrator_affiliations.xlsx
	
GATE_RAND_Israel_monthly_data.dta
	The contents of the GATE_GTD_Israel_monthly_data_STATA.dta file with the addition of RAND counts aggregated from rand_terrorism_87-04.dta;
	represents the RAND count of attacks over the observation period
	





