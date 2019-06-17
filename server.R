#
# This app draws a simple ballistics curve, given inputs of velocity and angle of attack. 
#

library(shiny)

shinyServer(function(input, output) {

    # place the enemy tank randomly around the input$distance
    foe <- reactive({input$distance * (1 + rnorm(1, mean = 0, sd = 0.1))})
    
    # calculate the x and y component of the firing trajectory
    x_comp <- reactive({input$velocity * cos(input$angle * 2 * pi / 360)})
    y_comp <- reactive({input$velocity * sin(input$angle * 2 * pi / 360)})
    
    # calculate the time when the projectile goes input$distance, and when
    # it would hit the ground (t_max and t_grnd, respectively)
    t_max <- reactive({foe() / x_comp()})
    t_grnd <- reactive({2 * y_comp() / input$gravity})
    
    output$plot <- renderPlot({
        # if an undershoot (it hits the ground first), trace path to t_grnd.
        # if not, make a second time series (t2) to trace the rest of the path.
        if (t_grnd() < t_max()) {
            t <- seq(from = 0, to = t_grnd(), by = 0.1)
        } else {
            t <- seq(from = 0, to = t_max() + 0.1, by = 0.1)
            t2 <- seq(from = t_max(), to = t_grnd(), by = 0.1)
        }
        x_max <- ceiling(max(c(0, t_max()*x_comp(), foe())))
        y_max <- ceiling(max(y_comp() * t - 0.5 * input$gravity * t^2))
        # plot the two points (tanks) and the projectile path
        plot(x = c(0, x_max),
             y = c(0, y_max),
             type = "n",
             asp = 1,
             main = "Ballistics Curve",
             xlab = "Horizontal Distance (m)",
             ylab = "Height (m)")
        points(x = 0, y = 0, pch = 16, col = "red", cex = 2)
        points(x = foe(), y = 0, pch = 16, col = "orange", cex = 2)
        lines(x = x_comp() * t,
              y = y_comp() * t - 0.5 * input$gravity * t^2,
              col = "green")
        if (t_grnd() >= t_max()) {
            lines(x = x_comp() * t2,
                  y = y_comp() * t2 - 0.5 * input$gravity * t2^2,
                  col = "dark green")
        }
        points(x = x_comp() * t_grnd(), y = 0, pch = 21, col = "red", cex = 1500/foe())
        abline(h = 0, col = "black")
        grid()
        
    })
    
    output$dist_final <- renderText({paste0(round(x_comp() * t_grnd(), 1), " m")})
    
    output$foe        <- renderText({paste0(round(foe(), 1)," m")})

    output$hit        <- renderText({
        if (abs(x_comp() * t_grnd() - foe()) < 10) {
            "You Hit!"
        } else {
            "You Missed!"
        }
    })    
})
