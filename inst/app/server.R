




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
                palette = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(length(levels(df[,input$treemap_var]))),
                draw = TRUE
        )
    })

    output$univariate_table <- renderDataTable({

        uni_dat <- df %>% group_by(across(input$treemap_var)) %>% summarise(n = n()) %>%
          mutate("%"  = round(n*100/sum(n),2))
        datatable(uni_dat)

    })

    # bivariate plots
    #
    biv_data <- reactive({

      biv_data <- df %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>%
          summarise(n = n())  %>% arrange(desc(n)) %>% ungroup()

      if (input$filter_nas == "Hide") {na.omit(biv_data,c(input$biv_1))} else {biv_data}


    })

    output$bivariate_plot <- renderPlot({

        # if input selected
        biv_dat <- biv_data() %>% head(40)

        p <- ggplot(biv_dat,aes_string(x = input$biv_1, y = "n", fill = input$biv_2, label = "n"))

          if (input$n_pct == "Count") {
           p <- p +  geom_bar(stat = "identity") +
             geom_text(size = 4, position = position_stack(vjust = 0.5))
             }
        else {
          p <- p + geom_bar(stat = "identity", position = "fill") +
            geom_text(size = 4, position = position_fill(vjust = 0.5))
            }

           p <- p +
             theme(plot.title = element_text(hjust = 0.8),
                 text = element_text(size = 13),
                 axis.title.x = element_blank(),axis.title.y = element_blank(),
                 legend.position = "top", legend.title = element_blank(),
                 panel.background = element_rect(fill = "gray95"),
                 panel.border = element_rect(linetype = "solid", fill = NA),
                 panel.grid.major = element_line(colour = "grey"),
                 plot.margin = margin(0,0.1,0,0.25,"cm")) +

            scale_y_discrete(expand = expansion(mult = c(0,0))) + scale_x_discrete()+
            scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))
                              (length(levels(as.factor(df[,input$biv_2])))),na.value = "grey") +
            coord_flip()
          p


    }, height = 600)

    output$bivariate_table <- renderDataTable({

        biv_table <- biv_data() %>% mutate("%"  = round(n*100/sum(n),4))

        datatable(biv_table)

    })

    #scatter plot

    output$scatter_plot <- renderPlotly({

        p <- df %>%
          filter(EnrollmentCount <= input$sliderEnrollment[2] & EnrollmentCount >= input$sliderEnrollment[1]) %>%
            ggplot(aes_string(x = "EnrollmentCount",
                              y = input$scatter_group,
                              color = input$scatter_colour))+
            geom_point(position = "jitter", inherit.aes = T)+
          # can add more things for tooltip with aes(text = ?
            scale_y_discrete(label=abbreviate) +
          scale_color_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))
                            (length(levels(as.factor(df[,input$scatter_colour])))),na.value = "grey")+
          theme(axis.title.x = element_blank(),axis.title.y = element_blank(),
                legend.position = "right", legend.title = element_blank(),
                panel.background = element_rect(fill = "gray95"),
                panel.border = element_rect(linetype = "solid", fill = NA),
                panel.grid.major = element_line(colour = "grey")
                )

        ggplotly(p, height = 650, tooltip = c("x","y",input$scatter_colour))

    })

    output$scatter_groups <- renderPlot({

      scatt_dat <- df %>% group_by(across(.cols = c(input$scatter_colour))) %>%
        summarise(n = n())

      ggplot(scatt_dat, aes_string(x = input$scatter_colour,
                                   y = "n", fill = input$scatter_colour,  label = "n")) +
        geom_col() +
        geom_text(aes(label = n), hjust = -.2, size = 4) +

        scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))
                          (length(levels(df[,input$scatter_colour]))),
                          na.value = "grey") +
        theme(
          text = element_text(size = 13),
          axis.title.x = element_blank(),axis.title.y = element_blank(),
          axis.text.y = element_blank(), axis.ticks.y = element_blank(),
          legend.position = "none", #legend.title = element_blank(),legend.direction = "vertical",
          panel.background = element_rect(fill = "gray95"),
          panel.border = element_rect(linetype = "solid", fill = NA),
          panel.grid.major = element_line(colour = "grey"), plot.margin = margin(0.7,0.5,0,0,"cm")
        )+
        scale_y_discrete(expand = expansion(mult = c(0, .08)))+
        scale_x_discrete(limits = rev)+
        coord_flip()

      }, height = 600)#



    output$missing_data_plot <- renderPlot({

        #df %>%
        gg_miss_var(df)

    })




}
