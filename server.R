server <- function(input, output, session) {
  session$onSessionEnded(stopApp)

  
    filtered_data <- reactive({
      
      b <- filter_on_name_string(input$textStringName, bgg_data)
      
      b <- filter_on_player_number(input$selectNumPlayers, b)
      
      b <- filter_on_playing_time(input$checkboxPlayingTime, b)
      
      b <- filter_on_subdomain(input$select2Subdomain, b)
      
      b <- filter_on_category(input$select2Category,b)
      
      b <- filter_on_mechanic(input$select2Mechanic,b)
      
      #b <- filter_on_year_published(input$selectYearPublished, b)
      
      max_pages <- ceiling(nrow(b)/games_per_page)
      b$page_num <- rep(1:max_pages, each = games_per_page, len = nrow(b))
      
      updatePageruiInput(session, 'top', pages_total = max_pages)
      
      if (input$top[['page_current']] > input$top[['pages_total']]) {
        updatePageruiInput(session, 'top', page_current = max_pages)
      } else if (input$top[['page_current']] == 0 & input$top[['pages_total']] != 0) {
        updatePageruiInput(session, 'top', page_current = 1)
      }
      
      subset(b, page_num == input$top[['page_current']])
    })
  
    # output$cp <- renderText(paste("Current Page:", input$top[['page_current']]))
    # output$pt <- renderText(paste("Max Page:", input$top[['pages_total']]))
  
    output$tiles <- renderUI({
      fluidRow(
        column(12, id = "columns",
          lapply(filtered_data()$game_id, function(id) {
            a(box(width=NULL,
                  title = HTML(paste0("<div class='image-wrap'><img src='./",
                                        return_df_column('path_to_image', id, filtered_data()), ".jpg' class='fixed-width'>",
                                        "<span class='tooltiptext'>",
                                          make_tool_tip(id, filtered_data()),
                                        "</span>",
                                      "</div>", 
                                      "<strong><div class='box-display-name' style='font-size: 11pt;'>", 
                                        return_df_column('name', id, filtered_data()),
                                      "</div></strong>",
                                      "<div class='game-info' style='font-size: 10pt;'>", 
                                        "<div>Rank #", return_df_column('rank', id, filtered_data()), "</div>", 
                                        "<div>",return_df_column('display_player_number', id, filtered_data()), "</div>",
                                        "<div>",return_df_column('display_playing_time', id, filtered_data()), "</div>",
                                        "<div class='gamehonors'>",return_df_column('display_game_honors', id, filtered_data()),
                                          "<span class='honorstooltip'></span></div>",
                                      "</div>",
                                      "<span>",
                                        return_df_column('stars', id, filtered_data()),
                                        "<span style='font-size: 7pt;'>",
                                          return_df_column('usersrated', id, filtered_data()) %>% unlist %>% formatC(big.mark = ","),
                                        "</span>",
                                      "</span>"
                                      ))
              ), href= return_df_column('bgg_url', id, filtered_data()), target="_blank")
          })
               
        )
      )
    })

    # output$table1 <- DT::renderDataTable(
    #   filtered_data() %>%
    #     select (game_id, page_num, name, yearpublished, minplayers, maxplayers, playingtime, age, category_list,
    #             designer_list, artist_list) %>%
    #     datatable(rownames = FALSE)
    # )

    

}
