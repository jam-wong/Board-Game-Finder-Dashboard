display_game_honors <- function(num_game_honor) {
  return(paste0(num_game_honor, "<img src='./icons/medal.png'>"))
}

display_player_number <- function(minplayers, maxplayers) {
  if (minplayers != maxplayers) {
    players_string <- paste0(minplayers, '-', maxplayers, "<img src='./icons/person.png'>")
  } else if (minplayers == maxplayers) {
    if (minplayers != 1) {
      players_string <- paste0(minplayers, "<img src='./icons/person.png'>")
    } else {
      players_string <- paste0(minplayers, "<img src='./icons/person.png'>")
    }
  }
  
  return(players_string)
}

display_playing_time <- function(playingtime) {
  hrs_string <- playingtime %/% 60
  mins_string <- playingtime %% 60
  
  if (hrs_string < 1) {
    
    playing_time_string <- paste0("<img src='./icons/time.png'>", mins_string, "m")
  } else if (mins_string < 1) {
    playing_time_string <- paste0("<img src='./icons/time.png'>", hrs_string, "hr")
  } else {
    playing_time_string <- paste0("<img src='./icons/time.png'>", hrs_string, "hr ", mins_string, "m")
  }
  
  return(playing_time_string)
}

display_stars_rating <- function(rating) {
  rounded_rating <- round(rating / 0.25) * 0.25
  split_rating <- strsplit(as.character(rounded_rating), '\\.')
  int_num <- as.numeric(split_rating[[1]][1])
  
  output_code <- ""
  output_code <- paste0(output_code, paste0(replicate(int_num, "<img src='./icons/star1.png'>"), collapse = ""))
  
  if (length(split_rating[[1]]) > 1) {
    output_code <- paste0(output_code, "<img src='./icons/star", split_rating[[1]][2], ".png'>")
    num_blank_stars <- 10 - (int_num + 1)
  } else {
    num_blank_stars <- 10 - int_num
  }
  
  output_code <- paste0(output_code, paste0(replicate(num_blank_stars, "<img src='./icons/star0.png'>"), collapse = ""))
  
  return(output_code)
}