#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

### add the libraries ###
library(data.table)
library(readr)
library(shiny)
library(ggplot2)
library(magrittr)
library(plotly)

### to load the data ###
DP_LIVE_26092022094100394 <- read_csv("DP_LIVE_26092022094100394.csv")

### transform data as a data table ###
HP=setDT(DP_LIVE_26092022094100394)

### change the format of date and annual data ###
HP = HP[FREQUENCY == "Q"]
HP$TIME = gsub("Q1","01-01",HP$TIME)
HP$TIME = gsub("Q2","04-01",HP$TIME)
HP$TIME = gsub("Q3","07-01",HP$TIME)
HP$TIME = gsub("Q4","10-01",HP$TIME)
HP$TIME=as.Date(HP$TIME)
HP

### separate the data ###
Countries = unique(HP$LOCATION)
unique_time <- unique(HP$TIME)

### create point plot function to compare the situation across countries at the same time###
myplotp = function(input, input2,scale = "linear",subject,Time0,timeframe) {#Calculate revalue
  for (country in Countries){
    i0 =HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country][TIME ==Time0,Value]
    if (length(i0)>0){
      HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country, REVALUE:=100*Value/i0]
    } else {
      HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country, REVALUE:=NA]
    }
  }   
  p=ggplot(HP[INDICATOR=="HOUSECOST" & SUBJECT==subject], aes(x=TIME, y = REVALUE, group = LOCATION) ) + 
    geom_line(colour = "grey") +
    geom_point(data = HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION %in% input & TIME == input2], 
               aes(col = LOCATION ),
               size =3)  
  p=p+xlim(timeframe) #range of the x axis
  if (scale == 'logarithmic') {       # setting the variable scale to logarithmic
    p= p + scale_y_log10()
  }
  return(p)
}

### create line plot function to compare overall trends across countries ###
myplotl = function(input, input2,scale = "linear",subject,Time0,timeframe) {
  for (country in Countries){
    i0 =HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country][TIME ==Time0,Value]
    if (length(i0)>0){
      HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country, REVALUE:=100*Value/i0]
    } else {
      HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION==country, REVALUE:=NA]
    }
  }   
  l=ggplot(HP[INDICATOR=="HOUSECOST" & SUBJECT==subject], aes(x=TIME, y = REVALUE, group = LOCATION ) ) + 
    geom_line(colour = "grey") +
    geom_line(data = HP[INDICATOR=="HOUSECOST" & SUBJECT==subject & LOCATION %in% input], 
              aes(col = LOCATION ))
  l=l+xlim(timeframe)
  if (scale == 'logarithmic') {
    l= l + scale_y_log10()
  }
  return(l)
}


# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("OECD Housing prices during the time"), #title

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(     # Side panel which collects user input
          radioButtons(   # to select Nominal price or Real price
          inputId = "subject", 
          label = "Perspectives:",
          choices = c("NOMINAL","REAL"),
          selected = "NOMINAL",
          ),
          radioButtons(  # select the variable scale to linear or logarithmic
          inputId = "scale", 
          label = "Scale:",
          choices = c("linear","logarithmic"),
          selected = "linear"
        ),
          selectInput( # highlight the countries
            inputId = "Countr",
            label = "Select the Country",
            choices =HP$LOCATION,
            selected = NULL,
            multiple = TRUE,
          ),
          selectInput( # choose the date
            inputId = "TIM",
            label = "Select the Date",
            choices =unique_time,
            selected ="2020-01-01",
          ),
          selectInput( #can choose the base date which want to compare
           inputId = "Time0",
           label = "Index=100",
           choices = unique_time,
           selected ="2015-01-01",
          ),          
          sliderInput(inputId = "timeframe",  #range of timeline
                      label = "Time Range",
                      min = min(HP$TIME),
                      max = max(HP$TIME), 
                      value=c(min(HP$TIME),max(HP$TIME))
        ),
        ),
        # Show two different plots
        mainPanel("The prices in different countries at different times",  # Main panel which shows output
                  tabsetPanel( #subdivide the user-interface into discrete sections
                    tabPanel("Point", plotlyOutput("MyplotP")), 
                    tabPanel("Line", plotlyOutput("MyplotL"))
        )
    )
  )
)

# R-code which creates the output to be added to the dashboard app
server <- function(input, output) {
  output$MyplotP = renderPlotly({ #Use the plotly function to make the graph interactive
    myplotp(input$Countr,input$TIM,input$scale,input$subject,input$Time0,input$timeframe)
  })
  output$MyplotL = renderPlotly({
    myplotl(input$Countr,input$TIM,input$scale,input$subject,input$Time0,input$timeframe)
  })
}

# Run the application 
shinyApp(ui = ui, server = server) ### Start the server
