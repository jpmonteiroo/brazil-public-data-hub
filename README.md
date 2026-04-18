# Brazil Public Data Hub

Rails application that aggregates Brazilian public data from official APIs, with a dashboard for economic and geographic indicators such as Selic, IBC-Br, and federative units.

Aplicacao Rails que agrega dados publicos do Brasil a partir de APIs oficiais, com um dashboard para indicadores economicos e geograficos como Selic, IBC-Br e unidades federativas.

## English

### Overview

This project consumes public data from official Brazilian sources and presents it in a modern dashboard.

Current integrations:
- Banco Central do Brasil (BCB)
- Instituto Brasileiro de Geografia e Estatistica (IBGE)

Current architecture highlights:
- `app/operations`: application use cases
- `app/queries`: read/query objects
- `app/services`: infrastructure and supporting domain services
- `app/components`: reusable dashboard presentation objects

### Requirements

- Ruby `3.3.1`
- PostgreSQL
- Bundler

### Setup

1. Install dependencies:

```bash
bundle install
```

2. Create and migrate the database:

```bash
bin/rails db:create db:migrate
```

3. Seed the initial data sources and indicators:

```bash
bin/rails db:seed
```

4. Start the application:

```bash
bin/dev
```

### Running the sync

To enqueue a dashboard sync from the UI, use the "Atualizar dados agora" button.

To run the sync manually in the console:

```ruby
SyncPublicData.call
```

### Running tests

Run the full RSpec suite:

```bash
bundle exec rspec
```

Run a specific spec file:

```bash
bundle exec rspec spec/operations/dashboard/build_page_data_spec.rb
```

### Code quality

Run linting:

```bash
bin/rubocop
```

Run Zeitwerk consistency checks:

```bash
bin/rails zeitwerk:check
```

Run security checks:

```bash
bin/brakeman
bin/bundler-audit
bin/importmap audit
```

### Continuous Integration

GitHub Actions runs:
- Ruby security scans
- JavaScript dependency audit
- RuboCop
- Zeitwerk check
- RSpec test suite with PostgreSQL

## Portugues

### Visao geral

Este projeto consome dados publicos de fontes oficiais brasileiras e os apresenta em um dashboard moderno.

Integracoes atuais:
- Banco Central do Brasil (BCB)
- Instituto Brasileiro de Geografia e Estatistica (IBGE)

Destaques da arquitetura atual:
- `app/operations`: casos de uso da aplicacao
- `app/queries`: objetos de leitura e consulta
- `app/services`: infraestrutura e servicos de apoio
- `app/components`: objetos reutilizaveis de apresentacao do dashboard

### Requisitos

- Ruby `3.3.1`
- PostgreSQL
- Bundler

### Configuracao

1. Instale as dependencias:

```bash
bundle install
```

2. Crie e rode as migracoes do banco:

```bash
bin/rails db:create db:migrate
```

3. Popule o banco com as fontes e indicadores iniciais:

```bash
bin/rails db:seed
```

4. Inicie a aplicacao:

```bash
bin/dev
```

### Executando a sincronizacao

Para enfileirar a sincronizacao pela interface, use o botao "Atualizar dados agora".

Para executar manualmente no console:

```ruby
SyncPublicData.call
```

### Executando os testes

Rode toda a suite RSpec:

```bash
bundle exec rspec
```

Rode um arquivo especifico:

```bash
bundle exec rspec spec/queries/dashboard/load_data_query_spec.rb
```

### Qualidade de codigo

Rodar lint:

```bash
bin/rubocop
```

Rodar validacao do Zeitwerk:

```bash
bin/rails zeitwerk:check
```

Rodar verificacoes de seguranca:

```bash
bin/brakeman
bin/bundler-audit
bin/importmap audit
```

### Integracao continua

O GitHub Actions executa:
- scans de seguranca Ruby
- auditoria de dependencias JavaScript
- RuboCop
- checagem do Zeitwerk
- suite RSpec com PostgreSQL
