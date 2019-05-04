library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)
library(googleVis)

coffee <- read.csv(file = "ICO_CROP_DATA.csv", stringsAsFactors = F)
coffee <- coffee %>% mutate(., SEASON = substr(YEAR,1,4))
coffee <- coffee %>% filter(., !is.na(TOTAL_PRODUCTION) & TOTAL_PRODUCTION != 0)
coffee <- coffee[c(1,8,2,3,4,5,6,7)]
coffee <- coffee[c(-3)]


coffee$DOMESTIC_CONSUMPTION <- coffee$DOMESTIC_CONSUMPTION %>% replace_na(., 0)
coffee$EXPORTABLE_PRODUCTION <- coffee$EXPORTABLE_PRODUCTION %>% replace_na(., 0)
coffee$GROSS_OPENING_STOCKS <- coffee$GROSS_OPENING_STOCKS %>% replace_na(., 0)
coffee <- coffee %>% mutate(., "% Domestic Consumption" = DOMESTIC_CONSUMPTION/TOTAL_PRODUCTION * 100, 
                            "% Exportable Production" = EXPORTABLE_PRODUCTION/TOTAL_PRODUCTION * 100,
                            "% Gross Opening Stocks"= GROSS_OPENING_STOCKS/TOTAL_PRODUCTION * 100)

mean_stats_year <- coffee %>% group_by(., SEASON) %>% summarise(., "Mean Total Production" = mean(TOTAL_PRODUCTION),
                                                                "Mean Domestic Consumption" = mean(DOMESTIC_CONSUMPTION),
                                                                "Mean Exportable Production" = mean(EXPORTABLE_PRODUCTION),
                                                                "Mean Gross Opening Stocks" = mean(GROSS_OPENING_STOCKS))

coffee <- coffee %>% rename(., "Exportable Production" = "EXPORTABLE_PRODUCTION")
coffee <- coffee %>% rename(., "Domestic Consumption" = "DOMESTIC_CONSUMPTION")
coffee <- coffee %>% rename(., "Gross Opening Stocks" = "GROSS_OPENING_STOCKS")
coffee <- coffee %>% rename(., "Country" = "COUNTRY")
coffee <- coffee %>% rename(., "Season" = "SEASON")
coffee <- coffee %>% rename(., "Month" = "MONTH")

mean_stats_year <- mean_stats_year[c(-1)]
stats = colnames(coffee)
stats = stats[c(-1,-2,-3)]
