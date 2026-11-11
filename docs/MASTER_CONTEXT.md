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

- PostgreSQL 18 (servidor "PostgreSQL 18" no pgAdmin).
- pgAdmin 4.
- Banco: `projeto_ecommerce`.
- Schema: `ecommerce`.
- Base: Olist, obtida pelo Kaggle.
- Tabelas importadas ate agora:
  - `ecommerce.customers`;
  - `ecommerce.orders`;
  - `ecommerce.order_items`;
  - `ecommerce.order_payments`;
  - `ecommerce.order_reviews`;
  - `ecommerce.products`.
- Script de consultas: `projeto-sql-olist.sql`, na raiz do repositorio.
- Repositorio: https://github.com/yaasmimvitoriiasp-dot/projeto-sql-olist (publico).

## Estado atual do projeto

Atualizado em 2026-11-10.

Fatos ja concluidos:

- Seis tabelas importadas, com contagens registradas no `DATA_MAP.md`.
- Colunas e tipos de `customers` e `orders` conferidos via `information_schema`.
- Etapa 1 (fundamentos) praticada: agregacoes, `GROUP BY`, `HAVING`, `DISTINCT`, `IS NULL`.
- Checagem de qualidade: datas de entrega nulas por status; 8 pedidos `delivered` sem data.
- Etapa 2 (relacionamentos) iniciada: perguntas de negocio 1 e 2 resolvidas com `JOIN` de 2 e 3 tabelas.

Pontos ainda nao concluidos:

- Validar unicidade de `order_id` e registrar a de `customer_id`.
- Validar granularidade das tabelas novas antes de analises que somem valores (risco de duplicacao em 1:N).
- Perguntas de negocio 3 a 6.
- Consolidar a diferenca entre `INNER JOIN` e `LEFT JOIN`.

## Meta de publicacao e escopo (decidido em 2026-11-02 e 2026-11-03)

Publicar o projeto no GitHub e no LinkedIn ate 2026-12-14, com o resto de dezembro como folga. O projeto nao deve se arrastar por meses.

Ritmo: cerca de 40 minutos por dia (30 em semanas pesadas de faculdade), uma tarefa fechada por sessao, com commit no fim de cada sessao.

Escopo da versao publicada (recorte das Etapas 1, 2 e 5 do roadmap; as Etapas 3, 4, 6 e 7 continuam valendo para depois):

| Periodo | Entrega |
|---|---|
| ate 2026-11-09 | Fundamentos e importacao das tabelas (concluido em 2026-11-04) |
| 2026-11-10 a 2026-11-30 | 6 perguntas de negocio com `JOIN` |
| 2026-12-01 a 2026-12-07 | Organizacao do repositorio, README, limpeza do script, sessao de Git |
| 2026-12-08 a 2026-12-14 | Revisao final e post no LinkedIn |

Perguntas de negocio da versao publicada:

1. De onde vem os pedidos entregues (pedidos por estado) - concluida em 2026-11-10
2. Quanto cada estado fatura - concluida em 2026-11-10
3. Ticket medio por pedido
4. Formas de pagamento mais usadas
5. Atraso na entrega afeta a nota da avaliacao?
6. Categorias de produto que mais vendem

Exercicios extras de dificuldade crescente entram entre as perguntas: `LEFT JOIN` para achar o que falta, calculo com datas, `CASE WHEN`, CTEs e funcoes de janela.

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
| 2026-11-02 | Publicar ate 2026-12-14 com escopo enxuto (6 perguntas de negocio) | Faculdade com pouco tempo; projeto publicado vale mais que projeto grande inacabado |
| 2026-11-03 | Importar `order_items`, `order_payments`, `order_reviews` e `products`; deixar `sellers`, `geolocation` e traducao de categorias de fora | Sao as tabelas necessarias para as 6 perguntas |
| 2026-11-04 | Manter os CSVs fora do repositorio; README apontara para o Kaggle | Arquivos pesados e disponiveis publicamente na fonte |
| 2026-11-10 | IA (Claude, Gemini) usada como professora e revisora; validacao e interpretacao sao feitas pela estudante; README tera secao "Como usei IA no projeto" | Mostrar uso consciente de IA, valorizado em vagas de dados |
| 2026-11-10 | Documentos de `docs/` sao a fonte oficial do contexto do projeto | Manter qualquer assistente de IA alinhado ao mesmo historico |

## Quando e como atualizar este arquivo

Atualizar apenas quando houver mudanca estrutural: novo objetivo, mudanca de ambiente, nova etapa do roadmap, alteracao de estrutura de pastas ou decisao relevante do projeto. Progresso de aula, erros e exercicios devem ficar no `PROGRESS_TRACKER.md`.
