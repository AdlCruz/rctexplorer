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
                title.legend = NA,
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

        p <- ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n"))

          if (input$n_pct == "count") {
           p <- p +  geom_bar(stat = "identity") +
             geom_text(size = 4, position = position_stack(vjust = 0.5))}
        else {
          p <- p + geom_bar(stat = "identity", position = "fill") +
            geom_text(size = 4, position = position_fill(vjust = 0.5))}

          p <- p + theme(
                plot.title = element_text(hjust = 0.8),
                text = element_text(size = 13),
                axis.title.x = element_blank(),axis.title.y = element_blank(),
                legend.position = "top", legend.title = element_blank(),
                panel.background = element_blank(),panel.border = element_rect(linetype = "solid", fill = NA),
                panel.grid.major = element_line(colour = "grey"),
                plot.margin = margin(0,0.1,0,0.25,"cm")) +
            scale_y_discrete(expand = c(0,0)) +
            scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(length(levels(df[,input$biv_2]))),
                              na.value = "grey") +
            coord_flip()
          p


    }, height = 600)

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
