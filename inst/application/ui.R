ui = fluidPage(
    titlePanel("Explore, Select, Download and Plot your search of clinicaltrials.gov",
               windowTitle = "Data Explorer"),
    tabsetPanel(id = "panels",
                tabPanel("?", mainPanel(h3("App usage suggestions"),
                                        h4("Data Table"),p("The DATATABLE tab displays the result of searching clinicaltrials.gov with your defined expression.\n The default list of fields used is 'for_explorer'.\n"),
                                        h4("Plots"),
                                        h4("Data summaries"),p("'Data Snippet' displays the first 15 observations. Respectively, 'Summary' and 'Structure' display the output from calling summary() and str() functions on the search results"),
                                        h4("Missing values"), p("")
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
                                                     radioButtons("n_pct","Choose axis scale",
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
    ))