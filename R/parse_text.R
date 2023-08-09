#' Create Dataframe From Text
#'
#' @description Constructs a data table from unstructured text according to the user's instructions.
#'
#' @param text The text to be converted into a tidy dataframe
#' @param instructions Instructions to be included in the GPT-3 prompt (format them like you would format instructions to a human research assistant, in as much detail as possible).
#' @param col_names A list of column names for each variable in the dataframe.
#' @param model Which model variant of GPT-3 to use. Defaults to 'gpt-3.5-turbo'
#' @param openai_api_key Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.
#'
#' @return A dataframe with a number of columns equal to `ncol(col_names)`
#' @export
#'
#' @examples
#' parse_text(text = "John went to the store. Rosie ran errands at the mall.",
#'            instructions = "Create a dataset from the following passage with the names of each character and the place they went.",
#'            col_names = c("Name of Character", "Where They Went"))
parse_text <- function(text,
                       instructions,
                       col_names,
                       model = 'gpt-3.5-turbo',
                       openai_api_key = Sys.getenv('OPENAI_API_KEY')) {

  openai <- reticulate::import("openai")

  if(openai_api_key == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }

  # format the prompt
  prompt <- paste0(instructions,
                  "\n---\n",
                  text,
                  "\n---\n\n",
                  paste0("| ", col_names, " ", collapse = ""),
                  "|\n|",
                  paste0(rep(" --- |", length(col_names)),
                         collapse = ""),
                  "\n")

  # for Chat Endpoint, embed the prompt in a "messages" dictionary object
  messages <- reticulate::dict(role = 'user', content = prompt)

  # query the API
  response <- openai$ChatCompletion$create(model = model,
                                           messages = c(messages),
                                           temperature = as.integer(0),
                                           max_tokens = as.integer(2000))

  output <- response$choices[[1]]$message$content


  # deprecated Completions endpoint
  # response <- openai$Completion$create(
  #   engine = model,
  #   prompt = paste0(instructions, "\n---\n", text, "\n---\n\n", paste0('| ', var_descriptions, ' ', collapse = ''), "|\n|",
  #                   paste0( rep(' --- |', length(var_descriptions)), collapse = ''), "\n"),
  #   temperature = as.integer(0),
  #   max_tokens = as.integer(1000)
  # )
  # output <- response$choices[[1]]$text

  # convert the resulting table to a tidy dataframe
  d <- readr::read_delim(
    # paste an extra row, in case there's only one row.
    paste0(output, '\n', paste(rep(
      '|', length(col_names) + 1
    ), collapse = '')),
    delim = '|',
    col_names = c('empty1', col_names, 'empty2')
  ) |>
    # read_delim sees the leading and trailing |'s as marking empty columns. remove those columns
    dplyr::select(-empty1,-empty2) |>
    # remove leading or trailing whitespace
    dplyr::mutate_all(stringr::str_squish) |>
    # remove that last row
    dplyr::slice(1:dplyr::n() - 1)

  return(d)

}
