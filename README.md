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

## Como executar a aplicação

1. Garanta que você possui o Docker Engine (ou Docker Desktop) instalado em sua máquina;
2. Em um terminal (ou instância do Docker CLI) aberto no diretório do projeto, execute o comando abaixo:
```bash
docker compose up -d
```
Para verificar se os containers foram devidamente criados, você pode executar o comando `docker container ls`, que deve retornar um resultado semelhante ao descrito abaixo: 
```bash
$ docker container ls
=> CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS         PORTS                                       NAMES
=> a00fb02a7d84   postgres   "docker-entrypoint.s…"   8 seconds ago   Up 6 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
=> 4b03194cf2fd   postgres   "docker-entrypoint.s…"   8 seconds ago   Up 6 seconds   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   postgres-test
=> 65547a674e3c   ruby       "bash"                   8 seconds ago   Up 6 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   ruby
```

A aplicação conta com dois bancos de dados: um para o ambiente de desenvolvimento, que é escutado na porta 5432, e o de testes que é escutado na porta 5433.

3. Em um terminal aberto no diretório do projeto, execute o comando abaixo para instalar as dependências do projeto:
```bash 
docker exec ruby bundle
```

## Como executar o servidor e acessar a aplicação em ambiente de desenvolvimento
1. Siga as instruções de como executar a aplicação;
2. Em um terminal com o diretório do projeto aberto, execute o seguinte comando: 
```bash
docker exec ruby ruby server.rb
```
3. Em um navegador de sua escolha, visite http://localhost:3000/hello para ver a página inicial.

## Endpoints disponíveis

### GET /tests
```bash
http://localhost:3000/tests ou
GET '/tests'
```
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com os resultados dos exames cadastrados na plataforma