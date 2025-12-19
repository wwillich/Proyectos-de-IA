# ============================
# Librerías
# ============================
library(tidyverse)
library(keras3)
library(tensorflow)

# ============================
# Paths y parámetros
# ============================
setwd("C:/Users/Walter/Desktop/Entrenamiento IA imagenes")

# Solo tomar subcarpetas como clases
label_list <- list.dirs("C:/Users/Walter/Desktop/Entrenamiento IA imagenes",
                        full.names = FALSE, recursive = FALSE)
output_n <- length(label_list)
save(label_list, file = "label_list.RData")
print(label_list)
print(output_n)

width  <- 224
height <- 224
target_size <- c(width, height)

batch_size <- 32
epochs     <- 50   # grande, EarlyStopping detendrá antes si es necesario

# ============================
# Carga de datasets
# ============================
path_train <- "C:/Users/Walter/Desktop/Entrenamiento IA imagenes"

train_ds <- image_dataset_from_directory(
  directory = path_train,
  labels = "inferred",
  label_mode = "categorical",
  validation_split = 0.2,
  subset = "training",
  seed = 2021,
  image_size = target_size,
  batch_size = batch_size
)

val_ds <- image_dataset_from_directory(
  directory = path_train,
  labels = "inferred",
  label_mode = "categorical",
  validation_split = 0.2,
  subset = "validation",
  seed = 2021,
  image_size = target_size,
  batch_size = batch_size
)

# ============================
# Data Augmentation
# ============================
data_augmentation <- keras_model_sequential() %>%
  layer_random_flip("horizontal") %>%
  layer_random_rotation(0.1)

train_ds <- train_ds %>%
  tf$data$Dataset$map(function(x, y) list(data_augmentation(x), y))

# ============================
# Normalización
# ============================
normalization_layer <- layer_rescaling(scale = 1/255)

train_ds <- train_ds %>% 
  tf$data$Dataset$map(function(x, y) list(normalization_layer(x), y))
val_ds <- val_ds %>% 
  tf$data$Dataset$map(function(x, y) list(normalization_layer(x), y))

# Prefetch para acelerar
train_ds <- train_ds %>% tf$data$Dataset$prefetch(tf$data$AUTOTUNE)
val_ds   <- val_ds %>% tf$data$Dataset$prefetch(tf$data$AUTOTUNE)

# ============================
# Modelo base (Xception)
# ============================
mod_base <- application_xception(
  weights = "imagenet",
  include_top = FALSE,
  input_shape = c(width, height, 3)
)
freeze_weights(mod_base)

# ============================
# Construcción del modelo
# ============================
model_function <- function(learning_rate = 0.001,
                           dropoutrate = 0.2, n_dense = 1024) {
  
  tf$keras$backend$clear_session()
  
  inputs <- layer_input(shape = c(width, height, 3))
  x <- mod_base(inputs)
  x <- x %>%
    layer_global_average_pooling_2d() %>%
    layer_dense(units = n_dense, activation = "relu") %>%
    layer_dropout(rate = dropoutrate) %>%
    layer_dense(units = output_n, activation = "softmax")
  
  model <- keras_model(inputs = inputs, outputs = x)
  
  model %>% compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_adam(learning_rate = learning_rate),
    metrics = "accuracy"
  )
  
  return(model)
}

model <- model_function()
summary(model)

# ============================
# Callbacks para entrenamiento
# ============================
early_stop <- callback_early_stopping(
  monitor = "val_loss",
  patience = 3,
  restore_best_weights = TRUE
)

reduce_lr <- callback_reduce_lr_on_plateau(
  monitor = "val_loss",
  factor = 0.5,
  patience = 2,
  min_lr = 1e-6
)

# ============================
# Entrenamiento
# ============================
history <- model %>% fit(
  train_ds,
  validation_data = val_ds,
  epochs = epochs,
  callbacks = list(early_stop, reduce_lr)
)

library(keras)
width <- 224
height<- 224
target_size <- c(width, height)
rgb <- 3 #color channels
path_test <- "C:/Users/Walter/Desktop/Entrenamiento IA imagenes"
test_data_gen <- image_data_generator(rescale = 1/255)
test_images <- flow_images_from_directory(path_test,
                                          test_data_gen,
                                          target_size = target_size,
                                          class_mode = "categorical",
                                          classes = label_list,
                                          shuffle = F,
                                          seed = 2021)
model %>% evaluate_generator(test_images,
                             steps = test_images$n)

# ============================
# Guardar modelo compatible Keras3
# ============================
model %>% save_model("identificacion_vehiculos.keras")
# Ahora podés recargarlo sin problemas:
model <- load_model_tf("www/identificacion_vehiculos.keras")
