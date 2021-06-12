#' Clean Input for Data Explorer
#'
#'
#' clean-app_input()
#' @param df a dataframe to manipulate
#' @examples
#' clean_app_input(search_expr = 'psoriatic arthritis',fields = for_explorer, max_studies = 300)

clean_app_input<- function (df) ({
    
    # remove rank or NCTId
    df <- df[,-1]
    # blanks into NAs
    df <- na_if(df, "")
    # columns to factors
    df <- named_cols_to_factors(df, fct_cols = fct_cols)
    # age range column
    if (all(age_cols %in% names(df))) {
        df$AgeRange <- do.call(paste, c(df[ , age_cols], list(sep = '-')))
    }
    # results in study entry?
    if (c("ResultsFirstPostDate") %in% names(df)) {
        df$HasResults <- ifelse(is.na(df$ResultsFirstPostDate), "No","Yes")
    }
    # no empty columns
    df <- df[, colSums( is.na(df) ) < nrow(df)]
    
    return(df)
    
})
