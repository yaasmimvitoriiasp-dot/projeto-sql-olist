# Mapa de Dados

Este arquivo registra o entendimento das tabelas usadas no projeto Olist. Nenhuma tabela nova deve ser usada em analise antes de entrar aqui.

Regra central: registrar como confirmado apenas o que foi verificado por consulta executada pela estudante. O que ainda nao foi verificado deve ficar como pendente.

Ultima atualizacao: 2026-11-18.

## Visao geral

- Banco: `projeto_ecommerce` (PostgreSQL 18).
- Schema: `ecommerce`.
- Fonte: base publica Olist obtida pelo Kaggle ("Brazilian E-Commerce Public Dataset by Olist").
- Pasta local dos CSVs: `Downloads\dados_olist\archive (1)\` (fora do repositorio).

| Tabela | Linhas | Data da contagem | Uso |
|---|---|---|---|
| `customers` | 99.441 | contagem inicial, sem data | clientes e localizacao |
| `orders` | 99.441 | contagem inicial, sem data | pedidos, status e datas |
| `order_items` | 112.650 | 2026-11-03 | itens de cada pedido, preco e frete |
| `order_payments` | 103.886 | 2026-11-03 | pagamentos de cada pedido |
| `order_reviews` | 99.224 | 2026-11-03 | avaliacoes dos pedidos |
| `products` | 32.951 | 2026-11-03 | produtos e categorias |

Nao importadas (nao necessarias por enquanto): `sellers`, `geolocation`, `product_category_name_translation`.

## Modelo de relacionamento

```text
pessoa (customer_unique_id) 1 --- N customer_id 1 --- 1 pedido (order_id)
                                                          |
                                     order_items (N) -----+----- order_payments (N)
                                                          |
                                                   order_reviews
order_items.product_id --- products.product_id
```

Confirmado em 2026-11-11: `order_id` e unico em `orders` e `customer_id` e unico em `customers` (99.441 linhas e 99.441 valores distintos em cada). Com as duas tabelas do mesmo tamanho, o 1:1 entre `customer_id` e pedido e consistente. Ainda nao verificado: se cada `customer_id` aparece uma unica vez em `orders`.

Ausencias encontradas com `LEFT JOIN` (2026-11-17):

| Verificacao | Resultado |
|---|---|
| Pedidos sem avaliacao | 768 (delivered 646, shipped 75, canceled 20, unavailable 14, processing 6, invoiced 5, created 2) |
| Pedidos sem nenhum item | 775 |
| Produtos da `products` nunca vendidos | 0 |
| Pedidos entregues sem pagamento | 1: `bfbd0f9bdef84302105ad712db648a6c` |

Pagamentos por pedido (2026-11-18): 96.479 pedidos com 1 pagamento + 2.961 com mais de 1 + 1 sem pagamento = 99.441.

Alerta de duplicacao (2026-11-11): 2.961 pedidos tem mais de uma linha em `order_payments` e 9.803 pedidos tem mais de uma linha em `order_items`. Juntar `order_items` e `order_payments` na mesma consulta multiplica linhas (ex.: 2 itens x 2 pagamentos = 4 linhas) e infla somas.

## `ecommerce.customers`

### Colunas e tipos (confirmado em 2026-11-02 via `information_schema.columns`)

| Coluna | Tipo |
|---|---|
| `customer_id` | varchar(32), not null |
| `customer_unique_id` | varchar(32) |
| `customer_zip_code_prefix` | integer |
| `customer_city` | varchar(100) |
| `customer_state` | char(2) |

### Granularidade

Uma linha por `customer_id`. Cada pedido gera um `customer_id` novo, entao a mesma pessoa (`customer_unique_id`) aparece em varias linhas quando compra mais de uma vez.

Evidencia da estudante: em SP ha 41.746 registros para 40.302 pessoas unicas (2026-11-02); a pessoa com mais registros tem 17 (2026-11-03).

Confirmado em 2026-11-11: `customer_id` e unico (99.441 linhas, 99.441 distintos).

### Qualidade

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| `customer_zip_code_prefix` como numero | Zeros a esquerda perdidos (ex.: 1151 em vez de 01151) | 2026-11-02 | Registrado; nao afeta as analises atuais |
| Duplicidade em `customer_unique_id` | Existe, por desenho (pessoa com varios pedidos) | 2026-11-02 | Confirmado |
| Unicidade de `customer_id` | 99.441 linhas, 99.441 distintos | 2026-11-11 | Confirmado |
| Nulos em `customer_id` | Coluna definida como not null | 2026-11-02 | Ok |
| Nulos em `customer_unique_id` e `customer_state` | Nao verificado | - | Pendente |

## `ecommerce.orders`

### Colunas e tipos (confirmado em 2026-11-02)

| Coluna | Tipo |
|---|---|
| `order_id` | varchar |
| `customer_id` | varchar |
| `order_status` | varchar |
| `order_purchase_timestamp` | timestamp |
| `order_approved_at` | timestamp |
| `order_delivered_carrier_date` | timestamp |
| `order_delivered_customer_date` | timestamp |
| `order_estimated_delivery_date` | timestamp |

### Granularidade

Uma linha por pedido. Confirmado em 2026-11-11: 99.441 linhas e 99.441 `order_id` distintos.

### Chaves e relacionamentos

| Coluna | Papel | Status |
|---|---|---|
| `order_id` | identificador do pedido; liga com `order_items`, `order_payments`, `order_reviews` | Unico (2026-11-11); usado em `JOIN` com `order_payments` (2026-11-10) |
| `customer_id` | liga com `customers.customer_id` | Usado em `JOIN` (2026-10-12 e 2026-11-10) |

### Qualidade

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| Pedidos sem `order_delivered_customer_date` | shipped 1.107, canceled 619, unavailable 609, invoiced 314, processing 301, delivered 8, created 5, approved 2 | 2026-11-04 | Registrado |
| Pedidos `delivered` sem data de entrega | 8 | 2026-11-04 | Inconsistencia. Excluir da analise de atraso |
| Unicidade de `order_id` | 99.441 linhas, 99.441 distintos | 2026-11-11 | Confirmado |

Regra para analise de atraso: usar apenas pedidos com `order_status = 'delivered'` e `order_delivered_customer_date` preenchida.

## `ecommerce.order_items`

Colunas criadas em 2026-11-03: `order_id` varchar(32), `order_item_id` integer, `product_id` varchar(32), `seller_id` varchar(32), `shipping_limit_date` timestamp, `price` numeric(10,2), `freight_value` numeric(10,2).

Granularidade (hipotese): uma linha por item de pedido; chave = `order_id` + `order_item_id`. Um pedido pode ter varios itens.

Risco em `JOIN`: relacionamento 1:N com `orders`. Somar valores de pedido depois de juntar com `order_items` pode multiplicar linhas.

Confirmado em 2026-11-11: 9.803 pedidos aparecem mais de uma vez (tem mais de um item).

Pendente: validar a chave `order_id` + `order_item_id` e nulos.

## `ecommerce.order_payments`

Colunas criadas em 2026-11-03: `order_id` varchar(32), `payment_sequential` integer, `payment_type` varchar(30), `payment_installments` integer, `payment_value` numeric(10,2).

Granularidade (hipotese): uma linha por pagamento de um pedido; chave = `order_id` + `payment_sequential`. Um pedido pode ter varios pagamentos (ex.: cartao + voucher).

Uso: faturamento por estado com `SUM(payment_value)` (2026-11-10). Somar todos os pagamentos de um pedido da o total pago; contar linhas aqui nao e o mesmo que contar pedidos.

Confirmado em 2026-11-11: 2.961 pedidos aparecem mais de uma vez (tem mais de um pagamento).

Confirmado em 2026-11-18: o mesmo pedido pode ter varias linhas da **mesma** forma de pagamento (ex.: `fa65dad1b0e818e3ccc5cb0e39231352` com 29 linhas de voucher). Para contar pedidos por forma de pagamento, usar `COUNT(DISTINCT order_id)`. Formas: credit_card, boleto, voucher, debit_card, not_defined (3 pedidos).

Um pedido entregue nao tem nenhuma linha nesta tabela (`bfbd0f9bdef84302105ad712db648a6c`); um `INNER JOIN` com `order_payments` o descarta.

## `ecommerce.order_reviews`

Colunas criadas em 2026-11-03: `review_id` varchar(32), `order_id` varchar(32), `review_score` integer, `review_comment_title` text, `review_comment_message` text, `review_creation_date` timestamp, `review_answer_timestamp` timestamp.

Granularidade (hipotese): uma linha por avaliacao. 99.224 linhas; 768 pedidos nao tem avaliacao (2026-11-17).

Indicio de duplicacao: `orders LEFT JOIN order_reviews` deu 99.992 linhas, mais que os 99.441 pedidos. Isso sugere que alguns pedidos tem mais de uma avaliacao. Pendente: quantificar antes da pergunta 5 (nota da avaliacao).

## `ecommerce.products`

Colunas criadas em 2026-11-03: `product_id` varchar(32), `product_category_name` varchar(100), `product_name_lenght`, `product_description_lenght`, `product_photos_qty`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm` (todas integer). A grafia `lenght` vem do arquivo original.

Granularidade (hipotese): uma linha por produto. Todo produto aparece em pelo menos um item vendido (2026-11-17). Pendente: unicidade de `product_id` e nulos em `product_category_name`.

## Pendencias de verificacao

- Verificar se cada `customer_id` aparece uma unica vez em `orders`.
- Validar a chave composta de `order_items` (`order_id` + `order_item_id`) e de `order_payments` (`order_id` + `payment_sequential`).
- Validar granularidade de `order_reviews` e `products`.
- Verificar nulos nas colunas de relacionamento.
- Registrar a data da contagem de `customers` e `orders`.

## Quando e como atualizar este arquivo

Atualizar sempre que uma tabela for importada, quando uma verificacao de nulos/duplicidades for feita, quando uma regra de relacionamento for confirmada ou quando a granularidade de uma tabela for compreendida. Todo numero deve ter data de leitura e deve ter sido obtido por consulta executada pela estudante.
