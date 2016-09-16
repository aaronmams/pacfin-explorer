library(RODBC)
library(dplyr)
library(ggplot2)

pacfin_logon <- read.csv("C:/Users/aaron.mamula.SWFSC/Desktop/pacfin_logon.csv")
pacfin_uid <- pacfin_logon$uid
pacfin_pw <- pacfin_logon$pw

#pull count of vessels by fishery and port
channel<- odbcConnect(dsn="pacfin",uid=paste(pacfin_uid),pw=paste(pacfin_pw),believeNRows=FALSE)
t <- Sys.time()
df <- sqlQuery(channel,paste("select PACFIN_YEAR, VESSEL_NUM, PACFIN_PORT_CODE,THOMSON_FISHERY_CODE,count(distinct FTID)",
                             "from PACFIN_MARTS.SWFSC_FISH_TICKETS",
                             "where PACFIN_YEAR > 2003",
                             "group by PACFIN_YEAR,VESSEL_NUM, PACFIN_PORT_CODE, THOMSON_FISHERY_CODE"
))
Sys.time() - t
close(channel)

df <- tbl_df(df) %>% arrange(PACFIN_YEAR,VESSEL_NUM,THOMSON_FISHERY_CODE,PACFIN_PORT_CODE)


#we could probably read this in as a .csv or something but I'll hard-code it for now:
f.codes <- data.frame(THOMSON_FISHERY_CODE=c(0:42),Fishery=c('OTH','D.CRAB POT','O.CRAB POT','LOBSTER POT','PRAWN POT',
                                                             'P.SHRIMP TWL','PRAWN TWL','WHITING TWL','DTS TWL',
                                                             'O.GRND TWL','SABLEFISH POT','SABLEFISH HKL','NS ROCK POT',
                                                             'NS ROCK HKL','NNS ROCK POT','NNS ROCK HKL','HALIBUT HKL',
                                                             'HALIBUT TWL','HALIBUT NET','STURGEON NET','SALMON TROLL',
                                                             'SALMON NET','SQD SEINE','CPS SEINE','P.HERRING','WS BASS',
                                                             'TUNA TROLL','TUNA SEINE','SHARK NET','HAGFISH POT',
                                                             'SWRD NET','SWRD OTH','CLAM DREDGE','CLAM/SCALLOP OTH',
                                                             'OYSTER','SCALLOP TWL','ABALONE','URCHIN','SEA CUCUMBER',
                                                             'GRND GILLNET','GRND LINE','BAIT SHRIMP MSC','BAIT SHRIMP OTH'))

df <- df %>% inner_join(f.codes,by="THOMSON_FISHERY_CODE")

#reorder ports using north to south designation
ports.ns <- read.csv("data/lbk_port_locs.csv", strip.white=TRUE)
ports.ns <- ports.ns[ports.ns$PCID%in%unique(df$PACFIN_PORT_CODE),c('LAT','PCID','NS.rank','PORT.NAME')]
ports.ns <- ports.ns[!duplicated(ports.ns$PCID),]

ports.ns <- ports.ns[order(ports.ns$LAT),]
ports.ns$ns <- c(1:length(unique(ports.ns$PCID)))

#merge port description
names(df) <- c('PACFIN_YEAR','VESSEL_NUM','PCID','THOMSON_FISHERY_CODE','FTID','Fishery')
df <- df %>% inner_join(ports.ns,by='PCID')

df$PORT.NAME <- factor(df$PORT.NAME,levels=ports.ns$PORT.NAME)
