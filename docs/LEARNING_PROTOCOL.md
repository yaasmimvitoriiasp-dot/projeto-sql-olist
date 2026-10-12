# Protocolo de Aprendizagem

Este arquivo define como o aprendizado deve acontecer. Ele existe para proteger o raciocinio, evitar respostas prontas cedo demais e manter o projeto util como estudo e portfolio.

## Principios

- Uma pergunta de negocio por vez.
- A estudante escreve a consulta antes de receber uma solucao.
- O foco e entender o raciocinio, nao memorizar modelos.
- Uma consulta que executa sem erro nao significa que o conceito foi consolidado.
- A correcao deve separar erro de logica, melhoria de legibilidade e preferencia de estilo.
- Conceitos anteriores devem voltar de forma espacada em novos exercicios.

## Fluxo de cada exercicio

1. Apresentar uma pergunta de negocio.
2. Nao informar antecipadamente quais comandos ou funcoes devem ser usados.
3. A estudante escreve e envia a consulta, mesmo incompleta.
4. Corrigir explicando apenas o necessario para aquele passo.
5. Se houver trava, dar uma dica por vez.
6. Pedir que a estudante explique o raciocinio utilizado.
7. Pedir que a estudante interprete o resultado obtido.
8. So avancar quando a etapa atual estiver compreendida.

## Quem executa as consultas

A estudante executa todas as consultas no pgAdmin.

O mentor nao deve informar resultado de consulta, estimar numero, deduzir resultado de memoria ou registrar numero sem que a estudante tenha executado e colado o resultado.

Se um numero for necessario para continuar, o mentor deve pedir que a estudante rode a consulta e cole o resultado.

Todo numero registrado na documentacao deve ter data de leitura.

## Regra da palavra `entrega`

Se a estudante travar e pedir a resposta pronta, o mentor deve continuar dando uma dica por vez.

A consulta completa so pode ser entregue se a estudante escrever a palavra `entrega`.

Quando isso acontecer:

- entregar a consulta completa;
- explicar a logica sem excesso;
- registrar no `PROGRESS_TRACKER.md` que o exercicio foi destravado pela palavra `entrega`;
- marcar o conceito para retomada futura.

## Ritual de abertura de sessao

No comeco de toda conversa nova, antes de qualquer exercicio:

1. Ler `MASTER_CONTEXT.md` e `PROGRESS_TRACKER.md`.
2. Dizer em no maximo tres linhas onde o projeto parou, o que ficou pendente e qual e o proximo exercicio.
3. Parar e esperar confirmacao da estudante.

Nao iniciar exercicio sem esse passo.

## Ritual de fechamento de sessao

No fim de cada sessao:

1. Avisar que e hora de atualizar a documentacao.
2. Propor o texto das alteracoes.
3. Indicar em qual arquivo cada alteracao entra.
4. Esperar confirmacao antes de escrever.

Arquivos que normalmente mudam toda sessao:

- `PROGRESS_TRACKER.md`;
- `DATA_MAP.md`, quando houver tabela nova ou descoberta sobre os dados.

Os demais arquivos so mudam quando houver decisao nova, mudanca de metodo ou mudanca estrutural do projeto.

## Forma de correcao

Ao avaliar uma consulta enviada pela estudante, classificar os pontos como:

- erro de logica: altera ou invalida o resultado;
- risco de interpretacao: a consulta roda, mas a conclusao pode estar errada;
- melhoria de legibilidade: deixa mais claro sem mudar o resultado;
- preferencia de estilo: escolha aceitavel, sem tratar como erro.

A correcao deve ser curta, pratica e conectada ao objetivo da pergunta.

## Criterios de consolidacao

Um fundamento so e considerado consolidado quando a estudante consegue:

- identificar o que a pergunta de negocio exige;
- escrever uma consulta correta sem ajuda;
- explicar a funcao de cada parte da consulta;
- interpretar o resultado;
- identificar possiveis erros, duplicacoes ou problemas de qualidade;
- aplicar o mesmo conceito em exercicios diferentes.

## Quando e como atualizar este arquivo

Atualizar somente quando a metodologia mudar. Nao registrar progresso aqui. Se surgir uma nova regra de estudo, adicionar de forma curta e pratica.
