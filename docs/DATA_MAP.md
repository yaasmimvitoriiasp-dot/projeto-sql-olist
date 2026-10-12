# Mapa de Dados

Este arquivo registra o entendimento das tabelas usadas no projeto Olist. Nesta fase, ele e o documento mais importante: nenhuma tabela nova deve ser usada em analise antes de entrar aqui.

Regra central: registrar como confirmado apenas o que foi verificado por consulta executada pela estudante. O que ainda nao foi verificado deve ficar como pendente.

## Visao geral

- Banco: `projeto_ecommerce`.
- Schema: `ecommerce`.
- Fonte: base publica Olist obtida pelo Kaggle.
- Tabelas importadas ate agora: `customers` e `orders`.
- Demais tabelas da base Olist: ainda nao importadas.

## `ecommerce.orders`

### O que ja foi confirmado

| Item | Registro |
|---|---|
| Tabela importada | Sim |
| Quantidade de registros | 99.441 |
| Data da contagem | Data ainda nao registrada na consulta original |
| Uso atual | Analises de pedidos por status e relacionamento com clientes |

### Granularidade

Pendente de documentacao formal.

Hipotese operacional atual: cada linha representa um pedido. Essa hipotese faz sentido pelo uso de `order_id`, mas precisa ser confirmada e registrada por consulta executada pela estudante antes de virar regra documentada.

### Chaves e relacionamentos

| Coluna | Papel conhecido | Status |
|---|---|---|
| `order_id` | Identificador do pedido | Informado como unico nesta tabela, mas ainda precisa de validacao registrada com data |
| `customer_id` | Chave para relacionar com `ecommerce.customers.customer_id` | Usado com sucesso em `INNER JOIN` |
| `order_status` | Status do pedido | Usado em analise de quantidade de pedidos por status |

### Nulos e duplicidades

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| Nulos em `order_id` | Nao verificado | - | Pendente |
| Duplicidade em `order_id` | Nao verificado formalmente | - | Pendente |
| Nulos em `customer_id` | Nao verificado | - | Pendente |
| Nulos em `order_status` | Nao verificado | - | Pendente |

### Observacoes

- Foi praticada a contagem de pedidos por `order_status`.
- A consulta inicial usou `COUNT(DISTINCT order_id)`, mas foi explicado que, se `order_id` for unico, `COUNT(*)` e suficiente.

## `ecommerce.customers`

### O que ja foi confirmado

| Item | Registro |
|---|---|
| Tabela importada | Sim |
| Quantidade de registros | 99.441 |
| Data da contagem | Data ainda nao registrada na consulta original |
| Uso atual | Analises por estado, clientes unicos e relacionamento com pedidos |

### Granularidade

Pendente e prioritaria.

Ainda nao esta confirmado se cada linha representa:

- um registro de cliente associado a um pedido; ou
- uma pessoa unica; ou
- outro nivel de detalhe.

Ponto importante: a analise de clientes recorrentes contou linhas em `customers` e chamou esse total de `quantidade_pedidos`. Isso so e valido se for confirmado que `customers` possui uma linha por pedido/compra. A igualdade de registros entre `customers` e `orders` sugere essa possibilidade, mas nao confirma sozinha.

### Chaves e relacionamentos

| Coluna | Papel conhecido | Status |
|---|---|---|
| `customer_id` | Identificador do registro de cliente ligado ao pedido; usado no relacionamento com `orders.customer_id` | Usado com sucesso em `INNER JOIN`, validacao formal pendente |
| `customer_unique_id` | Identifica a pessoa real e permite analisar recorrencia | Usado em `COUNT(DISTINCT)` e `GROUP BY` |
| `customer_state` | Estado do cliente | Usado em analises por estado |

### Nulos e duplicidades

| Verificacao | Resultado | Data | Status |
|---|---|---|---|
| Nulos em `customer_id` | Nao verificado | - | Pendente |
| Duplicidade em `customer_id` | Nao verificado formalmente | - | Pendente |
| Nulos em `customer_unique_id` | Nao verificado | - | Pendente |
| Duplicidade em `customer_unique_id` | Existe possibilidade logica, pois representa pessoa real que pode comprar mais de uma vez | - | Precisa quantificar |
| Nulos em `customer_state` | Nao verificado | - | Pendente |

### Observacoes

- `customer_id` e usado para relacionar `orders` com `customers`.
- `customer_unique_id` e usado para contar pessoas diferentes e identificar possiveis clientes recorrentes.
- A diferenca entre pedidos e clientes unicos nao equivale automaticamente ao numero de clientes recorrentes.

## Tabelas ainda nao importadas

As demais tabelas da base Olist ainda nao foram importadas. Elas devem ser adicionadas gradualmente, somente quando forem necessarias para uma pergunta de negocio ou para avancar o aprendizado.

Quando uma tabela nova for importada, registrar antes de usar em analise:

- nome da tabela;
- quantidade de registros e data da contagem;
- granularidade;
- chave primaria ou identificador principal;
- colunas de relacionamento;
- verificacoes de nulos;
- verificacoes de duplicidade;
- observacoes sobre risco de duplicacao em joins.

## Pendencias de verificacao

- Confirmar a granularidade de `ecommerce.customers`.
- Confirmar formalmente a granularidade de `ecommerce.orders`.
- Validar se `orders.order_id` e unico.
- Validar se `customers.customer_id` e unico.
- Verificar nulos nas colunas usadas em relacionamento.
- Registrar novamente as contagens das tabelas com data de leitura.
- Registrar verificacoes antes de considerar recorrencia como quantidade de pedidos por pessoa.

## Quando e como atualizar este arquivo

Atualizar sempre que uma tabela for importada, quando uma verificacao de nulos/duplicidades for feita, quando uma regra de relacionamento for confirmada ou quando a granularidade de uma tabela for compreendida. Todo numero deve ter data de leitura e deve ter sido obtido por consulta executada pela estudante.
