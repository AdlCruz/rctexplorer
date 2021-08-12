#' Check DF
#'
#' This function checks the dataframe input
#' 
#' @param data list of 2 or dataframe
#' @keywords check input data
#' @export
#' @examples
#' check_df(data)

check_df <- function(data) {
    
    if (is.data.frame(data)) {
        df <- data
    } else if (length(data) == 2){
        df <- data[[1]]
    } else {
        print("The argument given is neither a dataframe nor the expected output of set_app_input.\nPlease try again")
        stopApp()
    }
    return(df)
}


#' Check Key
#'
#' This function checks the key input
#' 
#' @param data list of 2 or dataframe
#' @keywords check input data
#' @export
#' @examples
#' check_key(data)
check_key <- function(data){
    
    if (length(data) == 2) {
        key <- data[[2]]
    } else {
        key <- "No additional search information"
    }
    return(key)
}