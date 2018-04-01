dashboardPage(
  skin = "black",
  
  dashboardHeader(
    title = "Board Game Finder"
  ),
  
  dashboardSidebar(
    includeCSS("www/css/styles.css"),
    
    sidebarMenu(
      textInput(inputId = "textStringName", label = "Title Contains:",
                placeholder = "ex. Fight"),
      
      selectInput(inputId = "selectNumPlayers", label = "Number of Players",
                     choices = num_player_options),
      
      checkboxGroupInput(inputId = "checkboxPlayingTime", label = "Game Length",
                         choices = num_playing_time_options),
      
      column(12, select2Input("select2Subdomain", strong("Subdomain"), choices = unique_subdomain, type = c("input", "select"))),
      br(),br(),br(),br(),

      column(12, select2Input("select2Category", strong("Category"), choices=unique_category, type = c("input", "select"))), 
      br(),br(),br(),br(),
      
      column(12, select2Input("select2Mechanic", strong("Mechanic"), choices=unique_mechanic, type = c("input", "select"))),
      br(),br(),br(),br()
    ) 
  ),
  
  dashboardBody(
    fluidRow(
      column(width = 12, 
        div(style = "float: right;",
          pageruiInput('top', page_current = 1, pages_total = ceiling(nrow(bgg_data)/games_per_page))
        )
      )
    ),
      
    uiOutput("tiles")      
  )
)


