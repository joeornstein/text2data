# global reference to openai (will be initialized in .onLoad)
openai <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to openai
  openai <<- reticulate::import("openai", delay_load = TRUE)
}
