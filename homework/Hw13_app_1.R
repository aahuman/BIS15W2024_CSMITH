library(tidyverse)
library(shiny)
library(shinydashboard)
library(naniar)

UC_admit <- read_csv("data/UC_admit.csv")

ui <- dashboardPage(
  dashboardHeader(title = "UC Campus Admissions by Ethnicity 2010-2019"),
  dashboardSidebar(disable=T),
  dashboardBody(
    fluidRow(
      box(title = "Plot Settings", width = 3,
          radioButtons("x", "Select Year", choices = c("2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"), 
                       selected = "2010"),
          selectInput("y", "Select Campus", choices = c("Davis", "Irvine", "Berkeley", "Irvine", "Los_Angeles", "Merced", "Riverside", "San_Diego", "Santa_Barbara", "Santa_Cruz"),
                      selected = "Davis"),
          
          selectInput("z", "Select Admit Category", choices = c("Applicants", "Admits", "Enrollees"),
                      selected = "Applicants")
      ),
      box(title = "UC Admissions", width = 8,
          plotOutput("plot", width = "600px", height = "500px")
      ) 
    ) 
  )
)
server <- function(input, output, session) {
  
  session$onSessionEnded(stopApp)
  
  output$plot <- renderPlot({
    
    UC_admit %>% 
      filter(Academic_Yr==input$x, Campus==input$y, Category==input$z) %>% 
      filter(FilteredCountFR!="NA", Ethnicity!="All") %>% 
      ggplot(aes(x=reorder(Ethnicity, FilteredCountFR), y=FilteredCountFR))+
      geom_col(color="black", fill="dodgerblue2", alpha=0.4) +
      theme_linedraw(base_size = 18) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))+
      labs(x = "ethnicity", y = "number")
  })
}

shinyApp(ui, server)
