library(DT)
library(shiny)
library(dplyr)
library(rje) #for is.subset()
library(shinysky) #devtools::install_github("AnalytixWare/ShinySky")
library(readr)
library(shinyjs)
library(shinydashboard)

source(file.path('www', 'scripts', 'pagerui.R'))
source(file.path('www', 'scripts', 'filter_functions.R'))
source(file.path('www', 'scripts', 'helper.R'))

load(file = "bgg.RData")

games_per_page <- 20
num_player_options <- c("", 1, 2, 3, 4, 5, 6, 7, '8+')
num_playing_time_options <- c("< 30 mins", "30 - 60 mins", "60+ mins")