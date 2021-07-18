# rctexplorer
Currently functional. Pkg in development. Install with ```devtools::install_github("AdlCruz/rctexplorer")```--

This package contains an R Shiny application that allows the user to explore a dataframe of studies downloaded from clinicaltrials.gov. 

Using the application:

Save a dataframe with study results with ```set_app_input()```.

```df <- set_app_input("psoriatic arthritis", registration_fields, 500)```
then
```launch_explorer(df)```

The use of ```set_app_input()``` is recommended as it carries out useful cleaning and type transformations. There is a degree of flexiblity and the application will launch with any dataframe argument. The user may also modify the list of fields to feed into the application.

Inside the application there are different tabs that allow the user to interact with their dataframe.
