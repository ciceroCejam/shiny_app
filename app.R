library(shiny)
library(ggplot2)
library(babynames)
library(magrittr)


ui <- fluidPage(
  
  shinythemes::themeSelector(),
  
  titlePanel("Explorando os nomes de Bebês"),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter Name', 'David')
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Tendência',
          plotOutput('trend')
          ),
        tabPanel('Tabela',
          DT::DTOutput("babynames_table")
          )
      )
    )
  )
)

server <- function(input, output){
  output$trend <- renderPlot({
    data_name <- subset(
      babynames, name == input$name
    )
    ggplot(data_name)+
      geom_line(
        aes(x = year, y = prop, color = sex)
      )
  })
  output$babynames_table <- DT::renderDT({
    table_name <- subset(
      babynames, name == input$name
    )
    table_name %>% 
      dplyr::sample_frac(.1)
  })
  
}

shinyApp(ui = ui, server = server)
