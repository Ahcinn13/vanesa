
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("Tennis"),
  tabsetPanel(
    
####################################################################################    
    tabPanel("Players",
             h2("Players Statistics"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("tenisaci"),
                 uiOutput("leto"),
                 selectInput("data", "Choose statistics:",
                             choices=c(
                               "All", "Won","Loss","% of service points won","Aces","Double faults","% of return points won","% of BPConv","Tiebreak Wonn",
                                       "Tiebreak Loss"),selected = "All",
                             multiple = TRUE
                 )
               ),
               # Show a plot of the generated distribution
               mainPanel(
                 
                 DT::dataTableOutput('sta')
               )
             )
    ),



######################################################################
    tabPanel("Tournament",
             h2("Tournament Statistics"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("turn"),
                 uiOutput("leto_t"),
                 uiOutput("podlaga")
               ),
               mainPanel(
                 
                 DT::dataTableOutput('sta_tour')
                 )
             )
    )
)
))


