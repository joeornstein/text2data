#' Pairwise Comparison With GPT
#'
#' @param A The first text to compare
#' @param B The second text to compare
#' @param instructions Instructions to be included in the GPT prompt (format them like you would format instructions to a human research assistant).
#' @param model Which model variant of GPT to use. Defaults to 'gpt-3.5-turbo'
#' @param openai_api_key Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.
#'
#' @return A character (A or B)
#' @export
#'
#' @examples
#' pairwise_comparison(A = 'I am so very sad today',
#'                     B = 'I am so very happy today.',
#'                     instructions = 'Decide which of the following texts is more negative in sentiment.')
pairwise_comparison <- function(A, B,
                                instructions = 'Decide which of the following texts is more negative in sentiment.',
                                model = 'gpt-3.5-turbo',
                                openai_api_key = Sys.getenv('OPENAI_API_KEY')) {
  
  
  openai <- reticulate::import("openai")
  
  if(openai_api_key == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }
  
  # Construct the list of messages for conversation
  messages <- list(
    list("role" = "system", "content" = instructions),
    list("role" = "user", "content" = paste0("A. ", A)),
    list("role" = "user", "content" = paste0("B. ", B)),
    list("role" = "system", "content" = "Response (A or B):")
  )
  
  # query the API
  response <- openai$ChatCompletion$create(
    model = model,
    messages = messages,
    max_tokens = as.integer(1),
    temperature = as.integer(0)
  )
  
  
  # this code returns the highest probability output string
  response$choices[[1]]$message$content |>
    # remove carriage returns and whitespace
    stringr::str_squish()
  
}
