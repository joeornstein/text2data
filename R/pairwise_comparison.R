pairwise_comparison <- function(text,
                                instructions = 'Decide which of the following texts is more negative in sentiment.',
                                model = 'text-davinci-003',
                                openai_api_key = Sys.getenv('OPENAI_API_KEY')) {


  openai <- reticulate::import("openai")

  if(is.null(openai_api_key) | Sys.getenv('OPENAI_API_KEY') == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }

}
