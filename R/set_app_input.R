#' Set Input for Data Explorer
#'
#' This function takes a search expression and character vector with field names
#' and returns one dataframe. 'set_app_input()' is meant to be used as input for
#' the data explorer app as in the example.
#'
#' launch_explorer()
#' @param search_expr A string following the querying guidelines at
#' https://clinicaltrials.gov/api/gui/ref/syntax and https://clinicaltrials.gov/api/gui/ref/expr
#' @param fields A character vector with field names. The explorer is optimised
#' to work with the default list 'for_explorer' found in package "rctapi".
#' @param max_studies A number indicating how many studies out of all that
#' match the search expression will be returned.
#' @keywords set app input
#' @export
#' @examples
#' set_app_input(search_expr = 'psoriatic arthritis',fields = for_explorer, max_studies = 300)

set_app_input <- function (search_expr, fields = for_explorer, max_studies = 500) {

  df <- rctapi::get_study_fields(search_expr,fields, max_studies)
  # remove rank
  df <- df[,-1]

  if (all(for_explorer %in% fields)) {
    df$AgeRange <- do.call(paste, c(df[ , age_cols], list(sep = '-')))
    # Character columns into factors
    df[fct_cols] <- lapply(df[fct_cols], factor)
  } else {print("The explorer is optimised for use with list 'for_explorer'")}

  # no empty columns
  df <- df[, colSums( is.na(df) ) < nrow(df)]

  return(df)
}
