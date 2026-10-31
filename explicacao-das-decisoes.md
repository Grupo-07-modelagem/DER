# Nota explicativa: por que o modelo lógico foi feito deste jeito

**Para:** líder e demais integrantes da equipe 7
**Sobre:** a contribuição "Modelo lógico relacional" e "Normalização" da entrega final
**Arquivo principal:** `modelo-logico-e-normalizacao.md`

Esta nota existe para que o grupo consiga **avaliar, discordar e defender** as escolhas feitas, já que na arguição cada integrante responde sobre qualquer parte do projeto. Ela não substitui o documento principal.

---

## 1. O que esta contribuição entrega

- **Revisão da 1ª entrega:** tabela de alterações com "como era / como ficou / por quê".
- **Modelo lógico:** 10 tabelas com PK, FK, chaves compostas, restrições e integridade referencial, cada uma ligada à regra de negócio que a originou.
- **Normalização:** 1FN, 2FN e 3FN com dependências funcionais e casos reais do projeto.
- **dicionário de dados:** Atualização do Dicionario de dados com base na nova vrsão.
- **Script SQL:** dicionário de dados atualizado, script SQL, massa de dados e consultas.

## 2. De onde partimos

- Os diários de bordo mostram um modelo lógico de **4 tabelas** (CLIENTE, VENDA, PRODUTO, ITEM_VENDA), com poucos campos e em papel.
- O DER da 1ª entrega tem **9 entidades**; cinco delas (COLABORADOR, FORNECEDOR, REPRESENTANTE, PARCELA, TROCA_DEVOLUCAO) ainda não tinham sido convertidas em tabelas.
- A normalização não existia (o diário da Aula 6 a deixou para a aula seguinte).

## 3. As decisões e o raciocínio por trás delas

### D1. Representante × Fornecedor virou uma tabela associativa

- **Problema:** as cardinalidades da 1ª entrega dizem que um representante atende vários fornecedores e um fornecedor tem vários representantes. É um N:N, mas o DER só tem o losango "representa".
- **Decisão:** criar `FORNECEDOR_REPRESENTANTE` com PK composta.
- **Por quê:** é o mesmo raciocínio já aplicado a VENDA × PRODUTO (Aula 5).
- **Se fosse diferente:** guardar uma lista de representantes dentro do fornecedor violaria a 1FN.

### D2. CPF no cliente, opcional, mas obrigatório com limite de crédito

- **Problema:** a loja relatou "troca de nomes de clientes" (P2). Hoje o cliente só tem `id_cliente` e `nome`, nada que o identifique de verdade.
- **Decisão:** `cpf` `UNIQUE`, aceitando nulo, mais a regra `limite_credito = 0 OU cpf preenchido`.
- **Por quê:** resolve o problema declarado sem travar a venda à vista nem os clientes do Instagram, e liga o CPF a uma regra real: só se cobra quem está identificado (RN11).
- **Se fosse diferente:** CPF obrigatório para todos travaria vendas rápidas e coletaria dado pessoal sem necessidade; identificar por telefone `UNIQUE` barraria cadastros legítimos (pai e mãe com o mesmo número); sem identificador, o problema P2 continua sem resposta no modelo.
- **Depende de confirmação:** esta regra é uma proposta nossa, não uma regra informada pela loja (ver seção 6).

### D3. PRODUTO continua sendo uma tabela só (cada linha é uma peça)

- **Problema:** se o mesmo modelo existe em vários tamanhos e cores, dados como custo e fornecedor podem se repetir.
- **Decisão:** manter como está e documentar a justificativa.
- **Por quê:** o estoque é por tamanho e cor (RF05, RN04, P4); o ITEM_VENDA já aponta para a peça específica; RN06 diz que o preço "pode variar conforme o produto"; e o repositório não mostra que o custo se repita entre tamanhos.
- **Se fosse diferente (separar MODELO e PEÇA):** a normalização ficaria mais forte, mas seria necessária uma 11ª tabela, o DER teria que ser refeito e a FK de ITEM_VENDA teria que mudar, na última semana do projeto.
- **Como fica como evolução:** a separação é a primeira melhoria sugerida para o projeto, caso a loja confirme que o custo é igual em todos os tamanhos.

### D4. Atributos derivados não viram coluna

- **Problema:** o DER traz cinco atributos tracejados (`margem`, `setor_tamanho`, `subtotal`, `valor_total`, `situacao` da parcela).
- **Decisão:** não criar colunas para eles; calcular em consultas ou views.
- **Por quê:** guardá-los criaria dependências entre atributos não chave (violando a 3FN) e risco de divergência, como um `valor_total` que não bate com os itens.

### D5. PARCELA é entidade fraca

- **Problema:** na auditoria da Aula 6 o grupo não identificou entidade fraca; o README e o DER já mostram PARCELA como fraca.
- **Decisão:** manter PARCELA como fraca, com PK `(id_venda, numero_parcela)`.
- **Por quê:** o número da parcela (1 a 4) se repete em toda venda e só identifica a parcela junto com a venda. Não é uma contradição: o diário registra o que o grupo pensava naquele dia, e o modelo evoluiu depois. A mudança está registrada na tabela de alterações.

### D6. Algumas regras viram restrição; outras viram consulta de auditoria

- **Problema:** o `CHECK` do MySQL só enxerga a própria linha.
- **Decisão:** as regras de uma linha só (máximo de 4 parcelas, desconto entre 0 e 100, cancelamento em 24 horas, estoque não negativo) ficam no banco. As regras que cruzam tabelas (venda com pelo menos um item, parcelas só no crediário, crediário dentro do limite) ficam para consultas de auditoria. A tabela da seção 4 do documento principal separa as duas.
- **Por quê:** o manual da entrega final pede consultas de auditoria e pede que cada restrição tenha justificativa; assim cada regra tem um lugar claro.

### D7. CNPJ identifica o fornecedor

-   **Problema:** sem um identificador fiscal, o sistema pode receber
    cadastros duplicados da mesma empresa, dividindo os produtos entre
    registros diferentes.
-   **Decisão:** incluir `cnpj` em FORNECEDOR com `NOT NULL` e `UNIQUE`;
    manter `nome` como `NOT NULL`, sem `UNIQUE`.
-   **Por quê:** a RF09 é atendida pelo CNPJ único, que identifica a
    empresa e evita duplicidade de cadastro.

## 4. Alternativas que consideramos

| | Jeito 1 | Jeito 2 | Jeito 3 | **Jeito escolhido** |
|---|---|---|---|---|
| CPF | Não | Sim | Sim (opcional) | Sim (opcional; obrigatório com crédito) |
| PRODUTO | Peça (como está) | Separar modelo e peça | Peça (como está) | Peça (como está), justificada |
| Resolve P2 (troca de nomes)? | Não | Sim | Sim | Sim |
| Mantém DER, README e SQL coerentes sem grande retrabalho? | Sim | Não (11ª tabela) | Sim | Sim |
| Risco principal | Problema da loja sem resposta no modelo | Retrabalho na última semana | CPF sem regra clara de uso | CPF depende da confirmação da Dona |

## 5. O que precisa acompanhar para o projeto ficar coerente

O manual da entrega final lista como erro "deixar DER, modelo lógico, dicionário e SQL diferentes entre si". Para evitar isso:

1. **DER:** incluir a tabela associativa Fornecedor–Representante e o atributo `cpf` em CLIENTE; exportar uma imagem única e atualizada (hoje são três prints cortados).
2. **README:** corrigir os links para `docs/`, que não existe (os arquivos estão na raiz) e o link do DER, que está quebrado; atualizar para a estrutura de 16 seções pedida no manual.
3. **Cardinalidades:** corrigir o texto da relação Item de venda × Troca/devolução para (0,N).
4. **Fluxograma F1:** o caminho do crediário vai para F2 e não volta; o estoque (RN04) e a entrega não aparecem nesse caminho. Também há diferença entre o README e o PDF no cancelamento (devolver a peça ao estoque).
5. **Requisitos:** acrescentar um RF para consultar clientes em atraso (P3) e outro para o cancelamento em 24 horas, que hoje só aparece como regra.
6. **Dicionário e SQL:** são as próximas etapas e devem sair deste modelo, não o contrário.

## 6. O que ainda precisa de validação

**Com a loja:**
1. A Dona já pede CPF para vender no crediário?
2. Custo e fornecedor são iguais em todos os tamanhos e cores de um mesmo modelo?
3. Os tamanhos juvenis são só 12, 14, 16, 18 e 20?
4. Toda peça pertence a uma das quatro coleções?

**Com o grupo:**
1. Concordam com o Jeito escolhido (D2 e D3)?
2. Quem atualiza o DER e o README (itens 1 e 2 da seção 5)?

## 7. Perguntas que o professor pode fazer ("e se...?")

| Pergunta | Direção da resposta |
|---|---|
| E se o cliente pagar uma parte no Pix e outra no crediário? | Hoje a venda tem uma única `forma_pagamento`. A evolução seria uma tabela PAGAMENTO (venda, forma, valor) |
| E se o mesmo produto aparecer duas vezes na mesma venda? | A PK composta de ITEM_VENDA impede; as repetições vão para `quantidade` |
| E se o preço do produto mudar depois da venda? | O `preco_unitario` do item guarda o preço praticado, então o histórico não muda |
| E se o cliente quiser cancelar depois de 24 horas? | O `CHECK` recusa; o caminho passa a ser devolução (fluxo F3) |
| E se uma peça tiver mais de um fornecedor? | Hoje é (1,1). Mudaria para N:N com tabela associativa, como Representante × Fornecedor |
| E se a FK `id_cliente` não existisse na VENDA? | Haveria venda sem dono, sem como cobrar o crediário nem consultar o histórico (RF08) |
| E se o CPF for do responsável e a compra for para vários filhos? | O modelo identifica o cliente que compra (o responsável), não a criança |
| E se a loja passar a ter estoque em mais de um local? | RN05 limita o projeto à loja física; seria necessária uma tabela ESTOQUE por local |

## 8. Riscos e limites desta versão

- **A normalização do PRODUTO depende de uma premissa não confirmada** (seção 6, pergunta 2). Se a loja disser que o custo é igual entre tamanhos, a separação em modelo e peça passa a ser a melhor opção.
- **A regra de CPF com crédito é uma proposta,** não uma regra da loja. O `CHECK` correspondente é simples de remover se a Dona discordar.
- **Os `CHECK` exigem MySQL 8.0.16 ou superior.** Em versões anteriores o comando é aceito, mas a regra é ignorada.
- **O `CHECK` não valida o dígito do CPF,** apenas a unicidade.
- **Este material foi montado a partir dos manuais, do repositório e dos diários,** sem acesso aos slides das aulas; a notação do modelo lógico pode precisar de ajuste ao padrão usado pelo professor.
- **Uso de IA:** o rascunho foi elaborado com apoio do Claude e deve ser revisado pelo grupo. Registrar no diário de bordo, como a equipe já faz com o ChatGPT.


