# Rebase Labs

Uma aplicação web para listagem de resultados de exames de laboratório.

## Tecnologias

- Linguagem: Ruby
- Framework web: Sinatra
- Web server: Puma
- Processamento assíncrono: Sidekiq
- Suite de testes: RSpec
- Lint: Rubocop
- Monitoramento de cobertura de testes: SimpleCov

## Idioma
A aplicação sempre que possível priorizará o Português (mais especificamente, pt-BR). Portanto todo texto que não seja código, incluíndo descrições de testes, mensagens de commit, comentários no código, nomes de colunas no banco de dados, entre outros, estará em Português. 

## Pré-requisitos
- Possuir Docker Engine (ou Docker Desktop) instalado em sua máquina local.

## Como executar a aplicação

Em um terminal aberto no diretório do projeto, basta executar o comando abaixo para configurar a aplicação:

```bash
bin/dev
```

## Como encerrar os containers em execução

Basta executar o comando abaixo em um terminal aberto no diretório do projeto para encerrar todos os containers inicializados em `bin/setup`:

```bash
docker compose down
```

## Endpoints disponíveis

### GET /
```bash
http://localhost:3000/
```
- **Status**: 200 (OK)
- **Corpo da resposta**: Página web que exibe os resultados de `GET /tests` em formato de tabela dentro de uma página reativa, renderizando 100 conteúdos por vez.

### GET /tests
```bash
http://localhost:3000/tests ou
GET '/tests'
```
#### Com sucesso
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com os resultados dos exames cadastrados na plataforma
- **Exemplo de retorno**:

```json
[
  {
    "result_token": "00S0MD",
    "date": "2022-03-03",
    "full_name": "Ladislau Duarte",
    "cpf": "099.204.552-53",
    "email": "lisha@rosenbaum.org",
    "birth_date": "1981-02-02",
    "doctor": {
      "crm": "B000BJ8TIA",
      "crm_state": "PR",
      "full_name": "Ana Sophia Aparício Neto"
    },
    "tests": [
      {
        "type": "hemácias",
        "limits": "45-52",
        "results": "45"
      },
      {
        "type": "leucócitos",
        "limits": "9-61",
        "results": "82"
      },
      [...],
      {
        "type": "ácido úrico",
        "limits": "15-61",
        "results": "3"
      }
    ]
  },
  {
    "result_token": "06LD0G",
    "date": "2021-05-15",
    "full_name": "Valentina Cruz",
    "cpf": "003.596.348-42",
    "email": "cortez.dickens@farrell.name",
    "birth_date": "1979-04-04",
    "doctor": {
      "crm": "B00067668W",
      "crm_state": "RS",
      "full_name": "Félix Garcês"
    },
    "tests": [
      {
        "type": "hemácias",
        "limits": "45-52",
        "results": "77"
      },
      {
        "type": "leucócitos",
        "limits": "9-61",
        "results": "89"
      },
      [...],
      {
        "type": "ácido úrico",
        "limits": "15-61",
        "results": "39"
      }
    ]
  },
]
```
#### Erro na conexão com banco de dados
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com mensagem de erro
- **Exemplo de retorno**:
```json
{
  "errors": {
    "message": "Não foi possível conectar-se ao banco de dados."
  }
}
```

### GET /tests/:result_token
```bash
http://localhost:3000/tests/:result_token ou
GET '/tests'
```
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com o exame encontrado através da pesquisa por 
- **Exemplo de retorno**:

```json
{
  "result_token": "00S0MD",
  "date": "2022-03-03",
  "full_name": "Ladislau Duarte",
  "cpf": "099.204.552-53",
  "email": "lisha@rosenbaum.org",
  "birth_date": "1981-02-02",
  "doctor": {
    "crm": "B000BJ8TIA",
    "crm_state": "PR",
    "full_name": "Ana Sophia Aparício Neto"
  },
  "tests": [
    {
      "type": "hemácias",
      "limits": "45-52",
      "results": "45"
    },
    {
      "type": "leucócitos",
      "limits": "9-61",
      "results": "82"
    },
    [...],
    {
      "type": "ácido úrico",
      "limits": "15-61",
      "results": "3"
    }
  ]
}
```
#### Erro na conexão com banco de dados
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com mensagem de erro
- **Exemplo de retorno**:
```json
{
  "errors": {
    "message": "Não foi possível conectar-se ao banco de dados."
  }
}
```
#### Exame não foi encontrado no banco de dados
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com mensagem de erro
- **Exemplo de retorno**:
```json
{
  "errors": {
    "message": "Não foi encontrado nenhum exame com o token informado."
  }
}
```

#### Erro na conexão com banco de dados
- **Status**: 200 (OK)
- **Corpo da resposta**: Arquivo JSON com mensagem de erro
- **Exemplo de retorno**:
```json
{
  "errors": {
    "message": "Não foi possível conectar-se ao banco de dados."
  }
}
```
