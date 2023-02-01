#' Classify Text With GPT-3
#'
#' @description Constructs a GPT-3 prompt to classify a string of text according to user instructions
#'
#' @param text The text to be classified
#' @param instructions Instructions to be included in the GPT-3 prompt (format them like you would format instructions to a human research assistant).
#' @param examples A dataframe of "few-shot" examples. Must include one column called 'text' with the example text(s) and another column called "label" with the correct label(s).
#' @param model Which model variant of GPT-3 to use. Defaults to 'text-davinci-003'
#'
#' @return A dataframe with 5 classifications and their probabilities as assigned by GPT-3
#' @export
#'
#' @examples
#' classify_text(text = 'I am so very sad today',
#'               instructions = 'Classify the sentiment of the following string of
#'                               text as either Positive, Negative, or Neutral.')
classify_text <- function(text,
                          instructions = 'Classify the sentiment of the following tweet as Positive, Negative, or Neutral.',
                          examples = NULL,
                          model = 'text-davinci-003') {

  ## TODO: CAN THIS BE VECTORIZED??

  reticulate::source_python('R/gpt3-defs.py')

  # if the user provided a dataframe of few-shot examples, include them in the instructions
  if(!is.null(examples)){
    # throw an error if examples doesn't contain the correct fields
    if(sum(c('text', 'label') %in% names(examples)) == 2){
      for(i in 1:nrow(examples)){
        instructions <- paste0(instructions, '\n---\n', examples$text[i], '\nClassification: ', examples$label[i])
      }
    } else{
      stop("The 'examples' dataframe must include a column called 'text' and a column called 'label'")
    }

  }

  output <- gpt3_classify(text = text,
                          instructions = instructions,
                          mod = model)

  data.frame(classification = output[[1]],
             prob = output[[2]])

}

