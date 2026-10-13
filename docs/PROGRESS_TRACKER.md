# Acompanhamento de Progresso

Este arquivo registra a evolucao do aprendizado em SQL no projeto Olist. Ele deve mostrar o que foi praticado, o que ainda esta fragil, quais erros viraram aprendizado e qual e o proximo passo.

## Estado atual

- Projeto: SQL com base publica brasileira de e-commerce Olist.
- Banco: `projeto_ecommerce`.
- Schema: `ecommerce`.
- Tabelas importadas ate agora: `ecommerce.customers` e `ecommerce.orders`.
- Nivel atual: basico pratico, com fundamentos em consolidacao.
- Foco atual: agregacoes, `GROUP BY`, `HAVING`, `DISTINCT`, relacionamento entre `orders` e `customers`, granularidade e interpretacao dos resultados.

## Conteudos praticados

- `SELECT`
- `FROM`
- `COUNT`
- `COUNT(*)`
- `COUNT(campo)`
- `COUNT(DISTINCT campo)`
- `DISTINCT`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- Aliases com `AS`
- `INNER JOIN`
- `ON`
- `LIMIT`
- Uso do Query Tool do pgAdmin
- Execucao de trecho selecionado no pgAdmin
- Organizacao de consultas relacionadas no mesmo script usando comentarios

## Nivel por fundamento

| Fundamento | Nivel atual | Evidencia | Status |
|---|---|---|---|
| `SELECT` e `FROM` | Basico em consolidacao | Ja usados em consultas simples | Em pratica |
| `ORDER BY` | Basico em consolidacao | Ja usa ordenacao e alias no `ORDER BY` | Em pratica |
| `COUNT(*)` | Basico em consolidacao | Ja usado para contar pedidos por status | Em pratica |
| `COUNT(campo)` | Inicial | Sabe que ignora nulos, mas ainda precisa praticar quando usar | Reforcar |
| `COUNT(DISTINCT campo)` | Inicial | Ja usou para contar clientes unicos por estado | Reforcar |
| `DISTINCT` | Inicial | Esta aprendendo a identificar quando e necessario e quando mascara problema | Reforcar |
| `GROUP BY` | Inicial/intermediario inicial | Consegue escrever, mas ainda precisa entender melhor grupos, linhas dentro do grupo e agregacao | Prioridade |
| `HAVING` | Inicial | Ja aplicou com orientacao, conceito ainda nao consolidado | Prioridade |
| `INNER JOIN` | Basico | Montou relacionamento entre `orders` e `customers` por `customer_id` | Em pratica |
| Interpretacao de resultados | Em desenvolvimento | Ja interpretou diferenca entre pedidos e clientes unicos, mas precisa aprofundar recorrencia | Prioridade |

## Exercicios concluidos

### 1. Quantidade de pedidos por status

Consulta inicial usou `COUNT(DISTINCT order_id)`. Foi explicado que `order_id` e unico em `orders`, entao o `DISTINCT` era desnecessario nessa analise.

Versao final praticada:

```sql
SELECT
    order_status,
    COUNT(*) AS quantidade_status
FROM ecommerce.orders
GROUP BY order_status
ORDER BY quantidade_status DESC;
```

Aprendizado: quando a chave da tabela ja representa uma linha unica, `COUNT(*)` pode ser suficiente. O alias tambem pode ser usado no `ORDER BY`.

### 2. Quantidade de pedidos por estado

Consulta praticada:

```sql
SELECT
    c.customer_state AS estado,
    COUNT(o.order_id) AS total_pedidos
FROM ecommerce.orders o
INNER JOIN ecommerce.customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_pedidos DESC;
```

Resultado observado informado pela estudante: Sao Paulo com 41.746 pedidos.

Observacao: este numero precisa entrar no `DATA_MAP.md` ou em analises futuras somente com data de leitura quando for usado como evidencia documentada.

### 3. Clientes unicos por estado

Consulta praticada:

```sql
SELECT
    customer_state AS estado,
    COUNT(DISTINCT customer_unique_id) AS clientes_unicos
FROM ecommerce.customers
GROUP BY customer_state
ORDER BY clientes_unicos DESC;
```

Resultado observado informado pela estudante: Sao Paulo com 40.302 clientes unicos.

Aprendizado: a diferenca entre pedidos e clientes unicos nao representa exatamente a quantidade de clientes recorrentes, porque um mesmo cliente pode ter feito tres ou mais pedidos.

### 4. Clientes recorrentes

Consulta praticada:

```sql
SELECT
    customer_unique_id AS cliente,
    COUNT(*) AS quantidade_pedidos
FROM ecommerce.customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY quantidade_pedidos DESC;
```

Aprendizado: `GROUP BY customer_unique_id` cria um grupo por pessoa; `COUNT(*)` conta as linhas dentro de cada grupo; `HAVING COUNT(*) > 1` mantem apenas grupos com mais de uma linha.

Ponto de atencao: chamar `COUNT(*)` em `customers` de `quantidade_pedidos` so e valido se for confirmado que `customers` tem uma linha por pedido/compra, e nao uma linha por pessoa. Isso ainda esta pendente.

## Exercicios destravados pela palavra `entrega`

Nenhum ate o momento.

Quando a palavra `entrega` for usada e uma consulta completa for fornecida, registrar:

| Data | Exercicio | Conceito | Motivo do destravamento | Como retomar depois |
|---|---|---|---|---|

## Registro de erros e aprendizados

| Data | Erro ou dificuldade | Por que aconteceu | Aprendizado | Status |
|---|---|---|---|---|
| 2026-10-12 | Usou `COUNT(DISTINCT order_id)` para contar pedidos por status | `order_id` ja e unico em `orders`; o `DISTINCT` nao mudava o resultado esperado | Antes de usar `DISTINCT`, verificar a granularidade e a chave da tabela | Corrigido, reforcar em novos exercicios |
| 2026-10-12 | Alias `cliente_unico` foi usado para uma metrica que contava linhas/pedidos por cliente | O nome do alias descrevia mal a metrica calculada | Aliases devem nomear a medida de forma clara, por exemplo `quantidade_pedidos` | Corrigido |
| 2026-10-12 | Duvida conceitual sobre `GROUP BY`, linhas dentro do grupo e agregacao | O conceito ainda esta sendo formado alem da sintaxe | Praticar explicando qual e o grupo, o que esta sendo contado e o que o filtro `HAVING` remove | Pendente |
| 2026-10-12 | Possivel interpretacao precipitada de linhas em `customers` como pedidos | A granularidade de `customers` ainda nao foi confirmada por consulta da estudante | Verificar e registrar a granularidade antes de usar `customers` como base para quantidade de pedidos | Pendente |

## Dificuldades atuais

- Entender profundamente a relacao entre o campo agrupado, as linhas existentes dentro de cada grupo e a funcao de agregacao.
- Identificar sozinha quais operacoes uma pergunta de negocio exige.
- Diferenciar quando `DISTINCT` e necessario de quando ele esta escondendo duplicidade ou problema de relacionamento.
- Consolidar o uso de `HAVING` como filtro de grupos, nao como funcao de contagem.

## Proximo exercicio

Pergunta de negocio pendente:

> A empresa quer analisar somente os status que possuem mais de 500 pedidos. Mostre o status, a quantidade de pedidos e organize do maior resultado para o menor.

Importante: nao resolver este exercicio neste arquivo. Ele deve ser conduzido pela metodologia do `LEARNING_PROTOCOL.md`.

## Pendencias antes de avancar muito

- Verificar e registrar a granularidade de `ecommerce.customers`.
- Confirmar se cada linha de `customers` representa um cliente por pedido ou outro tipo de registro.
- Verificar chaves, nulos e duplicidades basicas em `customers` e `orders`.
- Registrar contagens com data no `DATA_MAP.md`.

## Sessoes de Git

### 2026-10-12 - Introducao ao Git

Repositorio iniciado e primeiro commit criado. Praticados `git init`, `git status`, `git add`, `git commit` e `git log`. Dificuldade identificada: distinguir preparacao, registro local e publicacao. Conceitos ainda em consolidacao.

Proximo passo em Git: retomar essa diferenca e definir o destino do arquivo de contexto original (`contexto-sql-olist.md`). O proximo exercicio de SQL permanece pendente, conforme a secao acima.

## Quando e como atualizar este arquivo

Atualizar ao final de toda sessao de estudo, depois da confirmacao da estudante. Registrar exercicios praticados, erros cometidos, conceitos que melhoraram, conceitos ainda frageis, uso da palavra `entrega` e o proximo exercicio. Nao marcar um fundamento como consolidado apenas porque a consulta executou sem erro.
