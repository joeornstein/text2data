#' Tweets About The Supreme Court of the United States
#'
#' This dataset contains 945 tweets referencing the US Supreme Court.
#' Roughly half were collected on June 4, 2018 following the *Masterpiece Cakeshop*
#' ruling, and the other half were collected on July 9, 2020 following the
#' Court's concurrently released opinions in *Trump v. Mazars* and *Trump v. Vance*.
#' Each tweet includes three independent human-coded sentiment scores (-1 to +1).
#'
#' CONTENT WARNING: These texts come from social media, and many contain explicit
#' or offensive language.
#'
#' @docType data
#'
#' @usage data(scotus_tweets)
#'
#' @format
#' A data frame with 945 rows and 5 columns:
#' \describe{
#'  \item{tweet_id}{A unique ID}
#'  \item{text}{The text of the tweet}
#'  \item{case}{An identifier denoting which Supreme Court ruling the tweet was collected after.}
#'  \item{expert1, expert2, expert3}{Hand-coded sentiment score (-1 = negative, 0 = neutral, 1 = positive)}
#' }
#'
#' @keywords datasets
#'
#' @references Ornstein et al. (2022). "How To Train Your Stochastic Parrot"
"scotus_tweets"


#' Labelled Example Tweets About The Supreme Court of the United States
#'
#' This dataset contains 12 example tweets referencing the Supreme Court
#' along with a sentiment label. These can be used as few-shot prompting
#' examples for classifying tweets in the `scotus_tweets` dataset.
#'
#' @docType data
#'
#' @usage data(scotus_tweets_examples)
#'
#' @format
#' A data frame with 12 rows and 4 columns:
#' \describe{
#'  \item{tweet_id}{A unique ID for each tweet}
#'  \item{text}{The text of the tweet}
#'  \item{case}{The case referenced in the tweet (Masterpiece Cakeshop or Trump v. Mazars)}
#'  \item{label}{The "true" label (Positive, Negative, or Neutral)}
#' }
#'
#' @keywords datasets
#'
#' @references Ornstein et al. (2022). "How To Train Your Stochastic Parrot"
"scotus_tweets_examples"
