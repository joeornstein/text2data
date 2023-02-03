#' Tweets About The Supreme Court of the United States
#'
#' This dataset contains 945 tweets referencing the Supreme Court,
#' collected between XXXX and YYYY, along with expert-coded sentiment
#' scores.
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
#'  \item{expert1, expert2, expert3}{Hand-coded sentiment score (-1 = negative, 0 = neutral, 1 = positive)}
#' }
#'
#' @keywords datasets
#'
#' @references Ornstein et al. (2022). "How To Train Your Stochastic Parrot"
#'
#' @examples
#' data(scotus_tweets)
"scotus_tweets"

#' Labelled Example Tweets About The Supreme Court of the United States
#'
#' This dataset contains 5 example tweets referencing the Supreme Court
#' along with a sentiment label. These can be used as few-shot learning
#' examples for classifying tweets in the `scotus_tweets` dataset.
#'
#' @docType data
#'
#' @usage data(scotus_tweet_examples)
#'
#' @format
#' A data frame with 5 rows and 2 columns:
#' \describe{
#'  \item{text}{The text of the tweet}
#'  \item{label}{The "true" label (Positive, Negative, or Neutral)}
#' }
#'
#' @keywords datasets
#'
#' @references Ornstein et al. (2022). "How To Train Your Stochastic Parrot"
"scotus_tweet_examples"
