#' To Intervention Arms Table
#'
#' Takes data frame with studies restults and returns dataframe with one row per arm
#'
#' to_arms()
#' @param df a dataframe to manipulate
#' @examples
#' to_arms(df)

to_arms <- function(df) {

  af <- df %>% select(NCTId, EnrollmentCount, OverallStatus, Phase, IsFDARegulatedDrug, HasResults, ArmGroupInterventionName) %>%
      filter(!is.na(ArmGroupInterventionName))

  lab_names <- paste("label",seq(1:50),sep = "")

  bf <- af %>% separate( col = ArmGroupInterventionName,
                         into = lab_names, sep = '\\|',
                         remove = TRUE, extra = "merge", fill = "right",
                         convert = TRUE )

  long_arms<- bf %>% pivot_longer(!c("NCTId", "EnrollmentCount", "OverallStatus", "Phase", "IsFDARegulatedDrug", "HasResults"),
                                  values_drop_na = T)

  long_arms$value <- tolower(long_arms$value)
  long_arms$value <- gsub(".*: ","",long_arms$value) # remove things before colon
  long_arms$value <- gsub("[0-9]+.mg","",long_arms$value) # remove dosage in mg
  long_arms$value <- gsub("\\(\\)","",long_arms$value) # remove empty parenthesis
  long_arms$value <- ifelse(grepl("placebo.(for.|to.)",long_arms$value),"placebo",long_arms$value) # sub clear pure placebo for placebo word
  long_arms$value <- trimws(long_arms$value)

  return(long_arms)
}
