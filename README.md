# Rebase Labs

Uma aplicação web para listagem de resultados de exames de laboratório.

## Tecnologias

- Linguagem: Ruby
- Framework web: Sinatra
- Web server: Puma
- Suite de testes: RSpec
- Lint: Rubocop
- Monitoramento de cobertura de testes: SimpleCov

## Idioma
A aplicação sempre que possível priorizará o Português (mais especificamente, pt-BR). Portanto todo texto que não seja código, incluíndo descrições de testes, mensagens de commit, comentários no código, nomes de colunas no banco de dados, entre outros, estará em Português. 

## Como rodar a aplicação usando containers (Docker)

### Ruby

1. Execute o comando abaixo em um terminal aberto no diretório do projeto para executar um container com Ruby:
```bash 
docker run -it \
	-p 3000:3000 \
	-v ${PWD}:/app \
	-v ruby_gems:/usr/local/bundle \
	-w /app \
	--name ruby \
	--network postgres_sinatra \
	--rm \
	ruby bash
```

2. Siga as instruções de como executar a aplicação para sistemas UNIX.

## Como executar a aplicação (sistemas UNIX)
1. Clone o repositório em uma pastaa local;
2. Execute o comando `bundle` em um terminal aberto no diretório do projeto;
3. Execute o comando `ruby server.rb` em um terminal aberto no diretório do projeto.

Seu terminal deverá mostrar o seguinte log:

```bash
Puma starting in single mode...
* Puma version: 6.4.2 (ruby 3.3.0-p0) ("The Eagle of Durango")
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 662
* Listening on http://0.0.0.0:3000
Use Ctrl-C to stop
```

## Como acessar a aplicação em ambiente de desenvolvimento
1. Siga as instruções de como executar a aplicação;
2. Em um navegador de sua escolha, visite http://localhost:3000/hello para ver a página inicial.

## Endpoints disponíveis

### GET /tests
```bash
http://localhost:3000/tests ou
GET '/tests'
```
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com os resultados dos exames cadastrados na plataforma