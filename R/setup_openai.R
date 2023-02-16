#' Setup OpenAI Python Module
#'
#' @description A helper function to install the OpenAI Python module, if it is not already on your system.
#'
#' @param method Method for installing python package (see reticulate::py_install)
#' @param conda Use conda? (see reticulate::py_install)
#' @export
setup_openai <- function(method = "auto", conda = "auto") {

  # if the python module is not installed, install it
  if(!reticulate::py_module_available('openai')){
    reticulate::py_install("openai", method = method, conda = conda, pip = TRUE)
  }

}
