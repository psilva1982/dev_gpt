# DevGPT - This is a simple clone chat gpt

## Requirements
- Docker 
- Hugging Face account

## Setup envoriment

Create ```.env``` file with your config. 

```
cp .env_sample .env

# Edit variable values
# Hugging face hub api key if you are use remote llama3
HUGGINGFACEHUB_API_TOKEN=FAKE_API_KEY

# Define YES if you are using ollama/llama3 container
USE_DOCKER=YES 
```

## Run with docker container
 
To run the project using [ollama / llama3.1](https://hub.docker.com/r/ollama/ollama) with docker you must first upload the container with ollama and llama3.1. To do this run the following commands. 

```
# Start ollama container
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Attach shell
docker exec -it ollama /bin/bash

# Add llama3.1 model
ollama run llama3.1

```

You can also **install the nvidia toolkit for docker** as described in [docker hub](https://hub.docker.com/r/ollama/ollama)

Once the container with ollama / llama3.1 is running you must set the variable ```USE_DOCKER``` in ```.env``` file.

```
# .env

USE_DOCKER=True
```


## Running with Hugging Face

With this option you can run the application without using a local container with ollama. To run with hugging face, you only need the api key to connect to the hugging face model.

With this option you can run the application without using a local container with ollama. To run with hugging face, you only need the api key to connect to the hugging face model.

Place your api key in the .env file in the XXXX variable and set YYYY


## Create the build for the Dockerfile

```
docker build -t devgpt .
```

Run the application with the command

```
docker run -d -p 8501:8501 --name devgpt devgpt
```