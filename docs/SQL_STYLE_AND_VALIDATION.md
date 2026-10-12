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
