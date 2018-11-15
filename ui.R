library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Your chances of surviving the Titanic disaster"),
    a("Click here for the documentation", href="http://irek978.github.io/TitanicSurvivalPresentation/#1", target="_blank"),
    p("Insert the requested values and discover which is your chance to survive at the Titanic disaster"),
    
    sidebarLayout(
        sidebarPanel(
       
            numericInput("age", "How old are you?:", 30),
            
            selectInput("sex", "Indicate your sex:", 
                        choices = c("Male", "Female")),
            
            selectInput("class", "In which class would you traveled?:", 
                        choices = c("1st", "2nd", "3rd", "Crew"))
            
        ),
        
        
        mainPanel(
            h3('Result of prediction'),
            h3('You entered'),
            h4('The class in your journey was the'),
            htmlOutput('inputClassValue'),
            h4('Your Sex'),
            htmlOutput('inputSexValue'),
            h4('Your Age'),
            htmlOutput('inputAgeValue'),
            h3('Your chances of surviving at the Titanic disaster could be at the:'),
            h2(htmlOutput('prediction'))
        
        )
    )
))
