-- ============================================================
-- CONSULTAS DE AUDITORIA (RESULTADO ESPERADO: ZERO REGISTROS)
-- ============================================================

-- A. Registros que violariam o limite de parcelas
SELECT id_venda, COUNT(*) AS quantidade_parcelas
FROM parcela
GROUP BY id_venda
HAVING COUNT(*) > 4;

-- B. Itens com quantidade inválida ou estoque negativo 
-- (Unificação corrigida para bater o mesmo número de colunas no UNION)
SELECT 'ITEM_VENDA COMPROMETIDO' AS erro, id_venda AS ref_id, id_produto, quantidade AS valor_analisado 
FROM item_venda 
WHERE quantidade <= 0
UNION ALL
SELECT 'ESTOQUE NEGATIVO' AS erro, id_produto AS ref_id, NULL, quantidade_estoque AS valor_analisado
FROM produto 
WHERE quantidade_estoque < 0;

-- C. Vendas sem itens
SELECT v.id_venda, v.data_hora
FROM venda v
LEFT JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE iv.id_venda IS NULL;

-- D. Parcelas de vendas que não são de crediário
SELECT p.id_venda, v.forma_pagamento, p.numero_parcela
FROM parcela p
JOIN venda v ON v.id_venda = p.id_venda
WHERE v.forma_pagamento <> 'crediario';

-- E. Trocas/devoluções acima da quantidade vendida
SELECT td.id_troca, td.id_venda, td.id_produto, td.quantidade AS qtd_devolvida,
       iv.quantidade AS quantidade_vendida
FROM troca_devolucao td
JOIN item_venda iv ON iv.id_venda = td.id_venda AND iv.id_produto = td.id_produto
WHERE td.quantidade > iv.quantidade;