#' To Edges
#'
#' Takes long arms data frame and returns edges
#' to_edges(df)
#' @param df a long dataframe of arms
#' @export
#' @examples
#' to_edges(df))

to_edges <- function(long_arms) {

  rl <- unique(long_arms$NCTId)
  tib_df <- data.frame()

  for (i in 1:length(rl)) {
    crrnt_stdy <- long_arms[long_arms$NCTId == rl[i],]
    unique_trts <- dplyr::distinct(crrnt_stdy, value, .keep_all = TRUE)
    if (length(unique_trts$NCTId) < 2 ) {
      next
    }
    else {
      combi <- t(combn(unique_trts$value,2))
      sorted_combi <- t(apply(combi,1,sort))
      othr_vars <- unique_trts[1:length(sorted_combi[1]),1:(ncol(unique_trts)-2)]
      othr_vars$n_trts <- length(unique_trts$NCTId)
      cmplt_combi <- cbind(sorted_combi,othr_vars)
      tib_df <- rbind(tib_df,cmplt_combi)
    }
  }
  names(tib_df)[1] <- "from"
  names(tib_df)[2] <- "to"
  return(tib_df)
}
