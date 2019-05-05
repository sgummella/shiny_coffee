library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(shiny)
library(DT)
library(shinyWidgets)
# library(RSQLite)
library(shinyLP)


# conn = dbConnect(drv = RSQLite(), dbname = "./database.sqlite")
# dbListTables(conn)

coffee <- read.csv(file = "ICO_CROP_DATA.csv", stringsAsFactors = F)
coffee <- coffee %>% mutate(., SEASON = substr(YEAR,1,4))
coffee <- coffee %>% filter(., !is.na(TOTAL_PRODUCTION) & TOTAL_PRODUCTION != 0)
coffee <- coffee[c(1,8,2,3,4,5,6,7)]
coffee <- coffee[c(-3)]

country_centroids = read.csv(file = "country_centroids_az8.csv", stringsAsFactors = F)
names(country_centroids)[1] <- "Country"


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
coffee_merge <- merge(coffee, country_centroids, by="Country") 
cofeee_merge <- coffee_merge %>% rename(., "Total Production" = "TOTAL_PRODUCTION")
coffee_merge$Season <- as.numeric(coffee_merge$Season) 




# sorted_coffee <- coffee[order(coffee$Country, coffee$Season) , ]
sorted_coffee = coffee_merge %>% group_by(., Country, Season)
sorted_coffee <- sorted_coffee %>% rename(., "Total Production" = "TOTAL_PRODUCTION")
sorted_coffee <- sorted_coffee[order(sorted_coffee$Country, sorted_coffee$Season), ]
sorted_coffee <- sorted_coffee %>% mutate(., Text = paste("Harvest Month:", '\t', Month, '\n',"Total Production:",'\t'  ,`Total Production`,'\n',"Domestic Consumption:",
                                                          '\t',`Domestic Consumption`,'\n', "Exportable Production:", "\t",
                                                          `Exportable Production`,"\n","Gross Opening Stocks:","\t", `Gross Opening Stocks`))
# sorted_coffee <- sorted_coffee %>% rename(., "Total Production" = "TOTAL_PRODUCTION")


mean_stats <- mean_stats_year[c(-1)]
stats = colnames(sorted_coffee)
stats = stats[c(-1,-2,-3)]



