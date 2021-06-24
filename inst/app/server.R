
server = function(input, output, session) {


    # select deselect reset columns to show
  observe({
    if (input$select_all > 0) {
      if (input$select_all %% 2 == 0){
        updateCheckboxGroupInput(session=session, inputId="show_vars",
                                 choices = c(names(df)),
                                 selected = c(names(df)))

      }
      else {
        updateCheckboxGroupInput(session=session, inputId="show_vars",
                                 choices = c(names(df)),
                                 selected = "")

      }}
  })

  observe({
    if (input$reset > 0) {
      updateCheckboxGroupInput(session=session, inputId="show_vars",
                               choices = c(names(df)),
                              selected = selected_cols)
    }
  })

    # Generate data summaries
    output$summary <- renderPrint({
        summary(df[input$df_table_rows_all,])
    })
    output$str <- renderPrint({
        str(df)
    })
    # Get head of selected data
    output$snippet <- renderPrint({
        head(df[input$df_table_rows_all,], n = 15)
    })

    # data table output
    output$df_table <- DT::renderDataTable({
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
    # One variable
    output$univariate_plot <- renderPlot({

        tree_dat <- df[input$df_table_rows_all,] %>% group_by(across(input$treemap_var)) %>% summarise(n = n())

        treemap(tree_dat,
                index=input$treemap_var,
                vSize="n",
                type="index",
                title = input$treemap_var,
                title.legend = NA,
                algorithm = "pivotSize",
                sortID = "size",
                palette = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))(length(levels(df[,input$treemap_var]))),
                draw = TRUE
        )
    })

    output$univariate_table <- renderDataTable({

        uni_dat <- df[input$df_table_rows_all,] %>% group_by(across(input$treemap_var)) %>% summarise(n = n()) %>%
          mutate("%"  = round(n*100/sum(n),2))
        datatable(uni_dat)

    })

    # Two variables

    biv_data <- reactive({

      biv_data <- df[input$df_table_rows_all,] %>% group_by(across(.cols = c(input$biv_1, input$biv_2))) %>%
          summarise(n = n())  %>% arrange(desc(n)) %>% ungroup()

      if (input$filter_nas == "Hide") {na.omit(biv_data,c(input$biv_1))} else {biv_data}


    })



    #plot
    output$bivariate_plot <- renderPlot({


        biv_dat <- biv_data() %>% head(40)

        p <- ggplot(biv_dat,aes(x = reorder(!!sym(input$biv_1),-n), y = n, fill = !!sym(input$biv_2), label = n))

          if (input$n_pct == "Stack") {
           p <- p +  geom_bar(stat = "identity", position = "stack") +
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

            scale_y_discrete(expand = expansion(mult = c(0,0))) +
            scale_x_discrete(limits = rev)+
            scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))
                              (length(levels(as.factor(df[,input$biv_2])))),na.value = "grey") +
            coord_flip()
          p


    }, height = 600)

    output$bivariate_table <- renderDataTable({

        biv_table <- biv_data() %>% mutate("%"  = round(n*100/sum(n),2))

        datatable(biv_table)

    })

    #scatter plot

    output$scatter_plot <- renderPlotly({

        p <- df[input$df_table_rows_all,] %>%
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

      scatt_dat <- df[input$df_table_rows_all,] %>% group_by(across(.cols = c(input$scatter_colour))) %>%
        summarise(n = n())

      ggplot(scatt_dat, aes_string(x = input$scatter_colour,
                                   y = "n", fill = input$scatter_colour,  label = "n")) +
        geom_col() +
        geom_text(aes(label = n), hjust = -.2, size = 4) +

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

         scale_fill_manual(values = colorRampPalette(brewer.pal(n = 8, name = "Dark2"))
                           (length(levels(as.factor(df[,input$scatter_colour])))),
                           na.value = "grey") +
        coord_flip()

      }, height = 600)#

  na_data <- reactive ({

   na_dat <- df[input$df_table_rows_all,] %>% map_df(~sum(is.na(.))) %>%
      pivot_longer(cols = names(df),
                   names_to = "Field",
                   values_to = "Missing") %>%
      mutate(PercentMissing = round(Missing*100/nrow(df),2)) %>%
     arrange(Missing) %>%
     mutate(Field = factor(Field,levels = Field)) %>%
     mutate(PctNA = ifelse(PercentMissing >= 75,'> 75%',
                           ifelse(PercentMissing >= 50,'> 50%',
                                  ifelse(PercentMissing >= 25,'> 25%',
                                         ifelse(PercentMissing >= 0,'> 0%',NA)))))



  })

    output$missing_data_plot <- renderPlot({


    p <- na_data() %>% ggplot(aes(x=Field, y=PercentMissing)) +
        geom_segment(aes(x=Field, xend=Field, y=0, yend = PercentMissing, color = PctNA),
                     size = 1, alpha =0.9)+
      geom_point(size=3, color="black", alpha = 0.9) +

      theme_light()+
      theme(
        legend.position = "none",
        panel.border = element_blank()
      )+
      coord_flip()

    p


    }, height = 600)
  output$missing_data_table <- renderDataTable({

    na_data() %>% arrange(desc(Missing))

    })
}



