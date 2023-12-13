library(shiny)
library(tidyverse)
library(DT)
library(markdown)

# Create the spreadsheet structure with unique column names
create_spreadsheet <- function(rows, columns) {
  col_names <- LETTERS[1:columns]
  matrix(nrow = rows, ncol = columns, data = NA) %>%
    as_tibble() %>%
    set_names(col_names)
}

# Initialize the spreadsheet
spreadsheet <- reactiveVal(create_spreadsheet(1000, 26)) # 26 columns for A to Z

# Function to update cell value with formula handling and error handling
update_cell <- function(spreadsheet, row, column, value) {
  col_name <- LETTERS[column]
  updated_spreadsheet <- spreadsheet()
  
  if (startsWith(value, "=")) {
    # Remove the '=' and evaluate the expression
    expr <- substr(value, 2, nchar(value))
    
    # Error handling for the evaluation
    value <- tryCatch({
      eval(parse(text = expr))
    }, error = function(e) {
      # Return the original expression if an error occurs
      paste("Error: Invalid formula", expr)
    })
  } else {
    # If the value does not start with '=', treat it as a string
    # Convert to numeric if it is a valid number
    if (suppressWarnings(!is.na(as.numeric(value)))) {
      value <- as.numeric(value)
    }
  }
  
  updated_spreadsheet[row, col_name] <- value
  spreadsheet(updated_spreadsheet)
}


# Shiny UI
ui <- fluidPage(
  titlePanel("Web-based Spreadsheet with Explanation"),
  
  # Tabset Panel
  tabsetPanel(
    tabPanel("Spreadsheet", 
             numericInput("row", "Row", 1, min = 1, max = 1000),
             numericInput("column", "Column", 1, min = 1, max = 26),
             textInput("value", "Value", ""),
             actionButton("update", "Update Cell"),
             DTOutput("spreadsheet_table")
    ),
    tabPanel("Explanation",
             htmlOutput("markdown")
    )
  )
)

# Shiny Server
server <- function(input, output, session) {}

# Run the application
shinyApp(ui = ui, server = server)

# HTML Content for the Explanation tab
explanationHTML <- "<h2>How Shiny Works</h2>
    <p>Shiny is an R package that makes it easy to build interactive web applications directly from R. 
    It allows R developers to create web applications without requiring extensive web development skills.</p>
    <p>Here’s a brief overview of its components:</p>
    <h3>UI (User Interface)</h3>
    <p>This part of the app (defined in the <code>ui</code> object) describes what the app looks like. 
    It uses R code to define the layout and appearance of the application.</p>
    <h3>Server</h3>
    <p>The server (defined in the <code>server</code> function) contains the instructions to build and rebuild the app 
    based on user input. It’s where the app’s logic is housed.</p>
<pre><code>
server <- function(input, output, session) {
  observeEvent(input$update, {
    update_cell(spreadsheet, input$row, input$column, input$value)
  })
  
  output$spreadsheet_table <- renderDT({
    spreadsheet()
  }, options = list(pageLength = 10))
  
  output$markdown <- renderUI({
    HTML(explanationHTML)
  })
}

</code></pre>
<h3>The <code>update_cell</code> Function</h3>
<pre><code>
# Function to update cell value with formula handling and error handling
update_cell <- function(spreadsheet, row, column, value) {
  col_name <- LETTERS[column]
  updated_spreadsheet <- spreadsheet()
  
  if (startsWith(value, '=')) {
    # Remove the '=' and evaluate the expression
    expr <- substr(value, 2, nchar(value))
    
    # Error handling for the evaluation
    value <- tryCatch({
      eval(parse(text = expr))
    }, error = function(e) {
      # Return the original expression if an error occurs
      paste('Error: Invalid formula', expr)
    })
  } else {
    # If the value does not start with '=', treat it as a string
    # Convert to numeric if it is a valid number
    if (suppressWarnings(!is.na(as.numeric(value)))) {
      value <- as.numeric(value)
    }
  }
  
  updated_spreadsheet[row, col_name] <- value
  spreadsheet(updated_spreadsheet)
}
</code></pre>
<h3>Reactive Values in Shiny and Their Equivalent in React</h3>
<p>Reactive values in Shiny are objects that can be used to store and reactively respond to changes in data. 
When a reactive value changes, any reactive expressions or outputs that depend on it are automatically updated. 
This concept is somewhat similar to 'state' in React, a popular JavaScript library for building user interfaces. 
In React, 'state' is used to trigger re-renders and update the UI when the data changes.</p>
"

# Update the server function to include the explanation HTML
server <- function(input, output, session) {
  observeEvent(input$update, {
    update_cell(spreadsheet, input$row, input$column, input$value)
  })
  
  output$spreadsheet_table <- renderDT({
    spreadsheet()
  }, options = list(pageLength = 10))
  
  output$markdown <- renderUI({
    HTML(explanationHTML)
  })
}

shinyApp(ui = ui, server = server)