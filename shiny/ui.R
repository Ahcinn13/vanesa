
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
                 uiOutput("statistike")
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
    ),


######################################################################

  tabPanel("Head To Head",
           h2("Head To Head Statistics"),
           sidebarLayout(
           sidebarPanel(
              uiOutput("tenisac"),
              uiOutput("nasprotnik"),
              uiOutput("turnir"),
              uiOutput("toleto")
             ),
             mainPanel(
             
               DT::dataTableOutput('head')
               )
            )
  ),

######################################################################

tabPanel("Players by country map",
         h2("Number of players by country map"),
         sidebarLayout (
           sidebarPanel(),
           mainPanel(
             leafletOutput("map")
           )
         ))


)))

