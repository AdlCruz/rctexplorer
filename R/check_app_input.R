
#' Parse Check App Input
#'
#' This function parses the app input to create a search key
#'
#' @param data list of 2 or dataframe
#' @keywords check input data
#' @export
#' @examples
#' check_app_input(data)
check_app_input <- function(data) {

  if (is.data.frame(data)) {
    df <- data
    key <- "No additional search information"
  } else if (length(data) == 2){
    df <- data[[1]]
    key <- data[[2]]
  } else {
    print("The argument given is neither a dataframe nor the expected output of set_app_input(). Please try again")
    stopApp()
  }
  return(list(df = df, key = key))
}
