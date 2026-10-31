-- ============================================================
-- CONSULTAS DE OPERAÇÃO E GESTÃO
-- ============================================================

-- 1. Estoque atual
SELECT id_produto, descricao, tamanho, cor, quantidade_estoque
FROM produto
WHERE quantidade_estoque > 0
ORDER BY quantidade_estoque ASC, descricao ASC;

-- 2. Histórico de compras por cliente
SELECT c.nome AS cliente, v.id_venda, v.data_hora, p.descricao,
       iv.quantidade, iv.preco_unitario
FROM cliente c
JOIN venda v ON v.id_cliente = c.id_cliente
JOIN item_venda iv ON iv.id_venda = v.id_venda
JOIN produto p ON p.id_produto = iv.id_produto
ORDER BY c.nome ASC, v.data_hora DESC;

-- 3. Total líquido por venda
SELECT v.id_venda, c.nome AS cliente,
       ROUND(SUM(iv.quantidade * iv.preco_unitario) * (1 - v.percentual_desconto / 100), 2) AS total_liquido
FROM venda v
JOIN cliente c ON c.id_cliente = v.id_cliente
JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE v.data_hora_cancelamento IS NULL
GROUP BY v.id_venda, c.nome, v.percentual_desconto
ORDER BY v.id_venda ASC;

-- 4. Parcelas em aberto e vencidas
SELECT c.nome AS cliente, p.id_venda, p.numero_parcela,
       p.valor_parcela, p.data_vencimento
FROM parcela p
JOIN venda v ON v.id_venda = p.id_venda
JOIN cliente c ON c.id_cliente = v.id_cliente
WHERE p.data_pagamento IS NULL
ORDER BY p.data_vencimento ASC;

-- 5. Produtos mais vendidos (Agrupamento corrigido para usar a PK do produto)
SELECT p.id_produto, p.descricao, SUM(iv.quantidade) AS unidades_vendidas
FROM item_venda iv
JOIN produto p ON p.id_produto = iv.id_produto
JOIN venda v ON v.id_venda = iv.id_venda
WHERE v.data_hora_cancelamento IS NULL
GROUP BY p.id_produto, p.descricao
ORDER BY unidades_vendidas DESC;

-- 6. Exemplo seguro de UPDATE
START TRANSACTION;
UPDATE cliente
SET situacao_crediario = 'restrito'
WHERE id_cliente = 3;
ROLLBACK;

-- 7. Exemplo seguro de DELETE (O RESTRICT agirá se houver dados vinculados)
START TRANSACTION;
DELETE FROM representante WHERE id_representante = 2;
ROLLBACK;