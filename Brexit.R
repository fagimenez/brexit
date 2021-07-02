#Brexit Vote -----------------------------------------------

#This code draws a map of the 2016 Brexit Referendum in the UK using data from the UK Electoral Commission

install.packages("tidyverse")
install.packages("sf")
install.packages("raster")
install.packages("dplyr")
install.packages("spData")
install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source')
install.packages("tmap")
install.packages("leaflet")
install.packages("ggplot2")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("rgeos")


library(tidyverse)
library(sf)
library(raster)
library(dplyr)
library(spData)
library(spDataLarge)
library(tmap)
library(leaflet)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)


uk <- readRDS(gzcon(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_GBR_3_sf.rds")))

ni <- readRDS(gzcon(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_GBR_1_sf.rds")))

brexit <-read.csv("https://www.electoralcommission.org.uk/sites/default/files/2019-07/EU-referendum-result-data.csv")

uk <- uk[ -c(1:3,5:9, 11:16) ]

ni <- ni[ -c(1:3,5:10) ]

brexit <- brexit[ -c(1:4, 6:18) ]

ni <- ni %>% 
  rename(Area = NAME_1)

ni <- ni %>% 
  filter(Area == "Northern Ireland")

uk <- uk %>% 
  rename(Area = NAME_3) 

uk <- uk %>% 
  rename(Country = NAME_1)

uk <- uk %>% 
  filter(Country != "Northern Ireland")

uk <- uk[ -c(1) ]

uk <- uk %>% 
  mutate(Area = dplyr::recode(Area, `London` = "City of London",
                                    `Aberdeen` = "Aberdeen City",
                                    `Anglesey` = "Isle of Anglesey",
                                    `Edinburgh` = "City of Edinburgh",
                                    `Bristol` = "Bristol, City of",
                                    `Dundee` = "Dundee City",
                                    `Durham` = "County Durham",
                                    `Glasgow` = "Glasgow City",
                                    `Herefordshire` = "Herefordshire, County of",
                                    `Kingston upon Hull` = "Kingston upon Hull, City of",
                                    `Suffolk coastal` = "Suffolk Coastal",
                                    `Saint Helens` = "St. Helens",
                                    `Saint Edmundsbury` = "St Edmundsbury",
                                    `Saint Albans` = "St Albans",
                                    `Rhondda, Cynon, Taff` = "Rhondda Cynon Taf",
                                    `Perthshire and Kinross` = "Perth and Kinross")) 


uk <- rbind(uk, ni)

brexit_map <- merge(uk, brexit, by.x = "Area", all.x = TRUE)


  ggplot(data = brexit_map) +
    geom_sf(aes(geometry = geometry, fill = Pct_Remain > 50)) +
    scale_fill_manual(labels = c("Leave", "Remain"), values = c("#0070C0", "#FFD105"), name = "Brexit Vote")+
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          rect = element_blank())

    

