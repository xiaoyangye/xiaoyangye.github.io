#https://shanghai.hosting.nyu.edu/data/r/case-4-database-management-shiny.html
#A great tutorial

library(shiny)
library(shinydashboard)
library(dplyr)
library(glue)
library(shinyauthr)
library(RSQLite)
library(DBI)
library(lubridate)
library(DT)
library(tidyverse)
library(readxl)

# How many days should sessions last?
cookie_expiry <- 7

# This function must return a data.frame with columns user and sessionid.  Other columns are also okay
# and will be made available to the app after log in.

get_sessions_from_db <- function(conn = db, expiry = cookie_expiry) {
  dbReadTable(conn, "sessions") %>%
    mutate(login_time = ymd_hms(login_time)) %>%
    as_tibble() %>%
    filter(login_time > now() - days(expiry))
}

# This function must accept two parameters: user and sessionid. It will be called whenever the user
# successfully logs in with a password.

add_session_to_db <- function(user, sessionid, conn = db) {
  tibble(user = user, sessionid = sessionid, login_time = as.character(now())) %>%
    dbWriteTable(conn, "sessions", ., append = TRUE)
}

db <- dbConnect(SQLite(), ":memory:")
dbCreateTable(db, "sessions", c(user = "TEXT", sessionid = "TEXT", login_time = "TEXT"))

user_base <- tibble(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  password_hash = sapply(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("Dear Colleague!", "User Two")
)

ui <- dashboardPage(
  dashboardHeader(
    title = "High school coursetaking in Rhode Island",
    titleWidth = 400, 
    tags$li(
      class = "dropdown",
      style = "padding: 8px;",
      shinyauthr::logoutUI("logout")
    ),
    tags$li(
      class = "dropdown",
      tags$a(
        icon("map"),
        href = "https://www.annenberginstitute.org",
        title = "Annenberg@Brown"
      )
    )
  ),
  
  dashboardSidebar(
    collapsed = TRUE,
    div(textOutput("welcome"), style = "padding: 20px"),
    sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("house")),
        menuItem("Introduction", tabName = "intro", icon = icon("file")),
        menuItem("Flowchart", tabName = "flow", icon = icon("users")),
        menuItem("Course codes", tabName = "code", icon = icon("file-code"))
        # https://fontawesome.com/v6.0/icons
    )
  ),
  
  dashboardBody(
    shinyauthr::loginUI(
      "login", 
      cookie_expiry = cookie_expiry
      #additional_ui = tagList(
      #  tags$p("test the different outputs from the sample logins below
      #       as well as an invalid login attempt.", class = "text-center"),
      #  HTML(knitr::kable(user_base[, -3], format = "html", table.attr = "style='width:100%;'"))
      #)
    ),
    tabItems(
      tabItem(tabName = "home", uiOutput("homeUI")),
      tabItem(tabName = "intro", uiOutput("introUI")),
      tabItem(tabName = "flow", uiOutput("flowUI")),
      tabItem(tabName = "code", uiOutput("codeUI"))
    )
  )
)

server <- function(input, output, session) {
  
  # call login module supplying data frame, user and password cols and reactive trigger
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password_hash,
    sodium_hashed = TRUE,
    cookie_logins = TRUE,
    sessionid_col = sessionid,
    cookie_getter = get_sessions_from_db,
    cookie_setter = add_session_to_db,
    log_out = reactive(logout_init())
  )
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  # hide/show body and sidebar
  observe({
    if (credentials()$user_auth) {
      shinyjs::removeCssClass(selector = "body", class = "sidebar-collapse")
    } else {
      shinyjs::addCssClass(selector = "body", class = "sidebar-collapse")
    }
  })
  
  user_info <- reactive({
    credentials()$info
  })
  
  user_data <- reactive({
    req(credentials()$user_auth)
    
    if (user_info()$permissions == "admin") {
      dplyr::starwars[, 1:10]
    } else if (user_info()$permissions == "standard") {
      dplyr::storms[, 1:11]
    }
  })
  
  output$welcome <- renderText({
    req(credentials()$user_auth)
    
    glue("Welcome {user_info()$name}")
  })
  
  output$homeUI <- renderUI({
    req(credentials()$user_auth)
    
      fluidPage(
            titlePanel("Individualized optimal course sequences for student success"), 
            
            mainPanel(
              p("High school mathematics and science courses are a key lever for preparing
            students for college and career success as well as expanding and diversifying 
            participation in STEM. 
            Given the apparent, long-lasting benefits of advanced mathematics and science courses, 
            policy conversations and previous literature have focused on enrolling more students in advanced courses 
            in high school. However, we know relatively little about the coursetaking trajectories regarding which courses 
            to take, when to take them, and in what sequential orders.", style = "font-size:large"),
              
              p("In particular, American high school students need to choose a specific coursetaking trajectory 
            in mathematics and science from more than 1.5 million possible course sequences.  
            Students may not make optimal decisions due to cognitive and informational barriers to finding 
            the personalized “optimal” trajectory from all the possible options that are correlated with uncertain
            potential outcomes. Understanding how high school students choose course trajectories will inform the 
            opportunities for effectively guiding students’ coursetaking decisions and improving their long-term success.", style = "font-size:large")
              
              #p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
              #strong("strong() makes bold text."),
              #em("em() creates italicized (i.e, emphasized) text."),
              #br(),
              #code("code displays your text similar to computer code"),
              #div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
              #br(),
              #p("span does the same thing as div, but it works with",
              #  span("groups of words", style = "color:blue"),
              #  "that appear inside a paragraph.")
                  )
            )
  })
  

  output$introUI <- renderUI({
    req(credentials()$user_auth)
    
             fluidPage(

               mainPanel(
                 strong("A Research-Policy Partnership for Improvement in Rhode Island", style = "font-size:x-large"),
                 
                 strong("Student Success: Equality and Efficiency", style = "font-size:x-large")
                 
                 #p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
                 #strong("strong() makes bold text."),
                 #em("em() creates italicized (i.e, emphasized) text."),
                 #br(),
                 #code("code displays your text similar to computer code"),
                 #div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
                 #br(),
                 #p("span does the same thing as div, but it works with",
                 #  span("groups of words", style = "color:blue"),
                 #  "that appear inside a paragraph.")
               )
             )
  })

  output$flowUI <- renderUI({
    req(credentials()$user_auth)
    
             fluidRow(
               tabBox(
                 title = "Math coursetaking flowchart",
                 id = "tabset3", width = "1000px", height = "1000px", selected = "All students",
                 
                 tabPanel("Black", 
                          box(id = "tabset3b", height = "800px", width = "800px", 
                              htmlOutput("black")
                          )
                 ),
                 
                 tabPanel("Hispanic", "Tab content 2"),
                 
                 tabPanel("White", 
                          box(id = "tabset3c", height = "800px", width = "800px", 
                              htmlOutput("white")
                          )
                 ),                  
                 
                 tabPanel("All students", 
                          box(id = "tabset3a", height = "800px", width = "800px", 
                              htmlOutput("all")
                          )
                 )
               )
             )
  })
  
  output$all <- renderUI({
    includeHTML("fig-all.html")
  })
  
  output$black <- renderUI({
    includeHTML("fig-black.html")
  })    
  
  output$white <- renderUI({
    includeHTML("fig-white.html")
  })     
  
  #-----------------#
  #### Codes page ####
  #-----------------#
  output$codeUI <- renderUI({
    req(credentials()$user_auth)
    
    fluidRow(
      tabBox(
        title = "Course codes",
        id = "coding", width = "1000px", height = "1000px", selected = "CSSC math groups",
        
        tabPanel("SCED-CSSC crosswalk", DT::dataTableOutput("sced")),
        
        tabPanel("CSSC math groups", DT::dataTableOutput("mathgroup"))
      )
    )
    
  })
  
  output$sced <- DT::renderDataTable({
    scedFile <- read_excel("SCED-CSSC.xlsx",sheet=1)
    DT::datatable(scedFile, options = list(lengthMenu = c(10, 20, 100), pageLength = 10), 
                  filter = 'top', 
                  caption = 'This table shows the crosswalks between CSSC codes and SCED codes. Reference: vHenke, R. R., Spagnardi, C., Chen, X., Bradby, D., & Christopher, E. (2019). Considerations for Using the School Courses for the Exchange of Data (SCED) Classification System in High School Transcript Studies: Applications for Converting Course. NCES 2019417. ')
  })
  
  output$mathgroup <- DT::renderDataTable({
    csscFile <- read_excel("SCED-CSSC.xlsx",sheet=2)
    csscFile <- mutate_at(csscFile, c("Math group"), as.factor)
    DT::datatable(csscFile, options = list(lengthMenu = c(10, 20, 100), pageLength = 20),
                  class = 'display', 
                  filter = 'top',
                  caption = 'This table shows the crosswalks between CSSC math courses and the seven Math levels. Reference: Brown, J., Dalton, B., Laird, J., Ifill, N. (2018). Paths Through Mathematics and Science: Patterns and Relationships in High School Coursetaking. NCES 2018-118.')
  })  
  
}

shiny::shinyApp(ui, server)