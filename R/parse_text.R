parse_text <- function(text,
                       instructions,
                       var_descriptions,
                       col_names = character(0),
                       model = 'text-davinci-003',
                       openai_api_key = Sys.getenv('OPENAI_API_KEY')) {

  openai <- reticulate::import("openai")

  if(is.null(openai_api_key)){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }

  # if(length(var_descriptions) == 0){
  #   stop("Please provide a list of descriptions for each variable in the dataframe.")
  # }
  #
  # if(instructions == ''){
  #   stop("Please provide instructions (in plain English) describing in as much detail as possible the dataframe you would like to create.")
  # }

  # query the API
  response <- openai$Completion$create(
    engine = model,
    prompt = paste0(instructions, "\n\n", text, "\n\n", paste0('| ', var_descriptions), " |\n|",
                    paste0( rep(' --- |', length(var_descriptions)), collapse = ''), "\n"),
    temperature = as.integer(0)
  )

}
