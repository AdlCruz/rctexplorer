## app.R ##

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
  require(treemapify)
  require(treemap)
  require(RColorBrewer)
  require(rctapi)
  require(naniar)

  shinyApp(
    ui = fluidPage(
      titlePanel("Explore, Select, Download and Plot your search of clinicaltrials.gov",
                 windowTitle = "Data Explorer"),
      tabsetPanel(id = "panels",
                  tabPanel("?", mainPanel(h3("App usage suggestions"),
                                          h4("Data Table"),p("The DATATABLE tab displays the result of searching clinicaltrials.gov with your defined expression.\n The list of fields used is 'for_explorer'."),
                                          h4("Plots"),
                                          h5("Univariable Analysis"),p(""),
                                          h5("Bivariate Analysis"),p(""),
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

                           fluidRow(column(10,h3("Univariate Plots"))),
                           fluidRow(column(10,h4("Treemap plot"))),
                           fluidRow(column(2,wellPanel(selectInput("treemap_var","Choose a variable",
                                                           names(df),
                                                           selected = "OverallStatus",
                                                           selectize = FALSE))),
                                    column(7,plotOutput("univariate_plot")),
                                    column(3,dataTableOutput("univariate_table"))),
                           hr(),
                           fluidRow(column(10,h3("Bivariate Plots"))),
                           fluidRow(column(10,h4("Stacked barplot"))),
                           fluidRow(column(2,wellPanel(selectInput("biv_1","Variables to group by",
                                                                   names(df),
                                                                   selected = "InterventionMeshTerm",
                                                                   selectize = FALSE),
                                                       selectInput("biv_2","",
                                                                   names(df),
                                                                   selected = "Phase",
                                                                   selectize = F),
                                                       radioButtons("n_pct","Choose y-axis type",
                                                                    c("count","percentage"), inline = TRUE))),
                                    column(7,plotOutput("bivariate_plot")),
                                    column(3,dataTableOutput("bivariate_table"))),
                           hr(),
                  fluidRow(column(12,h3("Scatter Plot"))),
                  fluidRow(column(2, wellPanel(selectInput("scatter_group", "Choose two variables \n to group by",
                                                           names(df),
                                                           selected = "InterventionMeshTerm",
                                                           selectize = F),
                                               selectInput("scatter_colour","",
                                                            names(df),
                                                            selected = "Phase",
                                                           selectize = F))),
                           column(7,plotlyOutput("scatter_plot")),
                           column(3))), #add selection inputs
                  # and filters

                  tabPanel("Data Snippet", verbatimTextOutput("snippet")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Structure", verbatimTextOutput("str")),
                  tabPanel("Missing Data",
                           fluidRow(column(12,plotOutput("missing_data_plot"))))
                  )),

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
      # univariate plots
      output$univariate_plot <- renderPlot({

          tree_dat <- df %>% group_by(across(input$treemap_var)) %>% summarise(n = n())

          treemap(tree_dat,
                  index=input$treemap_var,
                  vSize="n",
                  type="index",
                  title = input$treemap_var,
                  title.legend = input$treemap_var,
                  algorithm = "pivotSize",# "squarified"
                  sortID = "size",
                  palette = "HCL",
                  draw = TRUE
                )
           })

      output$univariate_table <- renderDataTable({

        uni_dat <- df %>% group_by(across(input$treemap_var)) %>% summarise(n = n())
        datatable(uni_dat)

      })

      # bivariate plots

      output$bivariate_plot <- renderPlot({

        biv_dat <- df %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>% summarise(n = n())  %>%
          arrange(desc(n)) %>% head(40) %>% ungroup()

        if (input$n_pct == "count") {
          ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n")) +
          geom_bar(stat = "identity")+
          geom_text(size = 4, position = position_stack(vjust = 0.5)) +
          labs(title = "")+
          xlab(input$biv_1)+ylab("Count")+
          theme(plot.title = element_text(hjust = 0.8))+
          coord_flip()
        } else {
          ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n")) +
          geom_bar(stat = "identity", position = "fill")+
          geom_text(size = 4, position = position_fill(vjust = 0.5)) +
          labs(title = "")+
          xlab(input$biv_1)+ylab("Percentage")+
          theme(plot.title = element_text(hjust = 0.8))+
          scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
          coord_flip()
          }

      })

      output$bivariate_table <- renderDataTable({

        biv_dat <- df %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>%
          summarise(n = n()) %>%  arrange(desc(n))

        datatable(biv_dat)

      })

      output$scatter_plot <- renderPlotly({
        # think of filtering first

        p <- df %>%
          ggplot(aes_string(x = "EnrollmentCount",
                            y = input$scatter_group,
                            color = input$scatter_colour))+
          geom_point(position = "jitter", inherit.aes = T)+
          scale_y_discrete(label=abbreviate)

       ggplotly(p)

      })

      output$missing_data_plot <- renderPlot({

        gg_miss_var(df)

      }, height = "200%")




    }
  )
}
