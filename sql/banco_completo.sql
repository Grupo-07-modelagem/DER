-- ============================================================
-- Banco de dados da Conectados na moda
-- ============================================================

CREATE DATABASE IF NOT EXISTS conectados_na_moda;
USE conectados_na_moda;

DROP TABLE IF EXISTS troca_devolucao, parcela, item_venda, venda, produto,
    fornecedor_representante, representante, fornecedor, colaborador, cliente;

-- ------------------------------------------------------------
-- TABELAS COM SEUS CHECKS
-- ------------------------------------------------------------

CREATE TABLE cliente (
    id_cliente          INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome                VARCHAR(120) NOT NULL,
    telefone            VARCHAR(20),
    data_nascimento     DATE,
    limite_credito      NUMERIC(10,2) NOT NULL DEFAULT 0,
    situacao_crediario  VARCHAR(10) NOT NULL DEFAULT 'liberado',
    cpf                 VARCHAR(11),
    
    CONSTRAINT uk_cliente_telefone UNIQUE (telefone),
    CONSTRAINT uk_cliente_cpf UNIQUE (cpf),
    CONSTRAINT ck_cliente_limite_credito CHECK (limite_credito >= 0),
    CONSTRAINT ck_cliente_situacao CHECK (situacao_crediario IN ('liberado', 'restrito')),
    CONSTRAINT ck_cliente_cpf_obrigatorio CHECK (limite_credito = 0 OR cpf IS NOT NULL)
);

CREATE TABLE colaborador (
    id_colaborador  INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    tipo            VARCHAR(12) NOT NULL,
    
    CONSTRAINT ck_colaborador_tipo CHECK (tipo IN ('dona', 'freelancer'))
);

CREATE TABLE fornecedor (
    id_fornecedor   INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    cnpj            VARCHAR(18) NOT NULL,
    
    CONSTRAINT uk_fornecedor_cnpj UNIQUE (cnpj)
);

CREATE TABLE representante (
    id_representante    INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome                VARCHAR(120) NOT NULL,
    telefone            VARCHAR(20),
    cnpj                VARCHAR(18),
    
    CONSTRAINT uk_representante_cnpj UNIQUE (cnpj)
);

CREATE TABLE fornecedor_representante (
    id_fornecedor       INTEGER NOT NULL,
    id_representante    INTEGER NOT NULL,
    PRIMARY KEY (id_fornecedor, id_representante),
    CONSTRAINT fk_fr_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor (id_fornecedor) ON DELETE RESTRICT,
    CONSTRAINT fk_fr_representante FOREIGN KEY (id_representante)
        REFERENCES representante (id_representante) ON DELETE RESTRICT
);

CREATE TABLE produto (
    id_produto          INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor       INTEGER NOT NULL,
    descricao           VARCHAR(160) NOT NULL,
    categoria           VARCHAR(10) NOT NULL,
    tamanho             VARCHAR(10),
    cor                 VARCHAR(40),
    colecao             VARCHAR(10),
    preco_custo         NUMERIC(10,2) NOT NULL,
    preco_venda         NUMERIC(10,2) NOT NULL,
    quantidade_estoque  INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT ck_produto_categoria CHECK (categoria IN ('roupa', 'acessorio')),
    CONSTRAINT ck_produto_tamanho_dominio CHECK (tamanho IN (
        'P', 'M', 'G', '1', '2', '3', '4', '5', '6', '7', 
        '8', '9', '10', '12', '14', '16', '18', '20'
    )),
    CONSTRAINT ck_produto_colecao CHECK (colecao IN ('primavera', 'verao', 'outono', 'inverno')),
    CONSTRAINT ck_produto_preco_custo CHECK (preco_custo >= 0),
    CONSTRAINT ck_produto_preco_venda CHECK (preco_venda >= 0),
    CONSTRAINT ck_produto_estoque CHECK (quantidade_estoque >= 0),
    CONSTRAINT ck_produto_caracteristicas CHECK (
        (categoria = 'roupa' AND tamanho IS NOT NULL AND cor IS NOT NULL)
        OR
        (categoria = 'acessorio' AND cor IS NOT NULL)
    ),
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor (id_fornecedor) ON DELETE RESTRICT
);

CREATE TABLE venda (
    id_venda                INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_cliente              INTEGER NOT NULL,
    id_colaborador          INTEGER NOT NULL,
    data_hora               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    canal                   VARCHAR(20) NOT NULL, -- Aumentado o VARCHAR para suportar os termos longos
    forma_pagamento         VARCHAR(12) NOT NULL,
    tipo_entrega            VARCHAR(10) NOT NULL,
    percentual_desconto     NUMERIC(5,2) NOT NULL DEFAULT 0,
    data_hora_cancelamento  TIMESTAMP,

    CONSTRAINT ck_venda_canal CHECK (canal IN ('loja fisica', 'instagram', 'whatsapp business')),
    CONSTRAINT ck_venda_pagamento CHECK (forma_pagamento IN ('dinheiro', 'cartao', 'pix', 'crediario')),
    CONSTRAINT ck_venda_entrega CHECK (tipo_entrega IN ('retirada', 'uber')),
    CONSTRAINT ck_venda_desconto CHECK (percentual_desconto BETWEEN 0 AND 100),
    CONSTRAINT ck_cancelamento_24h CHECK (
        data_hora_cancelamento IS NULL OR
        (data_hora_cancelamento >= data_hora AND
         data_hora_cancelamento <= DATE_ADD(data_hora, INTERVAL 24 HOUR))
    ),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_venda_colaborador FOREIGN KEY (id_colaborador)
        REFERENCES colaborador (id_colaborador) ON DELETE RESTRICT
);

CREATE TABLE item_venda (
    id_venda        INTEGER NOT NULL,
    id_produto      INTEGER NOT NULL,
    quantidade      INTEGER NOT NULL DEFAULT 1,
    preco_unitario  NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),

    CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_item_preco CHECK (preco_unitario >= 0),
    CONSTRAINT fk_item_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda) ON DELETE RESTRICT,
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto) ON DELETE RESTRICT
);

CREATE TABLE parcela (
    id_venda        INTEGER NOT NULL,
    numero_parcela  SMALLINT NOT NULL,
    valor_parcela   NUMERIC(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento  DATE,
    PRIMARY KEY (id_venda, numero_parcela),

    CONSTRAINT ck_parcela_numero CHECK (numero_parcela BETWEEN 1 AND 4),
    CONSTRAINT ck_parcela_valor CHECK (valor_parcela > 0),
    CONSTRAINT fk_parcela_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda) ON DELETE RESTRICT
);

CREATE TABLE troca_devolucao (
    id_troca        INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_venda        INTEGER NOT NULL,
    id_produto      INTEGER NOT NULL,
    id_colaborador  INTEGER NOT NULL,
    tipo            VARCHAR(10) NOT NULL,
    quantidade      INTEGER NOT NULL DEFAULT 1,
    data_hora       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_troca_tipo CHECK (tipo IN ('troca', 'devolucao')),
    CONSTRAINT ck_troca_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_troca_item FOREIGN KEY (id_venda, id_produto)
        REFERENCES item_venda (id_venda, id_produto) ON DELETE RESTRICT,
    CONSTRAINT fk_troca_colaborador FOREIGN KEY (id_colaborador)
        REFERENCES colaborador (id_colaborador) ON DELETE RESTRICT
);





