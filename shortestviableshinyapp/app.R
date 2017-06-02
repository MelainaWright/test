library(shiny)

rsconnect::setAccountInfo(name='mwright',
                          token='FE72305423A4AAC8C3B189029D5E6F73',
                          secret='iogeSSoDkvNOu8TgzmIQ0+LaoeceaCEH+Sd+eYpi')

library(rsconnect)

#have to make a unique input name (need it to connect inputs and outputs together ie if input needs to affect a certain output)
#use output$hist to call what is in the UI to the server
#render looks at code passed to it and runs it
#widget inputs in the UI that we gave an input name to are the only ones capable of connecting to the output in the server

#two file apps, one directory with two files: server.R (for function) and ui.R (for fluidPage)


UI <- fluidPage(sliderInput(inputId = "num",
                              label = "Choose a number",
                              value = 25, min = 1, max = 100), 
                plotOutput("hist"))


Server <- function(input, output) {
  output$hist <- renderPlot({ hist(rnorm(input$num))
    
  })
}


shinyApp(ui = UI, server = Server)