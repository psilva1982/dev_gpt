from langchain_ollama import ChatOllama
from langchain_community.llms import HuggingFaceHub
from langchain_core.prompts import MessagesPlaceholder
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
import os

def llama_on_hf(model = "meta-llama/Meta-Llama-3-8B-Instruct", temperature=0.1):
    llm = HuggingFaceHub(repo_id = model,
                         model_kwargs={
                             "temperature": temperature,
                             "return_full_text": False,
                             "max_new_tokens": 512,
                         })
    return llm

def llama_on_docker():
    llm = ChatOllama(model = "llama3.1", temperature = 0.1)
    return llm

def get_llm_model():
    use_docker = os.environ.get("USE_DOCKER", False)
    use_docker = True if use_docker == "True" else False
    if use_docker:
        return use_docker, llama_on_docker()

    return use_docker, llama_on_hf()

def model_response(user_query, chat_history):

    # Carregamento da LLM
    use_docker, llm = get_llm_model()

    # Definição dos prompts
    system_prompt = """
        Você é um assistente prestativo e está respondendo perguntas gerais. Responda em {language}.
    """
    language = "português"
    if use_docker:
        user_prompt = "<|begin_of_text|><|start_header_id|>user<|end_header_id|>\n{input}<|eot_id|><|start_header_id|>assistant<|end_header_id|>"
    else:
        user_prompt = "{input}"

    prompt_template = ChatPromptTemplate.from_messages([
        ("system", system_prompt),
        MessagesPlaceholder(variable_name="chat_history"),
        ("user", user_prompt)
    ]) 

    # Criação da chain
    chain = prompt_template | llm | StrOutputParser()

    # Retorno da resposta
    return chain.stream({
        "chat_history": chat_history,
        "input": user_query,
        "language": language
    })