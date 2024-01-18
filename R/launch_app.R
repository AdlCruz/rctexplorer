#' Launch Data Explorer Shiny App
#'
#' This function takes a dataframe as parameter and launches the explorer application.
#' @param df Dataframe obtained through set_app_input()
#' @keywords launch app
#' @export

launch_explorer <- function(data) {
  lst <- check_app_input(data)

  shinyOptions(df = lst$df, key = lst$key)
  shiny::runApp(system.file("app", package = "rctexplorer"))

}
