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
      resolution = '100',
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
      ggplot(aes(x = SEASON, y = !!sym(input$mean))) +
      geom_line(color = 'darkblue') + 
      geom_point(color = "darkblue") +
      labs(y = input$mean) +
      theme(axis.text.x=element_text(angle=-45, hjust=1)) +
      scale_x_discrete(limits = 1990:2017)
  })
  
  output$maxBoxMean <- renderInfoBox({
    data <- mean_stats_year %>% 
      select(SEASON, !!sym(input$mean)) %>% 
      arrange(desc(!!sym(input$mean))) %>% 
      head(1)
    infoBox(paste("Year: ", data$SEASON),
            paste("Max: ", round(data[,input$mean], 2)),
            "(in thousands of 60 kg bags)",
            icon = icon("chevron-up"))
  })
  output$minBoxMean <- renderInfoBox({
    data <- mean_stats_year %>%
      select(SEASON, !!sym(input$mean)) %>%
      arrange(!!sym(input$mean)) %>% 
      head(1)
    infoBox(paste("Year: ", data$SEASON),
            paste("Min: ", round(data[,input$mean], 2)),
            "(in thousands of 60 kg bags)",
            icon = icon("chevron-down"))
  })
  output$maxBox <- renderInfoBox({
    data <- sorted_coffee %>%
      filter(Country == input$country) %>%
      select(Season, !!sym(input$stat_country)) %>%
      arrange(desc(!!sym(input$stat_country))) %>%
      head(1)
    infoBox(paste("Year: ", data$Season),
            paste("Max: ", round(data[,input$stat_country],2)),
            "(in thousands of 60 kg bags)",
            icon = icon("chevron-up"))
    
  })
  output$minBox <- renderInfoBox({
    data <- sorted_coffee %>%
      filter(Country == input$country) %>%
      select(Season, !!sym(input$stat_country)) %>%
      arrange(!!sym(input$stat_country)) %>%
      head(1)
    infoBox(paste("Year: ", data$Season),
            paste("Min: ", round(data[,input$stat_country],2)),
            "(in thousands of 60 kg bags)",
            icon = icon("chevron-down"))
    
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
      select(Season, !!sym(input$stat_country)) %>%
      arrange(Season) %>%
      ggplot(aes(x = Season, y = !!sym(input$stat_country))) +
      geom_line(color = 'darkblue') +
      labs(y = input$stat_country) +
      geom_point(color = 'darkblue') +
      theme(axis.text.x=element_text(angle=-45, hjust=1)) +
      scale_x_discrete(limits = 1990:2017)
    })
  })

