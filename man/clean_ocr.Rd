% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_ocr.R
\name{clean_ocr}
\alias{clean_ocr}
\title{Clean Up OCR Errors}
\usage{
clean_ocr(
  text,
  instructions = "Correct the OCR errors.",
  model = "gpt-3.5-turbo",
  openai_api_key = Sys.getenv("OPENAI_API_KEY")
)
}
\arguments{
\item{text}{The OCR text to be cleaned up}

\item{instructions}{Instructions to be included at the top of the GPT-3 prompt. Defaults to "Correct the OCR errors."}

\item{model}{Which model variant of GPT-3 to use. Defaults to "gpt-3.5-turbo"}

\item{openai_api_key}{Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.}
}
\value{
The cleaned up text as a character object.
}
\description{
Constructs a GPT-3 prompt to correct errors in text generated by Optical Character Recognition.
}
\examples{
clean_ocr(text = "John wenf to the slore. Rosie ran ercands at the mal.")
}
