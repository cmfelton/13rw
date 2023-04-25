# 13RW

This is the replication package for Felton (2023), "*13 Reasons Why* Probably Increased Emergency Room Visits for Self-Harm among Teen Girls." Draft available here: https://osf.io/preprints/socarxiv/h8vgz/

Because this code uses the here package, I recommend you keep the directory structure the same as it is on github, with one exception: you should add an additional, empty folder called "plots". If you do not do this, the code will return an error. Running the code as-is will save all the plots to this folder.

Begin by opening the ``.Rproj`` file ``13RW.Rproj``. This will create a clean ``R`` session with no packages loaded and it will set the working directory to location of ``13RW.Rproj``. 

Assuming you've downloaded the ``.rds`` files from github (located in the data folder), you can start by running ``analysis_functions.R`` followed by ``analysis.R``. Be sure to install any packages you have not already installed. Code for doing so is commented out in the script. ``analysis.R`` will output all plots in the main text and supplement, with the exception of (a) the repeated placebo test procedure and (b) the simulations. These can be found in ``repeat_placebo.R`` and ``sims.R``. Be aware that these scripts take a long time to run. You likely don't want to run them all at once.

If you want to replicate the ``.rds`` files from the NEDS data, you will have to obtain those ``.csv`` files from NEDS and place them in data folder. You will then have to run two Stata files: ``csv_to_dta_teen_girls.do`` and ``csv_to_dta_other.do``, in that order. Both take a while to run and require a lot of memory. The former takes longer to run. You'll then have to run ``cleaning_functions.R``, ``diagnosis_codes.R``, and ``get_counts.R``, in that order.
