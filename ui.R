#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Tank Ballistics"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Adjust firing parameters and try to hit the target!"),
            sliderInput("gravity",
                        "Strength of Gravity (m/s^2)",
                        min = 0.5, max = 20, value = 9.8),
            sliderInput("angle",
                        "Angle of Attack (degrees)",
                        min = 0, max = 90, value = 45),
            sliderInput("velocity",
                        "Projectile Speed (m/s)",
                        min = 1, max = 100, value = 50),
            sliderInput("distance",
                        "Approximate Distance to Target",
                        min = 50, max = 1000, value = 100),
            submitButton("FIRE!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot"),
            h3("Projectile Distance"),
            textOutput("dist_final"),
            h3("Target Distance"),
            textOutput("foe"),
            textOutput("hit")
        )
    )
))
