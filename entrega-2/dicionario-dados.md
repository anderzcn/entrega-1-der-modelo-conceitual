## Dicionário de Dados — Rafimex

O dicionário de dados reúne a documentação das 16 tabelas do banco `db_rafimex`. São as entidades do modelo conceitual (***CLIENTE, COLABORADOR, PRODUTO, FORNECEDOR, PEDIDO, NOTA FISCAL e COMPRA/IMPORTAÇÃO***), mais as tabelas que surgiram na conversão para o modelo lógico: associativas, de domínio, de parcelas e de log de acesso. Cada tabela é descrita pela estrutura formal, pela leitura dos atributos e por uma tabela com tipo físico, chave, obrigatoriedade, restrições e significado de cada coluna.

> Este dicionário corresponde exatamente ao script [docs/script.sql](script.sql): mesmos nomes, tipos, obrigatoriedade e restrições.

---

## 1. Controle de versão e configuração

| Item | Valor |
| :---- | :---- |
| **Versão do dicionário** | 2.0 |
| **Data de atualização** | 31/10/2026 |
| **SGBD alvo** | MySQL 8.0 (testado no 8.0.40), mecanismo InnoDB |
| **Codificação** | `utf8mb4` |
| **Collation** | `utf8mb4_0900_ai_ci` |
| **Total de tabelas** | 16 |

**Justificativa da collation.** O `utf8mb4` guarda o padrão UTF-8 completo, de 4 bytes, o que garante acentos e símbolos em razão social, endereço e descrição de produto. A collation `0900_ai_ci` é *accent-insensitive* (ai) e *case-insensitive* (ci). Assim, uma busca por "sao paulo" encontra "São Paulo", e "CASA BELA" encontra "Casa Bela". Isso evita cadastros e contagens duplicados por diferença de acento ou de maiúscula.

### Histórico de versões

| Versão | Data | O que mudou |
| :---- | :---- | :---- |
| 1.0 | 23/09/2026 | Dicionário conceitual da Entrega 1 (seis entidades) |
| 1.1 | 26/10/2026 | Inclusão de ITEM_PEDIDO, COMPRA_IMPORTACAO, matriz LGPD e log de acesso |
| 2.0 | 31/10/2026 | Alinhado ao modelo lógico e ao script da Entrega 2: tabelas de domínio, TIPO_COLABORADOR, TITULO_RECEBER (parcelas), ITEM_COMPRA, FORNECEDOR_PRODUTO, LOG_ACESSO; contas a pagar na compra e devolução na nota fiscal; correção dos nomes de colunas |

---

## 2. Convenções

### Notação formal

| Símbolo | Significado e aplicação |
| :---- | :---- |
| `=` | é composto de (define a estrutura da tabela) |
| `+` | e (conecta elementos) |
| `( )` | opcional (coluna que aceita nulo) |
| `[ ]` | escolha obrigatória entre alternativas exclusivas (`[A \| B]`) |
| `{ }` | iteração / grupo repetitivo (`1{ PARCELA }n`) |
| `@` | identificador (chave primária) |
| `/ /` | comentário ou restrição |
| `* *` | chave estrangeira (FK) |

### Prefixos das colunas

| Prefixo | Significado | Exemplo |
| :---- | :---- | :---- |
| `ID_` | identificador (PK ou FK) | `ID_CLIENTE` |
| `NM_` | nome | `NM_RAZAO_SOCIAL` |
| `DT_` | data ou data/hora | `DT_DATA_DO_PEDIDO` |
| `CD_` | código (fiscal, SKU, CEP, UF, moeda) | `CD_NCM`, `CD_MOEDA` |
| `QT_` | quantidade | `QT_ESTOQUE` |
| `VL_` | valor monetário ou percentual | `VL_LIMITE_CREDITO`, `VL_PERC_COMISSAO` |
| `IN_` | indicador booleano | `IN_ATIVO` |
| `DS_` | descrição ou texto | `DS_EMAIL` |
| `NR_` | número (documento, nota, telefone) | `NR_CNPJ`, `NR_NF` |
| `ST_` | situação (status) com lista fechada de valores | `ST_SITUACAO_CREDITO` |
| `TP_` | tipo, com lista fechada de valores | `TP_TIPO_OPERACAO` |

### Colunas das tabelas de atributos

- **Chave:** `PK`, `FK` ou `PK, FK`.
- **Obrigatório:** "Sim" quando a coluna é `NOT NULL`.
- **Restrição / padrão:** `UNIQUE`, `CHECK` (valores permitidos), `DEFAULT` (valor padrão) e `AUTO_INCREMENT`.

---

## 3. Tabelas de domínio

Criadas na 3FN. Na Entrega 1, frete, forma de pagamento e status eram texto livre dentro de PEDIDO; agora são listas fechadas, referenciadas por chave.

### 3.1 TIPO_FRETE

**Estrutura formal:** `TIPO_FRETE = @ID_TIPO_FRETE + DS_TIPO_FRETE`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_TIPO_FRETE | INT | PK | Sim | AUTO_INCREMENT | Identifica a modalidade de entrega |
| DS_TIPO_FRETE | VARCHAR(30) | | Sim | UNIQUE | 'Transportadora' ou 'Retirada na Empresa' (RF06, RN15) |

**Índices:** PK ID_TIPO_FRETE; único em DS_TIPO_FRETE.

### 3.2 FORMA_PAGAMENTO

**Estrutura formal:** `FORMA_PAGAMENTO = @ID_FORMA_PAGAMENTO + DS_FORMA_PAGAMENTO`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_FORMA_PAGAMENTO | INT | PK | Sim | AUTO_INCREMENT | Identifica a forma de pagamento |
| DS_FORMA_PAGAMENTO | VARCHAR(30) | | Sim | UNIQUE | 'Boleto', 'PIX' ou 'Cartão'. O boleto passa pela análise de crédito (RN02, RN03) |

**Índices:** PK ID_FORMA_PAGAMENTO; único em DS_FORMA_PAGAMENTO.

### 3.3 STATUS_PEDIDO

**Estrutura formal:** `STATUS_PEDIDO = @ID_STATUS_PEDIDO + DS_STATUS_PEDIDO`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_STATUS_PEDIDO | INT | PK | Sim | AUTO_INCREMENT | Identifica a etapa do pedido |
| DS_STATUS_PEDIDO | VARCHAR(30) | | Sim | UNIQUE | 'Pendente', 'Em Separação', 'Faturado' ou 'Cancelado' |

**Índices:** PK ID_STATUS_PEDIDO; único em DS_STATUS_PEDIDO.

### 3.4 TIPO_COLABORADOR

Guarda o percentual de comissão, que depende só do tipo de vínculo (RN12). Mantê-lo em cada colaborador seria uma dependência transitiva (3FN).

**Estrutura formal:** `TIPO_COLABORADOR = @ID_TIPO_COLABORADOR + DS_TIPO_COLABORADOR + VL_PERC_COMISSAO`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_TIPO_COLABORADOR | INT | PK | Sim | AUTO_INCREMENT | Identifica o tipo de vínculo |
| DS_TIPO_COLABORADOR | VARCHAR(10) | | Sim | UNIQUE | 'Interno' (vendedor interno) ou 'Externo' (representante) |
| VL_PERC_COMISSAO | DECIMAL(5,2) | | Sim | CHECK entre 0 e 20 | Percentual de comissão: 3,00 para interno e 8,00 para externo (RN12) |

**Índices:** PK ID_TIPO_COLABORADOR; único em DS_TIPO_COLABORADOR.

---

## 4. Cadastros

### 4.1 COLABORADOR

Equipe comercial da Rafimex: representantes externos e vendedores internos. Contém dados pessoais (LGPD).

**Estrutura formal:**
```
COLABORADOR = @ID_COLABORADOR + *ID_TIPO_COLABORADOR* + NM_COLABORADOR + NR_CPF + DT_DATA_DE_NASCIMENTO
            + ENDERECO + DS_EMAIL + TELEFONE
ENDERECO    = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + (DS_COMPLEMENTO)
TELEFONE    = CD_DDD + NR_NUMERO_TEL
```

**Leitura:** @ID_COLABORADOR identifica o colaborador. \*ID_TIPO_COLABORADOR\* diz se ele é interno ou externo e, por isso, qual comissão recebe. ENDERECO e TELEFONE são atributos compostos, quebrados em colunas atômicas.

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_COLABORADOR | INT | PK | Sim | AUTO_INCREMENT | Identifica o colaborador |
| ID_TIPO_COLABORADOR | INT | FK | Sim | → TIPO_COLABORADOR | Tipo de vínculo, que define a comissão (RN12) |
| NM_COLABORADOR | VARCHAR(120) | | Sim | | Nome completo |
| NR_CPF | VARCHAR(14) | | Sim | UNIQUE; CHECK formato `000.000.000-00` | CPF (dado pessoal; não é usado como chave) |
| DT_DATA_DE_NASCIMENTO | DATE | | Sim | | Data de nascimento |
| CD_CEP | VARCHAR(9) | | Sim | CHECK formato `00000-000` | CEP |
| CD_UF | CHAR(2) | | Sim | | Sigla do estado |
| DS_CIDADE | VARCHAR(100) | | Sim | | Cidade |
| DS_BAIRRO | VARCHAR(100) | | Sim | | Bairro |
| DS_RUA | VARCHAR(150) | | Sim | | Rua |
| NR_NUMERO | VARCHAR(10) | | Sim | | Número do endereço |
| DS_COMPLEMENTO | VARCHAR(100) | | Não | | Complemento do endereço |
| DS_EMAIL | VARCHAR(100) | | Sim | CHECK formato de e-mail | E-mail corporativo |
| CD_DDD | CHAR(2) | | Sim | | DDD do telefone |
| NR_NUMERO_TEL | VARCHAR(14) | | Sim | | Número do telefone |

**Índices:** PK ID_COLABORADOR; único em NR_CPF; secundário em NM_COLABORADOR (busca por nome).

### 4.2 CLIENTE

Empresas (pessoa jurídica) que compram da Rafimex.

**Estrutura formal:**
```
CLIENTE  = @ID_CLIENTE + *ID_COLABORADOR* + NM_RAZAO_SOCIAL + NR_CNPJ + (NR_INSCRIC_ESTADUAL) + ENDERECO
         + DS_EMAIL + TELEFONE + VL_LIMITE_CREDITO + IN_ATIVO + ID_SERASA + ST_SITUACAO_CREDITO
         + DT_DATA_DE_ATUALIZACAO   / base da trava de 90 dias - RN09 /
ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + (DS_COMPLEMENTO)
TELEFONE = CD_DDD + NR_NUMERO_TEL
```

**Leitura:** @ID_CLIENTE identifica o cliente. \*ID_COLABORADOR\* é o representante que atende a carteira. ST_SITUACAO_CREDITO diz se o cliente está liberado, com restrição no Serasa ou inadimplente. DT_DATA_DE_ATUALIZACAO guarda a última confirmação dos dados; passados 90 dias, novos pedidos são bloqueados.

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_CLIENTE | INT | PK | Sim | AUTO_INCREMENT | Identifica o cliente |
| ID_COLABORADOR | INT | FK | Sim | → COLABORADOR | Representante responsável pela carteira (COLABORADOR atende CLIENTE) |
| NM_RAZAO_SOCIAL | VARCHAR(100) | | Sim | | Razão social |
| NR_CNPJ | VARCHAR(18) | | Sim | UNIQUE; CHECK formato `00.000.000/0000-00` | CNPJ (RF01, RN01) |
| NR_INSCRIC_ESTADUAL | VARCHAR(20) | | Não | | Inscrição estadual, quando houver |
| CD_CEP | VARCHAR(9) | | Sim | CHECK formato `00000-000` | CEP de entrega |
| CD_UF | CHAR(2) | | Sim | | Sigla do estado |
| DS_CIDADE | VARCHAR(100) | | Sim | | Cidade |
| DS_BAIRRO | VARCHAR(100) | | Sim | | Bairro |
| DS_RUA | VARCHAR(150) | | Sim | | Rua |
| NR_NUMERO | VARCHAR(10) | | Sim | | Número do endereço |
| DS_COMPLEMENTO | VARCHAR(100) | | Não | | Complemento |
| DS_EMAIL | VARCHAR(100) | | Sim | CHECK formato de e-mail | E-mail de contato financeiro |
| CD_DDD | CHAR(2) | | Sim | | DDD do telefone |
| NR_NUMERO_TEL | VARCHAR(10) | | Sim | | Número do telefone |
| VL_LIMITE_CREDITO | DECIMAL(15,2) | | Sim | DEFAULT 0; CHECK ≥ 0 | Limite para compras no boleto (RN02) |
| IN_ATIVO | BOOLEAN | | Sim | DEFAULT TRUE | Cadastro ativo ou desativado |
| ID_SERASA | VARCHAR(50) | | Sim | | Código da consulta no Serasa |
| ST_SITUACAO_CREDITO | VARCHAR(20) | | Sim | DEFAULT 'Ativo'; CHECK 'Ativo', 'Bloqueado Serasa' ou 'Inadimplente' | Situação de crédito (RN03, RN04) |
| DT_DATA_DE_ATUALIZACAO | DATE | | Sim | | Última confirmação dos dados cadastrais (RN09, RF09) |

**Índices:** PK ID_CLIENTE; único em NR_CNPJ (impede CNPJ duplicado); secundário em NM_RAZAO_SOCIAL (busca por nome); secundário em DT_DATA_DE_ATUALIZACAO (encontrar cadastros com mais de 90 dias).

### 4.3 PRODUTO

**Estrutura formal:** `PRODUTO = @ID_PRODUTO + CD_SKU + CD_NCM + DS_DESCRICAO + VL_PRECO_CUSTO + VL_PRECO_UNITARIO + QT_ESTOQUE + QT_PONTO_PEDIDO`

**Leitura:** VL_PRECO_UNITARIO é o preço de tabela atual. O preço efetivamente cobrado em cada venda fica em ITEM_PEDIDO (RN07). QT_PONTO_PEDIDO é o estoque mínimo que dispara o alerta de reposição (RF08).

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_PRODUTO | INT | PK | Sim | AUTO_INCREMENT | Identifica o produto |
| CD_SKU | VARCHAR(30) | | Sim | UNIQUE | Código interno do produto |
| CD_NCM | VARCHAR(10) | | Sim | | Classificação fiscal (NCM) |
| DS_DESCRICAO | VARCHAR(150) | | Sim | | Descrição do produto |
| VL_PRECO_CUSTO | NUMERIC(10,2) | | Sim | CHECK > 0 | Custo do produto para a Rafimex |
| VL_PRECO_UNITARIO | NUMERIC(10,2) | | Sim | CHECK > 0 | Preço de tabela atual |
| QT_ESTOQUE | INT | | Sim | DEFAULT 0; CHECK ≥ 0 | Quantidade disponível em estoque |
| QT_PONTO_PEDIDO | INT | | Sim | DEFAULT 0; CHECK ≥ 0 | Estoque mínimo para alerta de reposição (RF08) |

**Índices:** PK ID_PRODUTO; único em CD_SKU; secundário em CD_NCM (consultas por classificação fiscal).

### 4.4 FORNECEDOR

**Estrutura formal:**
```
FORNECEDOR = @ID_FORNECEDOR + NR_CNPJ + NM_RAZAO_SOCIAL + (NR_INSCRIC_ESTADUAL) + DS_EMAIL + TELEFONE + ENDERECO
TELEFONE   = CD_DDD + NR_NUMERO_TEL
ENDERECO   = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO_ENDERECO + (DS_COMPLEMENTO)
```

**Leitura:** NR_NUMERO_TEL é o telefone e NR_NUMERO_ENDERECO é o número do endereço. Na Entrega 1 os dois tinham o mesmo nome; agora estão separados.

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_FORNECEDOR | INT | PK | Sim | AUTO_INCREMENT | Identifica o fornecedor |
| NR_CNPJ | VARCHAR(18) | | Sim | UNIQUE; CHECK formato `00.000.000/0000-00` | CNPJ (RN10) |
| NM_RAZAO_SOCIAL | VARCHAR(100) | | Sim | | Razão social |
| NR_INSCRIC_ESTADUAL | VARCHAR(20) | | Não | | Inscrição estadual, quando houver |
| DS_EMAIL | VARCHAR(100) | | Sim | CHECK formato de e-mail | E-mail comercial |
| CD_DDD | CHAR(2) | | Sim | | DDD do telefone |
| NR_NUMERO_TEL | VARCHAR(10) | | Sim | | Número do **telefone** |
| CD_CEP | VARCHAR(9) | | Sim | CHECK formato `00000-000` | CEP |
| CD_UF | CHAR(2) | | Sim | | Sigla do estado |
| DS_CIDADE | VARCHAR(100) | | Sim | | Cidade |
| DS_BAIRRO | VARCHAR(100) | | Sim | | Bairro |
| DS_RUA | VARCHAR(150) | | Sim | | Rua |
| NR_NUMERO_ENDERECO | VARCHAR(10) | | Sim | | Número do **endereço** |
| DS_COMPLEMENTO | VARCHAR(100) | | Não | | Complemento |

**Índices:** PK ID_FORNECEDOR; único em NR_CNPJ; secundário em NM_RAZAO_SOCIAL.

### 4.5 FORNECEDOR_PRODUTO (associativa)

Resolve o N:N "FORNECEDOR fornece PRODUTO": um produto pode ter vários fornecedores, e um fornecedor fornece vários produtos.

**Estrutura formal:** `FORNECEDOR_PRODUTO = @*ID_FORNECEDOR* + @*ID_PRODUTO*`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_FORNECEDOR | INT | PK, FK | Sim | → FORNECEDOR | Fornecedor homologado |
| ID_PRODUTO | INT | PK, FK | Sim | → PRODUTO | Produto fornecido |

**Índices:** PK composta (ID_FORNECEDOR, ID_PRODUTO).

---

## 5. Ciclo de vendas

### 5.1 PEDIDO

**Estrutura formal:**
```
PEDIDO = @ID_PEDIDO + *ID_CLIENTE* + *ID_COLABORADOR* + DT_DATA_DO_PEDIDO + VL_VALOR_VENDA
       + *ID_TIPO_FRETE* + *ID_FORMA_PAGAMENTO* + VL_DESCONTO_APLICADO + IN_APROVACAO_DIRETORIA
       + *ID_STATUS_PEDIDO* + 1{ ITEM_PEDIDO }n
       / desconto > 4% exige aprovação da diretoria - RN06 /
```

**Leitura:** todo pedido tem cliente e colaborador emissor (RN05). Frete, forma de pagamento e status vêm das tabelas de domínio. VL_VALOR_VENDA já tem o desconto aplicado. Um trigger bloqueia pedido novo de cliente inativo, inadimplente, com devolução por endereço sem revalidação, com cadastro vencido, com restrição no Serasa pagando no boleto, ou acima do limite de crédito (RN02, RN03, RN04, RN09, RN13).

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_PEDIDO | INT | PK | Sim | AUTO_INCREMENT | Identifica o pedido |
| ID_CLIENTE | INT | FK | Sim | → CLIENTE | Cliente que comprou (RF03, RN05) |
| ID_COLABORADOR | INT | FK | Sim | → COLABORADOR | Colaborador que registrou o pedido (RF03, RN05) |
| DT_DATA_DO_PEDIDO | DATE | | Sim | | Data do pedido |
| VL_VALOR_VENDA | DECIMAL(18,2) | | Sim | CHECK > 0 | Valor total, já com o desconto |
| ID_TIPO_FRETE | INT | FK | Sim | → TIPO_FRETE | Modalidade de entrega (RF06, RN15) |
| ID_FORMA_PAGAMENTO | INT | FK | Sim | → FORMA_PAGAMENTO | Forma de pagamento |
| VL_DESCONTO_APLICADO | DECIMAL(8,2) | | Sim | DEFAULT 0; CHECK entre 0 e 100 | Percentual de desconto |
| IN_APROVACAO_DIRETORIA | BOOLEAN | | Sim | DEFAULT FALSE; CHECK desconto ≤ 4 ou aprovação = TRUE | Aprovação da diretoria para desconto acima de 4% (RF04, RN06) |
| ID_STATUS_PEDIDO | INT | FK | Sim | → STATUS_PEDIDO | Etapa do pedido |

**Índices:** PK ID_PEDIDO; secundário em DT_DATA_DO_PEDIDO (consultas por período); FKs indexadas pelo InnoDB.

### 5.2 ITEM_PEDIDO (associativa)

Resolve o N:N "PEDIDO contém PRODUTO" e guarda os atributos do relacionamento: quantidade, preço praticado e previsão de chegada.

**Estrutura formal:**
```
ITEM_PEDIDO = @*ID_PEDIDO* + @*ID_PRODUTO* + QT_VENDIDA + VL_UNITARIO_VENDIDO + (DT_PREVISAO_CHEGADA)
            / DT_PREVISAO_CHEGADA vazia = sai do estoque; preenchida = entrega programada - RF07, RN08 /
```

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_PEDIDO | INT | PK, FK | Sim | → PEDIDO (ON DELETE CASCADE) | Pedido ao qual o item pertence |
| ID_PRODUTO | INT | PK, FK | Sim | → PRODUTO | Produto vendido |
| QT_VENDIDA | INT | | Sim | CHECK > 0 | Quantidade vendida |
| VL_UNITARIO_VENDIDO | DECIMAL(10,2) | | Sim | CHECK > 0; não pode ser alterado (trigger) | Preço praticado no dia da venda (RF05, RN07) |
| DT_PREVISAO_CHEGADA | DATE | | Não | | Data prevista de chegada quando o item é entrega programada (RF07, RN08) |

**Índices:** PK composta (ID_PEDIDO, ID_PRODUTO), que impede o mesmo produto duas vezes no mesmo pedido.

### 5.3 NOTA_FISCAL

**Estrutura formal:**
```
NOTA_FISCAL = @ID_NF + *ID_PEDIDO* + NR_NF + NR_CHAVE_ACESSO + DT_DATA_EMISSAO + (VL_IMPOSTO_IMPORTACAO)
            + VL_TOTAL_IMPOSTOS + VL_TOTAL_NF + DS_STATUS_NF + 1{ PARCELA }n + (DEVOLUCAO)
PARCELA     = NR_PARCELA + DT_VENCIMENTO + VL_PARCELA + (DT_PAGAMENTO) + ST_STATUS_TITULO
            / atributo multivalorado: vira a tabela TITULO_RECEBER /
DEVOLUCAO   = DT_DEVOLUCAO + DS_MOTIVO_DEVOLUCAO + VL_TAXA_REENTREGA
            / no máximo uma por nota: fica na própria nota - P3, RN13 /
```

**Leitura:** a nota liga-se ao pedido por \*ID_PEDIDO\* (no máximo uma nota por pedido, RN14). Os dados do cliente e dos produtos não são repetidos: vêm do pedido. Quando a mercadoria volta, a data, o motivo e a taxa de reentrega são preenchidos; quando a entrega dá certo, ficam vazios.

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_NF | INT | PK | Sim | AUTO_INCREMENT | Identifica a nota |
| ID_PEDIDO | INT | FK | Sim | UNIQUE; → PEDIDO | Pedido que originou a nota (RN14) |
| NR_NF | INT | | Sim | UNIQUE | Número da NF-e |
| NR_CHAVE_ACESSO | VARCHAR(44) | | Sim | UNIQUE; CHECK 44 dígitos | Chave de acesso da NF-e |
| DT_DATA_EMISSAO | DATE | | Sim | | Data de emissão |
| VL_IMPOSTO_IMPORTACAO | DECIMAL(18,2) | | Não | | Imposto de importação (II), só quando a nota tem produto importado |
| VL_TOTAL_IMPOSTOS | DECIMAL(18,2) | | Sim | CHECK ≥ 0 e menor que o total | Soma dos tributos da nota |
| VL_TOTAL_NF | DECIMAL(18,2) | | Sim | CHECK > 0 | Valor total da nota |
| DS_STATUS_NF | VARCHAR(20) | | Sim | DEFAULT 'Emitida'; CHECK 'Emitida' ou 'Cancelada' | Situação da nota |
| DT_DEVOLUCAO | DATE | | Não | CHECK ≥ data de emissão | Data em que a mercadoria voltou (P3) |
| DS_MOTIVO_DEVOLUCAO | VARCHAR(30) | | Não | CHECK 'Endereço desatualizado', 'Avaria no transporte' ou 'Recusa do cliente' | Motivo da devolução; "Endereço desatualizado" bloqueia o cliente (RN13) |
| VL_TAXA_REENTREGA | DECIMAL(10,2) | | Não | CHECK ≥ 0 | Custo da reentrega |

Os três campos de devolução são preenchidos juntos ou ficam todos vazios (`CHECK CK_NF_DEVOLUCAO`).

**Índices:** PK ID_NF; único em ID_PEDIDO (relação 1:1 com o pedido); único em NR_NF; único em NR_CHAVE_ACESSO; secundário em DT_DATA_EMISSAO.

### 5.4 TITULO_RECEBER

Conversão do atributo multivalorado **parcela** da NOTA_FISCAL: o boleto pode ser parcelado em até 3x (30, 60 e 90 dias). Cada linha é uma parcela. PIX e cartão geram um único título, já pago na emissão.

**Estrutura formal:**
```
TITULO_RECEBER = @ID_TITULO + *ID_NF* + NR_PARCELA + DT_VENCIMENTO + VL_PARCELA + (DT_PAGAMENTO) + ST_STATUS_TITULO
               / "vencido" não é guardado: é calculado (em aberto e com vencimento antes de hoje) /
```

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_TITULO | INT | PK | Sim | AUTO_INCREMENT | Identifica a parcela (cada uma tem baixa própria) |
| ID_NF | INT | FK | Sim | → NOTA_FISCAL | Nota a que a parcela pertence |
| NR_PARCELA | INT | | Sim | DEFAULT 1; CHECK entre 1 e 12; UNIQUE junto com ID_NF | Número da parcela (RN16) |
| DT_VENCIMENTO | DATE | | Sim | | Data de vencimento |
| VL_PARCELA | DECIMAL(18,2) | | Sim | CHECK > 0 | Valor da parcela; a soma das parcelas é igual ao total da nota |
| DT_PAGAMENTO | DATE | | Não | Obrigatória quando a situação é 'Pago' | Data da baixa |
| ST_STATUS_TITULO | VARCHAR(20) | | Sim | DEFAULT 'Aberto'; CHECK 'Aberto', 'Pago' ou 'Cancelado' | Situação da parcela. Parcela paga libera a comissão (RN12); vencida e não paga é pendência do cliente (RN04) |

**Índices:** PK ID_TITULO; único composto (ID_NF, NR_PARCELA); secundário em DT_VENCIMENTO (inadimplência por período).

---

## 6. Ciclo de compras

### 6.1 COMPRA_IMPORTACAO

Compra nacional ou importação feita a um fornecedor cadastrado. Cada compra gera exatamente uma conta a pagar, por isso o vencimento, o pagamento e a situação são colunas da própria compra (RN11).

**Estrutura formal:**
```
COMPRA_IMPORTACAO = @ID_COMPRA + *ID_FORNECEDOR* + NR_NUMERO_COMPRA + TP_TIPO_OPERACAO + DT_DATA_COMPRA
                  + (DT_PREVISAO_CHEGADA) + (DT_DATA_RECEBIMENTO) + VL_VALOR_TOTAL + CD_MOEDA + (DS_INCOTERM)
                  + ST_STATUS_COMPRA + 1{ ITEM_COMPRA }n + (CONTA_A_PAGAR)
CONTA_A_PAGAR     = DT_VENCIMENTO_PAGAMENTO + (DT_PAGAMENTO) + ST_STATUS_PAGAMENTO
                  / vazia quando a compra é cancelada /
```

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_COMPRA | INT | PK | Sim | AUTO_INCREMENT | Identifica a compra |
| ID_FORNECEDOR | INT | FK | Sim | → FORNECEDOR | Fornecedor cadastrado (RN10) |
| NR_NUMERO_COMPRA | VARCHAR(20) | | Sim | UNIQUE | Número da compra (ex.: IMP-2026-012, CN-2026-014) |
| TP_TIPO_OPERACAO | VARCHAR(20) | | Sim | CHECK 'Compra nacional' ou 'Importação' | Tipo da operação |
| DT_DATA_COMPRA | DATE | | Sim | | Data da compra |
| DT_PREVISAO_CHEGADA | DATE | | Não | CHECK ≥ data da compra | Previsão de chegada, que permite vender como entrega programada (RN08, RN11) |
| DT_DATA_RECEBIMENTO | DATE | | Não | Obrigatória quando a situação é 'Recebido'; ≥ data da compra | Data em que a mercadoria chegou |
| VL_VALOR_TOTAL | DECIMAL(18,2) | | Sim | CHECK > 0 | Valor total **em reais** (convertido na data da compra) |
| CD_MOEDA | CHAR(3) | | Sim | DEFAULT 'BRL'; CHECK 'BRL', 'USD', 'EUR' ou 'CNY' | Moeda da negociação (ISO 4217) |
| DS_INCOTERM | VARCHAR(3) | | Não | CHECK 'EXW', 'FOB', 'CFR', 'CIF', 'DAP' ou 'DDP'; obrigatório só na importação | Termo internacional de comércio |
| ST_STATUS_COMPRA | VARCHAR(20) | | Sim | DEFAULT 'Pendente'; CHECK 'Pendente', 'Recebido' ou 'Cancelado' | Situação da compra |
| DT_VENCIMENTO_PAGAMENTO | DATE | | Não | Obrigatória se a compra não foi cancelada | Vencimento da conta a pagar ao fornecedor (RN11) |
| DT_PAGAMENTO | DATE | | Não | Obrigatória quando o pagamento é 'Pago' | Data em que o fornecedor foi pago |
| ST_STATUS_PAGAMENTO | VARCHAR(20) | | Não | CHECK 'Pendente' ou 'Pago'; obrigatória se a compra não foi cancelada | Situação da conta a pagar |

**Índices:** PK ID_COMPRA; único em NR_NUMERO_COMPRA; secundário em ST_STATUS_COMPRA (filtro por situação); secundário em DT_DATA_COMPRA (consultas por período).

### 6.2 ITEM_COMPRA (associativa)

Resolve o N:N "PRODUTO inclui COMPRA / IMPORTAÇÃO".

**Estrutura formal:** `ITEM_COMPRA = @*ID_COMPRA* + @*ID_PRODUTO* + QT_COMPRADA + VL_CUSTO_UNITARIO_COMPRA`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_COMPRA | INT | PK, FK | Sim | → COMPRA_IMPORTACAO (ON DELETE CASCADE) | Compra a que o item pertence |
| ID_PRODUTO | INT | PK, FK | Sim | → PRODUTO | Produto comprado |
| QT_COMPRADA | INT | | Sim | CHECK > 0 | Quantidade comprada |
| VL_CUSTO_UNITARIO_COMPRA | DECIMAL(10,2) | | Sim | CHECK > 0 | Custo unitário na compra |

**Índices:** PK composta (ID_COMPRA, ID_PRODUTO).

---

## 7. Log de acesso e matriz LGPD

### 7.1 LOG_ACESSO

Tabela técnica de auditoria (RNF04 e LGPD, art. 6º, X — responsabilização). Registra quem leu ou alterou dados. O usuário é guardado por login e perfil, e não por FK, porque quem acessa também pode ser do financeiro, do faturamento, de compras ou do RH, que não estão em COLABORADOR (equipe comercial). Por não ser dado do negócio, não aparece no DER.

**Estrutura formal:** `LOG_ACESSO = @ID_LOG + NM_USUARIO + DS_PERFIL + DT_ACESSO + DS_OPERACAO + DS_TABELA_AFETADA + (NR_ID_REGISTRO)`

| Coluna | Tipo | Chave | Obrigatório | Restrição / padrão | Descrição |
| :---- | :---- | :---- | :---- | :---- | :---- |
| ID_LOG | INT | PK | Sim | AUTO_INCREMENT | Identifica o registro de acesso |
| NM_USUARIO | VARCHAR(60) | | Sim | | Login de quem acessou |
| DS_PERFIL | VARCHAR(20) | | Sim | CHECK 'Vendedor', 'Financeiro', 'Faturamento', 'Compras', 'RH' ou 'Administrador' | Perfil de acesso do usuário |
| DT_ACESSO | DATETIME | | Sim | | Data e hora do acesso |
| DS_OPERACAO | VARCHAR(10) | | Sim | CHECK 'Ler', 'Inserir', 'Atualizar' ou 'Apagar' | Operação realizada |
| DS_TABELA_AFETADA | VARCHAR(30) | | Sim | | Tabela acessada |
| NR_ID_REGISTRO | INT | | Não | | Chave do registro acessado, quando houver |

**Índices:** PK ID_LOG; secundário em DT_ACESSO; secundário em DS_TABELA_AFETADA.

A consulta **A13** do script aponta acessos fora da permissão do perfil, e a **A14** mostra quem acessou os dados de clientes no mês.

### 7.2 Papéis por operação, base legal e retenção

| Tabela | Perfil | Ler | Inserir | Atualizar | Apagar | Base legal (LGPD, art. 7º) | Retenção |
| :---- | :---- | :----: | :----: | :----: | :----: | :---- | :---- |
| CLIENTE | Vendedor | ✔ | ✔ | ✔ | | Execução de contrato (V) | Enquanto ativo + 5 anos |
| CLIENTE | Financeiro | ✔ | | ✔ | | Proteção do crédito (X) | 5 anos após a quitação |
| COLABORADOR | RH | ✔ | ✔ | ✔ | ✔ | Obrigação legal (II) | Prazos da legislação trabalhista e previdenciária |
| PEDIDO, ITEM_PEDIDO | Vendedor | ✔ | ✔ | | | Execução de contrato (V) | 5 anos (documento fiscal) |
| NOTA_FISCAL | Faturamento | ✔ | ✔ | ✔ | | Obrigação legal (II) | 5 anos (documento fiscal) |
| TITULO_RECEBER | Financeiro, Faturamento | ✔ | ✔ | ✔ | | Execução de contrato (V) e proteção do crédito (X) | 5 anos após a quitação |
| COMPRA_IMPORTACAO, ITEM_COMPRA | Compras, Financeiro | ✔ | ✔ | ✔ | | Execução de contrato (V) e obrigação legal (II) | 5 anos (documento fiscal) |
| PRODUTO, FORNECEDOR | Compras | ✔ | ✔ | ✔ | | Não é dado pessoal (CNPJ é de pessoa jurídica) | Enquanto ativo |
| LOG_ACESSO | Administrador | ✔ | ✔ | | | Legítimo interesse / segurança (IX) | 6 meses (Marco Civil da Internet, art. 15) |

**Regras gerais:**
- O perfil **Administrador** gerencia usuários e lê o log, mas não altera dados do negócio.
- **Apagar** só existe para RH (correção de cadastro de colaborador). Pedidos, notas e títulos nunca são apagados: são cancelados e o histórico permanece (RNF02). As FKs do banco impedem apagar registros com histórico.
- Dados pessoais de colaboradores (CPF, nascimento, endereço) só são lidos pelo RH. Qualquer outro perfil acessando COLABORADOR aparece na auditoria A13.

---


