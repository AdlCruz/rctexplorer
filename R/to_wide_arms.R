#' To Interventions Table
#'
#' Takes data frame with studies restults and returns dataframe with one row per study,
#' and one intervention per column
#' to_wide_arms()
#' @param df a dataframe to manipulate
#' @export
#' @examples
#' to_wide_arms(df)


to_wide_arms <- function(df) {



    df$ArmGroupInterventionName[is.na(df$ArmGroupInterventionName)] <- "Empty"

    lab_names <- paste("label",seq(1:70),sep = "")

    bf <- df %>% separate( col = ArmGroupInterventionName,
                         into = lab_names, sep = '\\|',
                         remove = TRUE, extra = "merge", fill = "right",
                         convert = TRUE )

    long_arms<- bf %>% pivot_longer(starts_with("label",ignore.case = FALSE),
                                  values_drop_na = T)

    long_arms$value <- ifelse(grepl("placebo.(for.|to.)",long_arms$value),"PBO",long_arms$value) # subst for or to placebo to just placebo
    long_arms$value <- ifelse(grepl("placebo",long_arms$value),"PBO",long_arms$value)
    long_arms$value <- trimws(long_arms$value) # trim whitespace

    remake_wide <- pivot_wider(long_arms, names_from = name, values_from = value)

    return(remake_wide)
}
