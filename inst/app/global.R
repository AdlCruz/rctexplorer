
# clean enrollment count to set slider
enrolled <- df$EnrollmentCount[which(!is.na(df$EnrollmentCount))]

selected_cols <- c("NCTId","StudyType","OverallStatus","StartDate",
                   "CompletionDate","Condition","Phase","EnrollmentCount","ArmGroupType","InterventionType",
                   "InterventionMeshTerm","Gender","AgeRange","HealthyVolunteers")
