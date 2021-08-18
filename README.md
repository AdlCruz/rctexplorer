Working. In development. Install with `devtools::install_github("AdlCruz/rctexplorer")`

Depends on [`rctapi`](https://github.com/AdlCruz/rctapi).

# rctexplorer: Explore ClinicalTrials.gov data

## 1. Download the data

`data <- set_app_input("search_ expr = "psoriatic arthritis", fields - for_explorer, max_studies = 500)`

## 2. Launch the app

`launch_explorer(data)`

There is a degree of flexiblity and the application will also launch with a dataframe argument.

Inside the application there are different tabs that allow the user to interact with the dataframe.

The Help tab is marked ?
