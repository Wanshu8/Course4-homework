#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(readxl)
library(DT)


# Read the Excel file
movie_data <- read_excel("movies.xlsx")

# Correct the decimal point for the Grade column
movie_data$Grade <- as.numeric(gsub(",", ".", movie_data$Grade))

# Define UI for the app
ui <- fluidPage(
  tags$img(src = "tenor.gif", align = "right", height = "100px"),
  includeCSS("styles.css"),
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("Movies Information"),
  sidebarLayout(
    sidebarPanel(
      id = "sidebar",
      checkboxGroupInput("like_filter", "Filter by Like:",
                         choices = c("Yes", "No"),
                         selected = c("Yes", "No")),
      sliderInput("grade_filter", "Filter by Grade:",
                  min = min(movie_data$Grade, na.rm = TRUE),
                  max = max(movie_data$Grade, na.rm = TRUE),
                  value = c(min(movie_data$Grade, na.rm = TRUE), max(movie_data$Grade, na.rm = TRUE))),
      textInput("actor_search", "Search by Actor:"),
      checkboxInput("show_additional_filters", "Show Additional Filters", value = FALSE),
      conditionalPanel(
        condition = "input.show_additional_filters == true",
        selectInput("genre_filter", "Filter by Genre:",
                    choices = unique(movie_data$Genre), selected = NULL, multiple = TRUE)
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Movies Table", DTOutput("moviesTable")),
        tabPanel("Rating Plot", plotOutput("ratingPlot")),
        tabPanel("Summary", verbatimTextOutput("summary")),
      )
    )
  )
)

# Define server logic for the app
server <- function(input, output) {
  
  # Filter the data based on the selected filters
  filtered_data <- reactive({
    data <- movie_data[movie_data$Like %in% input$like_filter, ]
    data <- data[data$Grade >= input$grade_filter[1] & data$Grade <= input$grade_filter[2], ]
    if (input$actor_search != "") {
      data <- data[grepl(input$actor_search, data$Actor, ignore.case = TRUE), ]
    }
    if (!is.null(input$genre_filter) && length(input$genre_filter) > 0) {
      data <- data[data$Genre %in% input$genre_filter, ]
    }
    data
  })
  
  # Render the table
  output$moviesTable <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })
  
  # Render the plot
  output$ratingPlot <- renderPlot({
    data <- filtered_data()
    barplot(data$Grade, names.arg = data$Movie, 
            main = "Movie Ratings",
            xlab = "Movies", ylab = "Ratings",
            las = 2, col = "darkgreen")
  })
  
  # Render the summary
  output$summary <- renderPrint({
    data <- filtered_data()
    summary(data)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
