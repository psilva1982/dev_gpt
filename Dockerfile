FROM python:3.12.3

ENV PYTHONUNBUFFERED 1
# prevents python creating .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# Fix 
RUN mkdir -p /usr/share/man/man1

## Install environment dependencies
RUN apt-get update && apt-get -y install git python3-dev build-essential python3-setuptools libmagic-dev \
  git ssh zsh curl wget fonts-powerline \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash python
USER python

# Set work directory
WORKDIR /home/python/app

ENV PYTHONPATH=${PYTHONPATH}/home/python/app

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t https://github.com/romkatv/powerlevel10k \
    -p git \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -a 'export TERM=xterm-256color'

RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc && \
    echo 'HISTFILE=/home/python/zsh/.zsh_history' >> ~/.zshrc

COPY ./requirements.txt /home/python/app/

RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

ENTRYPOINT ["/entrypoint"]
