return_df_column <- function(column, id, df) {
  return(df[which(df$game_id == id), column])
}

make_tool_tip <- function(id, df) {
  
  s <- paste0(
    strong(return_df_column('name', id, df)), br(),br(),
    "<div style='font-size: 9pt;' align='left'>",
    "<strong><u>Subdomains</strong></u>: ", return_df_column('boardgamesubdomain', id, df),br(),
    "<strong><u>Category</strong></u>: ", return_df_column('boardgamecategory', id, df),br(),
    "<strong><u>Mechanic</strong></u>: ", return_df_column('boardgamemechanic', id, df),br(),br(),
    "</div>",
    "<div style='font-size: 8pt;'>", 
    "<strong><u>Description</strong></u>: ", return_df_column('description', id, df),
    "</div>")
  return(s)
}