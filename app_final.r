library(shiny)
library(dplyr)
library(tidyr)
library(leaflet)
library(tmaptools)
library(scales)
library(reshape2)
library(shinycssloaders)
library(bslib)
library(ggplot2)

ts <- read.csv("ts_df.csv")
ts$date <- as.Date(ts$date, format = "%d.%m.%Y")
setlist <- read.csv("setlist.csv")
cechy <- c("danceability", "valence", "energy", "loudness", "acousticness", "tempo", "duration_ms")

album_colors <- c(
  "1989" = "skyblue1",
  "Evermore" = "burlywood3", 
  "Fearless" = "gold",
  "Folklore" = "seashell3",
  "Lover" = "hotpink", 
  "Midnights" = "dodgerblue4",
  "Red" = "red2",
  "Reputation" = "black", 
  "Speak Now" = "mediumpurple1",
  "The Tortured Poets Department" = "gray50",
  "Taylor Swift (debut)" = 'darkseagreen3',
  "Other" = 'thistle1')

koncerty <- paste(ts$city, ts$date)
koncerty_numery <- setNames(koncerty, paste(seq_along(koncerty), koncerty, sep = ". "))

artists <- as.data.frame(c(ts$opener_ar1, ts$opener_ar2))
colnames(artists) <- "artist"
artists$artist <- na_if(trimws(artists$artist), "")
artists <- na.omit(artists)
artist_df <- as.data.frame(sort(table(artists$artist), decreasing = TRUE))
colnames(artist_df) <- c("artist", "count")

cechy_polskie <- c(
  "energy" = "Energia (energy)",
  "danceability" = "Taneczność (danceability)",
  "valence" = "Pozytywność (valence)",
  "acousticness" = "Akustyczność (acousticness)",
  "speechiness" = "Zawartość mowy (speechiness)",
  "tempo" = "Tempo (tempo)",
  "loudness" = "Głośność (loudness)",
  "duration_ms" = "Długość utworu (duration_ms)"
)


ui <- navbarPage(
                 title = div(
                 "The Eras Tour: Muzyczna podróż dookoła świata w liczbach"),
                 
                 tabPanel("Mapa trasy koncertowej",
                          fluidPage(
                            tags$style(HTML("h3 {font-weight: bold;}")),
                            h3("Witaj w muzycznej podróży!"),
                            p("Na poniższej mapie zaznaczone zostały wszystkie 
                              miasta, w których Taylor Swift wystąpiła w ramach 
                              trasy Eras Tour. Kliknij na wybrany punkt, aby 
                              dowiedzieć się więcej o danym koncercie."),
                            column(8, offset = 2,
                            sliderInput(
                              inputId = "data_filter",
                              label = "Wybierz zakres dat koncertów:",
                              min = min(ts$date),  
                              max = max(ts$date),
                              value = c(min(ts$date), max(ts$date)),  
                              timeFormat = "%Y-%m-%d",
                              width = "100%"
                            ),
                            checkboxInput(
                              inputId = "pokaz_trase",
                              label = "Zobacz kolejność koncertów",
                              value = TRUE
                            ),
                            leafletOutput("mapa", height = "700px", width = "100%")
                            )) %>% withSpinner()
                          ),
                 
                 tabPanel("Setlista",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("Koncert",
                                          "Wybierz koncert:",
                                          choices = koncerty_numery, 
                                          selected = koncerty[1]),
                              hr(),
                              selectInput("cecha",
                                          "Wybierz cechę do wykresu punktowego:",
                                          choices = setNames(names(cechy_polskie), cechy_polskie), 
                                          names(cechy_polskie)[1]),
                              checkboxInput("czyLiniaTrendu",
                                            "Pokaż linię trendu",
                                            FALSE)
                            ),
                            mainPanel(
                              h3("Udział piosenek z albumów w setliście danego koncertu"),
                              p("Poniższy wykres kafelkowy pokazuje, jak rozkładają się utwory 
                                w setliście wybranego koncertu według albumów. Każdy kwadrat 
                                reprezentuje jedną piosenkę."),
                              plotOutput("wykresWaffle")  %>% withSpinner(), 
                              hr(),
                              h3("Analiza wybranej cechy piosenek"),
                              p("Poniższy wykres punktowy pokazuje rozkład wybranej 
                                cechy (np. danceability, energy) dla kolejnych 
                                piosenek w setliście. Możesz również zaznaczyć opcję 
                                wyświetlenia linii trendu."),
                              plotOutput("wykresPunktowy")  %>% withSpinner()
                            )
                          )
                 ),
                 
                 tabPanel("Analiza tras koncertowych",
                          fluidPage(
                            h3("Analiza tras koncertowych Taylor Swift"),
                            p("Poniższy wykres przedstawia porównanie pięciu tras 
                              koncertowych Taylor Swift pod względem liczby koncertów, 
                              sprzedanych biletów i przychodu."),
                            plotOutput("tour_summary_plot")  %>% withSpinner()
                          )
                 ),
                 
  theme = bslib::bs_theme(bootswatch = "minty"),
  header = tags$head(tags$style(HTML("
    body {
        font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        background-color: ghostwhite;}
    h3 {
        font-family: 'Segoe UI', Helvetica, Arial, sans-serif;
        font-weight: bold; }
    h3 { font-weight: bold; }
     .navbar-nav .nav-link {
        color: #000000; font-family: 'Segoe UI', Helvetica, Arial, sans-serif}
    .navbar-nav .nav-link.active {background-color: #ADD8E6;}
    .navbar-nav .nav-link:hover {background-color: deepskyblue;}
    .navbar {background-color: aliceblue;
    display: flex; 
        flex-direction: row;}
    .navbar-brand {
        font-family: 'Segoe UI', Helvetica, Arial, sans-serif;
        font-size: 30px; font-weight: bold;
        margin-right: 10px;
        color: #333333;}
    .navbar-nav {
      width: 100%; 
      display: flex;
      list-style: none;
      padding-left: 0;
      margin-top: 0; 
      margin-bottom: 0;}
    .navbar .container-fluid { 
        display: flex;
        flex-direction: column; 
        width: 100%;
        justify-content: flex-start;
    }
  
  .footer {
      width: 100%;
    background-color: aliceblue; 
      color: #555555; 
      text-align: center;
    padding: 10px 0; 
      font-family: 'Segoe UI', Helvetica, Arial, sans-serif; 
      font-size: 14px;
    border-top: 1px solid #e0e0e0;
    margin-top: 40px;
  }
  .footer p {
    margin-bottom: 5px; 
  }
  .footer a {
    color: #555555; 
      text-decoration: none; 
  }
  .footer a:hover {
    text-decoration: underline;
  }
  "))),
  
  div(class = "footer",
      p("Autorzy: Barbara Jankowska, Gerard Mańkowski, Krystian Kaliś"), 
      p("Wydział Matematyki i Nauk Informacyjnych Politechniki Warszawskiej"),
  )
)

server <- function(input, output, session) {
  
  
  
  filtered_ts <- reactive({
    req(input$data_filter)
    ts %>%
      filter(date >= input$data_filter[1], date <= input$data_filter[2])
  })
  
  filtered_ts_mapa <- reactive({
    filtered_ts() %>%
      group_by(city, lon, lat, date) %>%
      summarise(
        opener1 = first(opener_ar1),
        opener2 = first(opener_ar2),
        tickets = sum(tick_sales, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      mutate(
        opener1 = na_if(trimws(opener1), ""),
        opener1 = na_if(opener1, "NA"),
        opener2 = na_if(trimws(opener2), ""),
        opener2 = na_if(opener2, "NA"),
        openers = case_when(
          !is.na(opener1) & !is.na(opener2) ~ paste(opener1, "&", opener2),
          !is.na(opener1) ~ opener1,
          !is.na(opener2) ~ opener2,
          TRUE ~ ""
        )
      ) %>% 
      group_by(city, lon, lat) %>%
      summarise(
        details = paste0(
          "<b>", format(date, "%Y-%m-%d"), "</b>: ",
          ifelse(openers != "", paste0(openers, " — "), ""),
          format(tickets, big.mark = " ", scientific = FALSE),
          "<br>"
        ) %>% paste(collapse = ""),
        total_tickets = sum(tickets),
        .groups = "drop"
      )
  })
  
  filtered_path <- reactive({
    filtered_ts() %>%
      arrange(date) %>%
      distinct(city, lon, lat, .keep_all = TRUE) %>%
      select(lon, lat)
  })
  
  output$mapa <- renderLeaflet({
    
    dane <- filtered_ts_mapa()
    
    pal <- colorNumeric(
      palette = "YlOrRd",
      domain = log10(dane$total_tickets + 1)
    )
    
    mapa <- leaflet(dane, options = leafletOptions(minZoom = 2, maxZoom = 6)) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        label = ~city,
        color = ~pal(log10(total_tickets)),
        radius = ~sqrt(total_tickets) / 150,
        fillOpacity = 0.9,
        popup = ~paste0(
          "<b>", city, "</b><br><br>",
          "<b>Szczegóły koncertów:</b><br>",
          details,
          "<br><b>️ Łącznie sprzedanych biletów:</b> ",
          format(total_tickets, big.mark = " ", scientific = FALSE)
        )
      ) %>%
      addLegend(
        pal = pal,
        values = ~log10(total_tickets),
        title = htmltools::HTML("<b> Taylor Swift<br/>The Eras Tour<br/>Sprzedane bilety (log)</b>"),
        position = "bottomright",
      ) 
    if (input$pokaz_trase) {
      path_coords <- filtered_path()
      mapa <- mapa %>%
        addPolylines(
          lng = path_coords$lon,
          lat = path_coords$lat,
          color = "blue",
          weight = 2,
          opacity = 0.6,
          group = "Trasa"
        )
    }
    mapa %>%
      setView(lng = 0, lat = 20, zoom = 2) %>%
      setMaxBounds(lng1 = -170, lat1 = -60, lng2 = 192, lat2 = 85)
  })
  
  
  
  output$wykresWaffle <- renderPlot({
    indeks <- match(input$Koncert, koncerty)
    
    surp_songs_raw <- c(ts[indeks, "surp_1"], ts[indeks, "surp_2"])
    surp_songs <- unlist(strsplit(surp_songs_raw, "\\s*/\\s*"))
    
    surp_albums_raw <- c(ts[indeks, "album_1"], ts[indeks, "album_2"])
    surp_albums <- unlist(strsplit(surp_albums_raw, "\\s*/\\s*"))
    
    df <- data.frame(track_name = surp_songs, album_name = surp_albums)
    
    df$album_short <- dplyr::recode(df$album_name,
                                    "1989" = "1989",
                                    "evermore" = "Evermore",
                                    "Fearless" = "Fearless",
                                    "folklore" = "Folklore",
                                    "Lover" = "Lover",
                                    "Midnights" = "Midnights",
                                    "Red" = "Red",
                                    "reputation" = "Reputation",
                                    "Speak Now" = "Speak Now",
                                    "The Tortured Poets Departament" = "The Tortured Poets Department",
                                    "Taylor Swift (debut)" = "Taylor Swift (debut)",
                                    "Other" = "Other")
    
    setlist2 <- bind_rows(setlist, df)
    
    album_levels <- c("Lover", "Fearless", "Red", "Speak Now", "Reputation", 
                      "Folklore", "Evermore", "1989", "The Tortured Poets Department", 
                      "Midnights", "Taylor Swift (debut)", "Other")
    
    setlist2$album_short <- factor(setlist2$album_short, levels = album_levels)
    
    album_counts <- setlist2 %>%
      count(album_short) %>%
      filter(!is.na(album_short)) %>%
      arrange(factor(album_short, levels = album_levels))
    
    # Wykres geom_tile
    tile_data <- album_counts %>%
      uncount(n) %>%
      group_by(album_short) %>%
      mutate(y = row_number(),
             x = factor(album_short, levels = album_levels)) %>%
      ungroup()
    
    ggplot(tile_data, aes(x = x, y = y, fill = album_short)) +
      geom_tile(color = "white", size = 0.5) +
     #scale_x_continuous(breaks = 1:length(album_levels), labels = album_levels) +
      scale_fill_manual(values = album_colors[names(album_colors) %in% album_levels]) +
      coord_fixed() +
      labs(title = "Udział piosenek z albumów w setliście") +
      theme_minimal(base_size = 12) +
      theme(
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        legend.position = "none"
      )
  })
  
  
  
    output$wykresPunktowy <- renderPlot({
      gg <- ggplot(setlist) +
        geom_point(aes(x = number, y = !!rlang::sym(input$cecha), color = album_short)) +
        labs(
          x = "Numer piosenki",
          y = cechy_polskie[input$cecha],
          color = "Album",
          title = paste("Analiza cechy:", cechy_polskie[input$cecha])
        ) +
        scale_color_manual(values = album_colors)
      
      if(input$czyLiniaTrendu) {
        gg <- gg + geom_smooth(aes(x = number, y = .data[[input$cecha]]), se = FALSE)
      }
      gg
    
      
  })
  
    
    
    output$tour_summary_plot <- renderPlot({
      
      ### Dane są wzięte z różnych źródeł
      
      swift_tours_summary <- data.frame(
        Tour = c(
          "Eras Tour",
          "Reputation Stadium Tour",
          "The 1989 World Tour",
          "The Red Tour",
          "Speak Now World Tour"
        ),
        Year = c("2023–24", "2018", "2015", "2013–14", "2011–12"),
        Concerts = c(149, 53, 83, 86, 110),
        Tickets_Sold = c(10168008, 2888922, 2278647, 1702933, 1642435),
        Gross_Revenue_USD = c(2100000000, 345675146, 250733097, 150200000, 123700000)
      )
      
      swift_tours_summary$log_Tickets_Sold <- log10(swift_tours_summary$Tickets_Sold)
      swift_tours_summary$log_Gross_Revenue_USD <- log10(swift_tours_summary$Gross_Revenue_USD)
      
      ggplot(swift_tours_summary, aes(
        x = log_Tickets_Sold,
        y = log_Gross_Revenue_USD,
        size = Concerts,
        color = Tour
      )) +
        geom_point(alpha = 0.5) +
        scale_size_continuous(range = c(10, 30)) +
        scale_color_manual(values = c(
          "Eras Tour" = "dodgerblue4",
          "The Red Tour" = "red2",
          "Speak Now World Tour" = "mediumpurple1",
          "Reputation Stadium Tour" = "black",
          "The 1989 World Tour" = "gold"
        )) +
        labs(
          title = "Taylor Swift – Trasy koncertowe",
          x = "Liczba sprzedanych biletów(log)",
          y = "Przychód w USD(log)",
          size = "Liczba koncertów"
        ) +
        coord_cartesian(
          xlim = c(6.1, 7.1),
          ylim = c(7.5, 9.75)
        ) +
        theme_light()
       })
    
    
}

shinyApp(ui = ui, server = server)

