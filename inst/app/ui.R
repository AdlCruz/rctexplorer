
enrolled <- df$EnrollmentCount[which(!is.na(df$EnrollmentCount))]




ui = fluidPage(
    titlePanel("Explore, Select, Download and Plot your search of clinicaltrials.gov",
               windowTitle = "Data Explorer"),
    tabsetPanel(id = "panels",
                tabPanel("Data Table",
                         fluidRow(
                             column(2,
                                    wellPanel(actionButton("select_all", label="All/None"),
                                              actionButton("reset", label="Reset"),
                                        checkboxGroupInput("show_vars","Columns to show:",
                                                           choices = names(df),
                                                           selected = c("NCTId","Acronym","StudyType","OverallStatus","LeadSponsorName"))
                                    )
                             ),
                             column(10, DT::dataTableOutput("df_table"))
                         )
                ),
                tabPanel("Data Snippet",verbatimTextOutput("snippet")),
                tabPanel("Summary",verbatimTextOutput("summary")),
                tabPanel("Structure",verbatimTextOutput("str")),
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
                         fluidRow((column(2,h3("Bivariate Plots"),h4("Stacked barplot"),h5("Only first 40 rows from the right side table"),
                                          offset = 2)),

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
                                  column(3, dataTableOutput("bivariate_table")),
                                  div(style = "margin-bottom:50px")),


                         hr(),

                         fluidRow(div(style = "margin-top:50px"),
                                  (column(2,h3("Scatter Plot"),h4("Enrollment Count"), offset = 2)),
                                  (column(8, column(4, selectInput("scatter_group", "Variables to group by",
                                                                  names(df),
                                                                  selected = "InterventionMeshTerm",
                                                                  selectize = F),
                                                      div(style = "margin-top:-20px"),
                                                      selectInput("scatter_colour","",
                                                                  names(df),
                                                                  selected = "Phase",
                                                                  selectize = F)),
                                            column(4, sliderInput("sliderEnrollment","Filter by EnrollmentCount",
                                                                  min = 0, max = max(enrolled),
                                                                  value = c(0,max(enrolled)),
                                                                  step = T,ticks = T, sep = ""))))),# more scatter inputs here
                        fluidRow(column(9,plotlyOutput("scatter_plot")),
                                 column(3, plotOutput("scatter_groups")))
                        ), # end of plots tab

                tabPanel("Interventions Table",
                  fluidRow(
                    column(2,
                           wellPanel(actionButton("select_all_2", label="All/None"),
                                     actionButton("reset_2", label="Reset"),
                                     checkboxGroupInput("show_vars_2","Columns to show:",
                                                        choices = c("Please click Reset"), # is insta updated to show right ui
                                                        selected = c("NCTId","Acronym","StudyType","OverallStatus","LeadSponsorName"))
                           )
                    ),
                    column(10,dataTableOutput("arms_table")))
                  ),
                tabPanel("Network",
                         fluidRow(column(12,selectInput("layout", "Choose a layout type",
                                                 choices = c("layout_in_circle","layout_with_fr","layout_nicely",
                                                             "layout_as_star","layout_on_sphere","layout_on_grid",
                                                             "layout_with_gem","layout_with_sugiyama"),
                                                 selected = "layout_with_fr"),offset = 1)),
                  fluidRow(column(12, visNetworkOutput("network"), offset = 1))
                  ),
                tabPanel("Missing Data",
                         fluidRow(column(1), #missing data plot controls
                                  column(7,plotOutput("missing_data_plot")),
                                  column(4,dataTableOutput("missing_data_table"))),
                         fluidRow(column(1), #missing data plot controls
                                  column(7,plotOutput("missing_by_study_plot")),
                                  column(4,dataTableOutput("missing_data_table")))),
                tabPanel("?", mainPanel(fluidRow(column(12,h3("Welcome to rctexplorer"),

                                                        hr(),

                                                        h3(strong("Tabs Overview:")),

                                                        p(strong("Data Table")," : The dataframe entered into the application through the launcher function. Boxes at the top of each column show the categories held when possible and alllow filtering."),

                                                        p(strong("Data summaries"), ": 'Data Snippet' displays the first 15 observations in the dataframe. 'Summary' and 'Structure' display the output from calling summary() and str() functions on the dataframe"),

                                                        p(strong("Plots")," : Show frequency of chosen grouped variables and studies by number of participants enrolled."),

                                                        p(strong("Interventions Table")," : Table showing one study per row with a column for each of its intervention arms (split from var. 'ArmGroupInterventionName')"),

                                                        p(strong("Network")," : Network plot of interventions for filtered studies"),

                                                        p(strong("Missing Data")," : Shows number of missing values for each variable present in the filtered dataframe"),

                                                        # there was a br() here

                                                        h3(strong("Filtering")),
                                                        p("Filtering implemented on the main data table will be carried on to all other instances of the data used in the application. At startup the Data Table tab will display only a few columns. More columns can be toggled on via the checkbox. The boxes atop of each column and the global search bar both understand regular expressions.\n
Warning: all filtering resets when columns are toggled on/off."),
                                                        p(strong("Useful regular expression templates\n")),
                                                        p("^(?!word|otherword).*$ This is a negative lookahead and will exlcude all words between ! and ). The bar works as an alternate symbol."),
                                                        p("(?=[abcdefgh]).*$ This is a positive lookahead and will include any results with any of the characters inside the brackets."),


                                                        h3(strong("Interactivity")),
                                                        p("Most tabs have a degree of interactivty.\n The data table tab includes download buttons. The variables plotted are changeable as are some features of the plot (e.g hide/show NAs values). The scatter plot is wrapped in a plotly function, allowing for zooming, panning and filtering by clicking on the plot and legend. The network graph is implemented with visNetwork and also includes interactive features such as dragging, creating, and removing nodes."),

                                                        h3(strong("Useful links")),
                                                        p(a("https://clinicaltrials.gov/api/gui")),
                                                        p(a("https://regex101.com/")),
                                                         offset = 3))))
    ))

