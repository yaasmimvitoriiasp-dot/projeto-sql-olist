# Acompanhamento de Progresso

Este arquivo registra a evolucao do aprendizado em SQL no projeto Olist. Ele deve mostrar o que foi praticado, o que ainda esta fragil, quais erros viraram aprendizado e qual e o proximo passo.

Ultima atualizacao: 2026-11-10.

## Estado atual

- Projeto: SQL com base publica brasileira de e-commerce Olist.
- Banco: `projeto_ecommerce` (PostgreSQL 18, pgAdmin 4).
- Schema: `ecommerce`.
- Tabelas importadas: `customers`, `orders`, `order_items`, `order_payments`, `order_reviews`, `products`.
- Nivel atual: basico pratico, entrando em relacionamentos (Etapa 2 do roadmap).
- Foco atual: `JOIN` entre varias tabelas, agregacoes (`COUNT`, `SUM`), validacao de chaves e interpretacao de negocio.
- Meta: projeto publicado no GitHub e no LinkedIn ate 2026-12-14 (ver `MASTER_CONTEXT.md`).

## Conteudos praticados

- `SELECT`, `FROM`, `WHERE`
- `COUNT(*)`, `COUNT(campo)`, `COUNT(DISTINCT campo)`
- `SUM`
- `DISTINCT`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- Aliases com `AS` e aliases de tabela (`c`, `o`, `p`)
- `IS NULL` e `AND`
- `INNER JOIN` com 2 e 3 tabelas
- `LEFT JOIN` (usado uma vez; diferenca para `INNER JOIN` explicada em 2026-11-10)
- `information_schema.tables` e `information_schema.columns`
- `CREATE TABLE` e importacao de CSV pelo Import/Export Data do pgAdmin
- Uso do Query Tool do pgAdmin
- Organizacao de consultas no mesmo script usando comentarios

## Nivel por fundamento

| Fundamento | Nivel atual | Evidencia | Status |
|---|---|---|---|
| `SELECT` e `FROM` | Basico consolidado | Usados em todas as consultas | Ok |
| `WHERE` | Basico em consolidacao | Filtros por status e por nulos; entendeu que coluna do `WHERE` nao precisa estar no `SELECT` (2026-11-10) | Em pratica |
| `ORDER BY` | Basico consolidado | Ordena por alias e por agregacao | Ok |
| `COUNT(*)` / `COUNT(campo)` | Basico em consolidacao | Descobriu na pratica que `COUNT(campo)` ignora nulos (2026-11-04) | Em pratica |
| `COUNT(DISTINCT campo)` | Basico em consolidacao | Usa para pessoas unicas; teve duvida se `customer_unique_id` precisava de `DISTINCT` e comprovou rodando as duas versoes (2026-11-02) | Reforcar |
| `GROUP BY` | Basico em consolidacao | Agrupa por uma e por duas colunas (cidade + estado) | Em pratica |
| `HAVING` | Basico | Resolveu cidades com mais de 1.000 clientes unicos sem consultar o chat (2026-11-02) | Em pratica |
| `IS NULL` | Inicial | Pesquisou e aplicou sozinha (2026-11-04) | Em pratica |
| `INNER JOIN` | Basico | 2 tabelas (2026-11-10) e 3 tabelas (2026-11-10, com pesquisa no Gemini) | Prioridade |
| `LEFT JOIN` | Inicial | Usou com `WHERE` na tabela da direita (vira `INNER` na pratica); diferenca explicada com exemplo | Prioridade |
| `SUM` | Inicial | Faturamento por estado (2026-11-10) | Em pratica |
| Interpretacao de resultados | Em desenvolvimento | Comparou fatia de pedidos x faturamento por estado; identificou inconsistencia nos dados (8 pedidos `delivered` sem data) | Em pratica |

## Exercicios concluidos

Numeracao conforme o arquivo `projeto-sql-olist.sql`.

### 1. Quantidade de pedidos por status (2026-10-12)

Aprendizado: quando a chave da tabela ja representa uma linha unica, `COUNT(*)` e suficiente.

### 2. Quantidade de pedidos por estado (2026-10-12)

`INNER JOIN` entre `orders` e `customers`. Resultado informado: Sao Paulo com 41.746 pedidos (todos os status).

### 3. Clientes unicos por estado (2026-10-12)

Resultado informado: Sao Paulo com 40.302 clientes unicos.

### 4 a 13. Recorrencia, unicidade e pessoas diferentes (entre 2026-10-12 e 2026-11-02)

Consultas no script: clientes com mais de um registro, status com mais de 500 pedidos, conferencia da unicidade de `customer_id` (exercicio 10), pessoas diferentes na tabela `customers` (exercicio 12), cinco estados com mais pessoas diferentes (exercicio 13).

Resultados dos exercicios 10 e 12 nao foram registrados. Ver pendencias.

### Top 5 estados por clientes unicos (2026-11-02)

Resultado: SP 40.302, RJ 12.384, MG 11.259, RS 5.277, PR 4.882.

Aprendizado: o 40.302 registrado em 12/10 era o total de pessoas unicas de SP, nao do conjunto inteiro. Em SP sao 41.746 registros para 40.302 pessoas.

### 14 e 15. Catalogo do banco (2026-11-02)

Consultou `information_schema.tables` e `information_schema.columns` para listar tabelas, colunas e tipos.

Aprendizado: o banco guarda um catalogo de si mesmo, consultavel com `SELECT`. Descoberta de qualidade: `customer_zip_code_prefix` foi importado como `integer` e perdeu os zeros a esquerda.

Observacao: as versoes 14 e 15 no script sao tentativas intermediarias (uma tem `wher` incompleto). Limpar na etapa de portfolio.

### Cidades com mais de 1.000 clientes unicos (2026-11-02)

Resultado: 9 cidades. Sao Paulo/SP 14.984, Rio de Janeiro/RJ 6.620, Belo Horizonte/MG 2.672, Brasilia/DF 2.069, Curitiba/PR 1.465, Campinas/SP 1.398, Porto Alegre/RS 1.326, Salvador/BA 1.209, Guarulhos/SP 1.153.

Leitura de negocio: 3 das 9 cidades sao de SP.

Consulta ainda nao esta no script.

### 16. Dez pessoas que mais fizeram pedidos (2026-11-03)

Resultado: a pessoa com mais pedidos tem 17; depois 9, 7, 7, 7 e varias com 6.

Aprendizado: aqui `COUNT` sem `DISTINCT` e o correto, porque o grupo ja e a pessoa e cada linha e um registro/pedido.

Leitura de negocio: recompra e rara na base.

### Importacao de tabelas (2026-11-03)

`CREATE TABLE` + Import/Export Data do pgAdmin para `order_payments`, `order_items`, `order_reviews` e `products`. Contagens no `DATA_MAP.md`.

### 16 (repetido no script). Pedidos sem data de entrega por status (2026-11-04)

Resultado: shipped 1.107, canceled 619, unavailable 609, invoiced 314, processing 301, delivered 8, created 5, approved 2.

Aprendizado: `COUNT(campo)` ignora nulos; para contar linhas com o campo nulo, contar uma coluna que sempre existe (`order_id`).

Descoberta de qualidade: 8 pedidos com status `delivered` sem data de entrega. Confirmado com `AND`.

### Pergunta de negocio 1: pedidos entregues por estado (2026-11-10)

`JOIN` entre `customers` e `orders`, filtrando `order_status = 'delivered'`. Resultado: 27 estados. SP 40.501, RJ 12.350, MG 11.354, RS 5.345, PR 4.923 ... RR 41. Soma dos resultados: 96.478 pedidos entregues.

Leitura de negocio: SP tem cerca de 42% dos pedidos entregues; SP, RJ e MG somam cerca de dois tercos. Em SP, 41.746 - 40.501 = 1.245 pedidos nao entregues.

Observacao: foi usado `LEFT JOIN` com filtro na tabela da direita, o que na pratica equivale a `INNER JOIN`.

Consulta ainda nao esta no script.

### Pergunta de negocio 2: faturamento por estado (2026-11-10)

`INNER JOIN` entre `customers`, `orders` e `order_payments`, com `SUM(payment_value)` e filtro `delivered`. Resultado: soma de R$ 15.422.461,77. SP R$ 5.770.266,19; RJ R$ 2.055.690,45; MG R$ 1.819.277,61 ... RR R$ 9.039,52.

Leitura de negocio: SP tem 42,0% dos pedidos entregues, mas 37,4% do faturamento. Estados do Norte e Nordeste (CE, PA, PB, MA, PI) tem fatia de faturamento maior que de pedidos, o que sugere valor por pedido maior fora de SP. Hipotese a investigar: frete.

Como foi resolvido: a estrutura de 3 `JOIN`s foi pesquisada no Gemini e replicada. Explicacao do caminho entre as tabelas com as proprias palavras ainda pendente.

Consulta ainda nao esta no script.

## Exercicios destravados pela palavra `entrega`

Nenhum ate o momento.

Observacao: os comandos `CREATE TABLE` das quatro tabelas novas (2026-11-03) e a consulta ao `information_schema.tables` (2026-11-02) foram fornecidos prontos, por serem preparacao de ambiente e nao exercicio. Em 2026-11-02 ficou combinado que, daqui em diante, consultas de conferencia do ambiente tambem nao vem prontas.

| Data | Exercicio | Conceito | Motivo do destravamento | Como retomar depois |
|---|---|---|---|---|

## Registro de erros e aprendizados

| Data | Erro ou dificuldade | Por que aconteceu | Aprendizado | Status |
|---|---|---|---|---|
| 2026-10-12 | Usou `COUNT(DISTINCT order_id)` para contar pedidos por status | `order_id` ja e unico em `orders` | Antes de usar `DISTINCT`, verificar a granularidade e a chave da tabela | Corrigido |
| 2026-10-12 | Alias `cliente_unico` para uma metrica que contava linhas | O nome descrevia mal a metrica | Aliases devem nomear a medida | Corrigido |
| 2026-10-12 | Duvida conceitual sobre `GROUP BY` e agregacao | Conceito em formacao | Explicar qual e o grupo e o que esta sendo contado | Melhorou (ver exercicio 16) |
| 2026-11-02 | `LIMIT 5` parecia filtrar a tabela certa | Coincidencia na ordem das linhas | `LIMIT` corta quantidade; quem escolhe linhas e o `WHERE` | Corrigido |
| 2026-11-02 | Achava que `customer_unique_id` nao precisava de `DISTINCT` | O nome sugere que o valor aparece uma vez na tabela | Unico por pessoa, mas repete por pedido (como um CPF em varias notas fiscais); comprovou rodando com e sem `DISTINCT` | Corrigido |
| 2026-11-03 | Importacao falhou: CSV de itens escolhido para a tabela de pagamentos; depois delimitador trocado para `;` | Nomes de arquivo parecidos | Conferir nome do arquivo e delimitador; ler o detalhe do erro em View Processes | Corrigido |
| 2026-11-04 | `COUNT(order_delivered_customer_date)` com `WHERE ... IS NULL` retornava 0 | `COUNT(campo)` ignora nulos | Contar uma coluna que sempre existe | Corrigido |
| 2026-11-10 | `LEFT JOIN` com filtro na tabela da direita | Diferenca entre tipos de join esquecida | O filtro remove as linhas sem par, entao vira `INNER JOIN` na pratica | Reforcar com exercicio |

## Dificuldades atuais

- Diferenca entre `INNER JOIN` e `LEFT JOIN` na pratica (quando cada um muda o resultado).
- Explicar com as proprias palavras o caminho de um `JOIN` com 3 tabelas.
- Prever duplicacao de linhas em relacionamentos 1:N (sera essencial no ticket medio).

## Proximo exercicio

Validacao de chaves (pendencia do `DATA_MAP.md`), curta, antes da pergunta 3:

> Antes de calcular ticket medio, confirme se `order_id` e unico em `orders` e se `customer_id` e unico em `customers`. Depois, descubra se um mesmo pedido pode aparecer mais de uma vez em `order_payments` e em `order_items`.

Em seguida: pergunta de negocio 3, ticket medio por pedido.

Importante: nao resolver este exercicio neste arquivo. Ele deve ser conduzido pela metodologia do `LEARNING_PROTOCOL.md`.

## Pendencias antes de avancar muito

- Registrar os resultados dos exercicios 10 (unicidade de `customer_id`) e 12 (pessoas diferentes em `customers`), com data.
- Validar unicidade de `order_id` em `orders`.
- Verificar nulos nas chaves de relacionamento.
- Explicar com as proprias palavras a consulta da pergunta 2.
- Colocar no script as consultas das cidades com mais de 1.000 clientes e das perguntas 1 e 2.

## Sessoes de Git

### 2026-10-12 - Introducao ao Git

Repositorio iniciado e primeiro commit criado. Praticados `git init`, `git status`, `git add`, `git commit` e `git log`. Dificuldade identificada: distinguir preparacao, registro local e publicacao.

### 2026-11-04 - Upload pelo site

Arquivo `projeto-sql-olist.sql` enviado pelo site do GitHub (Add file > Upload files). Combinada a rotina de subir o script no fim de cada sessao. Arquivo local: `OneDrive\Documentos\projeto-sql-olist\projeto-sql-olist.sql`. Os CSVs ficam fora do repositorio.

### 2026-11-10 - Ligacao da pasta local ao GitHub pela linha de comando

Praticados `git init`, `git branch -M master`, `git remote add origin`, `git fetch`, `git reset origin/master`, `git status` e `git restore docs/`.

Aprendizado: o `git status` mostrou os arquivos de `docs/` como `deleted` porque existiam no GitHub e nao na pasta local; `git restore` trouxe de volta antes de qualquer commit.

Rotina diaria combinada: `git add`, `git commit -m "mensagem"`, `git push`.

Proximo passo em Git: sessao de estudo na Etapa 5 (organizacao do repositorio).

## Uso de IA no projeto

- A estudante usa IA (Claude e Gemini) como professora e revisora.
- O que nao se terceiriza: validar os numeros e interpretar o negocio.
- O README tera uma secao "Como usei IA no projeto".

## Quando e como atualizar este arquivo

Atualizar ao final de toda sessao de estudo, depois da confirmacao da estudante. Registrar exercicios praticados, erros cometidos, conceitos que melhoraram, conceitos ainda frageis, uso da palavra `entrega` e o proximo exercicio. Nao marcar um fundamento como consolidado apenas porque a consulta executou sem erro.
