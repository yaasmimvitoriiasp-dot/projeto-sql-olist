# Contexto Geral do Projeto

Este arquivo guarda o contexto estavel do projeto: objetivo, ambiente, escopo, roadmap, estrutura de pastas e decisoes tomadas. Ele nao deve virar diario de aula; para progresso de estudo, usar `PROGRESS_TRACKER.md`.

## Objetivo

Desenvolver um projeto de SQL usando a base publica brasileira de e-commerce Olist, com dois objetivos igualmente importantes:

1. Aprender SQL de verdade, compreendendo o raciocinio por tras de cada fundamento.
2. Construir gradualmente um projeto de portfolio apresentavel em entrevistas, LinkedIn e GitHub para vagas de Analista de Dados ou BI Junior.

O projeto deve evoluir de consultas simples para analises de negocio, validacoes de qualidade dos dados, indicadores, views analiticas, documentacao das tabelas e regras utilizadas, README para GitHub, registro de evolucao, integracao futura com Power BI e possivel evolucao posterior para dbt e Databricks.

## Contexto profissional

A estudante atua como analista de dados e possui experiencia principalmente com:

- Qlik Sense;
- Power BI;
- ETL;
- modelagem dimensional;
- APIs;
- Power Query;
- DAX;
- indicadores e dashboards;
- levantamento de requisitos com areas de negocio.

O conhecimento atual de SQL e basico e esta sendo desenvolvido neste projeto. O foco nao e apenas escrever consultas, mas entender como uma analista usa SQL no trabalho: validacao, relacionamento, organizacao de scripts, versionamento, views, alimentacao de dashboards e interpretacao para responder perguntas de negocio.

## Ambiente

- PostgreSQL 17.
- pgAdmin.
- Banco: `projeto_ecommerce`.
- Schema: `ecommerce`.
- Base: Olist, obtida pelo Kaggle.
- Tabelas importadas ate agora:
  - `ecommerce.customers`;
  - `ecommerce.orders`.

## Estado atual do projeto

Fatos ja concluidos:

- As tabelas `customers` e `orders` foram importadas.
- Cada uma possui 99.441 registros, conforme informado no contexto inicial.
- Ja foram praticadas consultas com agregacao, agrupamento, ordenacao e `INNER JOIN`.
- Ja foi feita uma analise de pedidos por status.
- Ja foi feita uma analise de pedidos por estado.
- Ja foi feita uma analise de clientes unicos por estado.
- Ja foi iniciada uma analise de clientes recorrentes.

Pontos ainda nao concluidos:

- Confirmar e documentar a granularidade de `customers`.
- Confirmar e documentar formalmente a granularidade de `orders`.
- Registrar as contagens das tabelas com data de leitura.
- Validar nulos e duplicidades nas chaves e colunas de relacionamento.
- Consolidar `GROUP BY`, `HAVING` e recorrencia com mais pratica.

## Roadmap

### Etapa 1: Fundamentos

Conteudos:

- filtros;
- ordenacao;
- agregacoes;
- `GROUP BY`;
- `HAVING`;
- `DISTINCT`;
- valores nulos;
- operadores logicos;
- datas;
- funcoes basicas de texto e numeros.

Criterios de conclusao:

- identificar o que uma pergunta simples exige;
- escrever consultas corretas sem ajuda direta;
- explicar cada parte da consulta;
- interpretar o resultado;
- reconhecer risco de erro, nulo, duplicidade ou uso desnecessario de `DISTINCT`.

### Etapa 2: Relacionamentos

Conteudos:

- `INNER JOIN`;
- `LEFT JOIN`;
- diferencas entre tipos de join;
- cardinalidade;
- granularidade;
- duplicacoes provocadas por relacionamento;
- validacao antes e depois de um join.

Criterios de conclusao:

- explicar a chave de relacionamento;
- prever o efeito esperado do join;
- validar quantidade de linhas antes e depois;
- identificar quando um join aumentou linhas indevidamente;
- evitar `DISTINCT` como correcao falsa de duplicidade.

### Etapa 3: SQL intermediario

Conteudos:

- `CASE WHEN`;
- subconsultas;
- CTEs;
- funcoes de janela;
- rankings;
- comparacoes entre periodos;
- metricas acumuladas.

Criterios de conclusao:

- quebrar uma pergunta maior em etapas logicas;
- escolher entre CTE, subconsulta ou consulta direta;
- criar metricas condicionais;
- comparar resultados entre grupos ou periodos;
- explicar a diferenca entre linha, grupo e janela.

### Etapa 4: Projeto analitico

Conteudos:

- perguntas de negocio mais completas;
- indicadores;
- validacoes;
- analises de clientes, vendas, produtos, vendedores, pagamentos e avaliacoes;
- views finais;
- registro dos insights.

Criterios de conclusao:

- transformar perguntas de negocio em consultas;
- validar indicadores;
- documentar regras;
- separar consulta exploratoria de consulta final;
- registrar insights e limitacoes.

### Etapa 5: Portfolio

Conteudos:

- scripts organizados;
- README;
- dicionario de dados;
- diagrama das tabelas;
- objetivo;
- metodologia;
- principais analises;
- insights;
- limitacoes;
- repositorio no GitHub;
- material para LinkedIn e entrevistas.

Criterios de conclusao:

- projeto compreensivel para recrutadores e pessoas tecnicas;
- scripts reproduziveis;
- README claro;
- decisoes documentadas;
- evolucao de aprendizagem demonstrada.

### Etapa 6: Integracao

Conteudos:

- conexao do PostgreSQL ao Power BI;
- dashboard com indicadores;
- avaliacao de dbt para organizar, testar e documentar transformacoes.

Criterios de conclusao:

- Power BI conectado a consultas ou views confiaveis;
- indicadores validados antes da visualizacao;
- regras documentadas;
- decisao consciente sobre uso de dbt.

### Etapa 7: Evolucao futura

Conteudos:

- Databricks;
- lakehouse;
- pipelines;
- processamento em maior escala.

Criterios de conclusao:

- fundamentos de SQL consolidados antes da migracao;
- clareza sobre por que Databricks seria util;
- projeto pronto para evoluir sem substituir a base conceitual em PostgreSQL.

## Estrutura de pastas

Estrutura recomendada para o projeto:

```text
Projeto_olist/
  docs/
    MASTER_CONTEXT.md
    LEARNING_PROTOCOL.md
    PROGRESS_TRACKER.md
    DATA_MAP.md
    SQL_STYLE_AND_VALIDATION.md
  sql/
    exploratory/
    validation/
    analysis/
    views/
  assets/
  README.md
```

Observacao: a pasta `docs/` foi criada primeiro. As demais pastas podem ser criadas conforme o projeto avancar.

## Registro de decisoes

| Data | Decisao | Motivo |
|---|---|---|
| 2026-10-12 | Permanecer em PostgreSQL por enquanto | Consolidar fundamentos de SQL antes de adicionar novas camadas de ferramenta |
| 2026-10-12 | Importar tabelas gradualmente | Evitar excesso de complexidade e permitir documentar granularidade, chaves e qualidade antes do uso analitico |
| 2026-10-12 | Deixar dbt e Databricks para etapas posteriores | Primeiro construir base solida em SQL, validacao e modelagem analitica |

## Quando e como atualizar este arquivo

Atualizar apenas quando houver mudanca estrutural: novo objetivo, mudanca de ambiente, nova etapa do roadmap, alteracao de estrutura de pastas ou decisao relevante do projeto. Progresso de aula, erros e exercicios devem ficar no `PROGRESS_TRACKER.md`.
