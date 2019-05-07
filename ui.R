#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# my_options$explorer <- "{actions:['dragToZoom', 'rightClickToReset']}"
# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "Coffee Beans"),
  dashboardSidebar(
    sidebarUserPanel("Sashank Gummella",
                     image = "https://producttable.barn2.co.uk/wp-content/uploads/2017/06/Coffee-Beans.jpg"),
    sidebarMenu(
      menuItem("Overview", tabName = "intro", icon = icon("coffee")),
      menuItem("Global Map", tabName = "map", icon = icon("globe-africa")),
      menuItem("Time Series", tabName = "data", icon = icon("hourglass-half")),
      menuItem("Recap", tabName = "recap", icon = icon("rev")),
      #creating menuItem link tab to github repo
      menuItem("Github Repository", href = "https://github.com/sgummella/shiny_zappos", icon = icon("github")))
   
    ),
  dashboardBody(
    
    tabItems(
      #creating Overview tabItem
      tabItem(tabName = 'intro',
              fluidRow(
                column(
                  width = 12,
                  align = 'center',
                  box(
                    title = strong('International Coffee Organization Crop Data 1990 - 2017'),
                    status = 'success',
                    solidHeader = T,
                    width = NULL,
                    img(src = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/International_coffee_organisation.svg/1200px-International_coffee_organisation.svg.png',
                        width = 800, align = "center")
                    
                  )
                )
              ),
              fluidRow(
                column(
                  width = 12,
                  box(
                    title = strong('Welcome'),
                    status = 'success',
                    solidHeader = T,
                    width = NULL,
                    h4(
                      'This dataset, provided by the International Coffee Organization, combines annual data from 56 member state nations from 1990 to 2017. It presents a few statistics, such as, total production, domestic consumption, exportable production, and gross opening stocks. All of these statistics are given in thousands of 60 kg bags. The International Coffee Organization (ICO) is the primary intergovernmental organization for the global coffee market. It oversees nearly all of the coffee production market and two-thirds of global coffee consumption. This dataset was found on the Kaggle website, but was cleaned and mutated by me for this project\'s purposes. \nTotal production and domestic consumption are self-explanatory.\n Exportable production is the difference of total production and domestic consumption.\n Gross opening stock is the amount of coffee held by a coffee producing country\'s producers, processors, traders and exporters at the beginning of a crop year. Coffee stocks could be held if there\'s a surplus to export requirements or to ensure an orderly flow of exports.'
                    )
                  )
                )
              ),
              fluidRow(
                column(
                  width = 12,
                  box(
                    title = strong('Motivation / Questions of Interest'),
                    status = 'success',
                    solidHeader = T,
                    width = NULL,
                    h4(
                      'I wanted to use this dataset to learn about the global coffee production and consumption markets. I will determine how countries rank in domestic consumption and exportable production relative to their individual total production values. This will give me a better idea of different countries\' relationships with coffee. Which countries cultivate to export more? Which countries cultivate to consume more? Which countries have higher gross opening stocks relative to their total production?'  
                    )
                    
                  )
                )
              )
              
              ),
      #creating global map tabItem
      tabItem(tabName = 'map',
              h2('Coffee Production and Consumption 1990-2017'),
              fluidRow(
                  box(
                    width = 2,
                    title = 'Select Input',
                    solidHeader = T,
                    status = 'success',
                    selectInput(inputId = "year_harvest",
                      label = "Select a Year",
                      choices = Year,
                      selected = NULL,
                      # options = list(actions-box = TRUE),
                      multiple = FALSE
                    )
                  ),
              column(width = 10, plotlyOutput("map", height = 700), solidHeader = TRUE, status = 'success')
              )
              ),
      #creating time series / data tabItem
      tabItem(tabName = "data",
          fluidRow(
              box(width = 4,
                title = 'Select Input',
                solidHeader = T,
                status = 'success',
                selectizeInput(
                  "stat_country",
                  label = "Select a Statistic",
                  choices = as.character(stats),
                  selected = NULL),
                selectizeInput(
                  "country",
                  label = "Select a Country",
                  choices = as.character(unique(sorted_coffee$Country)),
                  selected = NULL)
                # infoBoxOutput("maxBox")
                ),
              infoBoxOutput("maxBox"),
              infoBoxOutput("minBox")
          ),
          fluidRow(
                box(width = 12,
                  title = 'Crop Data by Year and Country',
                  status = 'success',
                  solidHeader = T,
                  plotlyOutput('country_season_line')
                )
              ),
            fluidRow(
              box(width = 4,
                title = 'Select Input',
                status = 'success',
                solidHeader = T,
                selectizeInput(
                  'mean',
                  label = "Select an Average",
                  choices = as.character(colnames(mean_stats)),
                  selected = NULL)),
                infoBoxOutput("maxBoxMean"),
                infoBoxOutput("minBoxMean")
              ),
            fluidRow(
                box(width = 12,
                  title = "Mean Crop Data by Year",
                  status= 'success',
                  solidHeader = T,
                  plotlyOutput('mean_season_line')
              )
            ),
      
            fluidRow(
                box(
                  width = 6,
                  title = 'Coffee Data by Season and Country',
                  status = 'success',
                  solidHeader = T,
                  # width = NULL,
                  dataTableOutput('country_season_table')
                ), 
                box(
                  width = 6,
                  title = 'Mean Coffee Data by Season',
                  status = 'success',
                  solidHeader=T,
                  dataTableOutput('mean_season_table')
                )
              )),
            
            
      #creating tabItem recap / future work
      tabItem(tabName = "recap",
              fluidRow(
                column(
                  width = 12,
                  box(
                    title = "Recap",
                    status = "success",
                    solidHeader = T,
                    width = NULL,
                    h4(
                      'In general, a trend I am seeing is that South American, Carribean, and some Central American nations have been consuming more coffee domestically over the recent couple of decades. As a result, most have been exporting less. Brazil was able to offset this deficit by producing more coffee. '
                    ),
                    h4(
                      'South America used to be the biggest player in coffee production. In Africa, nations have been producing more coffee to export in the last couple of decades. Countries, such as, Ghana, Zambia, Togo have either raised exportable production or maintained high export over this time period.'
                    ),
                    h4(
                      'Countries in South America, Africa, and Asia are producing much more coffee to meet higher domestic consumption. The whole world, as a collective, is drinking A LOT more coffee! As a result of this, gross opening stocks are decreasing steadily to meet both domestic and overseas demands. Changes in countries\' domestic consumptions noted around 1997-1999.'
                      
                  )
                )
              )),
              fluidRow(
                column(
                  width = 12,
                  box(
                    title = "Future Work",
                    status = "success",
                    solidHeader = T,
                    width = NULL,
                    h4(
                      'If I had more time, I would tap into coffee import datasets to see how coffee is distributed globally. This would help piece where coffee is being sent to and who the biggest importers are. America and Europe are undoubtedly biggest consumers in the world, but won\'t know for sure until I merge with an imports dataset.'
                    ),
                    h4(
                      'An imports dataset that tells me where countries are importing their coffee from would give insight into the economies of coffee producing countries and help explain global trends, such as, why some countries consume less than others.'
                    )
                  )
                )
              )
              )
      )
  )
    )
)
