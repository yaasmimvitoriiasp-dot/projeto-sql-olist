# Mapa de Dados

Este arquivo registra o entendimento das tabelas usadas no projeto Olist. Nenhuma tabela nova deve ser usada em analise antes de entrar aqui.

Regra central: registrar como confirmado apenas o que foi verificado por consulta executada pela estudante. O que ainda nao foi verificado deve ficar como pendente.

Ultima atualizacao: 2026-11-10.

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

O 1:1 entre `customer_id` e `order_id` e uma hipotese apoiada pela contagem igual das duas tabelas (99.441). Validacao formal pendente.

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

Pendente: registrar o resultado do exercicio 10 (unicidade de `customer_id`) com data.

### Qualidade

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| `customer_zip_code_prefix` como numero | Zeros a esquerda perdidos (ex.: 1151 em vez de 01151) | 2026-11-02 | Registrado; nao afeta as analises atuais |
| Duplicidade em `customer_unique_id` | Existe, por desenho (pessoa com varios pedidos) | 2026-11-02 | Confirmado |
| Unicidade de `customer_id` | Consulta feita (exercicio 10), resultado nao registrado | - | Pendente |
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

Hipotese: uma linha por pedido. Validacao de unicidade de `order_id` pendente.

### Chaves e relacionamentos

| Coluna | Papel | Status |
|---|---|---|
| `order_id` | identificador do pedido; liga com `order_items`, `order_payments`, `order_reviews` | Usado em `JOIN` com `order_payments` (2026-11-10); unicidade pendente |
| `customer_id` | liga com `customers.customer_id` | Usado em `JOIN` (2026-10-12 e 2026-11-10) |

### Qualidade

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| Pedidos sem `order_delivered_customer_date` | shipped 1.107, canceled 619, unavailable 609, invoiced 314, processing 301, delivered 8, created 5, approved 2 | 2026-11-04 | Registrado |
| Pedidos `delivered` sem data de entrega | 8 | 2026-11-04 | Inconsistencia. Excluir da analise de atraso |
| Unicidade de `order_id` | Nao verificado | - | Pendente |

Regra para analise de atraso: usar apenas pedidos com `order_status = 'delivered'` e `order_delivered_customer_date` preenchida.

## `ecommerce.order_items`

Colunas criadas em 2026-11-03: `order_id` varchar(32), `order_item_id` integer, `product_id` varchar(32), `seller_id` varchar(32), `shipping_limit_date` timestamp, `price` numeric(10,2), `freight_value` numeric(10,2).

Granularidade (hipotese): uma linha por item de pedido; chave = `order_id` + `order_item_id`. Um pedido pode ter varios itens.

Risco em `JOIN`: relacionamento 1:N com `orders`. Somar valores de pedido depois de juntar com `order_items` pode multiplicar linhas.

Pendente: validar granularidade e nulos.

## `ecommerce.order_payments`

Colunas criadas em 2026-11-03: `order_id` varchar(32), `payment_sequential` integer, `payment_type` varchar(30), `payment_installments` integer, `payment_value` numeric(10,2).

Granularidade (hipotese): uma linha por pagamento de um pedido; chave = `order_id` + `payment_sequential`. Um pedido pode ter varios pagamentos (ex.: cartao + voucher).

Uso: faturamento por estado com `SUM(payment_value)` (2026-11-10). Somar todos os pagamentos de um pedido da o total pago; contar linhas aqui nao e o mesmo que contar pedidos.

Pendente: validar quantos pedidos tem mais de um pagamento.

## `ecommerce.order_reviews`

Colunas criadas em 2026-11-03: `review_id` varchar(32), `order_id` varchar(32), `review_score` integer, `review_comment_title` text, `review_comment_message` text, `review_creation_date` timestamp, `review_answer_timestamp` timestamp.

Granularidade (hipotese): uma linha por avaliacao. Pendente: verificar se um pedido pode ter mais de uma avaliacao e se `review_id` se repete.

## `ecommerce.products`

Colunas criadas em 2026-11-03: `product_id` varchar(32), `product_category_name` varchar(100), `product_name_lenght`, `product_description_lenght`, `product_photos_qty`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm` (todas integer). A grafia `lenght` vem do arquivo original.

Granularidade (hipotese): uma linha por produto. Pendente: unicidade de `product_id` e nulos em `product_category_name`.

## Pendencias de verificacao

- Registrar resultado da unicidade de `customers.customer_id` (exercicio 10).
- Validar se `orders.order_id` e unico.
- Validar granularidade de `order_items`, `order_payments`, `order_reviews` e `products`.
- Verificar nulos nas colunas de relacionamento.
- Registrar a data da contagem de `customers` e `orders`.

## Quando e como atualizar este arquivo

Atualizar sempre que uma tabela for importada, quando uma verificacao de nulos/duplicidades for feita, quando uma regra de relacionamento for confirmada ou quando a granularidade de uma tabela for compreendida. Todo numero deve ter data de leitura e deve ter sido obtido por consulta executada pela estudante.
