# Hello there,
# Thank you for clicking on the link to this video.
# This demonstration shows the tools in action.
# They were created for my MSc dissertation project.

library(devtools)

install_github("AdlCruz/rctapi")
install_github("AdlCruz/rctexplorer")

library(rctapi)
library(rctexplorer)


PsA_data <- get_study_fields(search_expr = "psoriatic arthritis", 
                                 fields = for_explorer, 
                                 max_studies = 200, response_content = T)

launch_explorer(PsA_data)

PsA_app_data <- set_app_input(search_expr = "psoriatic arthritis AREA[StudyType]Interventional", 
                          fields = for_explorer, 
                          max_studies = 600)

launch_explorer(PsA_app_data)

# let us find and load unfinished studies by some of the largest pharmaceutical 
# companies in the world and also see the reason the sponsors provided
 
unfinished_rcts <- set_app_input("AREA[StudyType]Interventional AND AREA[LeadSponsorName](novartis OR merck OR abbvie) AND AREA[OverallStatus](Withdrawn OR Suspended OR Terminated)", 
                                 fields = c(for_explorer,"WhyStopped"),
                                 max_studies = 1000)

launch_explorer(unfinished_rcts)



# install.packages("devtools")
devtools::install_github("presagia-analytics/ctrialsgov")

library(ctrialsgov)














# Thank you. Have a nice day!















