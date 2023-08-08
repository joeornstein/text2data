# text2data <img src="man/figures/DALL·E 2023-04-19 14.54.12.png" align="right" width="120" />

We developed the `text2data` package so that researchers could easily format and submit LLM prompts using the `R` programming language. It provides a handful of convenient functions to query the OpenAI API and return its output as a tidy `R` dataframe.

## Installation

The package is currently available as a GitHub repository. To install, first make sure you have the `devtools` package available, then you can install the package with the following lines of code:

```
devtools::install_github('joeornstein/text2data')
```

You will also want to make sure you have the `reticulate` package installed, which allows `R` to talk to Python.

```
install.packages('reticulate')

reticulate::install_miniconda()
```

Once `reticulate` is installed, you can install OpenAI's Python module, which will allow us to submit prompts to the GPT-3 API. We've included a convenience function in the package to handle this installation for you:

```
library(text2data)

setup_openai()
```

You will also need an account with OpenAI. You can sign up [here](https://beta.openai.com/signup), after which you'll need generate an API key [here](https://platform.openai.com/account/api-keys). We recommend adding this API key as a variable in your operating system environment called `OPENAI_API_KEY`; that way you won't risk leaking it by hard-coding it into your `R` scripts. The `text2data` package will automatically look for your API key under that variable name, and will prompt you to enter the API key manually if it can't find one there. If you're unfamiliar with setting Environment Variables in your operating system, [here](https://dev.to/biplov/handling-passwords-and-secret-keys-using-environment-variables-2ei0) are some helpful instructions. Note that you may need to restart your computer after completing this step.

## Completing Prompts

The workhorse function of the `text2data` package is `complete_prompt()`. It submits a prompt to the OpenAI API, and returns a dataframe with the five most likely next word predictions and their associated probabilities.

```r
library(text2data)

complete_prompt(prompt = 'I feel like a')
```

If you prefer the model to autoregressively generate text instead of outputting the next-word probabilities, you can set the `max_tokens` input greater than 1. The function will return a character object with the most likely completion.

```r
complete_prompt(prompt = 'I feel like a',
                max_tokens = 18)
```

Note that by default, the `temperature` input is set to 0, which means the model will always return the most likely completion for your prompt. Increasing temperature allows the model to randomly select words from the probability vector (see the [API reference](https://platform.openai.com/docs/api-reference/completions) for more on these parameters).

You can also change which model variant the function calls using the `model` input. By default, it is set to "text-davinci-003", the RLHF variant of GPT-3 (175 billion parameters). For the non-RLHF variants, try "davinci" (175 billion parameters) or "curie" (13 billion parameters).

## Formatting Prompts

Manually typing prompts with multiple few-shot examples can be tedious and error-prone, particularly when performing the sort of contextual prompting we recommend in the paper. So we include the `format_prompt()` function to aid in that process.

The function is designed with classification problems in mind. If you input the text you would like to classify along with a set of instructions, the default prompt template looks like this:

```r
library(text2data)

format_prompt(text = 'I am feeling happy today.',
              instructions = 'Decide whether this statment is happy or sad.')
```

You can customize the template using `glue` syntax, with placeholders for {text} and {label}.

```r
format_prompt(text = 'I am feeling happy today.',
              instructions = 'Decide whether this statment is happy or sad.',
              template = 'Statement: {text}\nSentiment: {label}')
```

This is particularly useful when including few-shot examples in the prompt. If you input these examples as a tidy dataframe, the `format_prompt()` function will paste them into the prompt them according to the template. To illustrate, we can classify a tweet from from the social media sentiment application. First, load the Supreme Court Tweets dataset, which is included with the package.

```r
data(scotus_tweets) # the full dataset
data(scotus_tweets_examples) # a dataframe with few-shot examples
```

```r
format_prompt(text = scotus_tweets$text[42],
              instructions = 'Classify these tweets as Positive, Neutral, or Negative',
              examples = scotus_tweets_examples,
              template = 'Tweet: {text}\nSentiment: {label}')
```

This prompt can then be used as an input to `complete_prompt()`.

```r
format_prompt(text = scotus_tweets$text[42],
              instructions = 'Classify these tweets as Positive, Neutral, or Negative',
              examples = scotus_tweets_examples,
              template = 'Tweet: {text}\nSentiment: {label}') |> 
  complete_prompt(model = 'davinci')
```

