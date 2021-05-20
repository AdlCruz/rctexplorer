#' Set Input for Data Explorer
#'
#' This function takes a search expression and character vector with field names
#' and returns one dataframe. This dataframe which must be named "df" is used by the data explorer app called by
#' launch_explorer()
#' @param search_expr A string following the querying guidelines at
#' https://clinicaltrials.gov/api/gui/ref/syntax and https://clinicaltrials.gov/api/gui/ref/expr
#' @param fields A character vector with field names. Default list for_explorer is optimised for
#' data explorer app performance.
#' @param max_studies A number indicating how many studies out of all that
#' match the search expression will be returned.
#' @keywords set app input
#' @export
#' @examples
#' set_app_input(expr = 'psoriatic arthritis',fields = for_explorer, max_studies = 300)

set_app_input <- function (search_expr, fields = for_explorer, max_studies = 500) {
  df <- rctapi::get_study_fields(search_expr,fields, max_studies)
  # remove rank
  df <- df[,-1]
  #Age Criteria columns
  age_cols <- c("MinimumAge","MaximumAge")
  df$AgeRange <- do.call(paste, c(df[ , age_cols], list(sep = '-')))#

  # Variables by type
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

  # Character columns into factors
  df[fct_cols] <- lapply(df[fct_cols], factor)
  # no empty columns
  df <- df[, colSums( is.na(df) ) < nrow(df)]
  print("Please save me as 'df'")
  return(df)
}
