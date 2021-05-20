# make into functions and roxygenize

#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

#meshterm by phase
meshterm_phase_barplot <- function (df) {
  
  by_meshterm_phase <- df %>% filter(!is.na(InterventionMeshTerm)) %>% 
    group_by(InterventionMeshTerm,Phase) %>% summarize(n = n())  %>%  
    arrange(desc(n),desc(Phase)) %>% head(40)

  by_meshterm_phase %>%
    ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = Phase, label = n)) +
    geom_bar(stat = "identity")+
    geom_text(size = 3, position = position_stack(vjust = 0.5)) +
    labs(title = "Groups of studies with the same \n Intervention MESH terms by Phase")+
    xlab("Intervention MESH Terms")+ylab("Count")+
    theme(plot.title = element_text(hjust = 0.8))+
    coord_flip()
  
}


#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

#meshterm by design purpose
meshterm_purpose_barplot <- function(df) {
  
  by_meshterm_purpose <- df %>%
  group_by(InterventionMeshTerm,DesignPrimaryPurpose) %>% summarize(n = n())  %>%
  arrange(desc(n)) %>% head(40)

  by_meshterm_purpose %>%
  ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = DesignPrimaryPurpose, label = n)) + #
  geom_bar(stat = "identity", position = "fill")+
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  labs(title = "")+
  xlab("")+ylab("")+
  theme(plot.title = element_text(hjust = 0.8))+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
  coord_flip()
  
}


#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

#meshterm by design allocation
meshterm_allocation_barplot <- function(df) {
  
  by_meshterm_allocation <- df  %>% group_by(InterventionMeshTerm,DesignAllocation) %>% summarize(n = n())  %>%  
  arrange(desc(n)) %>% head(40)

  by_meshterm_allocation %>%
  ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = DesignAllocation, label = n)) +
  geom_bar(stat = "identity", position = "fill")+
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  labs(title = "")+
  xlab("")+ylab("")+
  theme(plot.title = element_text(hjust = 0.8))+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
  coord_flip()

}


#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

#meshterm by data monitoring commitee
meshterm_dmc_barplot <- function(df) {
  
  by_meshterm_dmc <- df  %>% #%>% filter(!is.na(InterventionMeshTerm)) %>% 
  group_by(InterventionMeshTerm,OversightHasDMC) %>% summarize(n = n()) %>% arrange(desc(n)) %>% head(40)

  by_meshterm_dmc %>%
  ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = OversightHasDMC, label = n)) +
  geom_bar(stat = "identity", position = "fill")+
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  labs(title = "")+
  xlab("")+ylab("")+
  theme(plot.title = element_text(hjust = 0.8))+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
  coord_flip()
  
}

#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

#meshterm by overall study status
meshterm_status_barplot <- function(df) {
  
  by_meshterm_status <- df  %>% #%>% filter(!is.na(InterventionMeshTerm)) %>% 
  group_by(InterventionMeshTerm,OverallStatus) %>% summarize(n = n()) %>% arrange(desc(n)) %>% head(40)

  by_meshterm_status %>%
  ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = OverallStatus, label = n)) +
  geom_bar(stat = "identity", position = "fill")+
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  labs(title = "")+
  xlab("")+ylab("")+
  theme(plot.title = element_text(hjust = 0.8))+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
  coord_flip()

}


#' Plot MESH Term by 
#' @param df Dataframe with the results from searching clinicaltrials.gov
#' @keywords plot 

# meshterm by coindition
meshterm_condition_barplot <- function(df){
  
by_meshterm_condition <- df  %>% #  filter(!is.na(InterventionMeshTerm)) %>% 
  group_by(InterventionMeshTerm,Condition) %>% summarize(n = n()) %>% arrange(desc(n)) %>% head(25)

  by_meshterm_condition %>%
  ggplot(aes(x = reorder(InterventionMeshTerm,n), y = n, fill = Condition, label = n)) +
  geom_bar(stat = "identity", position = "fill")+
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  labs(title = "")+
  xlab("")+ylab("")+
  theme(plot.title = element_text(hjust = 0.8), legend.position = "bottom")+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
  coord_flip()
  
}
