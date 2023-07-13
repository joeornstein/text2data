#' Create Dataframe From Text
#'
#' @description Constructs a GPT prompt to parse data from unstructured text according to the user's instructions.
#'
#' @param text The text to be converted into a tidy dataframe
#' @param instructions Instructions to be included in the GPT prompt (format them like you would format instructions to a human research assistant, in as much detail as possible).
#' @param var_descriptions Optional: A list of descriptions for each variable in the dataframe. (If not specified, will query GPT to create these)
#' @param col_names Optional: A list of column names for the resulting dataframe. Must be the same length as the list of variable descriptions. If not provided, var_descriptions will be used for column names.
#' @param model Which model variant of GPT to use. Defaults to 'gpt-3.5-turbo'
#' @param openai_api_key Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.
#'
#' @return A dataframe with a number of columns equal to `ncol(var_descriptions)`
#' @export
#'
#' @examples
#' parse_text(text = "John went to the store. Rosie ran errands at the mall.",
#'            instructions = "Create a dataset from the following passage with the names of each character and the place they went.",
#'            var_descriptions = c("Name of Character", "Where They Went"),
#'            col_names = c('name', 'destination') )
parse_text <- function(text,
                       instructions = "Create a dataset from the following package extracting relevant information",
                       var_descriptions = character(0),
                       col_names = character(0),
                       model = 'gpt-3.5-turbo',
                       openai_api_key = Sys.getenv('OPENAI_API_KEY')) {
  
  openai <- reticulate::import("openai")
  
  if(openai_api_key == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }
  
  if(length(var_descriptions) == 0) {
    # Construct the list of messages for conversation
    messages <- list(
      list("role" = "system", "content" = "You have been given a task to create a dataset. Please suggest some variable names. For example, in John went to the store. Rosie ran errands at the mall, you would return 'Name, Destination' Keep them comma separated"),
      list("role" = "user", "content" = text)
    )
    
    # query the API for variable names
    response <- openai$ChatCompletion$create(
      model = model,
      messages = messages,
      temperature = as.integer(0),
      max_tokens = as.integer(100)
    )
    
    # Get the variable names
    var_descriptions <- strsplit(response$choices[[1]]$message$content, ",")[[1]]
    var_descriptions <- noquote(trimws(var_descriptions))  # remove quotations and leading/trailing whitespace
  }
  
  # Construct the list of messages for conversation
  messages <- list(
    list("role" = "system", "content" = instructions),
    list("role" = "user", "content" = text),
    list("role" = "user", "content" = paste0('| ', var_descriptions, ' ', collapse = ''), "|\n|",
         paste0( rep(' --- |', length(var_descriptions)), collapse = ''), "\n")
  )
  
  # query the API
  response <- openai$ChatCompletion$create(
    model = model,
    messages = messages,
    temperature = as.integer(0),
    max_tokens = as.integer(1000)
  )
  
  output <- response$choices[[1]]$message$content
  
  # convert the resulting table to a tidy dataframe
  d <- readr::read_delim(
    # paste an extra row, in case there's only one row.
    paste0(output, '\n', paste(rep(
      '|', length(var_descriptions) + 1
    ), collapse = '')),
    delim = '|',
    col_names = c('empty1', var_descriptions, 'empty2')
  ) |>
    # read_delim sees the leading and trailing |'s as marking empty columns. remove those columns
    dplyr::select(-empty1,-empty2) |>
    # remove leading or trailing whitespace
    dplyr::mutate_all(stringr::str_squish) |>
    # remove that last row
    dplyr::slice(1:dplyr::n() - 1)
  
  if(length(col_names) != 0 & length(var_descriptions) != length(col_names)){
    stop('Error: col_names and var_descriptions must be the same length.')
  }
  
  if(length(col_names) == length(var_descriptions)){
    names(d) <- col_names
  }
  
  return(d)
}

