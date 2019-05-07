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
coffee <- coffee %>% mutate(., "Percent_Domestic_Consumption" = DOMESTIC_CONSUMPTION/TOTAL_PRODUCTION * 100, 
                            "Percent_Exportable_Production" = EXPORTABLE_PRODUCTION/TOTAL_PRODUCTION * 100,
                            "Percent_Gross Opening_Stocks"= GROSS_OPENING_STOCKS/TOTAL_PRODUCTION * 100)

mean_stats_year <- coffee %>% group_by(., SEASON) %>% summarise(., "Mean_Total_Production" = mean(TOTAL_PRODUCTION),
                                                                      "Mean_Domestic_Consumption" = mean(DOMESTIC_CONSUMPTION),
                                                                      "Mean_Exportable_Production" = mean(EXPORTABLE_PRODUCTION),
                                                                      "Mean_Gross_Opening_Stocks" = mean(GROSS_OPENING_STOCKS))
mean_stats_year$SEASON <- as.numeric(mean_stats_year$SEASON)
coffee <- coffee %>% rename(., "Exportable_Production" = "EXPORTABLE_PRODUCTION")
coffee <- coffee %>% rename(., "Domestic_Consumption" = "DOMESTIC_CONSUMPTION")
coffee <- coffee %>% rename(., "Gross_Opening_Stocks" = "GROSS_OPENING_STOCKS")
coffee <- coffee %>% rename(., "Country" = "COUNTRY")
coffee <- coffee %>% rename(., "Season" = "SEASON")
coffee <- coffee %>% rename(., "Month" = "MONTH")
coffee_merge <- merge(coffee, country_centroids, by="Country") 
coffee_merge <- coffee_merge %>% rename(., "Total_Production" = "TOTAL_PRODUCTION")
coffee_merge$Season <- as.numeric(coffee_merge$Season) 




# sorted_coffee <- coffee[order(coffee$Country, coffee$Season) , ]
# sorted_coffee = coffee_merge %>% group_by(., Season)
# sorted_coffee <- sorted_coffee[order(sorted_coffee$Season), ]
# sorted_coffee <- sorted_coffee %>% rename(., "Total_Production" = "TOTAL_PRODUCTION")
sorted_coffee <- coffee_merge %>% mutate(., Text = paste("Country:", "\t", Country,'\n', 'Harvest Month:', '\t', Month, '\n',"Total Production:",'\t'  ,`Total_Production`,'\n',"Domestic Consumption:",
                                                          '\t',`Domestic_Consumption`,'\n', "Exportable Production:", "\t",
                                                          `Exportable_Production`,"\n","Gross Opening Stocks:","\t", `Gross_Opening_Stocks`))
# sorted_coffee <- sorted_coffee %>% rename(., "Total Production" = "TOTAL_PRODUCTION")


mean_stats <- mean_stats_year[c(-1)]
stats = colnames(sorted_coffee)
stats = stats[c(-1,-2,-3,-11,-12,-13)]
Year <- sorted_coffee %>% arrange(Season) %>% select(Season)
Year <- unique(Season)
