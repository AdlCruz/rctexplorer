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

                         fluidRow(column(2,h3("Univariate Plots"),h4("Treemap plot"),
                                         div(style = "margin-top:15px"),
                                         selectInput("treemap_var","Choose a variable",
                                                               names(df),
                                                               selected = "OverallStatus",
                                                               selectize = FALSE)),

                                  column(7,plotOutput("univariate_plot")),
                                  column(3,div(style = "margin-top:10px"),dataTableOutput("univariate_table"))),
                         hr(),
                         fluidRow((column(2,h3("Bivariate Plots"),h4("Stacked barplot"), offset = 2)),

                                    (column(7,column(4,selectInput("biv_1","Variables to group by",
                                                                  names(df),
                                                                  selected = "InterventionMeshTerm",
                                                                  selectize = FALSE),
                                                     div(style = "margin-top:-20px"),
                                                       selectInput("biv_2","",
                                                                  names(df),
                                                                  selected = "Phase",
                                                                  selectize = F)),
                                                      column(3,radioButtons("n_pct", "Choose horizontal scale",
                                                                   c("count", "percentage"))
                                                      ))
                                    )),
                         fluidRow(column(9, plotOutput("bivariate_plot")),
                                  column(3, dataTableOutput("bivariate_table"))),

                         div(style = "margin-bottom:40px"),
                         hr(),
                         fluidRow((column(2,h3("Scatter Plot"),h4("Enrollment Count"), offset = 2)),
                                  (column(7, column(4, selectInput("scatter_group", "Variables to group by",
                                                                  names(df),
                                                                  selected = "InterventionMeshTerm",
                                                                  selectize = F),
                                                      div(style = "margin-top:-20px"),
                                                      selectInput("scatter_colour","",
                                                                  names(df),
                                                                  selected = "Phase",
                                                                  selectize = F)),
                                            column(3, sliderInput("sliderEnrollment","Filter by Enrollment",
                                                                  min = 0, max = max(enrolled),
                                                                  value = c(0,500),
                                                                  step = T,ticks = T, sep = "."))))), # more scatter inputs here
                        fluidRow(column(9,plotlyOutput("scatter_plot")),
                                  column(3) # scatter groups plot here
                        )), # end of plots tab

                tabPanel("Data Snippet", verbatimTextOutput("snippet")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Structure", verbatimTextOutput("str")),
                tabPanel("Missing Data",
                         fluidRow(column(12,plotOutput("missing_data_plot"))))
    ))
