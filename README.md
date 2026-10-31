# Projeto Integrador — Modelagem de Dados

## Sistema de apoio à gestão de uma loja de roupas infantis e juvenis

## 1. Contexto do projeto

Este documento apresenta os processos de negócio, requisitos, regras, entidades, relacionamentos e modelos de dados de um sistema de apoio à gestão de uma loja de roupas infantis e juvenis.

## 2. Caracterização da empresa

A loja analisada é uma pequena loja de roupas infantis e juvenis. Também são comercializados alguns acessórios.

Os produtos são separados por tamanho e cor. Os tamanhos informados são: baby P, M e G; infantil do 1 ao 10; e juvenil do 12 ao 20. A loja trabalha com quatro coleções no ano: primavera, verão, outono e inverno.

As vendas podem acontecer na loja física, pelo Instagram e pelo WhatsApp Business. O pagamento pode ser feito em dinheiro, cartão, Pix ou crediário. A entrega pode ser retirada na loja ou feita por Uber.

A operação conta com uma responsável pela loja e freelancers, que ajudam no atendimento e nas vendas. A responsável também cuida da parte financeira e da cobrança do crediário.

---

## 3. Justificativa da escolha

A loja foi escolhida por ser um estabelecimento real com processos que podem ser organizados por meio de um sistema de dados.

Um dos principais problemas identificados foi que algumas vendas ainda são anotadas em caderno, o que já ocasionou perdas de vendas. Também foi relatada a ocorrência de troca de nomes de clientes no sistema e dificuldade para acompanhar clientes com parcelas em atraso no crediário.

A modelagem busca organizar principalmente os dados de clientes, produtos, vendas, estoque e crediário.

---

## 4. Problemas e necessidades

| Problema | Necessidade |
|---|---|
| Vendas anotadas em caderno | Registrar as vendas no sistema |
| Troca de nomes de clientes | Identificar melhor cada cliente |
| Clientes em atraso no crediário | Controlar parcelas e situação do cliente |
| Dificuldade para acompanhar estoque | Consultar a quantidade de cada produto |

---

## 5. Processos de negócio

### PR01 — Cadastro de cliente

Cadastrar o cliente antes da compra ou durante a venda.

### PR02 — Atendimento e venda

Atender o cliente, escolher os produtos, registrar a venda, receber o pagamento e entregar ou separar o produto.

### PR03 — Controle de estoque

Atualizar o estoque quando uma venda é realizada e consultar a quantidade disponível.

### PR04 — Crediário

Registrar as parcelas, acompanhar os vencimentos e controlar os clientes que estão em atraso.

### PR05 — Troca e devolução

Registrar quando um cliente troca ou devolve um produto.

### PR06 — Compras e abastecimento

Comprar produtos para as coleções ou para reposição e cadastrar os novos produtos no sistema.

---

## 6. Requisitos funcionais

| ID | Requisito |
|---|---|
| RF01 | O sistema deverá cadastrar clientes. |
| RF02 | O sistema deverá cadastrar produtos com tamanho, cor, coleção, custo e preço. |
| RF03 | O sistema deverá registrar vendas e seus itens. |
| RF04 | O sistema deverá atualizar o estoque quando uma venda for realizada. |
| RF05 | O sistema deverá consultar o estoque disponível. |
| RF06 | O sistema deverá registrar vendas no crediário e suas parcelas. |
| RF07 | O sistema deverá registrar trocas e devoluções. |
| RF08 | O sistema deverá permitir consultar o histórico de compras do cliente. |
| RF09 | O sistema deverá cadastrar fornecedores e representantes. |

---

## 7. Requisitos não funcionais

| ID | Requisito |
|---|---|
| RNF01 | O sistema deverá ter uma interface simples para facilitar o atendimento. |
| RNF02 | O acesso às informações deverá ser controlado de acordo com o usuário. |
| RNF03 | O sistema deverá apresentar as informações de forma rápida para uso durante o atendimento. |
| RNF04 | Os dados deverão possuir cópia de segurança. |

---

## 8. Regras de negócio

1. Toda venda realizada pela loja deve ser registrada no sistema.
2. Roupas possuem tamanho e cor cadastrados separadamente.
3. Os tamanhos seguem as faixas baby, infantil e juvenil informadas pela loja.
4. A venda de um produto deve diminuir sua quantidade em estoque.
5. O estoque controlado no projeto é o da loja física.
6. O preço de venda usa como base o custo da peça multiplicado por 2,2, podendo variar conforme o produto.
7. O crediário pode ter no máximo 4 parcelas.
8. O cliente que não paga o crediário pode ficar com o crédito restringido.
9. Descontos podem ser negociados no fechamento da venda.
10. Uma venda pode ser cancelada em até 24 horas em caso de imprevisto.
11. A responsável pela loja cuida da parte financeira e da cobrança do crediário.
12. A loja trabalha com as coleções primavera, verão, outono e inverno.
13. Uma venda deve possuir pelo menos um item antes de ser finalizada.
14. O produto vendido precisa estar cadastrado e possuir estoque disponível.
15. Cada parcela pertence a uma única venda e o número da parcela fica entre 1 e 4.
16. Uma troca ou devolução só pode ser registrada para um item que pertence à venda informada.
17. O histórico de vendas não deve ser apagado; cancelamentos são registrados na própria venda.

## 9. Restrições e políticas

- O controle financeiro e a cobrança do crediário ficam com a responsável pela loja.
- O crediário possui limite para cada cliente.
- O máximo informado é de 4 parcelas.
- O cancelamento pode ocorrer em até 24 horas.
- A responsável pela loja e os freelancers podem realizar atendimento e vendas.
- A responsável pela loja e os freelancers podem realizar trocas e devoluções.
- O estoque considerado no projeto é somente o da loja física.

## 10. Fluxogramas

Foram elaborados quatro fluxogramas para representar os principais processos da loja.

### F1 — Atendimento e venda

Início → Cliente solicita atendimento → Identificar ou cadastrar cliente → Cliente escolhe os produtos → Registrar venda e itens → Forma de pagamento?

- Pagamento comum → Realizar pagamento → Efetivar venda → Atualizar estoque → Forma de entrega?
- Crediário → Seguir para F2

Na entrega:

- Retirada → Cliente leva a peça.
- Uber → Solicitar entrega por Uber.

Os dois caminhos seguem para Venda realizada → Houve imprevisto em até 24 horas?

- Sim → Cancelar venda → Devolver peça ao estoque → Fim.
- Não → Fim.

### F2 — Crediário

Início → Consultar limite e situação do crediário → Crediário liberado e dentro do limite?

- Não → Outra forma de pagamento → Fim.
- Sim → Definir número de parcelas (1 a 4) → Registrar crediário → Enviar cópia ao cliente → Acompanhar vencimentos → Parcela foi paga?

Se sim, registrar o pagamento.

Se não, a responsável pela loja cobra o cliente → Cliente pagou?

- Sim → Registrar pagamento → Continuar acompanhamento.
- Não → Restringir crediário → Anotar restrição no cadastro → Fim.

Quando todas as parcelas forem pagas ou o crediário for restringido, o processo termina.

### F3 — Troca e devolução

Início → Cliente solicita troca ou devolução → Localizar venda e item → É troca ou devolução?

- Troca → Registrar troca → Devolver peça ao estoque → Cliente escolhe outra peça → Nova venda → Fim.
- Devolução → Registrar devolução → Devolver peça ao estoque → Fim.

### F4 — Compras e abastecimento

Início → Planejamento da coleção ou reposição → Avaliar o que está faltando → Comprar por representante ou viagem?

- Representante → Comprar com a fábrica → Fábrica emite a nota fiscal → Loja recebe as peças.
- Viagem → Comprar diretamente → Loja recebe as peças.

Depois dos dois caminhos:

→ Cadastrar as peças no sistema → Estoque disponível para venda → Fim.

**Integração entre os fluxos:** F1 pode encaminhar para F2 no crediário; F3 trabalha sobre uma venda e devolve peças ao estoque; F4 abastece o estoque utilizado pelas vendas.

[Consultar os fluxogramas](docs/Fluxogramas.pdf)

## 11. Entidades

As entidades identificadas são:

- CLIENTE
- COLABORADOR
- PRODUTO
- FORNECEDOR
- REPRESENTANTE
- FORNECEDOR_REPRESENTANTE
- VENDA
- ITEM_VENDA
- PARCELA
- TROCA_DEVOLUCAO

`ITEM_VENDA` é uma entidade associativa, pois liga VENDA e PRODUTO.

`FORNECEDOR_REPRESENTANTE` é uma entidade associativa, pois liga FORNECEDOR e REPRESENTANTE.

`PARCELA` é uma entidade fraca, pois depende de VENDA para ser identificada.

## 12. Atributos

Os principais atributos de cada entidade estão no [Dicionário de Dados](docs/dicionario-de-dados.md).

Os atributos foram escolhidos para representar as informações usadas nos processos da loja.

## 13. Relacionamentos

| ID | Relacionamento |
|---|---|
| R1 | CLIENTE realiza VENDA |
| R2 | COLABORADOR registra VENDA |
| R3 | VENDA contém ITEM_VENDA e ITEM_VENDA representa PRODUTO |
| R4 | FORNECEDOR fornece PRODUTO |
| R5 | REPRESENTANTE representa FORNECEDOR |
| R6 | VENDA é parcelada em PARCELA |
| R7 | ITEM_VENDA é objeto de TROCA_DEVOLUCAO |
| R8 | COLABORADOR efetua TROCA_DEVOLUCAO |

## 14. Cardinalidades

As cardinalidades foram analisadas nos dois sentidos, de acordo com os conteúdos das aulas. A tabela completa está em [cardinalidades.md](docs/cardinalidades.md).

Exemplos:

- Um cliente pode realizar várias vendas.
- Cada venda está ligada a um cliente.
- Uma venda possui um ou mais itens.
- Um produto pode aparecer em várias vendas.
- Uma venda pode não ter parcelas ou ter de 1 a 4 parcelas.

## 15. Dicionário de dados conceitual

O dicionário foi feito em nível conceitual, com o nome do atributo, sua função e a entidade a que pertence.

[Consultar o Dicionário de Dados](docs/dicionario-de-dados.md)

## 16. Diagrama Entidade-Relacionamento

O DER representa as entidades, atributos, relacionamentos e cardinalidades levantados no projeto.

### DER conceitual

[Visualizar o DER conceitual](DER.jpg)

[Material de apoio do DER](DER.html)

### DER lógico atualizado

[Consultar o DER lógico](docs/DER-logico.md)

## 17. Justificativas técnicas

As principais decisões de modelagem são explicadas no arquivo [justificativas-tecnicas.md](docs/justificativas-tecnicas.md).

## 18. Modelo lógico e normalização

O modelo lógico apresenta as tabelas, atributos, chaves primárias e estrangeiras, chaves compostas, restrições e integridade referencial. O mesmo documento apresenta a aplicação de 1FN, 2FN e 3FN, com as dependências funcionais e as decomposições.

[Consultar o modelo lógico e a normalização](docs/modelo-logico-e-normalizacao.md)

## 19. Script SQL e massa de dados

O script principal [banco_completo.sql](sql/banco_completo.sql) centraliza a criação do banco, das tabelas, das chaves e das restrições de integridade.

A carga de testes e as consultas foram organizadas nos arquivos [massa_de_dados](sql/massa_de_dados), [consultas_de_operacao_e_gestao.sql](sql/consultas_de_operacao_e_gestao.sql) e [consultas_de_auditoria.sql](sql/consultas_de_auditoria.sql).

O ambiente-alvo informado para os scripts é MySQL 8.0.16 ou superior.

## 20. Análise de dados e possibilidades de evolução

Com os dados estruturados, a loja pode acompanhar os seguintes indicadores:

- Faturamento líquido por período, canal, colaborador e forma de pagamento.
- Ticket médio e quantidade média de itens por venda.
- Margem estimada por produto (`preco_venda - preco_custo`).
- Giro e cobertura de estoque, com alerta para produtos abaixo do mínimo.
- Taxa de troca ou devolução por produto, coleção e período.
- Parcelas em aberto, atraso do crediário e utilização do limite de cada cliente.
- Vendas por coleção, tamanho, cor e faixa etária.

Esses indicadores ajudam a decidir quando repor produtos, quais coleções priorizar, quais canais trazem mais resultado e quais clientes precisam de uma abordagem de cobrança.

Como evolução, um painel de BI pode receber uma camada de fatos de vendas e dimensões de tempo, produto, cliente, canal e colaborador. Também é possível aplicar inteligência artificial para prever a demanda por coleção e tamanho, sugerir reposição, identificar comportamentos de atraso e recomendar produtos, sempre com revisão da responsável pela loja e proteção dos dados pessoais.

## 21. Conclusão

A análise dos processos e problemas da loja permitiu identificar os principais dados que precisam ser organizados. O modelo foi montado com base nas entidades, atributos, relacionamentos e cardinalidades trabalhados na disciplina.

A entrega concentra-se em clientes, produtos, vendas, estoque, crediário, trocas e abastecimento. Esse escopo foi representado em um modelo lógico normalizado e em um script SQL correspondente. O resultado busca apoiar uma operação mais consistente e preservar o histórico necessário para decisões da loja.

## 22. Pontos de evolução técnica

O projeto relaciona os processos da loja às tabelas de venda, item, parcela, estoque e troca, permitindo representar o atendimento e o pós-venda. A normalização também busca evitar a duplicação de dados de clientes, produtos e fornecedores.

Como ponto de atenção para uma próxima etapa, a regra “uma venda precisa ter pelo menos um item” deve ser validada no fechamento da venda. Também é possível evoluir o controle de compras e entradas de estoque para registrar notas fiscais, custo por lote e histórico de movimentações. Essas melhorias ficam registradas como possibilidades futuras, sem alterar o escopo atual.