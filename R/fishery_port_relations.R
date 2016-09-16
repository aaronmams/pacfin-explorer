
source("R/fisherynetwork_datapull.R")
source("R/fisherynetwork_fns.R")

port.df <- port.network(port="FORT BRAGG",fishery="D.CRAB POT",yr=2012)

ggplot(port.df,aes(x=Fishery,y=PORT.NAME)) + 
  geom_tile(aes(fill=boats),colour="white")+
  scale_fill_gradient(low="gray",high="steelblue") + 
  theme_bw() + 
  theme(axis.text.x=element_text(angle=45,size=8),
        axis.text.y=element_text(size=8)) + 
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) 


port.df <- port.network(port="MORRO BAY",fishery="SABLEFISH POT",yr=2013)

ggplot(port.df,aes(x=Fishery,y=PORT.NAME)) + 
  geom_tile(aes(fill=boats),colour="white")+
  scale_fill_gradient(low="gray",high="steelblue") + 
  theme_bw() + 
  theme(axis.text.x=element_text(angle=45,size=8),
        axis.text.y=element_text(size=8)) + 
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) 



port.df1 <- port.network(port="MOSS LANDING",fishery="CPS SEINE",yr=2005)
port.df1$ref="ML CPS"
port.df2 <- port.network(port="MOSS LANDING",fishery="SALMON TROLL",yr=2005)
port.df2$ref="ML SALMON TROLL"

port.df <- data.frame(rbind(port.df1,port.df2))

ggplot(port.df,aes(x=Fishery,y=PORT.NAME)) + 
  geom_tile(aes(fill=boats),colour="white")+
  scale_fill_gradient(low="gray",high="steelblue") + 
  facet_wrap(~ref) + 
  theme_bw() + 
  theme(axis.text.x=element_text(angle=45,size=8),
        axis.text.y=element_text(size=8)) + 
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  ylab("Port")