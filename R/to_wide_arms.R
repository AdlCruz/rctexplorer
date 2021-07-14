#' To Interventions Table
#'
#' Takes data frame with studies restults and returns dataframe with one row per study,
#' and one intervention per column
#' to_wide_arms()
#' @param df a dataframe to manipulate
#' @export
#' @examples
#' to_wide_arms(df)


to_wide_arms <- function(long_arms) {

    remake_wide <- pivot_wider(long_arms, names_from = name, values_from = value)

    return(remake_wide)
}
