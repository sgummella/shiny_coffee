#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



# Define server logic required to draw a histogram
shinyServer(function(input, output){
  output$map <- renderPlotly({
    sorted_coffee <- sorted_coffee %>%
      filter(., Season == input$year_harvest)
    
    geo <- list(
      showframe = TRUE,
      showland = TRUE,
      showcoastlines = TRUE,
      projection = list(type = 'orthographic'),
      resolution = '10000',
      showcountries = TRUE,
      countrycolor = "#ededed",
      showocean = TRUE,
      oceancolor = '#0077be',
      showlakes = TRUE,
      lakecolor = '#0077be'
    )
    
    plot_geo(locationmode = 'country names', color = I("blue")) %>%
      add_markers(
        data = sorted_coffee, x = sorted_coffee$Longitude, y = sorted_coffee$Latitude,
        hovertext = sorted_coffee$Text, alpha = 2
      ) %>%
      # add_segments(
      #   data = sorted_coffee,
      #   x = sorted_coffee$Longitude,
      #   y = sorted_coffee$Latitude,
      #   alpha = 0.75, size=I(4), 
      # ) %>%
      layout(
        geo = geo, showlegend = FALSE, height = 700, hovermode = 'closest'
      )
  })
  #get averages for different type of input stat
  mean_statistic = reactive({
    mean_stats_year %>%
      select(SEASON, input$mean)
  })
  #output table for mean stats by season
  output$mean_season_table = DT::renderDataTable({
    mean_statistic()
  })
  #plot time series for mean stats
  output$mean_season_line = renderPlotly({
    mean_stats_year %>%
      select(SEASON, input$mean) %>%
      ggplot(aes(x = SEASON, y = input$mean)) + geom_line()
  })
  #get values for different types of input statistic and country
  country_stats <- reactive({
    sorted_coffee %>%
      filter(Country == input$country) %>%
      select(Season, input$stat_country)
  })
  #output table for stat and country by season
  output$country_season_table = DT::renderDataTable({
    country_stats()
  })
  #plot time series by country and statistic chosen
  output$country_season_line <- renderPlotly({
      sorted_coffee %>%
      filter(Country == input$country) %>% 
      select(input$stat_country, Season) %>%
      ggplot(aes(x = Season, y = input$stat_country))  + geom_line()
    })
  })

