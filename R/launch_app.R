#' Launch Data Explorer Shiny App
#'
#' This function takes a dataframe as parameter and launches the explorer application.
#' @param df Dataframe obtained through set_app_input()
#' @keywords launch app
#' @export
#' @examples
#' df <- set_app_input("psoriatic arthritis")
#' launch_explorer(df)

launch_explorer <- function(df = df) {

    shiny::runApp(system.file("R/app", package = "rctexplorer"))

}
