library(shiny)
library(ggplot2)
library(maps)
library(tidyr)
library(dplyr)
library(stringr)




ui <- fluidPage(
  titlePanel("US Census Visualization",
             windowTitle = "CensusVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Creat demographic maps with information from the 2010 Census"),
      selectInput(inputId = "var",
                  label = "Choose a variable to display",
                  choices = list("Percent White", "Percent Black",
                                 "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White")
    ),
      
    mainPanel(
      textOutput(outputId = "selected_var"),
      plotOutput(outputId = "plot")
    )
    
    
  )
  
)

server <- function(input, output, session) {
  
 # output$selected_var = renderText(
  #                        paste("You have selected: ", input$var)
   #                     )

  
  
  
  output$plot = renderPlot({
    
    counties <- reactive({
      race = readRDS("data/counties.rds")
      
      
      counties_map = map_data("county")
      
      # In order to join both tables we need to make sure we are combining them by both state
      # and county as a unique identifier
      
      counties_map = counties_map %>%
        mutate(counties = paste(region, subregion, sep = ","))
      
      
      left_join(counties_map, race, by = c("counties" = "name"))
      
    })
    
    
    
    
    race = switch (input$var,
                   "Percent White" = counties()$white,
                   "Percent Black" = counties()$black,
                   "Percent Hispanic" = counties()$hispanic,
                   "Percent Asian" = counties()$asian
    )
    
    
    ggplot(counties(), aes(x = long, y = lat, group = group, fill = race ))+
    geom_polygon(color = "black")+
    scale_fill_gradient(low = "white", high = "red")
  })
  

  
}

shinyApp(ui, server)