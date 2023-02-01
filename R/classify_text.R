#' Classify Text With GPT-3
#'
#' @description Constructs a GPT-3 prompt to classify a string of text according to user instructions
#'
#' @param text The text to be classified
#' @param instructions Instructions to be included in the GPT-3 prompt (format them like you would format instructions to a human research assistant).
#' @param model Which model variant of GPT-3 to use. Defaults to 'text-davinci-003'
#'
#' @return A dataframe with 5 classifications and their probabilities as assigned by GPT-3
#' @export
#'
#' @examples
#' classify_text(text = 'I am so very sad today',
#'               instructions = 'Classify the sentiment of the following string of text as either Positive, Negative, or Neutral.')
classify_text <- function(text,
                          instructions = 'Classify the sentiment of the following tweet as Positive, Negative, or Neutral.',
                          model = 'text-davinci-003') {

  ## TODO: SHOULD BE ABLE TO INPUT A DATAFRAME OF FEW-SHOT EXAMPLES

  ## TODO: CAN THIS BE VECTORIZED??

  reticulate::source_python('R/gpt3-defs.py')

  output <- gpt3_classify(text = text,
                          instructions = instructions,
                          mod = model)

  data.frame(classification = output[[1]],
             prob = output[[2]])

}

