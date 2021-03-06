
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
               tags$img(src='header_photo.png', height='200px'))),
  tabsetPanel(
    
    tabPanel("Rankings",
             h2("ATP Rankings"),
             mainPanel(
               DT::dataTableOutput("s"))),
    
####################################################################################    
    tabPanel("Player Statistics",
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
                 #textOutput('tekstime'),
                 DT::dataTableOutput('sta')
               )
             )
    ),
    
    tabPanel("Player Analysis",
             h2("Player Analysis"),
             sidebarLayout(
               
               
               
               sidebarPanel(
                 uiOutput("ten"),
                 uiOutput("stati")),
               mainPanel(
                 plotOutput("company"))
             )
    ),


######################################################################
    tabPanel("Tournament Statistics",
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

    tabPanel("Tournament Analysis",
             h2("Tournament Analysis"),
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
           mainPanel(
             leafletOutput("map")
           )
         )
###################################################################




)))

