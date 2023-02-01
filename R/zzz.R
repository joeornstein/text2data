# global reference to Python packages we need (will be initialized in .onLoad)
#os <- NULL
openai <- NULL
#math <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to packages
  #os <<- reticulate::import("os", delay_load = TRUE)
  openai <<- reticulate::import("openai", delay_load = TRUE)
  #math <<- reticulate::import("math", delay_load = TRUE)
}
