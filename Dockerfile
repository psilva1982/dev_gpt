# Primeira etapa: build
FROM python:3.12.3-slim as build

# Variáveis de ambiente para otimizar comportamento do Python e Pip
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# Criar diretório de documentação para evitar warnings durante a instalação do man
RUN mkdir -p /usr/share/man/man1

# Instalar dependências do sistema necessárias para compilação de pacotes Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    build-essential \
    libmagic-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho
WORKDIR /app

# Copiar os arquivos necessários para o build
COPY requirements.txt .

# Instalar as dependências do projeto na pasta temporária `/.venv`
RUN python -m venv /.venv && \
    /.venv/bin/pip install --no-cache-dir -r requirements.txt

# Segunda etapa: runtime (imagem final)
FROM python:3.12.3-slim

# Variáveis de ambiente
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PATH="/.venv/bin:$PATH" \
    TERM=xterm-256color \
    PYTHONPATH=/home/python/app

# Instalar dependências de ambiente necessárias para execução
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh \
    curl \
    wget \
    fonts-powerline \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Criar e configurar o usuário 'python'
RUN useradd -ms /bin/bash python
USER python

# Definir diretório de trabalho
WORKDIR /home/python/app

# Copiar o ambiente virtual da etapa de build para a imagem final
COPY --from=build /.venv /.venv

# Instalar Zsh com Powerlevel10k e plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t https://github.com/romkatv/powerlevel10k \
    -p git \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    && echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc \
    && echo 'HISTFILE=/home/python/zsh/.zsh_history' >> ~/.zshrc

# Copiar o código da aplicação
COPY . .

EXPOSE 8501 

# Definir o ponto de entrada
ENTRYPOINT ["/home/python/app/entrypoint"]
