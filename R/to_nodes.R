#' To Nodes
#'
#' Takes data frame with edges and extracts a node dataframe
#' to_nodes(edges)
#' @param df a dataframe to manipulate
#' @export
#' @examples
#' to_nodes(edges)

to_nodes <- function(edges) {
  nodes <- data.frame( label = unlist(c(edges$from,edges$to)),
                       id = unlist(c(edges$from,edges$to)),
                       pats = edges$EnrollmentCount/edges$n_trts)

  nodes <- nodes %>% group_by(label,id) %>% dplyr::summarize(value = round(sum(pats))) %>% ungroup()
  nodes <- nodes %>% mutate(title = paste0("Approx. ", as.numeric(nodes$value),"\n patients received this treatment"))
  nodes$group <- group_str(nodes$label, precision = 5, strict = FALSE, remove.empty = FALSE)
  return(as.data.frame(nodes))
}
