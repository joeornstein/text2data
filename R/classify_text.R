#' Classify Text With GPT-3
#'
#' @description Constructs a GPT-3 prompt to classify a string of text according to user instructions
#'
#' @param text The text to be classified
#' @param instructions Instructions to be included in the GPT prompt (format them like you would format instructions to a human research assistant).
#' @param examples A dataframe of "few-shot" examples. Must include one column called 'text' with the example text(s) and another column called "label" with the correct label(s).
#' @param model Which model variant of GPT to use. Defaults to 'gpt-3.5-turbo'
#' @param openai_api_key Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.
#'
#' @return A classification of the text
#' @export
#'
#' @examples
#' classify_text(text = 'I am so very sad today',
#'               instructions =
#'               'Classify the sentiment of the following string of text as either Positive, Negative, or Neutral.')
classify_text <- function(text,
                          instructions = 'Classify the sentiment of the following text as Positive, Negative, or Neutral.',
                          examples = NULL,
                          model = 'gpt-3.5-turbo',
                          temperature = as.integer(0),
                          max_tokens = as.integer(5),
                          openai_api_key = Sys.getenv('OPENAI_API_KEY')) {
  
  openai <- reticulate::import("openai")
  
  if(openai_api_key == ''){
    stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
  } else{
    openai$api_key = openai_api_key
  }
  
  # if the user provided a dataframe of few-shot examples:
  if(!is.null(examples)){
    
    # include the examples in the instruction preamble
    if(sum(c('text', 'label') %in% names(examples)) == 2){
      for(i in 1:nrow(examples)){
        instructions <- paste0(instructions, '\n---\n', examples$text[i], '\nClassification: ', examples$label[i])
      }
    } else{
      # throw an error if examples doesn't contain the correct fields
      stop("The 'examples' dataframe must include a column called 'text' and a column called 'label'")
    }
    
  }
  
  # query the API
  response <- openai$ChatCompletion$create(
    model = model,
    messages = list(
      list("role" = "system", "content" = instructions),
      list("role" = "user", "content" = paste0(text, "\nClassification:"))
    ),
    max_tokens = max_tokens, # adjust as per requirements
    temperature = temperature # adjust as per requirements
  )

  return(response$choices[[1]]$message$content)
}