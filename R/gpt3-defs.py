# GPT-3 prompt to convert unstructured text into a data table

import os
import openai
import math

openai.api_key = os.getenv("OPENAI_API_KEY")


def gpt3_classify(text, instructions, mod):
  
  response = openai.Completion.create(
    engine = mod,
    prompt = instructions + "\n---\n" + text + "\nClassification: ",
    max_tokens = 1, 
    logprobs = 5,
    temperature = 0
  )
  
    # record most probable tokens
  token1 = list(response.choices[0].logprobs.top_logprobs[0].keys())[0]
  token2 = list(response.choices[0].logprobs.top_logprobs[0].keys())[1]
  token3 = list(response.choices[0].logprobs.top_logprobs[0].keys())[2]
  token4 = list(response.choices[0].logprobs.top_logprobs[0].keys())[3]
  token5 = list(response.choices[0].logprobs.top_logprobs[0].keys())[4]
      
  # and their assigned probabilities
  prob1 = math.exp(response.choices[0].logprobs.top_logprobs[0].get(token1))
  prob2 = math.exp(response.choices[0].logprobs.top_logprobs[0].get(token2))
  prob3 = math.exp(response.choices[0].logprobs.top_logprobs[0].get(token3))
  prob4 = math.exp(response.choices[0].logprobs.top_logprobs[0].get(token4))
  prob5 = math.exp(response.choices[0].logprobs.top_logprobs[0].get(token5))
  
  return([token1, token2, token3, token4, token5], [prob1, prob2, prob3, prob4, prob5])


def gpt3_parse(instructions, text, var_descriptions, mod = 'text-davinci-003'):
  
  resp = openai.Completion.create(
    engine = mod,
    prompt = instructions + "\n\n" + text + "\n\n" + "| " + ' | '.join(var_descriptions) + " |\n|" + ' --- |' * len(var_descriptions) + "\n",
    max_tokens = 1000,
    temperature = 0
  )
  
  return(resp.choices[0].text)
