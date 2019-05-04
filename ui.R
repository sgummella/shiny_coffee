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
    siderbarMenu(
      menuItem("Overview", tabName = "intro", icon = icon("mug-hot")),
      menuItem("Global Map", tabName = "map", icon = icon("globe-africa")),
      menuItem("Time Series", tabName = "data", icon = icon("hourglass-half")),
      menuItem("Recap", tabName = "recap", icon = icon("rev")),
      #creating menuItem link tab to github repo
      menuItem("Github Repo", href = "https://github.com/sgummella/shiny_zappos.git", icon = icon("github")))
   
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
                      'This dataset, provided by the International Coffee Organization, combines annual data from 56 member state nations from 1990 to 2017. It presents a few statistics, such as, total production, domestic consumption, exportable production, and gross opening stocks. All of these statistics are given in thousands of 60 kg bags. The International Coffee Organization (ICO) is the primary intergovernmental organization for the global coffee market. It oversees nearly all of the coffee production market and two-thirds of global coffee consumption. This dataset was found on the Kaggle website, but was cleaned and mutated by me for this project\'s purposes. Total production and domestic consumption are self-explanatory. Exportable production is the difference of total production and domestic consumption. Gross opening stock is the amount of coffee held by a coffee producing country\'s producers, processors, traders and exporters at the beginning of a crop year. Coffee stocks could be held if there\'s a surplus to export requirements or to ensure an orderly flow of exports.'
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
              
              )
      #creating global map tabItem
      tabItem(tabName = 'map',
              h2('Coffee Production and Consumption 1990-2017'),
              fluidRow(
                column(
                  width = 1),
                  
                  column(width = 1,
                    title = 'Select Input',
                    solidHeader = T,
                    status = 'success',
                    selectInput(inputId = "year_harvest",
                      label = "Select a Year",
                      choices = as.character(coffee$SEASON),
                      selected = NULL,
                      # options = list(actions-box = TRUE),
                      multiple = FALSE
                    )
                  ),
              column(width = 11, plotlyOutput("coffee_map", height = 700), solidHeader = TRUE, status = 'success')
              )
              ),
      #creating time series / data tabItem
      tabItem(tabName = "data",
          fluidRow(
            column(
              width=4,
            
              box(
                title = 'Select Input',
                solidHeader = T,
                status = 'success',
                pickerInput(
                  "stat-country",
                  "Select a Statistc",
                  choices = as.character(stats),
                  selected = as.character(stats),
                  options = list(actions-box = TRUE),
                  multiple = T
                ),
                pickerInput(
                  "country",
                  "Select a Country",
                  choices = as.character(unique(coffee$COUNTRY)),
                  selected = as.character(unique(coffee$COUNTRY)),
                  options = list(actions-box = TRUE),
                  multiple= T
                )
              ),
              column(
                width = 8,
                box(
                  title = 'Crop Data by Year and Country',
                  status = 'success',
                  solidHeader = T,
                  plotlyOutput('<fill in with graph>'),
                  width = NULL
                )
              )
              ),
            fluidRow(
              column(
              width=4,
              box(
                title = 'Select Input',
                status = 'primary',
                solidHeader = T,
                pickerInput(
                  'mean-stats',
                  "Select an Average",
                  choices = as.character(colnames(mean_stats_year)),
                  selected = as.character(colnames(mean_stats_year)),
                  options = list(actions-box = TRUE),
                  multiple = T
                )
              ),
              column(
                width = 8,
                box(
                  title = "Mean Crop Data by Year",
                  status= 'success',
                  solidHeader = T,
                  plotlyOutput('fill in with graph'),
                  width = NULL
                )
              )
            )),
            fluidRow(
              column(
                width = 12,
                box(
                  title = 'Coffee Data Table',
                  status = 'success',
                  solidHeader = T,
                  width = NULL,
                  dataTableOutput('coffee')
                ) 
              )
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
                      ''
                    )
                  )
                )
              ),
              fluidRow(
                column(
                  width = 12,
                  box(
                    title = "Future Work",
                    status = "success",
                    solidHeader = T,
                    width = NULL,
                    h4(
                      ''
                    )
                  )
                )
              )
              )
      )
  )
))
