#' named_cols_to_factors
#'
#' Carries out class transform to factor.
#' Enhances datatable usage by providing ready levels on click of the filter boxes.
#'
#'
#' named_cols_to_factors()
#' @param df a dataframe
#' @param fct_cols a character vector, with the names of columns in the dataframe
#'
named_cols_to_factors <- function (df, fct_cols = fct_cols) {

    for(i in names(df)) {

        if(i %in% fct_cols ){
            df[,i] <- as.factor(df[,i])
        }
    }
    return(df)
}
