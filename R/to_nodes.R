#' To Nodes
#'
#' Takes data frame with edges and extracts a node dataframe
#' to_nodes(edges)
#' @param df a dataframe to manipulate
#' @examples
#' to_nodes(edges)

to_nodes <- function(edges) {
    nodes <- data.frame( label = unlist(c(edges$from,edges$to)),
                         id = unlist(c(edges$from,edges$to)))
    nodes <- nodes %>% group_by(label,id) %>% dplyr::summarize(value = n()) %>% ungroup()
    nodes <- nodes %>% mutate(title = paste0("Appears ", nodes$value," times in edge list"))
    nodes$group <- group_str(nodes$label, precision = 5, strict = FALSE, remove.empty = FALSE)
    return(as.data.frame(nodes))
}