# select on display

# selected_cols <- c("NCTId","StudyType","OverallStatus","StartDate",
#                    "CompletionDate","IsFDARegulatedDrug","IsFDARegulatedDevice","IsUnapprovedDevice",
#                    "OversightHasDMC","Condition","DesignPrimaryPurpose","Phase",
#                    "DesignInterventionModel","DesignMasking","DesignAllocation","EnrollmentCount",
#                    "ArmGroupType","InterventionType",
#                    "InterventionMeshTerm","Gender","MinimumAge","MaximumAge","HealthyVolunteers")

# variables to manipulae in set_app_input()

age_cols <- c("MinimumAge","MaximumAge")

fct_cols <- c("StudyType","OverallStatus","IsFDARegulatedDrug","IsFDARegulatedDevice",
              "IsUnapprovedDevice","Condition","DesignPrimaryPurpose","Phase",
              "DesignInterventionModel","DesignMasking","DesignAllocation",
              "InterventionMeshId","InterventionMeshTerm","Gender","MinimumAge",
              "MaximumAge","AgeRange","HealthyVolunteers","WhyStopped","OversightHasDMC")

char_cols <- c("Keyword",
               "ArmGroupLabel","ArmGroupType",
               "InterventionType","InterventionName",
               "PrimaryOutcomeMeasure")

date_cols <- c("StartDate","CompletionDate")

num_cols <- c("EnrollmentCount")

#usethis::use_data(selected_cols,age_cols,fct_cols,char_cols,date_cols,num_cols, internal = T, overwrite = T)

