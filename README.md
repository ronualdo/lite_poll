# Lite Poll

Esse projeto propõe um pequeno exercício sobre performance de aplicações web. Dentro
desse repositório nós temos uma pequena API Rest baseada em Rails e um conjunto de
scripts para facilitar o provisionamento da infraestrutura necessária e para fazer o
seu deploy. 

A idéia do exercício em alto nível se resume a:

0. Substituir a implementação falsa fornecida pelo repositório por uma implementação
real.
1. Fazer o deploy da aplicação.
2. Rodar os testes de stress
3. Checar o resultados
4. Tentar otimizar o resultados
5. Voltar ao passo 1 e repetir até estar satisfeito :)

## A aplicação

A API proposta consiste de basicamente 3 endpoints:

1. GET /polls/{poll_id} - Recupera as informações de uma enquete criada anteriormente
2. POST /polls/{poll_id}/votes - Permite que um usuário vote em uma enquete
3. POST /polls/{poll_id}/results - Recupera os resultados de uma enquete especifica

## Pre-requisitos

1. Uma conta na AWS
2. Uma conta na New Relic

## Rodando Aplicação Localmente

O repositório contém um arquivo `docker-compose.yml` com as configurações necessárias
para rodar o projeto localmente. Para iniciar a aplicação na porta 3000 rode o seguinte
commando a partir da pasta raiz do projeto:

```
docker-comose up
```

## Rodando Teste de Estresse Localmente

Junto com a configuração para rodar o projeto localmente a configuração do `docker-compose.yml` fornece um "perfil" quer permite a execução dos testes de estresse contra a apliação de forma local. Para rodar esses testes rode:

```
docker-compose --profile load_test up
```

## Fazendo o Deploy Inicial

Dentro da pasta `infrastructure/terraform-aws-lite-poll` existe uma série de arquivos
Terraform que definem uma infraestrutura básica para rodar a aplicação na AWS. Para 
provisionar a infra e fazer um deploy inicial, rode o comando:

```
./scripts/setup.sh
```

## Criando e Publicando uma Nova Imagem

Dado que a infraestrutura inicial já tenha sido criada, para criar uma nova imagem e publica-lá rode o script `./scripts/upload_image.sh` passando como parametro a nova tag a ser
utilizada pela nova image.

```
./scripts/upload_image.sh 0.0.2
```

## Deployando uma Nova Imagem

Para fazer o deploy de uma imagem já publicada edite a tag da imagem utilizada nos arquivos com as definições das tasks do projeto (task_definition.json.tpl e
db_prepare_task.definition.json.tpl).

```task_definition.json.tpl
  "essential": true,
  "memory": 512,
  "name": "worker",
  "cpu": 2,
  "image": "${REPOSITORY_URL}:0.0.1",
  (...)
```

Após editar os arquivos com a tag desejada da image, rode o script para aplicar as
definições de infraestrutura atuais.

```
./scripts/apply_infra.sh
```

Para rodar as migrações, utilize o seguinte script:

```
./scripts/migrate.sh
```
