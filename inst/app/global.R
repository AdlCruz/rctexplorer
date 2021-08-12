

    if (is.data.frame(data)) {
        df <- data
        key <- "No additional search information"
    } else if (length(data) == 2){
        df <- data[[1]]
        key <- data[[2]]
    } else {
        print("The argument given is neither a dataframe nor the expected output of set_app_input.\nPlease try again")
    }
