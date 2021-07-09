#' To Edges
#'
#' Takes long arms data frame and returns edges
#' to_edges(df)
#' @param df a long dataframe of arms
#' @examples
#' to_edges(df))
to_edges <- function(long_arms) {
    
    rl <- unique(long_arms$NCTId)
    tib_df <- data.frame()
    
    for (i in 1:length(rl)) {
        crr_st <- long_arms[long_arms$NCTId == rl[i],]
        unique_trts <- distinct(crr_st, value, .keep_all = TRUE)
        if (length(unique_trts$NCTId) < 2 ) {
            next
        }
        else {
            combi <- t(combn(unique_trts$value,2))
            a <- unique_trts[1:length(combi[1]),1:(ncol(unique_trts)-2)]
            a <- cbind(a,combi)
            tib_df <- rbind(tib_df,a)
        }
    }
    names(tib_df)[ncol(tib_df)-1] <- "from"
    names(tib_df)[ncol(tib_df)] <- "to"
    return(tib_df)
}