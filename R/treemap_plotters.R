# Univariable treemaps

#' Plot Gender variable
#'
#' This function takes the set dataframe and plots the gender variable as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot gender

gender_map <- function (df){
    df %>% group_by(Gender) %>% summarise(n = n()) %>%
    ggplot(aes(fill = reorder(Gender,desc(n)), area = n, label = n)) +
    geom_treemap() + 
    geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
    labs(title = "Sex/Gender Eligibility Criteria", fill = "")+
    scale_fill_brewer(palette = "Dark2")
}

#' Plot Study Type variable
#'
#' This function takes the set dataframe and plots the study type variable as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot StudyType

studytype_map <-function(df) { 
    df %>% group_by(StudyType) %>% summarise(n = n()) %>%
    ggplot(aes(fill = reorder(StudyType,desc(n)), area = n, label = n)) +
    geom_treemap() + 
    geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
    labs(title = "Study Type", fill = "")+
    scale_fill_brewer(palette = "Dark2")
}

#' Plot Condition variable
#'
#' This function takes the set dataframe and plots the condition variable as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot Condition

condition_map <- function (df) {
  df %>% group_by(Condition) %>% summarise(n = n()) %>% arrange(desc(n)) %>% head(15) %>%
  ggplot(aes(area = n, label = n,fill = reorder(Condition,desc(n)))) +
  geom_treemap() + 
  geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
  labs(title = "Conditions Studied", fill = "")+
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(15))
}

#' #' Plot AgeRange variable
#'
#' This function takes the set dataframe and plots the result of collapsing MinAge 
#' and MaxAge variables as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot MinAge MaxAge AgeRange

agerange_map <- function (df) {
  df %>% group_by(AgeRange) %>% summarise(n = n()) %>% arrange(desc(n)) %>% head(15) %>%
  ggplot(aes(area = n, label = n,fill = reorder(AgeRange,desc(n)))) +
  geom_treemap() + 
  geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
  labs(title = "Age Range Criteria", fill = "")+
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(15))
}

#' 
#' #' Plot OverallStatus variable
#'
#' This function takes the set dataframe and plots the overall status variable as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot OverallStatus

overallstatus_map <- function (df) {
  df %>% group_by(OverallStatus) %>% summarise(n = n()) %>% arrange(desc(n)) %>% head(15) %>%
  ggplot(aes(area = n, label = n,fill = reorder(OverallStatus,desc(n)))) +
  geom_treemap() + 
  geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
  labs(title = "Overall Study Status", fill = "")+
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(15))
}

#' #' Plot Phase variable
#'
#' This function takes the set dataframe and plots the phase variable as a treemap.
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot Phase

phase_map <- function(df) {
  df %>% group_by(Phase) %>% summarise(n = n()) %>% arrange(desc(n)) %>%
  ggplot(aes(area = n, label = n,fill = Phase)) +
  geom_treemap() + 
  geom_treemap_text(fontface = "italic", colour = "white", place = "centre", grow = FALSE) +
  labs(title = "Study Phase", fill = "")+
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(15))
}