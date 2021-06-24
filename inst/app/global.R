# pre selectec columns to show
selected_cols <- c("NCTId","StudyType","OverallStatus","StartDate",
                   "CompletionDate","Condition","Phase","EnrollmentCount","ArmGroupType","InterventionType",
                   "InterventionMeshTerm","Gender","AgeRange","HealthyVolunteers")

# clean enrollment count to set slider
enrolled <- df$EnrollmentCount[which(!is.na(df$EnrollmentCount))]

# function for network data
#
library(tidyr)
library(dplyr)
library(splitstackshape)

simplify_for_net <- function(df) {
  df <- df[,which(names(df)=="NCTId"| names(df) == "ArmGroupInterventionName")]
  make_wide <- cSplit(df,names(df[,-which(names(df)=="NCTId")]),sep = "|", drop = T)
  make_character<- mutate(make_wide, across(everything(),as.character))
  make_long <- pivot_longer(make_character,!c("NCTId"), names_to = c(".value","fields"), names_sep = "_", values_drop_na = T)
}
