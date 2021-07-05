#' To Intervention Arms Table
#'
#' Takes data frame with studies restults and returnsdataframe with one row per arm
#'  with unioque study identifier.
#' armify()
#' @param df a dataframe to manipulate
#' @examples
#' armify(df)


armify <- function(df) {#, row = "study"

    af <- df %>% select(NCTId, EnrollmentCount, OverallStatus, Phase, IsFDARegulatedDrug, HasResults, ArmGroupInterventionName) %>% filter(!is.na(ArmGroupInterventionName))
    lab_names <- paste("label",seq(1:50),sep = "")

    make_wide <- separate(af, col = ArmGroupInterventionName,
                                into = lab_names, sep = '\\|',
                                remove = TRUE, extra = "merge", fill = "right",
                                convert = TRUE) %>%
      select_if(~!(all(is.na(.)) | all(. == "")))

    make_character<- mutate(make_wide, across(everything(),as.character))

    make_long <- pivot_longer(make_character,
                              !c("NCTId", "EnrollmentCount", "OverallStatus","Phase", "IsFDARegulatedDrug", "HasResults"),
                              values_drop_na = T)

    drop_colon <- gsub(".*:","",make_long$value)

    bind_new <- cbind(make_long[1:7],drop_colon)

    remake_wide <- pivot_wider(bind_new, names_from = name, values_from = drop_colon)

    # grouping all placebos
    remake_wide$label1 <- ifelse(grepl("placebo",remake_wide$label1,ignore.case = T),"Any Placebo", remake_wide$label1)
    remake_wide$label2 <- ifelse(grepl("placebo",remake_wide$label2,ignore.case = T),"Any Placebo", remake_wide$label2)

    # her might be the right place for selection of either first two treatments or all treatments

    return(remake_wide) # or make_long
}

