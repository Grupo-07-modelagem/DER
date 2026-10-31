# Dicionário de Dados Conceitual

Este dicionário mostra os principais atributos das entidades do projeto e para que cada um serve.

## CLIENTE

| Atributo           | Descrição                                       |
|--------------------|-------------------------------------------------|
| id_cliente         | Identificador do cliente.                       |
| nome               | Nome do cliente.                                |
| telefone           | Telefone para contato.                          |
| data_nascimento    | Data de nascimento do cliente.                  |
| limite_credito     | Limite de compra no crediário.                  |
| situacao_crediario | Informa se o cliente está liberado ou restrito. |
| CPF                | Cadastro de Pessoa Física (obrigatório se o cliente possuir limite de crédito > 0).     |


## COLABORADOR

| Atributo       | Descrição                        |
|----------------|----------------------------------|
| id_colaborador | Identificador do colaborador.    |
| nome           | Nome do colaborador.             |
| tipo           | Informa se é Dona ou freelancer. |

## FORNECEDOR

| Atributo      | Descrição                      |
|---------------|--------------------------------|
| id_fornecedor | Identificador do fornecedor.   |
| nome          | Nome da fábrica ou fornecedor. |
| cnpj          | CNPJ da empresa (Cadastro Nacional da Pessoa Jurídica).      |

## REPRESENTANTE

| Atributo         | Descrição                       |
|------------------|---------------------------------|
| id_representante | Identificador do representante. |
| nome             | Nome do representante.          |
| telefone         | Telefone para contato.          |
| cnpj            | CNPJ do representante (Cadastro de Pessoa Jurídica). |

## FORNECEDOR_REPRESENTANTE

| Atributo         | Descrição                       |
|------------------|---------------------------------|
| id_fornecedor    | Identificador do fornecedor.    |
| id_representante | Identificador do representante. |

## PRODUTO

| Atributo           | Descrição                            |
|--------------------|--------------------------------------|
| id_produto         | Identificador do produto.            |
| id_fornecedor      | Fornecedor responsável pelo produto. |
| descricao          | Descrição ou nome do produto.        |
| categoria          | Informa se é roupa ou acessório.     |
| tamanho            | Tamanho do produto.                  |
| cor                | Cor do produto.                      |
| colecao            | Coleção do produto.                  |
| preco_custo        | Valor pago pela loja.                |
| preco_venda        | Preço de venda.                      |
| quantidade_estoque | Quantidade disponível na loja.       |

## VENDA

| Atributo               | Descrição                                   |
|------------------------|---------------------------------------------|
| id_venda               | Identificador da venda.                     |
| id_cliente             | Cliente que realizou a compra.              |
| id_colaborador         | Colaborador responsável pela venda.         |
| data_hora              | Data e hora da venda.                       |
| canal                  | Local ou meio em que a venda aconteceu.     |
| forma_pagamento        | Forma usada no pagamento.                   |
| tipo_entrega           | Retirada ou entrega por Uber.               |
| percentual_desconto    | Desconto aplicado na venda.                 |
| data_hora_cancelamento | Data e hora do cancelamento, quando houver. |

## ITEM_VENDA

| Atributo       | Descrição                             |
|----------------|---------------------------------------|
| id_venda       | Venda à qual o item pertence.         |
| id_produto     | Produto vendido.                      |
| quantidade     | Quantidade do produto vendida.        |
| preco_unitario | Preço do produto no momento da venda. |

## PARCELA

| Atributo        | Descrição                        |
|-----------------|----------------------------------|
| id_venda        | Venda à qual a parcela pertence. |
| numero_parcela  | Número da parcela.               |
| valor_parcela   | Valor da parcela.                |
| data_vencimento | Data de vencimento.              |
| data_pagamento  | Data em que a parcela foi paga.  |

## TROCA_DEVOLUCAO

| Atributo       | Descrição                            |
|----------------|--------------------------------------|
| id_troca       | Identificador da troca ou devolução. |
| id_venda       | Venda original.                      |
| id_produto     | Produto envolvido na troca/devolução.|
| id_colaborador | Colaborador responsável.             |
| tipo           | Informa se é troca ou devolução.     |
| quantidade     | Quantidade de produtos envolvidos.   |
| data_hora      | Data e hora da troca ou devolução.   |

---

# Dicionário de Dados Implementado

Esta seção complementa a versão conceitual acima com o que existe no banco relacional.

## Convenções

- **PK**: chave primária.
- **FK**: chave estrangeira.
- **NN**: `NOT NULL`.
- Valores monetários usam `NUMERIC(10,2)`.
- Datas de operação usam `TIMESTAMP`; datas de nascimento, vencimento e pagamento usam `DATE`.

## Tabelas e atributos físicos

### CLIENTE

| Atributo           | Tipo             | Chave/restrição | Descrição                       |
|--------------------|------------------|-----------------|---------------------------------|
| id_cliente         | INTEGER identity | PK              | Identificador único do cliente. |
| nome               | VARCHAR(120)     | NN              | Nome usado no atendimento.      |
| telefone           | VARCHAR(20)      | UNIQUE          | Telefone para contato.          |
| data_nascimento    | DATE             | —               | Data de nascimento.             |
| limite_credito     | NUMERIC(10,2)    | NN, >= 0        | Limite disponível no crediário. |
| situacao_crediario | VARCHAR(10)      | NN, domínio     | `liberado` ou `restrito`.       |
| cpf                | VARCHAR(11)      | UNIQUE, CHECK (limite_credito ou CPF) | Cadastro de Pessoa Física (obrigatório se o cliente possuir limite de crédito > 0).  |

### COLABORADOR

| Atributo       | Tipo             | Chave/restrição | Descrição                     |
|----------------|------------------|-----------------|-------------------------------|
| id_colaborador | INTEGER identity | PK              | Identificador do colaborador. |
| nome           | VARCHAR(120)     | NN              | Nome do colaborador.          |
| tipo           | VARCHAR(12)      | NN, domínio     | `dona` ou `freelancer`.       |

### FORNECEDOR

| Atributo      | Tipo             | Chave/restrição | Descrição                      |
|---------------|------------------|-----------------|--------------------------------|
| id_fornecedor | INTEGER identity | PK              | Identificador do fornecedor.   |
| nome          | VARCHAR(120)     | NN              | Nome da fábrica ou fornecedor. |
| cnpj          | VARCHAR(18)  | UNIQUE, NN         | CNPJ da empresa (Cadastro Nacional da Pessoa Jurídica). |


### REPRESENTANTE

| Atributo         | Tipo             | Chave/restrição | Descrição                       |
|------------------|------------------|-----------------|---------------------------------|
| id_representante | INTEGER identity | PK              | Identificador do representante. |
| nome             | VARCHAR(120)     | NN              | Nome do representante.          |
| telefone         | VARCHAR(20)      | —               | Telefone para contato.          |
| cnpj             | VARCHAR(18)      | UNIQUE          | CNPJ do representante (Cadastro de Pessoa Jurídica).    |

### FORNECEDOR_REPRESENTANTE

| Atributo         | Tipo    | Chave/restrição | Descrição                |
|------------------|---------|-----------------|--------------------------|
| id_fornecedor    | INTEGER | PK composta, FK | Fornecedor representado. |
| id_representante | INTEGER | PK composta, FK | Representante vinculado. |

### PRODUTO

| Atributo           | Tipo             | Chave/restrição | Descrição                                    |
|--------------------|------------------|-----------------|----------------------------------------------|
| id_produto         | INTEGER identity | PK              | Identificador do produto.                    |
| id_fornecedor      | INTEGER          | NN, FK          | Fornecedor responsável pelo produto.         |
| descricao          | VARCHAR(160)     | NN              | Nome ou descrição da peça.                   |
| categoria          | VARCHAR(10)      | NN, domínio     | `roupa` ou `acessorio`.                      |
| tamanho            | VARCHAR(10)      | —               | Tamanho da roupa; nulo para acessório.       |
| cor                | VARCHAR(40)      | —               | Cor cadastrada.                              |
| colecao            | VARCHAR(10)      | NN, domínio     | `primavera`, `verao`, `outono` ou `inverno`. |
| preco_custo        | NUMERIC(10,2)    | NN, >= 0        | Custo de aquisição.                          |
| preco_venda        | NUMERIC(10,2)    | NN, >= custo    | Preço atual de venda.                        |
| quantidade_estoque | INTEGER          | NN, >= 0        | Saldo disponível na loja física.             |

### VENDA

| Atributo               | Tipo             | Chave/restrição | Descrição                               |
|------------------------|------------------|-----------------|-----------------------------------------|
| id_venda               | INTEGER identity | PK              | Identificador da venda.                 |
| id_cliente             | INTEGER          | NN, FK          | Cliente da venda.                       |
| id_colaborador         | INTEGER          | NN, FK          | Responsável pelo registro.              |
| data_hora              | TIMESTAMP        | NN              | Momento do registro.                    |
| canal                  | VARCHAR(12)      | NN, domínio     | `loja`, `instagram` ou `whatsapp`.      |
| forma_pagamento        | VARCHAR(12)      | NN, domínio     | Dinheiro, cartão, Pix ou crediário.     |
| tipo_entrega           | VARCHAR(10)      | NN, domínio     | `retirada` ou `uber`.                   |
| percentual_desconto    | NUMERIC(5,2)     | NN, 0 a 100     | Desconto aplicado.                      |
| data_hora_cancelamento | TIMESTAMP        | —, até 24h      | Momento do cancelamento, quando houver. |

### ITEM_VENDA

| Atributo       | Tipo          | Chave/restrição | Descrição                            |
|----------------|---------------|-----------------|--------------------------------------|
| id_venda       | INTEGER       | PK composta, FK | Venda que contém o item.             |
| id_produto     | INTEGER       | PK composta, FK | Produto vendido.                     |
| quantidade     | INTEGER       | NN, > 0         | Unidades do produto na venda.        |
| preco_unitario | NUMERIC(10,2) | NN, >= 0        | Preço praticado no momento da venda. |

### PARCELA

| Atributo        | Tipo          | Chave/restrição    | Descrição                            |
|-----------------|---------------|--------------------|--------------------------------------|
| id_venda        | INTEGER       | PK composta, FK    | Venda do crediário.                  |
| numero_parcela  | SMALLINT      | PK composta, 1 a 4 | Número dentro da venda.              |
| valor_parcela   | NUMERIC(10,2) | NN, > 0            | Valor a cobrar.                      |
| data_vencimento | DATE          | NN                 | Data prevista para pagamento.        |
| data_pagamento  | DATE          | —                  | Data efetiva, nula quando em aberto. |

### TROCA_DEVOLUCAO

| Atributo       | Tipo             | Chave/restrição | Descrição                    |
|----------------|------------------|-----------------|------------------------------|
| id_troca       | INTEGER identity | PK              | Identificador da ocorrência. |
| id_venda       | INTEGER          | NN, FK composta | Venda original.              |
| id_produto     | INTEGER          | NN, FK composta | Item da venda envolvido.     |
| id_colaborador | INTEGER          | NN, FK          | Responsável pela operação.   |
| tipo           | VARCHAR(10)      | NN, domínio     | `troca` ou `devolucao`.      |
| quantidade     | INTEGER          | NN, > 0         | Quantidade retornada.        |
| data_hora      | TIMESTAMP        | NN              | Momento do registro.         |

> **Observação:** `(id_venda, id_produto)` é `UNIQUE` em `TROCA_DEVOLUCAO`, portanto cada item de venda pode possuir no máximo uma ocorrência de troca/devolução.