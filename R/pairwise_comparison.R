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
    prompt = paste0(instructions, '\n---\nA. ', A, '\nB. ', B, '\n---\nResponse:'),
    max_tokens = as.integer(1),
    logprobs = as.integer(5),
    temperature = as.integer(0)
  )

  # convert the dictionary of log probabilities into a dataframe
  keys <- names(response$choices[[1]]$logprobs$top_logprobs[[1]])

  logprobs <- numeric(length(keys))

  for(i in 1:length(keys)){
    logprobs[i] <- response$choices[[1]]$logprobs$top_logprobs[[1]]$get(keys[i])
  }

  d <- data.frame(response = stringr::str_squish(keys),
                  prob = exp(logprobs)) |>
    dplyr::filter(response %in% c('A', 'B')) |>
    dplyr::mutate(response = factor(response, level = c('A', 'B'))) |>
    dplyr::group_by(response, .drop = FALSE) |>
    dplyr::summarize(prob = sum(prob)) |>
    dplyr::ungroup()

  return(d)

}
