library(shiny)
library(shinydashboard)
library(keras3)
library(tensorflow)

# ============================
# Función de preprocesamiento
# ============================
preprocess_image <- function(path, target_size = c(224L, 224L)) {
  # Leer imagen
  img <- tf$io$read_file(path) %>%
    tf$image$decode_image(channels = 3) %>%
    tf$cast(tf$float32) / 255.0   # Convertir a float antes de cualquier operación
  
  # Asegurar que target_size sea int32
  size_tensor <- tf$constant(as.integer(target_size), dtype = tf$int32)
  
  # Redimensionar
  img <- tf$image$resize(img, size = size_tensor)
  
  # Agregar dimensión batch
  img <- tf$expand_dims(img, axis = as.integer(0))
  
  return(img)
}



# ============================
# Cargar modelo y labels
# ============================
model <- load_model("www/identificacion_vehiculos.keras")
load("www/label_list.RData")
options(scipen = 999) # evitar notación científica

# ============================
# Interfaz (UI)
# ============================
ui <- dashboardPage(
  skin = "green",
  dashboardHeader(
    title = tags$h1("Identificador de vehículos", 
                    style = "font-size: 120%; font-weight: bold; color: white"),
    titleWidth = 350,
    dropdownMenu(
      type = "notifications", 
      icon = icon("question-circle", "fa-1x"),
      badgeStatus = NULL,
      headerText = "",
      tags$li(a(href = "https://forloopsandpiepkicks.wordpress.com",
                target = "_blank",
                tagAppendAttributes(icon("icon-circle"), class = "info"),
                "Created by"))
    )
  ),
  dashboardSidebar(
    width = 350,
    fileInput("input_image", "Subir imagen", accept = c('.jpg','.jpeg','.png')),
    tags$br(),
    tags$p("Carga aquí la imagen del vehículo a identificar.")
  ),
  dashboardBody(
    h4("Instrucciones:"),
    tags$br(),
    tags$p("1. Tomar una foto de un vehículo."),
    tags$p("2. Recortar la imagen para que el vehículo ocupe la mayor parte."),
    tags$p("3. Subir la imagen con el menú de la izquierda."),
    tags$br(),
    fluidRow(
      column(h4("Imagen:"), imageOutput("output_image"), width = 6),
      column(h4("Resultado:"), tags$br(), textOutput("warntext"), tags$br(),
             tags$p("Este vehículo probablemente es:"),
             tableOutput("text"), width = 7)
    ), 
    tags$br()
  )
)

# ============================
# Servidor
# ============================
server <- function(input, output) {
  
  # --- Imagen procesada ---
  image <- reactive({
    req(input$input_image)
    preprocess_image(input$input_image$datapath)
  })
  
  # --- Predicción ---
  prediction <- reactive({
    req(input$input_image)
    pred <- model %>% predict(image())
    pred <- data.frame("Vehículo" = label_list, "Probabilidad" = t(pred))
    pred <- pred[order(pred$Probabilidad, decreasing = TRUE), ][1:5, ]
    pred$Probabilidad <- sprintf("%.2f %%", 100 * pred$Probabilidad)
    pred
  })
  
  # --- Render resultados ---
  output$text <- renderTable({
    prediction()
  })
  
  output$warntext <- renderText({
    req(input$input_image)
    if (as.numeric(sub("%", "", prediction()[1,2])) >= 30) {
      return(NULL)
    }
    "⚠️ Advertencia: No estoy seguro de este vehículo."
  })
  
  output$output_image <- renderImage({
    req(input$input_image)
    outfile <- input$input_image$datapath
    contentType <- input$input_image$type
    list(src = outfile, contentType = contentType, width = 400)
  }, deleteFile = FALSE)
}

# ============================
# Lanzar app
# ============================
shinyApp(ui, server)
