# DevGPT - This is a simple clone chat gpt

## Requirements
- Docker 
- Hugging Face account

## Setup envoriment

Create ```.env``` file with your config. 

```
cp .env_sample .env

# Edit variable values
HUGGINGFACEHUB_API_TOKEN=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
USE_DOCKER=YES 
```

## Run with llama3.1 on docker 

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



