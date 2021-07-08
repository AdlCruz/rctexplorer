# pre selectec columns to show
selected_cols <- c("NCTId","StudyType","OverallStatus","StartDate",
                   "CompletionDate","Condition","Phase","EnrollmentCount","ArmGroupType","InterventionType",
                   "InterventionMeshTerm","Gender","AgeRange","HealthyVolunteers")

# clean enrollment count to set slider
enrolled <- df$EnrollmentCount[which(!is.na(df$EnrollmentCount))]

#' To Intervention Arms Table
#'
#' Takes data frame with studies restults and returns dataframe with one row per study
#' and split intervention arms.
#' armify()
#' @param df a dataframe to manipulate
#' @examples
#' armify(df)


to_wide_arms <- function(long_arms) {

  remake_wide <- pivot_wider(long_arms, names_from = name, values_from = value)

  return(remake_wide)
}

to_arms <- function(df) {

  af <- df %>% select(NCTId, EnrollmentCount, OverallStatus, Phase, IsFDARegulatedDrug, HasResults, ArmGroupInterventionName) %>%
    filter(!is.na(ArmGroupInterventionName))

  lab_names <- paste("label",seq(1:50),sep = "")

  bf <- af %>% separate( col = ArmGroupInterventionName,
                         into = lab_names, sep = '\\|',
                         remove = TRUE, extra = "merge", fill = "right",
                         convert = TRUE )

  long_arms<- bf %>% pivot_longer(!c("NCTId", "EnrollmentCount", "OverallStatus", "Phase", "IsFDARegulatedDrug", "HasResults"),
                                  values_drop_na = T)

  long_arms$value <- tolower(long_arms$value)
  long_arms$value <- gsub(".*: ","",long_arms$value) # remove things before colon
  long_arms$value <- gsub("[0-9]+.mg","",long_arms$value) # remove dosage in mg
  long_arms$value <- gsub("\\(\\)","",long_arms$value) # remove empty parenthesis
  long_arms$value <- ifelse(grepl("placebo.(for.|to.)",long_arms$value),"placebo",long_arms$value) # sub clear pure placebo for placebo word
  long_arms$value <- trimws(long_arms$value)
  return(long_arms)
}

to_nodes <- function(edges) {
  nodes <- data.frame( label = unlist(c(edges$from,edges$to)),
                       id = unlist(c(edges$from,edges$to)))
  nodes <- nodes %>% group_by(label,id) %>% dplyr::summarize(value = n()) %>% ungroup()
  nodes <- nodes %>% mutate(title = paste0("Appears ", nodes$value," times in edge list"))
  nodes$group <- group_str(nodes$label, precision = 5, strict = FALSE, remove.empty = FALSE)
  return(as.data.frame(nodes))
}

to_edges <- function(long_arms) {

  rl <- unique(long_arms$NCTId)
  tib_df <- data.frame()

  for (i in 1:length(rl)) {
    crr_st <- long_arms[long_arms$NCTId == rl[i],]
    unique_trts <- distinct(crr_st, value, .keep_all = TRUE)
    if (length(unique_trts$NCTId) < 2 ) {
      next
    }
    else {
      combi <- t(combn(unique_trts$value,2))
      a <- unique_trts[1:length(combi[1]),1:(ncol(unique_trts)-2)]
      a <- cbind(a,combi)
      tib_df <- rbind(tib_df,a)
    }
  }
  names(tib_df)[ncol(tib_df)-1] <- "from"
  names(tib_df)[ncol(tib_df)] <- "to"
  return(tib_df)
}
