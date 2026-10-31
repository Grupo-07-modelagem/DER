# Cardinalidades

As cardinalidades mostram a quantidade mínima e máxima de ocorrências em
cada lado do relacionamento.

  -----------------------------------------------------------------------------
  Relacionamento             Lado 1                  Lado 2
  -------------------------- ----------------------- --------------------------
  CLIENTE realiza VENDA      CLIENTE (0,N)           VENDA (1,1)

  COLABORADOR registra VENDA COLABORADOR (0,N)       VENDA (1,1)

  VENDA contém ITEM_VENDA    VENDA (1,N)             ITEM_VENDA (1,1)

  PRODUTO aparece em         PRODUTO (0,N)           ITEM_VENDA (1,1)
  ITEM_VENDA                                         

  FORNECEDOR fornece PRODUTO FORNECEDOR (0,N)        PRODUTO (1,1)

  REPRESENTANTE participa de REPRESENTANTE (1,N)     FORNECEDOR_REPRESENTANTE
  FORNECEDOR_REPRESENTANTE                           (1,1)

  FORNECEDOR participa de    FORNECEDOR (0,N)        FORNECEDOR_REPRESENTANTE
  FORNECEDOR_REPRESENTANTE                           (1,1)

  VENDA é parcelada em       VENDA (0,4)             PARCELA (1,1)
  PARCELA                                            

  ITEM_VENDA é objeto de     ITEM_VENDA (0,N)        TROCA_DEVOLUCAO (1,1)
  TROCA_DEVOLUCAO                                    

  COLABORADOR efetua         COLABORADOR (0,N)       TROCA_DEVOLUCAO (1,1)
  TROCA_DEVOLUCAO                                    
  -----------------------------------------------------------------------------

### Análise dos dois sentidos

**CLIENTE --- VENDA:** um cliente pode não ter nenhuma venda ou ter
várias. Cada venda está ligada a um cliente.

**COLABORADOR --- VENDA:** um colaborador pode registrar nenhuma ou
várias vendas. Cada venda é registrada por um colaborador.

**VENDA --- ITEM_VENDA --- PRODUTO:** uma venda precisa ter pelo menos
um item. Um produto pode aparecer em várias vendas.

**FORNECEDOR --- PRODUTO:** um fornecedor pode fornecer vários produtos.
No modelo adotado, cada produto possui um fornecedor.

**REPRESENTANTE --- FORNECEDOR_REPRESENTANTE:** um representante deve
estar associado a pelo menos um fornecedor e pode estar associado a
vários. Cada registro da entidade associativa pertence a um único
representante.

**FORNECEDOR --- FORNECEDOR_REPRESENTANTE:** um fornecedor pode estar
cadastrado sem representante ou possuir vários representantes. Cada
registro da entidade associativa pertence a um único fornecedor.

**REPRESENTANTE --- FORNECEDOR:** um representante está associado a um
ou mais fornecedores. Um fornecedor pode estar associado a nenhum ou
vários representantes. Esse relacionamento muitos-para-muitos é
implementado pela entidade associativa FORNECEDOR_REPRESENTANTE.

**VENDA --- PARCELA:** uma venda pode ter nenhuma parcela quando não é
no crediário ou de 1 a 4 parcelas quando é a prazo.

**ITEM_VENDA --- TROCA_DEVOLUCAO:** um item de venda pode não ter
troca/devolução ou pode ter várias ocorrências registradas, inclusive
parciais. Cada troca/devolução é ligada a um único item vendido.

**COLABORADOR --- TROCA_DEVOLUCAO:** um colaborador pode realizar várias
ocorrências. Cada ocorrência é feita por um colaborador.
