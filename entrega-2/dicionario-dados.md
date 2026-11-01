## 5. Dicionário de Dados Conceitual

O dicionário de dados conceitual reúne a documentação das entidades que formam o modelo de dados do sistema: ***CLIENTE, COLABORADOR, PRODUTO, FORNECEDOR ,PEDIDO e NOTA FISCAL*** cada uma descrita por meio de sua estrutura formal, da leitura dos atributos e de uma tabela com os respectivos tipos físicos, obrigatoriedade e significado.

**Controlo de Versão e Configuração:**
* **Versão do Dicionário:** 1.1
* **Data de Atualização:** 26/10/2026
* **SGBD Alvo:** MySQL 8.0
* **Collation (`utf8mb4_0900_ai_ci`):** Justifica-se o uso por suportar o padrão completo UTF-8 de 4 bytes (incluindo símbolos), sendo *accent-insensitive* (`ai`) e *case-insensitive* (`ci`), o que otimiza buscas por Razão Social e Endereços sem diferenciar letras maiúsculas/minúsculas ou acentos.
  
*Notação Formal:*
| Símbolo | Significado e Aplicação |
| :--- | :--- |
| = | é composto de (define a estrutura da entidade) |
| + | e (conecta elementos obrigatórios) |
| () | opcional (campos que podem ser nulos) |
| [] | escolha obrigatória entre alternativas exclusivas |
| {} | iteração / grupo repetitivo |
| @ | identificador (chave primária) |
| / / | delimitadores de comentários ou restrições |
| * * | indicadores de chave estrangeira (FK) |

## 5.1 CLIENTE (PJ)

A entidade **CLIENTE** representa o armazenamento das informações das pessoas jurídicas que consomem os produtos e serviços da empresa.


### Estrutura Formal

**CLIENTE = @ID_CLIENTE + NM_RAZAO_SOCIAL + NR_CNPJ + NR_INSCRIC_ESTADUAL + ENDERECO + DS_EMAIL + TELEFONE + VL_LIMITE_CREDITO + IN_ATIVO + ID_SERASA + DT_DATA_DE_ATUALIZACAO**

**ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + DS_COMPLEMENTO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**


### Leitura da Estrutura

`@ID_CLIENTE` é a chave primária (**PK**) e identifica de forma única e exclusiva cada registro de cliente no sistema.

`NM_RAZAO_SOCIAL` representa o nome empresarial do cliente. `NR_CNPJ` armazena o número do CNPJ. `NR_INSCRIC_ESTADUAL` armazena o número da inscrição estadual, quando aplicável.

`ENDERECO` é um atributo composto que reúne os dados de localização do cliente, sendo decomposto em `CD_CEP` (código postal), `CD_UF` (sigla do estado), `DS_CIDADE` (cidade), `DS_BAIRRO` (bairro), `DS_RUA` (rua), `NR_NUMERO` (número) e `DS_COMPLEMENTO` (complemento).

`DS_EMAIL` armazena o e-mail empresarial utilizado para contato e identificação no sistema.

`TELEFONE` é um atributo composto que reúne os dados de contato telefônico do cliente, sendo decomposto em `CD_DDD` (código de área) e `NR_NUMERO_TEL` (número do telefone).

`VL_LIMITE_CREDITO` representa o limite de crédito concedido ao cliente. `IN_ATIVO` indica se o cadastro está ativo. `ID_SERASA` permite associar o cliente ao histórico de crédito no Serasa.

`DT_DATA_DE_ATUALIZACAO` registra os dados da última atualização das informações do cadastro.


### Atributos da Entidade CLIENTE

| **Atributo** | **Tipo Físico** | **Obrigatório** | **Descrição** |
|---|---|---|---|
| **ID_CLIENTE** | Número inteiro | Sim (PK) | Identifica de forma única e exclusiva cada registro de cliente no sistema. |
| **NM_RAZAO_SOCIAL** | Varchar(100) | Sim | Representa o nome empresarial do cliente. |
| **NR_CNPJ** | Varchar(18) | Sim | Armazena o número do CNPJ. |
| **NR_INSCRIC_ESTADUAL** | Varchar(20) | Não | Armazena o número da inscrição estadual, quando aplicável. |
| **CD_CEP** | Varchar(9) | Sim | Armazena o código de endereçamento postal do cliente. |
| **CD_UF** | Char(2) | Sim | Armazena a sigla da unidade federativa do endereço do cliente. |
| **DS_CIDADE** | Varchar(100) | Sim | Armazena a cidade do endereço do cliente. |
| **DS_BAIRRO** | Varchar(100) | Sim | Armazena o bairro do endereço do cliente. |
| **DS_RUA** | Varchar(150) | Sim | Armazena o nome da rua do endereço do cliente. |
| **NR_NUMERO** | Varchar(10) | Sim | Armazena o número do endereço do cliente. |
| **DS_COMPLEMENTO** | Varchar(100) | Não | Armazena informações complementares do endereço, quando aplicável. |
| **DS_EMAIL** | Varchar(100) | Sim | Armazena o e-mail empresarial utilizado para contato e identificação no sistema. |
| **CD_DDD** | Char(2) | Sim | Armazena o código de área do telefone do cliente. |
| **NR_NUMERO_TEL** | Varchar(10) | Sim | Armazena o número do telefone do cliente. |
| **VL_LIMITE_CREDITO** | Decimal(15,2) | Sim | Representa o limite de crédito concedido ao cliente. |
| **IN_ATIVO** | Booleano | Sim | Indica se o cadastro está ativo. |
| **ID_SERASA** | Varchar(50) | Sim | Permite associar o cliente ao histórico de crédito no Serasa. |
| **DT_DATA_DE_ATUALIZACAO** | Data | Sim | Registra a data da última atualização das informações do cadastro. |

### Índices

**Índices:** PK `ID_CLIENTE` (clusterizado); índice único em `NR_CNPJ` (impedir o cadastro duplicado de clientes); índice secundário em `NM_RAZAO_SOCIAL` (busca de clientes pela razão social); índice secundário em `DT_DATA_DE_ATUALIZACAO` (identificação de cadastros sem atualização há mais de 90 dias).

## 5.2 COLABORADOR

A entidade **COLABORADOR** representa a coleta de dados operacionais, contratuais e funcionais para a atuação do profissional no sistema.


### Estrutura Formal

**COLABORADOR = @ID_COLABORADOR + NM_COLABORADOR + NR_CPF + DT_DATA_DE_NASCIMENTO + DS_ENDERECO + DS_EMAIL + TELEFONE + DS_COMISSAO**

**ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + DS_COMPLEMENTO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**


### Leitura da Estrutura

`@ID_COLABORADOR` é a chave primária (**PK**) e identifica de forma única o colaborador no sistema.

`NM_COLABORADOR` representa o nome completo do colaborador. `NR_CPF` armazena o número do CPF do colaborador. `DT_DATA_DE_NASCIMENTO` registra a data de nascimento do colaborador.
`DS_EMAIL` armazena o e-mail do colaborador. `TELEFONE` é um atributo composto formado por `CD_DDD` e `NR_NUMERO_TEL`.

`ENDERECO` é um atributo composto que reúne os dados de localização do colaborador, sendo decomposto em `CD_CEP`, `CD_UF`, `DS_CIDADE`, `DS_BAIRRO`, `DS_RUA`, `NR_NUMERO` e `DS_COMPLEMENTO`.

`TELEFONE` é um atributo composto formado por `CD_DDD` e `NR_NUMERO_TEL`, utilizado para armazenar o telefone de contato do colaborador.

`DS_COMISSAO` representa a porcentagem de comissão de venda atribuída ao colaborador.


### Atributos da Entidade COLABORADOR

| **Atributo** | **Tipo Físico** | **Obrigatório** | **Descrição** |
|---|---|---|---|
| **ID_COLABORADOR** | Número inteiro | Sim (PK) | Identifica de forma única o colaborador no sistema. |
| **NM_COLABORADOR** | Varchar(120) | Sim | Representa o nome completo do colaborador. |
| **NR_CPF** | Varchar(14) | Sim | Armazena o número do CPF do colaborador. |
| **DT_DATA_DE_NASCIMENTO** | Data | Sim | Registra a data de nascimento do colaborador. |
| **DS_EMAIL** | Varchar(100) | Sim | Armazena o e-mail utilizado para contato e identificação no sistema. |
| **CD_CEP** | Varchar(9) | Sim | Armazena o código postal do colaborador. |
| **CD_UF** | Char(2) | Sim | Armazena a sigla do estado do colaborador. |
| **DS_CIDADE** | Varchar(100) | Sim | Armazena a cidade do colaborador. |
| **DS_BAIRRO** | Varchar(100) | Sim | Armazena o bairro do colaborador. |
| **DS_RUA** | Varchar(150) | Sim | Armazena a rua do colaborador. |
| **DS_COMPLEMENTO** | Varchar(100) | Não | Armazena informações complementares do endereço do colaborador. |
| **CD_DDD** | Char(2) | Sim | Armazena o código de área do telefone do colaborador. |
| **NR_NUMERO_TEL** | Varchar(14) | Sim | Armazena o número de telefone do colaborador. |
| **DS_COMISSAO** | Numérico(5,2) | Sim | 'Interno' ou 'Externo' — define a alçada de comissão (3% ou 8%) aplicada pela RN12

### Índices

**Índices:** PK `ID_COLABORADOR` (clusterizado); índice único em `NR_CPF` (impede o cadastro duplicado do colaborador); índice secundário em `NM_COLABORADOR` (facilita a busca de colaboradores pelo nome).

## 5.3 PRODUTO

A entidade **PRODUTO** representa o cadastro dos produtos registrados no sistema. 
Suas informações são utilizadas para identificação, classificação, controle de preços 
e acompanhamento da quantidade disponível em estoque.


- ### Estrutura Formal
**PRODUTO = @ID_PRODUTO + CD_SKU + CD_NCM + VL_PRECO_CUSTO + VL_PRECO_UNITARIO + QT_ESTOQUE + DS_DESCRICAO**

- ### Leitura da Estrutura

`@ID_PRODUTO` representa o identificador único do produto no sistema. 
`CD_SKU` corresponde ao código interno utilizado para identificação e controle do produto. 
`CD_NCM` armazena a classificação fiscal,

`VL_PRECO_CUSTO` e `VL_PRECO_UNITARIO` armazenam, respectivamente, os valores de custo 
unitário de venda do produto. `QT_ESTOQUE` indica a quantidade disponível em estoque. `DS_DESCRICAO` descreve o produto cadastrado no sistema.

- ### Atributos da Entidade PRODUTO

| Atributo | Tipo físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_PRODUTO** | Integer | Sim (PK) | Identifica de forma única cada produto cadastrado no sistema. |
| **CD_SKU** | Varchar(30) | Sim | Identifica o produto por meio de um código interno utilizado para controle e organização do estoque. |
| **CD_NCM** | Varchar(10) | Sim | Armazena o código NCM utilizado para a classificação fiscal do produto. |
| **VL_PRECO_CUSTO** | Numeric(10,2) | Sim | Representa o valor de custo do produto para a empresa. |
| **VL_PRECO_UNITARIO** | Numeric(10,2) | Sim | Representa o valor unitário pelo qual o produto será comercializado. |
| **QT_ESTOQUE** | Integer | Sim | Indica a quantidade disponível do produto em estoque. |  
| **DS_DESCRICAO** | Varchar(150) | Sim | Descrição do produto que está sendo adquirido. |

### Índices

**Índices:** PK `ID_PRODUTO` (clusterizado); índice único em `CD_SKU` (garante a identificação exclusiva do produto); índice secundário em `CD_NCM` (facilita consultas pela classificação fiscal do produto).

## 5.4 FORNECEDOR

A entidade **FORNECEDOR** representa o fornecedor responsável pelo fornecimento de produtos para a empresa.

-

### Estrutura Formal

**FORNECEDOR = @ID_FORNECEDOR + NR_CNPJ + NM_RAZAO_SOCIAL + NR_INSCRIC_ESTADUAL + DS_EMAIL + TELEFONE + ENDERECO**

**ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO_ENDERECO + DS_COMPLEMENTO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**

-

### Leitura da Estrutura

`@ID_FORNECEDOR` é a chave primária (**PK**) e identifica de forma única o fornecedor no sistema.

`NR_CNPJ` armazena o CNPJ do fornecedor. `NM_RAZAO_SOCIAL` representa a razão social do fornecedor. `NR_INSCRIC_ESTADUAL` armazena o número de inscrição estadual da empresa, quando aplicável.

`DS_EMAIL` armazena o e-mail do fornecedor. `TELEFONE` é um atributo composto formado por `CD_DDD` e `NR_NUMERO_TEL`.

`ENDERECO` é um atributo composto que reúne os dados de localização do fornecedor, sendo decomposto em `CD_CEP`, `CD_UF`, `DS_CIDADE`, `DS_BAIRRO`, `DS_RUA`, `NR_NUMERO_ENDERECO` e `DS_COMPLEMENTO`.

-

### Atributos da Entidade FORNECEDOR

| **Atributo** | **Tipo Físico** | **Obrigatório** | **Descrição** |
|---|---|---|---|
| **ID_FORNECEDOR** | Número inteiro | Sim (PK) | Identifica de forma única o fornecedor no sistema. |
| **NR_CNPJ** | Varchar(18) | Sim | Armazena o CNPJ do fornecedor. |
| **NM_RAZAO_SOCIAL** | Varchar(100) | Sim | Representa a razão social do fornecedor. |
| **NR_INSCRIC_ESTADUAL** | Varchar(20) | Não | Armazena o número de inscrição estadual da empresa, quando aplicável. |
| **DS_EMAIL** | Varchar(100) | Sim | Armazena o e-mail do fornecedor. |
| **CD_CEP** | Varchar(9) | Sim | Armazena o código postal do fornecedor. |
| **CD_UF** | Char(2) | Sim | Armazena a sigla do estado do fornecedor. |
| **DS_CIDADE** | Varchar(100) | Sim | Armazena a cidade do fornecedor. |
| **DS_BAIRRO** | Varchar(100) | Sim | Armazena o bairro do fornecedor. |
| **DS_RUA** | Varchar(150) | Sim | Armazena a rua do fornecedor. |
| **NR_NUMERO_TEL** | Varchar(10) | Sim | Armazena o número do endereço do fornecedor. |
| **DS_COMPLEMENTO** | Varchar(100) | Não | Armazena informações complementares do endereço do fornecedor. |
| **CD_DDD** | Char(2) | Sim | Armazena o código de área do telefone do fornecedor. |
| **NR_NUMERO_ENDERECO** | Varchar(10) | Sim | Armazena o número do endereço do fornecedor. |

### Índices

**Índices:** PK `ID_FORNECEDOR` (clusterizado); índice único em `NR_CNPJ` (impede o cadastro duplicado do fornecedor); índice secundário em `NM_RAZAO_SOCIAL` (facilita a busca de fornecedores pela razão social).
## 5.5 PEDIDO
A entidade **PEDIDO** representa a separação de produtos e quantidades de itens que o cliente solicitou.

- ### Estrutura Formal
**PEDIDO = @ID_PEDIDO + ID_CLIENTE + ID_COLABORADOR + DT_DATA_DO_PEDIDO + VL_VALOR_VENDA + DS_TIPO_DE_FRETE + DS_FORMA_DE_PAGAMENTO + VL_DESCONTO_APLICADO + DS_STATUS_PEDIDO** 

- ### Leitura da Estrutura
`@ID_PEDIDO` Identifica o pedido solicitado no sistema 
`ID_CLIENTE` Vincula o pedido ao cliente solicitante do pedido. 
`ID_COLABORADOR` Vincula o pedido ao colaborador responsável.
`DT_DATA_DO_PEDIDO` Informativo da data em que o pedido foi solicitado.
`VL_VALOR_VENDA` Valor de venda do pedido solicitado pelo cliente.
`DS_TIPO_FRETE` Descreve a forma de frete se transportadora ou correios para entrega do produto. 
`DS_FORMA_DE_PAGAMENTO` Descreve a forma de pagamento que o cliente escolheu pagar pelo produto.  
`VL_DESCONTO_APLICADO` Valor da porcentagem da porcentagem de desconto aplicada no pedido.
 `DS_STATUS_PEDIDO` Descreve o status do pedido e em qual etapa do processo que o pedido está.

- ### Atributos da Entidade PEDIDO

| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_PEDIDO** | Integer | Sim (PK) | Identifica o pedido solicitado no sistema. |
| **ID_CLIENTE** | Número inteiro | Sim (FK) | Vincula o pedido ao cliente solicitante do pedido. |
| **ID_COLABORADOR** | Número inteiro | Sim (FK) | Vincula o pedido ao colaborador responsável. |
| **DT_DATA_DO_PEDIDO** | Date | Sim | Informativo da data em que o pedido foi solicitado. |
| **VL_VALOR_VENDA** | Decimal(18,2) | Sim | Valor de venda do pedido solicitado. |
| **DS_TIPO_DE_FRETE** | Varchar(30) | Sim | Descreve a forma de frete se transportadora ou correios para entrega do produto.   |
| **DS_FORMA_DE_PAGAMENTO** | Varchar(50) | Sim  | Descreve a forma de pagamento que o cliente escolheu pagar pelo produto.    |
| **VL_DESCONTO_APLICADO** | Decimal(8,2) | Sim | Valor da porcentagem de desconto aplicada no pedido.  |
| **DS_STATUS_PEDIDO** | Varchar(30) | Sim | Descreve o status do pedido e em qual etapa do processo que o pedido está.|

### Índices

**Índices:** PK `ID_PEDIDO` (clusterizado); índice secundário em `DT_DATA_DO_PEDIDO` (consulta de pedidos por período); índice secundário em `DS_STATUS_PEDIDO` (consulta de pedidos conforme seu status).

## 5.6 NOTA_FISCAL
A entidade **NOTA_FISCAL** representa o documento fiscal gerado a partir de um pedido já faturado, contendo os dados legais e tributários exigidos para a emissão da nota.

- ### Estrutura Formal
**NOTA_FISCAL= @ID_NF + ID_PEDIDO + NR_NF + NR_CHAVE_ACESSO + DT_DATA_EMISSAO + VL_IMPOSTO_IMPORTACAO + VL_TOTAL_IMPOSTOS + VL_TOTAL_NF + DS_STATUS_NF**

- ### Leitura da Estrutura
`@ID_NF` identifica a nota fiscal no sistema. 
`ID_PEDIDO `vincula a nota ao pedido que a originou , é essa referência que evita duplicar, na nota, os dados do cliente e dos produtos já registrados no pedido. 
`NR_NF` é o número sequencial da nota emitida.
`NR_CHAVE_ACESSO` é o código de 44 dígitos que identifica a NF-e perante a Receita.
`DT_DATA_EMISSAO` informa a data em que a nota foi emitida. 
`VL_IMPOSTO_IMPORTACAO` registra o valor de imposto de importação incidente, quando aplicável.
`VL_TOTAL_IMPOSTOS` soma todos os tributos da nota. 
`VL_TOTAL_NF` é o valor final faturado, já com os impostos inclusos.
`DS_STATUS_NF` indica se a nota foi emitida ou ainda necessário imprimir.

- ### Atributos da Entidade NOTA FISCAL

| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_NF**| Integer | Sim (PK) | Identifica a nota fiscal no sistema. |
| **ID_PEDIDO** | Integer | Sim (FK) | Vincula a nota fiscal ao pedido que a originou. |
| **NR_NF** | Integer | Sim (único) | Número sequencial da nota fiscal emitida. |
| **NR_CHAVE_ACESSO** | Varchar(44) | Sim (único) | Código de acesso da NF-e, exigido pela Receita Federal. |
| **DT_DATA_EMISSAO** | Date | Sim | Data em que a nota fiscal foi emitida. | 
| **VL_IMPOSTO_IMPORTACAO** | Decimal(18,2) | Não | Valor de imposto de importação, quando o produto faturado for de origem importada,(nem todo produto importado tem IPI, como tecido e Rattan) |
| **VL_TOTAL_IMPOSTOS** | Decimal(18,2) | Sim | Soma de todos os tributos incidentes na nota. |
| **VL_TOTAL_NF** | Decimal(18,2) | Sim | Valor total da nota fiscal, incluindo os impostos. |
| **DS_STATUS_NF** | Varchar(20) | Sim | Descreve o status da nota fiscal, 'Emitida' ou 'Cancelada'. |
| **DT_PAGAMENTO** | Data | Não | Preenchido quando cliente quita boleto. |
| **DS_STATUS_RECEBIMENTO** | Varchar(20) | Sim | Pendente ou pago- controla a liberação da comissão (RN12). |


### Índices

**Índices:** PK `ID_NF` (clusterizado); índice único em `ID_PEDIDO` (garante a relação 1:1 entre pedido e nota fiscal); índice único em `NR_NF` (impede números de nota fiscal duplicados); índice único em `NR_CHAVE_ACESSO` (garante a unicidade da chave de acesso da NF-e); índice secundário em `DT_DATA_EMISSAO` (consulta de notas fiscais por período).



## 5.7 ITEM_PEDIDO (Entidade Associativa)
A entidade ITEM_PEDIDO resolve o relacionamento N:N entre Pedido e Produto, registrando a quantidade comercializada e congelando o preço histórico, garantindo conformidade com o RF05.

*Estrutura Formal*
ITEM_PEDIDO = @ID_ITEM + ID_PEDIDO + ID_PRODUTO + QT_VENDIDA + VL_PRECO_UNITARIO_PRATICADO

*Atributos da Entidade ITEM_PEDIDO*
| Atributo | Tipo Físico | Obrigatório | Descrição |
| :--- | :--- | :--- | :--- |
| ID_ITEM | Integer | Sim (PK) | Identificador único da linha do item associativo. |
| ID_PEDIDO | Integer | Sim (FK) | Vínculo com o pedido correspondente. |
| ID_PRODUTO | Integer | Sim (FK) | Vínculo com o produto comercializado. |
| QT_VENDIDA | Integer | Sim | Quantidade de peças do item inseridas no pedido. |
| VL_PRECO_UNITARIO_PRATICADO| Decimal(10,2)| Sim | Preço de venda congelado no momento da emissão. |

*Índices:* PK ID_ITEM (clusterizado); índice secundário em ID_PEDIDO; índice secundário em ID_PRODUTO.

## 5.8 LOG_ACESSO e Tabela de Papéis por Operação (Matriz LGPD)
Para suportar o RNF04 (Acesso Restrito) e o Princípio da Responsabilização da LGPD, a entidade LOG_ACESSO audita quem acessa os dados, cruzada com a Matriz de Retenção e Papéis.

*Estrutura Formal*
LOG_ACESSO = @ID_LOG + ID_COLABORADOR + DT_ACESSO + DS_OPERACAO + DS_TABELA_AFETADA

*Matriz de Operações, Base Legal e Retenção:*
| Entidade Alvo | Papel / Perfil | Operações (CRUD) | Base Legal (Art. 7º LGPD) | Tempo de Retenção |
| :--- | :--- | :--- | :--- | :--- |
| *CLIENTE* | Vendedor / Rep. | Ler, Inserir, Atualizar | Execução de Contrato (Inciso V) | Enquanto ativo + 5 anos (Código Civil) |
| *CLIENTE* | Financeiro | Ler, Atualizar | Proteção ao Crédito (Inciso X) | 5 anos pós-quitação |
| *COLABORADOR*| RH / Diretoria | Ler, Inserir, Atualizar, Apagar| Obrigação Legal (Inciso II) | 30 anos (Legislação Trabalhista) |
| *PEDIDO / NF*| Faturamento | Ler, Inserir | Obrigação Legal (Inciso II) | 5 anos fiscais |
| *LOG_ACESSO* | Administrador | Ler, Inserir | Legítimo Interesse / Segurança | 6 meses (Marco Civil da Internet) |

## 5.9 COMPRA_IMPORTACAO
A entidade **COMPRA_IMPORTACAO** representa o registro da compra ou importação realizada pela empresa, reunindo as informações comerciais, fiscais, legais e tributárias necessárias para formalizar a operação, controlar o pedido e acompanhar o recebimento dos produtos.

 ### Estrutura Formal

**COMPRA_IMPORTACAO = @ID_COMPRA + ID_FORNECEDOR + NR_COMPRA + DS_STATUS + DS_OPERACAO + DT_COMPRA + DT_PREVISTA _CHEGADA + DT_RECEBIMENTO + MOEDA + VLR_TOTAL + DS_INCOTERM**

- ### Leitura da Estrutura 
`@ID_COMPRA` chave primária exclusiva que identifica cada compra no sistema
`ID_FORNECEDOR` referência ao fornecedor que realizou a venda/importação.
`NR_COMPRA` número ou código da compra/importação. 
`DS_STATUS` indica a situação atual da compra (ex: 'Aberta', 'Recebida', 'Concluída', 'Cancelada').
`DS_OPERACAO` tipo da operação, por exemplo, 'Importação', 'Compra nacional'.
`DT_COMPRA` data em que o pedido de compra foi realizado.
`DT_PREVISTA_CHEGADA` data prevista em que os produtos iram chegar.
`DT_RECEBIMENTO` data em que os produtos foram recebidos.
`MOEDA` moeda utilizada na compra (ex: BRL, USD, EUR).
`VLR_TOTAL` valor total da compra na moeda especificada.
`DS_INCOTERM` termo internacional de comércio aplicado na importação

### Atributos da Entidade COMPRA_IMPORTACAO
| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_COMPRA**| Integer | Sim (PK) | Identifica de forma única e exclusiva cada compra/importação no sistema. |
| **ID_FONECEDOR** | Integer | Sim (FK) | Referência ao fornecedor responsável pela compra/importação.|
| **NR_COMPRA** | Vachar(50) | Sim  | Número ou código atribuído à compra/importação. |
| **DS_STATUS** | Varchar(20) | Sim  | Status atual da compra ('Aberta', 'Recebida', 'Concluída', etc.). |
| **DS_OPERACAO** | Vachar(20) | Sim | Tipo da operação ('Importação', 'Compra nacional', etc.). | 
| **DT_COMPRA** | Data | Sim | Data em que foi efetuada a compra do pedido |
| **DT__PREVISTA_CHEGADA** | Data | Sim | Data prevista em que os produtos iram chegar. |
| **DT_RECEBIMENTO** | Data | Sim | Data em que os produtos foram recebidos. |
| **MOEDA** | Char(3) | Sim | Código da moeda utilizada na compra (ex: BRL, USD, EUR). |
| **VLR_TOTAL** | Varchar(18,2) | Sim | Valor total da compra na moeda especificada. |
| **DS_INCOTERM** | Varchar(10) | Sim | Termo internacional de comércio aplicado na importação. |

### Índices

**Índices:** PK `ID_COMPRA` (clusterizado): Identificação única da compra; índice único composto `ID_FORNECEDOR` e `NR_COMPRA`  Evita registro duplicado do mesmo número de pedido para o mesmo fornecedor; Índice secundário em `DS_STATUS`  Facilita consultas e filtros por situação da compra; Índice secundário em `DT_COMPRA` Permite consultas por período e intervalos de datas.


