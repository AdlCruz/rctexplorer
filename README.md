# rctexplorer
pkg in development

This package contains an R Shiny application that allows the user to explore the dataframe of studies obtained with ```rctapi:get_study_fields()```. 

There are two main ways of using the application.

1- The user can nest the package's two functions:

```launch_explorer( set_app_input("psoriatic arthritis", for_explorer, 500) )```

This launches the application and explores the dataframe returned by the nested function ```set_app_input()```. This function is optimised to feed into the application with the default list of fields ```for_explorer```.

2- The user can save a dataframe with study results either with ```set_app_input()``` or ```rctapi:: get_study_fields()``` and then launch the application with the saved dataframe as its argument.

```df <- set_app_input("psoriatic arthritis", registration_fields, 500)``` or
```df <- get_study_fields("psoriatic arthritis", core_info_fields, 500)``` then
```launch_explorer(df)```

The use of ```set_app_input()``` is recommended as it carries out useful cleaning and transformations. There is a degree of flexiblity and the application will launch with any dataframe argument. The user may also modify the list of fields to feed into the application or even nest a different function returning a dataframe inside launch_explorer().


Inside the application there are different tabs that allow the user to interact with their dataframe:

Data Table: An interactive data table including the functinality to filter/select and download.

Plots: Interactive plots including uinivariate treemaps, bivariate stacked barplots and more.

Data snippet: Output of calling ```head(df)```.

Summary: Output of calling ```summary(df)```.

Structure: Otput of calling ```str(df)```.

Missing Values: Eplore the dataframe's missing values.
