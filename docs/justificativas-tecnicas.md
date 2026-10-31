# Justificativas Técnicas

## 1. CLIENTE

A entidade CLIENTE existe porque a loja cadastra seus clientes e consulta seu histórico de compras e informações do crediário.

## 2. COLABORADOR

A entidade COLABORADOR representa a Dona e os freelancers que participam das vendas e das trocas. Assim podemos saber quem realizou cada operação.

## 3. PRODUTO

PRODUTO guarda as informações das peças que a loja vende. Tamanho e cor ficam como atributos porque são características do produto.

## 4. ITEM_VENDA

VENDA e PRODUTO possuem uma relação de muitos para muitos, porque uma venda pode ter vários produtos e um produto pode aparecer em várias vendas. Por isso foi criada a entidade associativa ITEM_VENDA. Ela também guarda quantidade e preço do produto na venda.

## 5. FORNECEDOR e REPRESENTANTE

Os dois foram separados porque a fábrica/fornecedor e o representante são pessoas ou empresas diferentes no processo de compra da loja.

## 6. PARCELA

PARCELA foi colocada como entidade fraca porque depende de VENDA para ser identificada. O número da parcela sozinho não identifica uma parcela de forma geral.

## 7. TROCA_DEVOLUCAO

A entidade TROCA_DEVOLUCAO registra quando um produto vendido volta para a loja. Ela fica ligada ao ITEM_VENDA para mostrar qual produto foi trocado ou devolvido.

## 8. Cardinalidades

As cardinalidades foram escolhidas com base nas regras informadas pela loja e analisadas nos dois sentidos. Por exemplo, uma venda sempre está ligada a um cliente, mas um cliente pode ter várias vendas.

## 9. Estoque

O estoque foi colocado como quantidade dentro de PRODUTO porque o projeto considera o estoque da loja física e a informação principal é a quantidade disponível.

## 10. Identificadores

Foi usado um identificador para cada entidade para facilitar a identificação dos registros. A definição de PK e FK será detalhada na etapa do modelo lógico.

## 11. O que mudou da primeira entrega

O modelo conceitual foi preservado, mas foi detalhado para permitir a
implementação. A relação N:N entre `FORNECEDOR` e `REPRESENTANTE` passou a
ter a tabela associativa `FORNECEDOR_REPRESENTANTE`, com chave composta. No
mesmo sentido, `ITEM_VENDA` e `PARCELA` receberam suas chaves compostas
explicitadas no modelo lógico.

Também foram acrescentadas restrições de domínio, valores obrigatórios,
valores monetários não negativos, estoque não negativo, limite de quatro
parcelas e cancelamento em até 24 horas. Essas regras não estavam expressas
com precisão no nível conceitual e agora são verificadas pelo banco.

O preço unitário foi mantido em `ITEM_VENDA`, mesmo existindo
`preco_venda` em `PRODUTO`, porque representa o valor histórico da negociação.
Isso evita que uma alteração no preço atual mude o histórico de uma venda.

O dicionário agora possui, além da descrição conceitual, tipos, chaves,
restrições e relacionamentos físicos. A massa de dados e as consultas de
operação e auditoria foram reunidas no script SQL para que o modelo possa ser
testado.
