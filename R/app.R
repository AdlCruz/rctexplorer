## app.R ##

#' Launch Data Explorer Shiny App
#'
#' This function takes one parameter
#' @param df Dataframe obtained through set_app_input()
#' @keywords launch app
#' @export
#' @examples
#' launch_explorer()

launch_explorer <- function(df) {
  
  require(shiny)
  require(shinydashboard)
  require(DT)
  require(dplyr)
  require(ggplot2)
  require(treemapify)
  require(RColorBrewer)
  require(rctapi)
  
  shinyApp(
    ui = fluidPage(
      titlePanel("Explore, Select, Download and Plot your search of clinicaltrials.gov",
                 windowTitle = "Data Explorer"),
      tabsetPanel(id = "panels",    
                  tabPanel("?", mainPanel(h3("App usage suggestions"),
                                          h4("Data Table"),p("The DATATABLE tab displays the result of searching clinicaltrials.gov with your defined expression.\n The list of fields used is 'viz_fields'."),
                                          h4("Plots"),
                                          h5("Univariable Analysis"),p("Plots showing the count of gender and age eligibility requirements, study types, conditions studied, and overall status variables"),
                                          h5("Stacked bars"),p("This plot excludes observations with missing InterventionMeshTerm"),
                                          h4("Data summaries"),p("'Data Snippet' displays the first 15 observations. Respectively, 'Summary' and 'Structure' display the output from calling summary() and str() functions on the search results"),
                  )),
                  tabPanel("Data Table",
                           fluidRow(
                             column(2,
                                    wellPanel(
                                      checkboxGroupInput("show_vars","Columns to show:",names(df),selected_cols)
                                    )
                             ),
                             column(10, "Data Table", DT::dataTableOutput("df"))
                           )
                  ),
                  tabPanel("Plots",
                           fluidRow(column(12,h3("Univariable Plots"))
                           ),
                           fluidRow(column(4,plotOutput("overallstatus_map")),column(4,plotOutput("studytype_map")),
                                    column(4,plotOutput("gender_map")),column(4,plotOutput("condition_map")),
                                    column(4,plotOutput("agerange_map")),column(4,plotOutput("phase_map"))
                           ),
                           fluidRow(column(12,h3("Studies by MESH Intervention Term"))
                           ),
                           fluidRow(column(1,actionButton("help_link", "?")), 
                                    column(5,plotOutput("meshterm_phase_barplot")),
                                    column(6,plotOutput("meshterm_status_barplot")),
                                    column(6,plotOutput("meshterm_purpose_barplot")),
                                    column(6,plotOutput("meshterm_allocation_barplot")),
                                    column(6,plotOutput("meshterm_dmc_barplot")),
                                    column(6,plotOutput("meshterm_condition_barplot"))
                                    
                           ),
                           fluidRow(
                             column(6,plotOutput("study_phase_enrollment_status"))
                             #column(6,plotOutput("")),
                           ),
                           fluidRow(
                             column(4))),
                  tabPanel("Data Snippet", verbatimTextOutput("snippet")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Structure", verbatimTextOutput("str")))),
    server = function(input, output, session) {
      
      # buttons events
      observeEvent(input$help_link, {
        newvalue <- "?"
        updateTabItems(session, "panels", newvalue)
      })
      
      # Generate data summaries
      output$summary <- renderPrint({
        summary(df)
      })
      output$str <- renderPrint({
        str(df)
      })
      # Get head of selected data
      output$snippet <- renderPrint({
        head(df, n = 15)
      })
      
      # data table output
      # data table formatting
      output$df<- DT::renderDataTable({
        DT::datatable(
          df[, input$show_vars, drop = FALSE],
          selection = list(target = 'row+column'),
          filter = 'top',
          extensions = "Buttons",
          
          options = list(
            lengthMenu = c(10, 50, 100, 200, length(df$NCTId)),
            pageLength = 10,
            initComplete = JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
              "}"),
            dom = 'Blfrtip',
            buttons = c('copy', 'csv', 'excel', 'pdf'),
            searchHighlight = TRUE,
            server = TRUE)
        )
      })
      # PLOTS
      # Univariable maps
      output$gender_map <- renderPlot(gender_map(df))
      output$studytype_map <- renderPlot(studytype_map(df))
      output$condition_map <- renderPlot(condition_map(df))
      output$agerange_map <- renderPlot(agerange_map(df))
      output$overallstatus_map <- renderPlot(overallstatus_map(df))
      output$phase_map <- renderPlot(phase_map(df))
      # Stacked bar plots focused on MESH Term
      output$meshterm_phase_barplot <- renderPlot(meshterm_phase_barplot(df))
      output$meshterm_status_barplot <- renderPlot(meshterm_status_barplot(df))
      output$meshterm_purpose_barplot <- renderPlot(meshterm_purpose_barplot(df))
      output$meshterm_allocation_barplot <- renderPlot(meshterm_allocation_barplot(df))
      output$meshterm_dmc_barplot <- renderPlot(meshterm_dmc_barplot(df))
      output$meshterm_condition_barplot <- renderPlot(meshterm_condition_barplot(df))
      
      
      
    }
    
  )
}