



ui = fluidPage(
    titlePanel("Explore, Select, Download and Plot your search of clinicaltrials.gov",
               windowTitle = "Data Explorer"),
    tabsetPanel(id = "panels",
                tabPanel("?", mainPanel(fluidRow(column(12,h3("Welcome to rctexplorer"),
                                        h3("Data Table"),p("The Data Table tab displays the dataframe entered into the application through the launcher function. By default, the list of fields is 'for_explorer' from 'rctapi' paired with your search expression. Boxes at the top of each column show the categories held and alllow filtering. The dispalyed table can be copied or downloaded as csv excel or pdf."),
                                        h3("Plots"),h4("Treemap"),p("Shows frequency of values from a chosen variable."),h4("Stacked barplot"),p("Computes summary of grouped variables chosen by user and shows them in stacked color filled bars."),h4("Scatter plot"),
                                        p("Introduces the main numeric variable in your dataframe. Individual studies are scattered by their EnrollmentCount and grouped by two chosen variables. This plot is wrapped with 'plotly', making it interactive. Try hovering over the dots, clicking on the legend labels and zooming, selecting and panning around. The menu on the top right also allows download of the displayed plot."),
                                        h3("Data summaries"),p("'Data Snippet' displays the first 15 observations. Respectively, 'Summary' and 'Structure' display the output from calling summary() and str() functions on the search results."),
                                        h3("Missing values"), p(""), offset = 3)))
                         ),
                tabPanel("Data Table",
                         fluidRow(
                             column(2,
                                    wellPanel(actionButton("select_all", label="All/None"),
                                              actionButton("reset", label="Reset"),
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
                                                      column(3,radioButtons("n_pct", "Choose horizontal view",
                                                                   c("Stack", "Fill"))),
                                                      column(3,radioButtons("filter_nas","Filter NAs",
                                                                   c("Show","Hide")))
                                            )
                                    )),
                         fluidRow(column(9, plotOutput("bivariate_plot")),
                                  column(3, dataTableOutput("bivariate_table"))),

                         div(style = "margin-bottom:50px"),
                         hr(),
                         fluidRow((column(2,h3("Scatter Plot"),h4("Enrollment Count"), offset = 2)),
                                  (column(8, column(4, selectInput("scatter_group", "Variables to group by",
                                                                  names(df),
                                                                  selected = "InterventionMeshTerm",
                                                                  selectize = F),
                                                      div(style = "margin-top:-20px"),
                                                      selectInput("scatter_colour","",
                                                                  names(df),
                                                                  selected = "Phase",
                                                                  selectize = F)),
                                            column(4, sliderInput("sliderEnrollment","Filter by Enrollment",
                                                                  min = 0, max = max(enrolled),
                                                                  value = c(0,max(enrolled)),
                                                                  step = T,ticks = T, sep = ""))))),# more scatter inputs here
                        fluidRow(column(9,plotlyOutput("scatter_plot")),
                                 column(3, plotOutput("scatter_groups")))
                        ), # end of plots tab

                tabPanel("Data Snippet", verbatimTextOutput("snippet")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Structure", verbatimTextOutput("str")),
                tabPanel("Missing Data",
                         fluidRow(column(2), #missing data plot controls
                                  column(7,plotOutput("missing_data_plot"))))
    ))
