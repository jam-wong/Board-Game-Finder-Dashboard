
filter_on_name_string <- function(string_name_input, data) {
  
  if (trimws(string_name_input) == '') {
    data %>% return
  } else {
    data %>% filter(grepl(string_name_input, name, ignore.case = TRUE)) %>% return
  }
}

filter_on_player_number <- function(player_number_input, data) {
  
  data_to_return <- reactive({
    
    if (player_number_input == '') {
      data %>% return
    } else if (player_number_input == '8+') {
      data %>% filter(maxplayers >= 8) %>% return
    } else {
      data %>% filter(minplayers <= as.integer(player_number_input),
                      maxplayers >= as.integer(player_number_input)) %>% return
    }
    
  })
  
  return(data_to_return())
}

filter_on_playing_time <- function(playing_time_inputs, data) {
  
  data_to_return <- reactive({
    if (is.null(playing_time_inputs)) {
      data
    } else { ### if input is not null
      
      if ("< 30 mins" %in% playing_time_inputs) {
        d1 <- data %>% filter(playingtime <= 30) 
      } else {
        d1 <- NULL
      }
      
      if ("30 - 60 mins" %in% playing_time_inputs) {
        d2 <- data %>% filter(30 < playingtime, playingtime <= 60)
      } else {
        d2 <- NULL
      }
      
      if ("60+ mins" %in% playing_time_inputs) {
        d3 <- data %>% filter(playingtime > 60)
      } else {
        d3 <- NULL
      }
      
      rbind(d1, d2, d3)
    }
  })
  
  return(data_to_return())
}

filter_on_subdomain <- function(subdomain_inputs, data) {
  
  data_to_return <- reactive({
    if (is.null(subdomain_inputs)) {
      data
    } else { ### if input is not null
      
      data %>% filter(lapply(subdomain_list, is.subset, x = subdomain_inputs) %>% unlist)
    }
  })
  
  return(data_to_return())
}

filter_on_category <- function(category_inputs, data) {
  
  data_to_return <- reactive({
    if (is.null(category_inputs)) {
      data
    } else { ### if input is not null
      
      data %>% filter(lapply(category_list, is.subset, x = category_inputs) %>% unlist)
    }
  })
  
  return(data_to_return())
}

filter_on_mechanic <- function(mechanic_inputs, data) {
  
  data_to_return <- reactive({
    if (is.null(mechanic_inputs)) {
      data
    } else { ### if input is not null
      
      data %>% filter(lapply(mechanic_list, is.subset, x = mechanic_inputs) %>% unlist)
    }
  })
  
  return(data_to_return())
}


filter_on_year_published <- function(year_published_input, data) {
  
  data_to_return <- reactive({
    
    if (year_published_input == '') {
      data %>% return
    } else if (year_published_input == '< 1980') {
      data %>% filter(yearpublished < 1980) %>% return
    } else {
      data %>% filter(yearpublished >= as.integer(year_published_input),
                      yearpublished < as.integer(year_published_input)+10) %>% return
    }
    
  })
  
  return(data_to_return())
}