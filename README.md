# Web-based Spreadsheet Application in R Shiny

This repository contains the code for a web-based spreadsheet application built using R Shiny. The application allows users to interact with a spreadsheet that supports basic functionalities like editing cells and evaluating simple arithmetic formulas.

## Features

- A spreadsheet with 1000 rows and 26 columns (A to Z).
- Ability to enter numbers, strings, and simple formulas into cells.
- Formulas start with `=` and support basic arithmetic operations (e.g., `=2+2`).
- Error handling for invalid formulas.

## How It Works

- The `create_spreadsheet` function initializes the spreadsheet structure.
- The `update_cell` function handles cell value updates, formula evaluation, error handling, and maintaining type consistency in the spreadsheet.
- The Shiny UI (`ui`) defines the layout and appearance of the web application.
- The Shiny Server (`server`) contains the logic to respond to user interactions.

## Installation

To run this application, you need to have R installed on your system along with the following R packages: `shiny`, `tidyverse`, `DT`, and `markdown`.

You can install these packages using the following commands in R:

```R
install.packages("shiny")
install.packages("tidyverse")
install.packages("DT")
install.packages("markdown")
```

## Running the Application

To run the application, clone this repository and open the R script. Then, execute the script in your R environment, and the application will start in a web browser.

## Contributing

Contributions to this project are welcome. Please feel free to fork the repository, make changes, and submit a pull request.

## License

This project is open source and available under the [MIT License](LICENSE).
