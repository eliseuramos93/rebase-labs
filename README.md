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

## Pré-requisitos
- Possuir Ruby instalado em sua máquina local;
- Possuir Docker Engine (ou Docker Desktop) instalado em sua máquina local.

## Como configurar a aplicação

Em um terminal aberto no diretório do projeto, basta executar o comando abaixo para configurar a aplicação:

```bash
bin/setup
```

## Como executar o servidor e acessar a aplicação em ambiente de desenvolvimento
1. Siga as instruções de como executar a aplicação;
2. Em um terminal com o diretório do projeto aberto, execute o seguinte comando: 
```bash
docker exec ruby ruby server.rb
```
3. Em um navegador de sua escolha, visite http://localhost:3000/hello para ver a página inicial.

## Como encerrar os containers em execução

Basta executar o comando abaixo em um terminal aberto no diretório do projeto para encerrar todos os containers inicializados em `bin/setup`:

```bash
docker compose down
```
## Endpoints disponíveis

### GET /tests
```bash
http://localhost:3000/tests ou
GET '/tests'
```
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com os resultados dos exames cadastrados na plataforma