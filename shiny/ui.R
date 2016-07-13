
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
    
    tabPanel("Ranking",
             mainPanel(
               DT::dataTableOutput("s"))),
    
####################################################################################    
    tabPanel("Player",
             h2("Player Statistics"),
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
    
    tabPanel("Player analysis",
             h2(" "),
             sidebarLayout(
               
               
               
               sidebarPanel(
                 uiOutput("ten"),
                 uiOutput("stati")),
               mainPanel(
                 plotOutput("company"))
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

    tabPanel("Tournament analysis",
             h2(" "),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("trleto"),
                 #uiOutput("ten")
                 uiOutput("st")
               ),
               mainPanel(
                 
                 plotOutput("statr")
                 #plotOutput("company")
               ))),


######################################################################

  tabPanel("Head To Head",
           uiOutput("h2hTitle"),
           uiOutput("head2head")
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
###################################################################




)))

