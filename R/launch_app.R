#' Launch Data Explorer Shiny App
#'
#' This function takes a dataframe as parameter and launches the explorer application.
#' @param df Dataframe obtained through set_app_input()
#' @keywords launch app
#' @export
#' @examples
#' launch_explorer(set_app_input(search_expr = 'psoriatic arthritis',fields = for_explorer, max_studies = 300))

launch_explorer <- function(df) {

    require(shiny)
    require(shinydashboard)
    require(DT)
    require(dplyr)
    require(ggplot2)
    require(treemap)
    require(RColorBrewer)
    require(rctapi)
    require(naniar)
    require(plotly)

    shiny::runApp(appDir = system.file("R","inst", package = "rctexplorer"))

}
