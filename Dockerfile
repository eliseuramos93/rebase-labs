FROM ruby

WORKDIR /app

COPY . /app

# Instalação do Firefox
## Criar o diretório para armazenar as chaves APT do repositório
RUN install -d -m 0755 /etc/apt/keyrings
## Garantir que o wget está instalado
RUN apt-get install wget
## Importar a chave do repositório APT da Mozilla
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- |  tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
## Adicionar a chave do repositório APT para a lista de fontes
RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" |  tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
## Configurar o APT para priorizar diretórios da Mozilla
RUN echo 'Package: * Pin: origin packages.mozilla.org Pin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla 
## Atualizar novamente as dependências e instalar o Mozilla Firefox
RUN apt-get update && apt-get install -y firefox
# Instalação do geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.34.0-linux64.tar.gz
RUN mv geckodriver /usr/local/bin/
RUN chmod +x /usr/local/bin/geckodriver

CMD ["bash"]