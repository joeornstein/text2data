#' Pairwise Comparison With GPT-3
#'
#' @param A The first text to compare
#' @param B The second text to compare
#' @param instructions Instructions to be included in the GPT-3 prompt (format them like you would format instructions to a human research assistant).
#' @param model Which model variant of GPT-3 to use. Defaults to 'text-davinci-003'
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
                                model = 'text-davinci-003',
                                openai_api_key = Sys.getenv('OPENAI_API_KEY')) {


  openai <- reticulate::import("openai")

  if(is.null(openai_api_key) | Sys.getenv('OPENAI_API_KEY') == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }

  # query the API
  response <- openai$Completion$create(
    engine = model,
    prompt = paste0(instructions, '\n---\nA. ', A, '\n\nB. ', B, '\n---\nResponse (A or B):'),
    max_tokens = as.integer(10),
    logprobs = as.integer(5),
    temperature = as.integer(0)
  )


  # this code returns the highest probability output string
  response$choices[[1]]$text |>
    # remove carriage returns and whitespace
    stringr::str_squish()


  # the commented out code returns a probability
  # # convert the dictionary of log probabilities into a dataframe
  # keys <- names(response$choices[[1]]$logprobs$top_logprobs[[1]])
  #
  # logprobs <- numeric(length(keys))
  #
  # for(i in 1:length(keys)){
  #   logprobs[i] <- response$choices[[1]]$logprobs$top_logprobs[[1]]$get(keys[i])
  # }
  #
  # # tidy the dataframe
  # data.frame(response = stringr::str_squish(keys),
  #                 prob = exp(logprobs)) |>
  #   dplyr::filter(response %in% c('A', 'B')) |>
  #   dplyr::mutate(response = factor(response, level = c('A', 'B'))) |>
  #   dplyr::group_by(response, .drop = FALSE) |>
  #   dplyr::summarize(prob = sum(prob)) |>
  #   dplyr::ungroup() |>
  #   # convert to proper probability (sums to 1)
  #   dplyr::mutate(prob = prob / sum(prob)) |>
  #   dplyr::filter(response == 'A') |>
  #   dplyr::pull(prob)

}
