# plot Modis data over time
# Modis summarized for watershed area from GEE
# 2020-12-05

library(ggplot2) 
library(tidyverse)
library(lubridate)

setwd("C:/Users/Alice Carter/Dropbox (Duke Bio_Ea)/projects/hall_50yl/code/")

# 1. read data ####
dat_list <- list_files("data/gee/")
dat <- read_csv("data/gee/gpp.csv") %>%
  mutate(year = as.numeric(substr(as.character(date), 1, 4)),
         doy = as.numeric(substr(as.character(date), 5, 8))) %>%
  select(-date)

GPP <- dat %>%
  group_by(year) %>%
  summarize(#GPP_mean = mean(GPP_mean, na.rm = T),
            GPP_cum = sum(GPP_mean),
            GPP_std = sum(GPP_std)) %>%
  filter(year != 2020)

dat <- read_csv("data/gee/npp.csv") %>%
  select(year = date, NPP_mean = annualNPP_mean, NPP_std = annualNPP_std) %>%
  filter(year != 2020)

NPP <- full_join(GPP, dat)
png("../figures/modis_npp.png", 
    width=6, height=5, units='in', res=300,)
  plot(NPP$year, NPP$GPP_cum/1000, type = "l", lwd = 2,
       ylim = c(min(NPP$NPP_mean - NPP$NPP_std, na.rm = T)/1000,
                max(NPP$GPP_cum + NPP$GPP_std, na.rm = T)/1000), 
       ylab = "1000 kgC/m2/year", xlab = "year",
       main = "Terrestrial Productivity")
  polygon(c(NPP$year, rev(NPP$year)), 
          c(NPP$GPP_cum + NPP$GPP_std, rev(NPP$GPP_cum - NPP$GPP_std))/1000,
          col = alpha("forestgreen", .5), border = NA)
  lines(NPP$year, NPP$NPP_mean/1000, lwd = 2)
  polygon(c(NPP$year, rev(NPP$year)), 
          c(NPP$NPP_mean + NPP$NPP_std, rev(NPP$NPP_mean - NPP$NPP_std))/1000,
          col = alpha("grey50", .5), border = NA)
  legend("topleft",
         c("GPP", "NPP"),
         col = c("forestgreen", "grey30"),
         lty = 1, lwd = 2, ncol = 2, bty = "n")
dev.off()



# 2. LAI ####

dat <- read_csv("data/gee/treed.csv") %>%
  mutate(date = as.Date(date, format = "%Y_%m_%d"),
         year = year(date)) %>%
  group_by(year) %>%
  summarize(lai = mean(Percent_Tree_Cover_mean, na.rm = T))
            #cum_lai = sum(Fpar_500m_mean, na.rm = T))

plot(dat$year, dat$lai)
meric(substr(as.character(date), 1, 4)),
         doy = as.numeric(substr(as.character(date), 5, 8))) %>%
  select(-date)
plot(dat$date, dat$Lai_500m_ax)