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
    global_map <- global_map %>%
      dplyr::filter(., year == input$year_harvest)
    
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
        hovertext = "text", alpha = 2
      ) %>%
      add_segments(
        data = sorted_coffee,
        x = sorted_coffee$Longitude,
        y = sorted_coffee$Latitude,
        alpha = 0.75, size=I(4), text = paste(sorted_coffee$Country, "\n",
                                              "Harvest Month: ",sorted_coffee$Month, "\n",
                                              "Total Production: ", sorted_coffee$`Total Production`, '\n',
                                              "Domestic Consumption: ", sorted_coffee$`Domestic Consumption`, '\n',
                                              "Exportable Production: ", sorted_coffee$`Exportable Production`, '\n',
                                              "Gross Opening Stock: ", sorted_coffee$`Gross Opening Stocks`)
      ) %>%
      layout(
        geo = geo, showlegend = FALSE, height = 700, hovermode = 'closest'
      )
  })
  
  
})
