# Acompanhamento de Progresso

Este arquivo registra a evolucao do aprendizado em SQL no projeto Olist. Ele deve mostrar o que foi praticado, o que ainda esta fragil, quais erros viraram aprendizado e qual e o proximo passo.

Ultima atualizacao: 2026-11-18.

## Estado atual

- Projeto: SQL com base publica brasileira de e-commerce Olist.
- Banco: `projeto_ecommerce` (PostgreSQL 18, pgAdmin 4).
- Schema: `ecommerce`.
- Tabelas importadas: `customers`, `orders`, `order_items`, `order_payments`, `order_reviews`, `products`.
- Nivel atual: basico pratico solido, fazendo relacionamentos e as primeiras consultas intermediarias (subconsulta).
- Foco atual: entender como o SQL funciona por dentro (ordem logica de execucao); consolidar `GROUP BY` + `HAVING`, `LEFT JOIN` e `DISTINCT` em tabelas 1:N; proximas: datas, `CASE WHEN`, CTE e funcoes de janela.
- Perguntas de negocio: 1 a 4 concluidas; faltam 5 e 6.
- Meta: projeto publicado no GitHub e no LinkedIn ate 2026-12-14 (ver `MASTER_CONTEXT.md`).

## Conteudos praticados

- `SELECT`, `FROM`, `WHERE`
- `COUNT(*)`, `COUNT(campo)`, `COUNT(DISTINCT campo)`
- `SUM`, `AVG`, `ROUND`
- Divisao entre agregacoes (`SUM(...) / COUNT(DISTINCT ...)`)
- `DISTINCT`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- Aliases com `AS` e aliases de tabela (`c`, `o`, `p`)
- `IS NULL`, `AND` e `IN`
- `INNER JOIN` com 2 e 3 tabelas
- `LEFT JOIN`, inclusive `LEFT JOIN` + `IS NULL` para achar o que falta (anti join)
- Subconsulta no `FROM` (contar os grupos de um `GROUP BY` + `HAVING`)
- Ordem logica de execucao (`FROM`/`JOIN` -> `WHERE` -> `GROUP BY` -> `HAVING` -> `SELECT` -> `ORDER BY`)
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
| `GROUP BY` | Em consolidacao | Fixacao com 2 pedidos (2026-11-16): previu certo as versoes com `GROUP BY`; explicou com as proprias palavras ("sacos"). Em 2026-11-18 ainda rodou `HAVING` com `GROUP BY` comentado, mas entendeu ao contar uma tabela pequena na mao | Reforcar de forma espacada |
| `HAVING` | Em consolidacao | Explicou em 2026-11-16: `WHERE` filtra linhas antes de contar, `HAVING` filtra grupos usando a conta | Reforcar de forma espacada |
| `IS NULL` | Inicial | Pesquisou e aplicou sozinha (2026-11-04) | Em pratica |
| `INNER JOIN` | Basico em consolidacao | 2 e 3 tabelas; explica que traz so o que existe nas duas tabelas; sabe que `JOIN` sozinho = `INNER JOIN` | Em pratica |
| `LEFT JOIN` | Em pratica | Treino de 2026-11-17: pedidos sem avaliacao, sem item, produtos nunca vendidos e pedido sem pagamento. Regra escrita por ela: `FROM` = tabela que tem o que eu procuro; `LEFT JOIN` = tabela onde pode estar faltando. Ainda inverte as tabelas ou filtra o nulo do lado errado na primeira tentativa | Reforcar |
| `SUM` | Basico | Faturamento por estado (2026-11-10) | Em pratica |
| `AVG` e media por pedido | Inicial | Ticket medio (2026-11-16): entendeu que `AVG` divide pelo numero de linhas, e que em tabela 1:N isso vira media por pagamento | Em pratica |
| `COUNT(DISTINCT)` em tabela 1:N | Inicial | Formas de pagamento (2026-11-18): resistiu, se convenceu achando nos dados um pedido com 29 vouchers | Reforcar |
| Subconsulta | Inicial | Aprendeu em 2026-11-18 para contar os grupos de um `GROUP BY` + `HAVING` | Em pratica |
| Ordem logica de execucao | Inicial | Explicada em 2026-11-17; ela pediu para aprender o funcionamento por dentro | Prioridade |
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

### 19 a 22. Validacao de chaves (2026-11-11)

| Verificacao | Resultado | Conclusao |
|---|---|---|
| `order_id` em `orders` | 99.441 linhas, 99.441 distintos | Unico |
| `customer_id` em `customers` | 99.441 linhas, 99.441 distintos | Unico |
| Pedidos com mais de uma linha em `order_payments` | 2.961 | 2.961 pedidos tem mais de um pagamento |
| Pedidos com mais de uma linha em `order_items` | 9.803 | 9.803 pedidos tem mais de um item |

Aprendizados:

- Agregacao sem `GROUP BY` considera a tabela inteira como um grupo e devolve uma linha. O que obriga o `GROUP BY` e ter no `SELECT` uma coluna fora da agregacao.
- Regra pratica: pergunta "para cada X" pede `GROUP BY X`; pergunta sobre a tabela inteira, nao.
- `GROUP BY` decide o que e um grupo; `COUNT` mede cada grupo; `HAVING` escolhe quais grupos ficam.
- Para saber quantos grupos sobraram, foi usada a aba Messages do pgAdmin ("rows affected"). Contar os grupos direto na consulta exige subconsulta (proximo nivel da trilha).
- Juntar `order_items` e `order_payments` na mesma consulta multiplica linhas.

Como foi resolvido: validacoes 1, 2 e 4 sozinha; na 3 precisou de uma dica e de exemplo com tabela pequena. A validacao 4 foi feita sem ajuda, com o mesmo raciocinio da 3.

Observacao: no script, a consulta da validacao 1 ainda tem um `GROUP BY order_id` que nao corresponde ao resultado registrado (foi rodado um trecho selecionado). Corrigir na limpeza.

### Fixacao de `GROUP BY` + `HAVING` (2026-11-16)

Com dois pedidos reais da `order_payments`, filtrados com `IN`: `7842147864c0425541edd55923f3c0f1` (2 pagamentos: credit_card 44,30 + voucher 50,00) e `b81ef226f3fe1789b1e8b2acac839d17` (1 pagamento: credit_card 99,33).

| Passo | Consulta | Palpite dela | Resultado |
|---|---|---|---|
| 2 | `SELECT *` | - | 3 linhas |
| 3 | so `COUNT(order_id)`, sem `GROUP BY` | 3 linhas | 1 linha, com o numero 3 |
| 4 | `order_id` + `COUNT` + `GROUP BY order_id` | 2 linhas, 2 e 1 | 2 linhas, 2 e 1 |
| 5 | + `HAVING COUNT(order_id) > 1` | - | 1 linha (o pedido 78421...) |

Aprendizado: `COUNT` troca as linhas pela quantidade delas; sem `GROUP BY` sai uma linha so. `SELECT *` + `COUNT` sem `GROUP BY` da erro.

Explicacao dela: o `GROUP BY` agrupa por uma categoria; o `WHERE` nao faz conta; o `HAVING` filtra usando a conta e vem depois do `GROUP BY`.

### Pergunta de negocio 3: ticket medio (2026-11-16)

Resultado: **R$ 159,86** por pedido entregue (`ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2)`).

Caminho:
- 1a tentativa: `AVG(payment_value)` = 153,07. Era a media por pagamento, nao por pedido.
- 2a tentativa: `AVG(SUM(...))` deu erro (agregacao dentro de agregacao). A intuicao "somar por pedido e depois tirar a media" estava certa; o jeito de escrever seria subconsulta.
- A ponte com DAX (`DIVIDE(SUM(...), DISTINCTCOUNT(...))`) destravou.
- Conferencia: 15.422.461,77 / 96.478 = 159,85, um centavo de diferenca. Hipotese: 1 pedido entregue sem pagamento. Confirmada em 2026-11-17.

### Treino de `INNER` x `LEFT JOIN` (2026-11-17)

Pedido dela: exercicios focados na dificuldade (entendia a teoria, mas nao sabia aplicar).

| Exercicio | Resultado |
|---|---|
| `orders` x `order_reviews`: linhas com `JOIN` e com `LEFT JOIN` | 99.224 e 99.992 (diferenca 768) |
| Pedidos sem avaliacao (`LEFT JOIN` + `r.order_id IS NULL`) | 768 |
| Pedidos sem nenhum item | 775 |
| Produtos da `products` nunca vendidos | 0 |
| Pedido entregue sem pagamento | 1: `bfbd0f9bdef84302105ad712db648a6c` |
| Pedidos sem avaliacao por status | delivered 646, shipped 75, canceled 20, unavailable 14, processing 6, invoiced 5, created 2 |

Regra escrita por ela como comentario no script:

```sql
FROM ecommerce.orders o                 -- tabela que tem o que eu procuro
LEFT JOIN ecommerce.order_payments p    -- tabela onde pode estar faltando
```

Erros no caminho: primeiro tentou achar o que falta olhando so a tabela onde falta (`order_items WHERE order_id IS NULL` = 0); filtrou o nulo do lado da `orders` (`o.order_id IS NULL`); inverteu as tabelas nos produtos.

Explicacao dela: "o `INNER` traz o que e compativel entre as duas tabelas; no `LEFT` a gente mantem tudo da esquerda, inclusive o que nao e compativel, e o que nao e compativel vem nulo".

Ainda nao entendeu por que filtrar por `r.review_id` tambem funciona. Retomar.

### Pergunta de negocio 4: formas de pagamento (2026-11-18)

| Forma | Sem `DISTINCT` (pagamentos) | Com `DISTINCT` (pedidos) | % dos 99.440 pedidos com pagamento |
|---|---|---|---|
| credit_card | 76.795 | 76.505 | 76,9% |
| boleto | 19.784 | 19.784 | 19,9% |
| voucher | 5.775 | 3.866 | 3,9% |
| debit_card | 1.529 | 1.528 | 1,5% |
| not_defined | 3 | 3 | 0,0% |

Leitura: o voucher cai 33% com `DISTINCT` porque varios vouchers sao usados no mesmo pedido (achou o pedido `fa65dad1b0e818e3ccc5cb0e39231352` com 29 linhas de voucher). A soma com `DISTINCT` (101.686) passa de 99.440 porque um pedido pode usar mais de uma forma, e isso e o correto.

Resistencia no caminho: achava que `order_id` era unico na `order_payments` e que o `DISTINCT` tiraria o pedido de outra forma de pagamento. Entendeu que o `DISTINCT` age dentro de cada grupo.

Observacao: o `ORDER BY` da consulta ainda usa `count(order_id)` sem `DISTINCT`; ajustar na limpeza.

### Subconsulta (2026-11-18)

Para contar quantos pedidos tem exatamente 1 pagamento: `SELECT COUNT(*) FROM (consulta com GROUP BY order_id HAVING COUNT(*) = 1) AS lista`. Resultado: **96.479**.

Conferencia: 96.479 (1 pagamento) + 2.961 (mais de 1) + 1 (sem pagamento) = 99.441 pedidos. Os numeros fecham.

Explicacao dela: "preciso do `GROUP BY` para olhar cada `order_id` separadamente, mas o resultado sai agrupado e nao e o total; por isso a subconsulta".

### Revisao e subconsulta com coluna (2026-11-21)

- Refez sozinha a subconsulta dos pedidos com exatamente 1 pagamento: 96.479.
- 32: 1.091 pedidos usaram a mesma forma de pagamento mais de uma vez (grupo = pedido + forma; por fora, `COUNT(DISTINCT order_id)`). Contar grupos e contar pedidos deu o mesmo numero: nenhum pedido repete duas formas ao mesmo tempo.

Aprendizados (nas palavras dela, ajustadas):

- Cada linha do resultado e um grupo; o `COUNT` conta as linhas da tabela original que estao dentro desse grupo.
- Ele conta dentro do grupo porque o `GROUP BY` acontece antes; o que esta no `GROUP BY` decide o que e um grupo.
- Se a consulta de fora vai usar uma coluna, ela precisa estar visivel no `SELECT` de dentro, e nao escondida dentro de um `COUNT`.

Erros no caminho: `COUNT(DISTINCT order_id)` dentro de cada grupo (sempre 1); consulta de fora pedindo `order_id` que a de dentro nao mostrava ("column does not exist"); `WHERE payment_type = '<id do pedido>'`.

Ainda "parece magica": contar dentro do grupo; grupos x pedidos.

Proximo: 33. Quantos pedidos usaram mais de uma forma de pagamento diferente?

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
| 2026-11-11 | `GROUP BY order_id` numa contagem da tabela inteira | Achava que toda agregacao exige `GROUP BY` | Sem coluna fora da agregacao no `SELECT`, nao precisa de `GROUP BY` | Corrigido |
| 2026-11-11 | `COUNT(order_id)` + `HAVING > 1` sem `GROUP BY` para achar pedidos repetidos | Le o `HAVING` como filtro de cada linha/ID e espera ver os registros listados | Com `COUNT` no `SELECT`, a consulta devolve uma linha por grupo; sem `GROUP BY` ha um grupo so (a tabela) e o `HAVING` compara o total com 1 | Melhorou com a fixacao de 2026-11-16; reapareceu em 2026-11-18 |
| 2026-11-16 | `AVG(payment_value)` como ticket medio | `AVG` divide pelo numero de linhas, e a `order_payments` tem uma linha por pagamento | Media por pedido = total / pedidos distintos | Corrigido |
| 2026-11-16 | `AVG(SUM(...))` | SQL nao aceita agregacao dentro de agregacao | Usar divisao entre agregacoes ou subconsulta | Corrigido |
| 2026-11-17 | `INNER JOIN` + `IS NULL` voltou vazio | O `INNER` descarta quem nao tem par antes do `WHERE` | Para achar o que falta: `LEFT JOIN` + nulo do lado da tabela onde pode faltar | Corrigido, reforcar |
| 2026-11-17 | Procurar o que falta olhando so a tabela onde falta | O registro ausente nao e uma linha nula, ele nao existe la | Partir da tabela que tem o registro | Corrigido |
| 2026-11-17 | Filtrar `o.order_id IS NULL` (lado da `orders`) | Confusao sobre de que lado nasce o nulo | O nulo nasce do lado da tabela do `LEFT JOIN` | Corrigido, reforcar |
| 2026-11-18 | Sem `DISTINCT` ao contar pedidos por forma de pagamento | Achava que `order_id` era unico na `order_payments` | Antes de contar, perguntar: "nessa tabela, o que eu conto pode se repetir?" | Corrigido |
| 2026-11-18 | `HAVING` com `GROUP BY` comentado; concluiu que nao havia pedidos com 1 pagamento | Mesmo ponto de 2026-11-11 | Sem `GROUP BY`, o `HAVING` compara o total da tabela | Corrigido, reforcar |

## Dificuldades atuais

- Quando a condicao e sobre cada linha (`WHERE`) e quando e sobre cada grupo (`GROUP BY` + `HAVING`). Melhorou, mas ainda escorrega.
- Escolher a tabela do `FROM` e o lado do nulo no `LEFT JOIN` na primeira tentativa.
- Prever duplicacao em tabelas 1:N antes de contar ou somar (`order_payments`, `order_items`).
- Por que filtrar por qualquer coluna da tabela da direita (ex.: `r.review_id`) funciona no anti join.
- Entender o funcionamento por dentro (ordem logica de execucao) e ler as consultas nessa ordem.

## Proximo exercicio

Pendente de 2026-11-18: "Existem pedidos que aparecem mais de uma vez com a mesma forma de pagamento? Quantos?" (exercicio 30 do script; o caso existe, ex.: `fa65dad...` com 29 vouchers, mas o total nao foi calculado).

Depois: pergunta de negocio 5, atraso na entrega x nota da avaliacao. Conceitos novos: calculo com datas e `CASE WHEN`.

Ver o plano por conceito em `MASTER_CONTEXT.md`.

Importante: nao resolver este exercicio neste arquivo. Ele deve ser conduzido pela metodologia do `LEARNING_PROTOCOL.md`.

## Pendencias antes de avancar muito

- Registrar o resultado do exercicio 12 (pessoas diferentes em `customers`), com data.
- Ajustar no script o `ORDER BY` da pergunta 4 para usar a mesma contagem com `DISTINCT`.
- Verificar nulos nas chaves de relacionamento.
- Explicar com as proprias palavras a consulta da pergunta 2.
- Colocar no script a consulta das cidades com mais de 1.000 clientes (perguntas 1 e 2 ja estao no script desde 2026-11-10).

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

### 2026-11-11 - Arquivo certo no pgAdmin

Em 2026-11-16 o arquivo certo foi definido de vez: as consultas foram copiadas da aba `ç.sql` para a aba aberta pelo Open File do arquivo do projeto.

O pgAdmin estava salvando no arquivo antigo `ç.sql` (pasta Downloads). Combinado: usar Save As para o arquivo do projeto e abrir sempre pelo Open File da pasta `OneDrive\Documentos\projeto-sql-olist\`.

### 2026-11-16 - GitHub conectado ao Claude

O GitHub foi conectado ao Claude com acesso **somente** ao repositorio `projeto-sql-olist` (os outros repositorios, inclusive de trabalho, ficam inacessiveis). Novo fluxo: o Claude atualiza `docs/` e faz commit e push direto; a estudante roda `git pull` na pasta do projeto antes de enviar o `.sql` (`git add`, `git commit`, `git push`).

Aprendizado: `git pull` precisa ser rodado dentro da pasta do repositorio; sem o `pull`, o `push` e recusado quando o GitHub tem commits novos.

## Uso de IA no projeto

- A estudante usa IA (Claude e Gemini) como professora e revisora.
- O que nao se terceiriza: validar os numeros e interpretar o negocio.
- O README tera uma secao "Como usei IA no projeto".

## Quando e como atualizar este arquivo

Atualizar ao final de toda sessao de estudo, depois da confirmacao da estudante. Registrar exercicios praticados, erros cometidos, conceitos que melhoraram, conceitos ainda frageis, uso da palavra `entrega` e o proximo exercicio. Nao marcar um fundamento como consolidado apenas porque a consulta executou sem erro.
