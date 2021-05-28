server = function(input, output, session) {
    
    # buttons events
    observeEvent(input$help_link, {
        newvalue <- "?"
        updateTabItems(session, "panels", newvalue)
    })
    
    # Generate data summaries
    output$summary <- renderPrint({
        summary(df)
    })
    output$str <- renderPrint({
        str(df)
    })
    # Get head of selected data
    output$snippet <- renderPrint({
        head(df, n = 15)
    })
    
    # data table output
    output$df<- DT::renderDataTable({
        DT::datatable(
            df[, input$show_vars, drop = FALSE],
            selection = list(target = 'row+column'),
            filter = 'top',
            extensions = "Buttons",
            
            options = list(
                lengthMenu = c(10, 50, 100, 200, length(df$NCTId)),
                pageLength = 10,
                initComplete = JS(
                    "function(settings, json) {",
                    "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                    "}"),
                dom = 'Blfrtip',
                buttons = c('copy', 'csv', 'excel', 'pdf'),
                searchHighlight = TRUE,
                server = TRUE)
        )
    })
    # PLOTS
    # univariate plots
    output$univariate_plot <- renderPlot({
        
        tree_dat <- df %>% group_by(across(input$treemap_var)) %>% summarise(n = n())
        
        treemap(tree_dat,
                index=input$treemap_var,
                vSize="n",
                type="index",
                title = input$treemap_var,
                title.legend = input$treemap_var,
                algorithm = "pivotSize",# "squarified"
                sortID = "size",
                palette = "HCL",
                draw = TRUE
        )
    })
    
    output$univariate_table <- renderDataTable({
        
        uni_dat <- df %>% group_by(across(input$treemap_var)) %>% summarise(n = n())
        datatable(uni_dat)
        
    })
    
    # bivariate plots
    
    output$bivariate_plot <- renderPlot({
        
        biv_dat <- df %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>% summarise(n = n())  %>%
            arrange(desc(n)) %>% head(40) %>% ungroup()
        
        if (input$n_pct == "count") {
            ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n")) +
                geom_bar(stat = "identity")+
                geom_text(size = 4, position = position_stack(vjust = 0.5)) +
                labs(title = "")+
                xlab(input$biv_1)+ylab("Count")+
                theme(plot.title = element_text(hjust = 0.8))+
                coord_flip()
        } else {
            ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n")) +
                geom_bar(stat = "identity", position = "fill")+
                geom_text(size = 4, position = position_fill(vjust = 0.5)) +
                labs(title = "")+
                xlab(input$biv_1)+ylab("Percentage")+
                theme(plot.title = element_text(hjust = 0.8))+
                scale_y_continuous(labels = function(x) paste0(x*100, "%"))+
                coord_flip()
        }
        
    })
    
    output$bivariate_table <- renderDataTable({
        
        biv_dat <- df %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>%
            summarise(n = n()) %>%  arrange(desc(n))
        
        datatable(biv_dat)
        
    })
    
    output$scatter_plot <- renderPlotly({
        # think of filtering first
        
        p <- df %>%
            ggplot(aes_string(x = "EnrollmentCount",
                              y = input$scatter_group,
                              color = input$scatter_colour))+
            geom_point(position = "jitter", inherit.aes = T)+
            scale_y_discrete(label=abbreviate)
        
        ggplotly(p)
        
    })
    
    output$missing_data_plot <- renderPlot({
        
        gg_miss_var(df)
        
    })
    
    
    
    
}