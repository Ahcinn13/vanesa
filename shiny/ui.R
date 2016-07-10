
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)
library(leaflet)

shinyUI(fluidPage(
  theme = shinytheme("spacelab"),
  titlePanel("Tennis",
             tags$head(
               tags$img(src='header_photo.jpg', height='200px'))),
  tabsetPanel(
    
####################################################################################    
    tabPanel("Players",
             h2("Players Statistics"),
             sidebarLayout(
               sidebarPanel(
                 tags$head(tags$style(type="text/css", "body {background-color: #B5CAB2;}")),
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
           uiOutput("h2hTitle"),
           uiOutput("head2head")
  ),
######################################################################
#tabPanel("Sets",
#         h2("Sets statistics"),
#         sidebarLayout(
#           sidebarPanel(
#             uiOutput("kje"),
#             uiOutput("eden")
#           ),
#           mainPanel(
#             DT::dataTableOutput("set")
#           )
#         )),

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

