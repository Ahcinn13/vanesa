
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("Tenis"),
  tabsetPanel(
    
####################################################################################    
    tabPanel("Statistics",
             h2("Players Statistics"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("tenisaci"),
                 uiOutput("leto")
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
                 uiOutput("turnir"),
                 uiOutput("leto_t")
                 #uiOutput("povrsina")
               ),
               mainPanel()
             )
    )
)
))


