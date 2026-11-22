# Estilo SQL e Validacao

Este arquivo define convencoes de escrita e um roteiro minimo de validacao para consultas SQL do projeto Olist.

## Convencoes de escrita

- Escrever palavras-chave SQL em maiusculas: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`.
- Usar uma coluna por linha em consultas com mais de uma coluna.
- Usar aliases claros para tabelas quando houver relacionamento.
- Usar aliases descritivos para metricas.
- Evitar `SELECT *` em consultas finais.
- Ordenar resultados finais por uma coluna que ajude a interpretar a pergunta.
- Usar comentarios para separar blocos de estudo ou explicar uma regra de negocio.
- Preferir clareza a compactacao.

Exemplo de formato:

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

## Como o SQL executa uma consulta (ordem logica)

A ordem em que se escreve nao e a ordem em que o banco executa. Para entender o resultado, ler a consulta nesta ordem:

1. `FROM` e `JOIN`: monta a tabela de trabalho, juntando as tabelas.
2. `WHERE`: descarta linhas, uma a uma. Ainda nao existe nenhuma conta.
3. `GROUP BY`: separa as linhas que sobraram em grupos ("sacos").
4. `HAVING`: descarta grupos, usando as contas de cada grupo.
5. `SELECT`: calcula as colunas e as agregacoes (`COUNT`, `SUM`, `AVG`) de cada grupo.
6. `ORDER BY`: ordena o resultado.
7. `LIMIT`: corta a quantidade de linhas mostradas.

Consequencias praticas:

- Agregacao sem `GROUP BY` trata a tabela inteira como um grupo e devolve uma linha.
- Com `GROUP BY`, o resultado tem uma linha por grupo. `COUNT(*)` conta as linhas que entraram em cada grupo, nao as linhas do resultado final.
- `WHERE` nao enxerga contas; condicao sobre contagem vai no `HAVING`.
- Condicao sobre cada linha -> `WHERE`. Condicao sobre cada grupo ("este pedido tem so 1 pagamento?") -> `GROUP BY` + `HAVING`.
- `DISTINCT` dentro do `COUNT` age dentro de cada grupo, separadamente.
- Uma coluna pode filtrar no `WHERE` sem aparecer no `SELECT`.
- Coluna no `SELECT` fora de agregacao precisa estar no `GROUP BY`.
- `JOIN` sozinho e `INNER JOIN`.

## Escolher `INNER` ou `LEFT JOIN`

1. Colocar no `FROM` a tabela que tem o que se procura (o assunto da pergunta).
2. Perguntar: "se um registro dela nao tiver par na outra tabela, ele precisa continuar no resultado?" Nao -> `INNER JOIN`. Sim -> `LEFT JOIN`.
3. Para achar o que falta (anti join): `LEFT JOIN` + `WHERE <coluna da tabela da direita> IS NULL`. O nulo nao existe nos dados: ele e criado pelo `LEFT JOIN` quando nao ha par. Preferir a chave da juncao (ex.: `p.order_id`), que so fica nula quando nao ha par.

## Quando usar subconsulta

Quando e preciso fazer uma segunda etapa em cima do resultado de uma consulta. Exemplo: o `GROUP BY` + `HAVING` gera uma lista de pedidos; para saber quantos sao, a lista vai entre parenteses no `FROM` de outra consulta que conta as linhas:

```sql
SELECT COUNT(*) AS total
FROM (
    SELECT order_id
    FROM ecommerce.order_payments
    GROUP BY order_id
    HAVING COUNT(*) = 1
) AS lista;
```

A consulta de fora so enxerga as colunas que a de dentro mostra no `SELECT`. Para `COUNT(*)` por fora, qualquer coluna serve; para `COUNT(DISTINCT x)` por fora, a de dentro precisa mostrar `x`.

## Medias em tabelas 1:N

`AVG(coluna)` divide pelo numero de linhas. Se a tabela tem varias linhas por pedido (pagamentos, itens), `AVG` vira media por linha, nao por pedido. Media por pedido: `SUM(valor) / COUNT(DISTINCT order_id)`. Nao existe agregacao dentro de agregacao (`AVG(SUM(...))` da erro).

## Aliases

Aliases devem ajudar a leitura.

Boas praticas:

- `quantidade_pedidos` para contagem de pedidos;
- `clientes_unicos` para `COUNT(DISTINCT customer_unique_id)`;
- `estado` para `customer_state`;
- `total_pedidos` quando a metrica realmente representa pedidos.

Evitar aliases que descrevem a coluna original, mas nao a metrica. Exemplo: `cliente_unico` nao e um bom nome para uma contagem de linhas por cliente.

## Uso de `DISTINCT`

Antes de usar `DISTINCT`, perguntar:

- Estou contando valores unicos ou tentando remover duplicidade que nao entendi?
- A coluna contada representa uma chave?
- O join pode ter multiplicado linhas?
- A granularidade da tabela esta clara?

Regra pratica: `DISTINCT` nao deve ser usado para esconder um relacionamento incorreto.

## Validacao antes de relacionamentos

Antes de fazer um join importante, verificar:

- qual e a granularidade de cada tabela;
- qual coluna liga uma tabela a outra;
- se a chave usada no relacionamento possui nulos;
- se a chave usada deveria ser unica em alguma das tabelas;
- a quantidade de registros de cada tabela;
- se a pergunta exige pedidos, pessoas, produtos, pagamentos ou outro nivel de analise.

## Validacao depois de relacionamentos

Depois de fazer um join importante, conferir:

- se a quantidade de linhas aumentou, diminuiu ou permaneceu como esperado;
- se houve perda de registros por causa de `INNER JOIN`;
- se um relacionamento 1:N multiplicou linhas;
- se a metrica ainda representa o que o alias diz representar;
- se `COUNT(*)`, `COUNT(campo)` ou `COUNT(DISTINCT campo)` faz sentido para a pergunta.

## Como detectar duplicacao

Sinais de possivel duplicacao:

- total de linhas maior que o esperado depois do join;
- uma chave que deveria aparecer uma vez passa a aparecer varias;
- a soma de pedidos, clientes ou valores fica maior do que antes do relacionamento;
- `DISTINCT` muda muito o resultado sem explicacao clara;
- a tabela relacionada tem mais de uma linha para a chave usada.

O caminho correto e entender a causa da duplicacao antes de corrigir a consulta.

## Como tratar nulos

Pontos de atencao:

- `COUNT(*)` conta linhas, mesmo com campos nulos.
- `COUNT(campo)` ignora valores nulos naquele campo.
- `COUNT(DISTINCT campo)` conta valores diferentes e nao nulos.
- Nulos em chaves de relacionamento podem fazer registros ficarem sem par.
- Nulos em campos de analise podem alterar a interpretacao de indicadores.

Antes de usar uma coluna em metrica ou relacionamento, verificar se ha nulos quando isso puder afetar a resposta.

## Tipos de consulta no projeto

- Consulta exploratoria: usada para entender os dados.
- Consulta de validacao: usada para conferir granularidade, nulos, duplicidades e efeito de joins.
- Consulta analitica: responde uma pergunta de negocio.
- View analitica: logica validada e reutilizavel, pronta para alimentar analises ou dashboards.

## Quando uma logica pode virar view

Uma consulta pode virar view quando:

- responde uma necessidade recorrente;
- ja teve granularidade validada;
- tem regras de negocio claras;
- passou por verificacoes de nulos, duplicidades e joins;
- possui nomes de colunas compreensiveis;
- nao depende de resultado temporario sem documentacao.

## Quando e como atualizar este arquivo

Atualizar quando uma nova convencao de escrita for adotada, quando surgir uma nova regra de validacao ou quando um erro recorrente mostrar que o roteiro precisa ficar mais claro. Nao registrar exercicios aqui; usar `PROGRESS_TRACKER.md`.
