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
  titlePanel("My Shiny App"),
  sidebarLayout( sidebarPanel(
    actionButton(0, "Cancel"),
    actionButton(1, "Submit", icon=NULL),
    actionButton(1, "Express confusion", icon=NULL),
    sidebarPanel(
      sliderInput("obs","Sliderbar", 0, 100, 0)
    )
  ),
  mainPanel(
    selectInput("select", label = h3("Select box"),
                choices = list("Choice 1" = 1, 
                               "Choice 2" = 2,
                               "Choice 3" = 3), 
                selected = 1),
    dateInput("inputId", "Date Selection", value = NULL, min = NULL, max = NULL,
              format = "yyyy-mm-dd", startview = "month", weekstart = 0,
              language = "en"),
    checkboxGroupInput("checkGroup",
                       label=h3("Checkbox group"),
                       choices=list("Choice 1"=1,
                                    "Choice 2"=2,
                                    "Choice 3"=3),
                       selected = 1),
    p("p creates a paragraph of text. Note: this paragraph is followed by br(),
                     which makes a blank line."),
    p("A new p() command starts a new paragraph. Supply a style attribute to change
                     the format of the entire paragraph",
      style = "font-family: 'times'; font-si16pt"),
    strong("strong() makes bold text."),
    em("em() creates italicized (i.e, emphasized) text."),
    br(),
    code("code displays your text similar to computer code"),
    div("div creates segments of text with a similar style. This division of text
                       is all blue because I passed the argument 'style = color:blue' to div",
        style = "color:blue"),
    br(),
    p("span does the same thing as div, but it works with",
      span("groups of words", style = "color:blue"),
      "that appear inside a paragraph."),
    img(src="bigorb.png", height=72, width=72),
    submitButton(text = "Apply Changes", icon = NULL),
    textOutput("text1"),
    textInput("textaaa", 
              label = h3("Text input"),
              value = "Enter text..."),
    dataTableOutput('mytable')
  )

  
  )

))
