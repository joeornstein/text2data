# text2data

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
