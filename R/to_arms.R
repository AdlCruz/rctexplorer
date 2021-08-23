#' To Intervention Arms Table
#'
#' Takes data frame with studies restults and returns dataframe with one row per arm
#' to_arms()
#' @param df a dataframe to manipulate
#' @export
#' @examples
#' to_arms(df)
#'
to_arms <- function(df) {

  af <- df %>% filter(!is.na(ArmGroupInterventionName))

  lab_names <- paste("label",seq(1:70),sep = "")

  bf <- af %>% separate( col = ArmGroupInterventionName,
                         into = lab_names, sep = '\\|',
                         remove = TRUE, extra = "merge", fill = "right",
                         convert = TRUE )

  long_arms<- bf %>% pivot_longer(starts_with("label",ignore.case = FALSE),
                                  values_drop_na = T)

  long_arms$value <- tolower(long_arms$value)
  long_arms$value <- gsub(".*: ","",long_arms$value) # remove chars before colon
  long_arms$value <- gsub("[0-9]+.mg","",long_arms$value) # remove mg dosage
  long_arms$value <- gsub("q2w|q4w|q8w","",long_arms$value) # remove timeframe
  long_arms$value <- gsub("\\(\\)","",long_arms$value) # remove empty parenthesis
  long_arms$value <- ifelse(grepl("placebo.(for.|to.)",long_arms$value),"PBO",long_arms$value) # subst for or to placebo to just placebo
  long_arms$value <- ifelse(grepl("placebo",long_arms$value),"PBO",long_arms$value)
  long_arms$value <- trimws(long_arms$value) # trim whitespace

  return(long_arms)

}
