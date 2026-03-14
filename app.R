library(shiny)
library(tidyverse)
library(bslib)

# Load Data
crime <- read_csv("data/raw/crime_rate_data_raw.csv") %>%
  rename(city = department_name,
         state_id = ORI) %>%
  mutate(
    city = str_split_fixed(city, ",", 2)[,1],
    state_id = substr(state_id, 1, 2)
  )

cities <- read_csv("data/raw/uscities_raw.csv") %>%
  filter(state_name != "Puerto Rico") %>%
  select(city, state_id, lat, lng)

df <- inner_join(crime, cities, by = c("city", "state_id"))

ui <- page_sidebar(
  title = "US Crime Dashboard",
  sidebar = sidebar(
    h4("Filters"),
    sliderInput(
      "year_range",
      "Select Year Range",
      min = min(df$year, na.rm = TRUE),
      max = max(df$year, na.rm = TRUE),
      value = c(max(df$year) - 4, max(df$year)),
      step = 1
    )
  ),
  
  # Main content
  layout_columns(
    value_box(
      title = "Total Violent Crimes",
      value = textOutput("total_crimes")
    ),
    card(
      h5("Violent Crime Rate Over Time"),
      plotOutput("line_plot", height = "350px")
    )
  )
)


server <- function(input, output, session) {
  
  filtered_df <- reactive({
    df %>%
      filter(year >= input$year_range[1],
             year <= input$year_range[2])
  })
  
  output$total_crimes <- renderText({
    sum(filtered_df()$violent_crime, na.rm = TRUE) |> scales::comma()
  })
  
  output$line_plot <- renderPlot({
    filtered_df() %>%
      group_by(year) %>%
      summarize(rate = mean(violent_per_100k, na.rm = TRUE)) %>%
      ggplot(aes(x = year, y = rate)) +
      geom_line(color = "#800000", linewidth = 1.2) +
      geom_point(color = "#800000") +
      labs(
        x = "Year",
        y = "Violent Crime per 100k",
        title = "Average Violent Crime Rate"
      ) +
      theme_minimal(base_size = 14)
  })
}

shinyApp(ui, server)
