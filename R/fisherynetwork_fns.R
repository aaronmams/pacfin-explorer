port.network <- function(port,fishery,yr){
  vessels <- unique(df$VESSEL_NUM[df$PORT.NAME==port & df$Fishery==fishery & df$PACFIN_YEAR==yr])
  port.df <- df %>% filter(VESSEL_NUM %in% vessels & PACFIN_YEAR==yr) %>% group_by(PORT.NAME,Fishery) %>%
    summarise(boats=n_distinct(VESSEL_NUM))
  return(port.df)
}