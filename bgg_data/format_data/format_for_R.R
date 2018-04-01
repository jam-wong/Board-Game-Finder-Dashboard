library(dplyr)
library(readr) # for read_csv (fixes encoding errors from read.csv)

dashboardDir <- file.path('D:', 'Programming Projects', 'Board-Game-Finder-Dashboard', 'dashboard')
dataDir <- file.path('D:', 'Programming Projects', 'Board-Game-Finder-Dashboard', 'bgg_data', 'data')

bgg_data <- read_csv(file.path(dataDir, 'board_game_geek_board_game_info.csv'))

bgg_data$bgg_url <- paste0("https://boardgamegeek.com/boardgame/", bgg_data$game_id)
bgg_data$path_to_image <- paste0("./thumbnails/", bgg_data$game_id, "t")
bgg_data$image <- NULL
bgg_data$thumbnail <- NULL

multiple_elements_variables <- c("boardgamesubdomain"
                                 , "boardgamecategory"
                                 , "boardgamemechanic"
                                 #, "boardgamepublisher"
                                 #, "boardgamedesigner"
                                 #, "boardgameartist"
                                 )

for (me_var in multiple_elements_variables){
  me_var %>% paste("=== Loop Element:", ., "===") %>% print
  list_var <- paste0(strsplit(me_var, "boardgame")[[1]][2], '_list')
  list_var %>% paste("Assigning", .) %>% print
  bgg_data[,list_var] <- bgg_data[,me_var] %>% lapply(., strsplit, ";")

  unique_var <- paste0("unique_", strsplit(me_var, "boardgame")[[1]][2])
  unique_var %>% paste("Assigning", .) %>% print
  assign(unique_var, bgg_data[,me_var] %>% lapply(., strsplit, ";") %>% unlist %>% unique %>% sort)
  bgg_data[,me_var] %>% lapply(., strsplit, ";") %>% unlist %>% unique %>% length %>% paste("Unique elements:", .) %>% print
  
  bgg_data[,me_var] <- lapply(bgg_data[,me_var], gsub, pattern=";", replacement=', ')
  print ("")
}

source(file.path('D:', 'Programming Projects', 'Board-Game-Finder-Dashboard', 'bgg_data', 'format_data', 'display_functions.R'))
bgg_data$stars <- lapply(bgg_data$average, display_stars_rating) %>% unlist
bgg_data$display_playing_time <- lapply(bgg_data$playingtime, display_playing_time) %>% unlist
bgg_data$display_player_number <- mapply(display_player_number, minplayers = bgg_data$minplayers, maxplayers = bgg_data$maxplayers)
bgg_data$display_game_honors <- mapply(display_game_honors, num_game_honor = bgg_data$boardgamehonor)

save(bgg_data
     , unique_subdomain
     , unique_category
     , unique_mechanic
     #, unique_publisher 
     #, unique_designer
     #, unique_artist
     , file = file.path(dashboardDir, "bgg.RData"))
