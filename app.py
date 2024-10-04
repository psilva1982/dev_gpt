import streamlit as st
from langchain_core.messages import AIMessage, HumanMessage
from llm import model_response

from dotenv import load_dotenv

load_dotenv()

# Configurações do Streamlit
st.set_page_config(page_title="Dev GPT 🤖", page_icon="🤖")
st.title("Dev GPT 🤖")


if "chat_history" not in st.session_state:
    st.session_state.chat_history = [AIMessage(content="Olá, sou o seu assistente virtual! Como posso ajudar você?")]

for message in st.session_state.chat_history:
    if isinstance(message, AIMessage):
        with st.chat_message("AI"):
            st.write(message.content)
    elif isinstance(message, HumanMessage):
        with st.chat_message("Human"):
            st.write(message.content)

user_query = st.chat_input("Digite sua mensagem aqui...")
if user_query is not None and user_query != "":
    st.session_state.chat_history.append(HumanMessage(content = user_query))

    with st.chat_message("Human"):
        st.markdown(user_query)

    with st.chat_message("AI"):
        resp = st.write_stream(model_response(user_query, 
                                              st.session_state.chat_history))
    st.session_state.chat_history.append(AIMessage(content=resp))