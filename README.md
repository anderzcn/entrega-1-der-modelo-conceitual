# Entrega 1 — Modelo Conceitual (DER)

### Modelagem de um sistema de gestão de vendas, crédito e estoque para a Rafimex - Mesa Posta e Decorações


## Metadados

| NOME | RGM |
|---|---|
| **Anderson Rafael da Silva** | **49031937** |
| **Leticia Souza Santos** | **49439286** |
| **Maria Eduarda Sobrinho dos Santos** | **49020595** |
| **Nathan Vieira De Lara** | **49462725** |
| **Ketlyn Nayara da Silva Cezar** | **48862347** |
## Introdução

Este projeto tem como objetivo desenvolver o Modelo Conceitual de Banco de Dados para a Rafimex - Mesa Posta e Decorações, uma empresa atacadista que vende artigos de mesa posta e decoração para outras empresas (B2B).

A Rafimex já opera com regras de negócio bem definidas para crédito, desconto e controle de estoque futuro ,como análise de crédito para venda no boleto, restrição automática para clientes com pendências no Serasa ou internas, com descontos de até 4% liberado para representante conceder ao cliente , e sinalização de estoque futuro com previsão de chegada. O problema real que encontramos está em outro lugar: o cadastro de clientes é feito manualmente pelo representante, e quando um cliente fica um tempo sem comprar, informações como telefone, e-mail e endereço podem ficar desatualizadas sem que ninguém perceba ,o que já gerou casos de boleto não recebido e cobrança de taxa de reentrega por mudança de endereço não informada. Pior ainda, esse problema só é percebido depois que já causou prejuízo: hoje não existe nada que avise a empresa, com antecedência, quais cadastros estão parados há muito tempo sem confirmação.

O objetivo deste trabalho é modelar um banco de dados que represente corretamente as regras que a Rafimex já segue, e que resolva esse problema específico de cadastro desatualizado de forma preventiva, avisando antes que vire prejuízo, e não só depois.

O escopo deste projeto é a modelagem conceitual: mapear clientes, equipe comercial (interna e externa), catálogo de produtos, fornecedores e pedidos de venda, incluindo o controle de preço praticado e produtos que ainda estão a caminho (importação). A implementação do banco de dados em si fica para a Entrega 2.

## 1. Caracterização da Organização

 - **Nome e natureza da organização:** Rafimex Comercial Importação e Exportação Ltda, conhecida comercialmente como Rafimex  Mesa Posta e Decorações, empresa privada com fins lucrativos que atua no comércio atacadista de utilidades domésticas e decoração,com parte do catálogo vindo de produtos importados.
 
 - **Contexto e porte:** A empresa está no mercado há 35 anos. Hoje conta com 14 funcionários internos ,5 na expedição, 2 auxiliares administrativos,além de 1 faturamento, 1 contas a pagar,1 financeiro, 2 vendedores internos, diretoria  e 20 representantes comerciais externos espalhados pelo Brasil. A carteira de clientes é de aproximadamente 10.000 empresas ativas, o catálogo tem cerca de 1.550 produtos, e o volume de vendas gira em torno de 5 a 10 pedidos por dia (140 a 200 por mês).

 
 - **Problemas e necessidades identificados:** Na visita, vimos que o principal ponto de melhoria não está nas regras comerciais da empresa ,que já são claras e bem aplicadas (crédito, desconto, estoque futuro) ,**mas no processo de manutenção do cadastro dos clientes. Como esse cadastro é atualizado manualmente pelo representante, só quando ele lembra de perguntar, clientes que compram com pouca frequência correm o risco de ficar com dados de contato desatualizados. Isso já causou boleto não entregue por telefone/e-mail errado, causando em casos mais graves até cnpj indo para cartório e cobrança de taxa de reentrega por mudança de endereço não avisada. E o pior: a empresa só descobre isso depois que já deu problema, porque não existe hoje nenhum aviso prévio de quais cadastros estão desatualizados.**
   
**Soluções para o problema previsto**
 
- Portal de Confirmação Ativa:
Disponibilizar links automáticos de validação por WhatsApp ou e-mail, permitindo que o cliente confirme previamente seus dados de contato e o endereço de entrega antes da emissão da nota fiscal.

- Alertas e Travas Sistemáticas: Implementar uma consulta ou visualização que sinalize clientes com dados desatualizados há mais de 90 dias ou sem compras recentes, exigindo que o representante realize a validação das informações antes de prosseguir com o lançamento de um novo pedido.
   

 - **Justificativa da escolha:** Escolhemos a Rafimex por ser uma empresa real, de porte médio-grande, com volume de dados suficiente para justificar uma modelagem robusta, mas ainda viável de mapear no prazo da disciplina. Além disso, uma das integrantes do grupo, Letícia, trabalha na Rafimex e tem acesso direto ao dia a dia da empresa, o que ajudou a entender os problemas reais descritos aqui.
 - **Evidências da organização:** 
  - *Localização:* [Visualizar Rafimex no Google Maps](https://maps.app.goo.gl/PDXnt86jRLMjDYKF8)
  - *Endereço e Contato:* [R. Barra do Tibagi, 537 - Bom Retiro, São Paulo - SP, 01128-000 | Tel: (11) 99471-1531- Gabriel Gedanken- DIRETOR COMERCIAL]
    -**Registro visual:** [FOTOS DE VISITAÇÃO](https://github.com/leticiasantoslht-cmyk/Docs-Rafimex2.git) 
## 2. Processos de Negócio
- **Cadastro de clientes:** só empresas (CNPJ) podem se cadastrar como clientes, e o cadastro deveria passar por revalidação periódica.

- **Análise de crédito:** antes de aprovar um pedido no boleto, o Financeiro verifica se o cliente tem restrição no Serasa ou pendência com a própria Rafimex, bloqueando a venda ou limitando a forma de pagamento conforme o caso.

- **Emissão de pedidos:** todo pedido é aberto vinculado a um cliente e a um representante, com desconto aplicado dentro da alçada permitida (até 4%, acima disso precisa de aprovação da diretoria) e a modalidade de entrega definida.

- **Controle de estoque:** a empresa separa o que já está fisicamente disponível no galpão ("Disponível/Reservado") do que ainda está vindo de importação ("Entrega Programada"), mostrando a data prevista de chegada no orçamento.

**Fluxogramas:** 
 ### Requisitos do Sistema   
**Requisitos Funcionais**
- RF01 — O sistema só pode cadastrar clientes com CNPJ válido e único.
- RF02 —O sistema deve bloquear vendas a prazo (boleto) para clientes com restrição cadastral ativa (Serasa) e suspender qualquer modalidade de venda para inadimplentes diretos com a Rafimex.  
- RF03: Todo pedido de venda deve ser obrigatoriamente associado a um cliente e a um colaborador 
- RF04 — Descontos acima de 4% exigem aprovação registrada da diretoria.
- RF05 — O valor cobrado em cada item do pedido deve ficar registrado permanentemente, sem mudar depois.
- RF06 — O sistema deve registrar a modalidade de entrega (retirada na empresa ou transportadora).
- RF07 — Cada item do pedido deve indicar se está disponível em estoque ou é entrega programada (com data estimada de chegada).
- RF08 — O sistema deve monitorar o ponto de pedido dos produtos para emissão de alertas preventivos de reposição de estoque.
- RF09 — O sistema deve sinalizar e bloquear para novas emissões de Pedidos, os cadastros de clientes com data de atualização superior a 90 dias

**Requisitos Não Funcionais**
- RNF01 — O sistema deve manter controle da data de atualização cadastral, ajudando a manter os dados em dia e em conformidade com a LGPD.
- RNF02 —O sistema deve aplicar restrições estritas de integridade (chaves estrangeiras - FK), impedindo a existência de itens sem pedido ou pedidos sem cliente vinculado, além de bloquear a exclusão de cadastros que possuam histórico de vendas.
- RNF03 — O sistema precisa funcionar bem mesmo com o volume atual (10.000 clientes, 1.550 produtos), sem travar ou ficar lento.
## 4. Regras de Negócio

- RN01 — Só empresas com CNPJ regular podem comprar da Rafimex.
- RN02 — Toda venda no boleto passa por análise de crédito antes de ser aprovada.
- RN03 — Cliente com pendência no Serasa só pode comprar à vista ou no cartão de crédito.
- RN04 — Cliente com pendência direta com a Rafimex não tem nenhuma venda liberada.
- RN05 — Todo pedido precisa ter um cliente e um representante comercial vinculados.
- RN06 — Representante aplica até 4% de desconto sozinho; acima disso, precisa de aprovação da diretoria.
- RN07 — O preço cobrado numa venda fica registrado daquele jeito para sempre, mesmo que o preço de tabela mude depois.
- RN08 — Produtos com chegada programada (importação) podem ser vendidos, desde que a data prevista de chegada apareça no orçamento.
- RN09 — É proibida a emissão ou faturamento de pedidos para clientes cujos dados cadastrais (endereço, telefone e contato financeiro) não tenham sido confirmados nos últimos 90 dias, visando prevenir devoluções de mercadoria e extravio de cobranças (essa é a regra que resolve o problema real de desatualização identificado na Rafimex.)
## 5. Dicionário de Dados Conceitual


**Tabela: CLIENTE**

# 1. CLIENTE (PJ)

A entidade **CLIENTE** representa o armazenamento das informações das pessoas jurídicas que consomem os produtos e serviços da empresa.

## 1.1. Estrutura Formal

**CLIENTE = @ID_CLIENTE + NM_RAZAO_SOCIAL + CD_CNPJ + NR_INSCRIC_ESTADUAL + ID_ENDERECO + DS_EMAIL + CD_TELEFONE + LM_LIMITE_CREDITO + IN_ATIVO + ID_SERASA + DT_DATA_DE_ATUALIZACAO**

## 1.2. Leitura da Estrutura

`@ID_CLIENTE` é a chave primária (**PK**) e identifica de forma única e exclusiva cada registro de cliente no sistema.

`NM_RAZAO_SOCIAL` representa o nome empresarial do cliente. `CD_CNPJ` armazena o número do CNPJ. `NR_INSCRIC_ESTADUAL` armazena o número da inscrição estadual, quando aplicável.

`ID_ENDERECO` estabelece o relacionamento com o endereço do cliente. `DS_EMAIL` e `CD_TELEFONE` armazenam os dados de contato.

`LM_LIMITE_CREDITO` representa o limite de crédito concedido ao cliente. `IN_ATIVO` indica se o cadastro está ativo. `ID_SERASA` permite associar o cliente ao histórico de crédito no Serasa.

Por fim, `DT_DATA_DE_ATUALIZACAO` registra a data da última atualização das informações do cadastro.

# 2. Atributos da Entidade CLIENTE

| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_CLIENTE** | Integer | Sim (PK) | Identifica unicamente o cliente no sistema. |
| **NM_RAZAO_SOCIAL** | Varchar(100) | Sim | Representa a razão social do cliente. |
| **CD_CNPJ** | Varchar(18) | Sim | Armazena o número do CNPJ do cliente. |
| **NR_INSCRIC_ESTADUAL** | Varchar(20) | Não | Armazena o número de inscrição estadual da empresa, quando aplicável. |
| **ID_ENDERECO** | Integer | Sim (FK) | Identifica o endereço associado ao cliente. |
| **DS_EMAIL** | Varchar(100) | Sim | Armazena o e-mail empresarial utilizado para contato e identificação no sistema. |
| **CD_TELEFONE** | Varchar(14) | Sim | Armazena o telefone de contato do cliente. |
| **LM_LIMITE_CREDITO** | Decimal(15,2) | Sim | Representa o limite de crédito disponibilizado para compras do cliente. |
| **IN_ATIVO** | Boolean | Sim | Indica se o cadastro do cliente está ativo no sistema. |
| **ID_SERASA** | Varchar(50) | Sim | Identifica o registro utilizado para associação do cliente ao histórico de crédito no Serasa. |
| **DT_DATA_DE_ATUALIZACAO** | Date | Sim | Registra a data em que as informações do cadastro foram atualizadas pela última vez. |

**Tabela: COLABORADOR**

# 1. COLABORADOR

A entidade **COLABORADOR** representa a coleta dos dados operacionais, contratuais e funcionais para a atuação do profissional no sistema.

## 1.1. Estrutura Formal 

**COLABORADOR = @ID_COLABORADOR + NM_COLABORADOR + NR_CPF + DT_DATA_DE_NASCIMENTO + ID_ENDERECO + DS_EMAIL + NR_TELEFONE + DS_COMISSAO**

## 1.2. Leitura da Estrutura 

`@ID_COLABORADOR ` Identifica o profissional no sistema.
`NM_COLABORADOR` Representa o nome completo do colaborador.
`NR_CPF` Número de indicação CPF do colaborador.
`DT_DATA_DE_NASCIMENTO` Informativo da data de nascimento do colaborador.
`ID_ENDERECO` Identificação do endereço do colaborador.
`DS_EMAIL` Informa o Email pessoal para identificação no sistema.
`NR_TELEFONE` Telefone contato pessoal do colaborador.
Por fim, ` DS_COMISSAO`   Valor referente a porcentagem de venda ao colaborador. 

# 2. Atributos da Entidade COLABORADOR

| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_COLABORADOR** | Integer | Sim (PK) | Identifica o profissional no sistema. |
| **NM_COLABORADOR** | Varchar(120) | Sim | Representa o nome completo do colaborador. |
| **NR_CPF** | Varchar(14) | Sim | Número de indicação CPF do colaborador. |
| **DT_DATA_DE_NASCIMENTO** | Date | Sim | Informativo da data de nascimento do colaborador. |
| **ID_ENDERECO** | Integer | Sim  | Identificação do endereço do colaborador. |
| **DS_EMAIL** | Varchar(100) | Sim  | Informa o Email pessoal para identificação no sistema. |
| **NR_TELEFONE** | Varchar(14) | Sim | Telefone contato pessoal do colaborador. |
| **DS_COMISSAO** | Numeric(5,2) | Sim  |Valor referente a porcentagem de venda ao colaborador.|


**Tabela: PRODUTO**

# 1. PRODUTO

A entidade **PRODUTO** representa o cadastro dos produtos registrados no sistema. 
Suas informações são utilizadas para identificação, classificação, controle de preços 
e acompanhamento da quantidade disponível em estoque.

## 1.1. Estrutura Formal

**PRODUTO = @ID_PRODUTO + CD_SKU + CD_NCM + CD_CODIGO_BARRA + VL_PRECO_CUSTO + VL_PRECO_VENDA + QT_ESTOQUE + ID_CATEGORIA**

## 1.2. Leitura da Estrutura

`@ID_PRODUTO` representa o identificador único do produto no sistema. 
`CD_SKU` corresponde ao código interno utilizado para identificação e controle do produto. 
`CD_NCM` armazena a classificação fiscal, enquanto `CD_CODIGO_BARRA` representa o código 
de barras utilizado para identificação comercial.

`VL_PRECO_CUSTO` e `VL_PRECO_VENDA` armazenam, respectivamente, os valores de custo 
e venda do produto. `QT_ESTOQUE` indica a quantidade disponível em estoque. 
Por fim, `ID_CATEGORIA` estabelece o relacionamento do produto com sua respectiva categoria.

# 2. Atributos da Entidade PRODUTO

| Atributo | Tipo físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_PRODUTO** | Integer | Sim (PK) | Identifica de forma única cada produto cadastrado no sistema. |
| **CD_SKU** | Varchar(30) | Sim | Identifica o produto por meio de um código interno utilizado para controle e organização do estoque. |
| **CD_NCM** | Varchar(10) | Sim | Armazena o código NCM utilizado para a classificação fiscal do produto. |
| **VL_PRECO_CUSTO** | Numeric(10,2) | Sim | Representa o valor de custo do produto para a empresa. |
| **VL_PRECO_VENDA** | Numeric(10,2) | Sim | Representa o valor pelo qual o produto será comercializado. |
| **CD_CODIGO_BARRA** | Varchar(20) | Sim | Armazena o código de barras utilizado para identificar o produto. |
| **QT_ESTOQUE** | Integer | Sim | Indica a quantidade disponível do produto em estoque. |
| **ID_CATEGORIA** | Integer | Sim (FK) | Identifica a categoria à qual o produto pertence, estabelecendo o relacionamento com a entidade **CATEGORIA**. |

**Tabela: FORNECEDOR**

# 1. FORNECEDOR
A entidade **FORNECEDOR** representa a separação de produtos, notas, e quantidades de itens que o cliente solicitou.
## 1.1. Estrutura Formal
**PEDIDO = @ID_FORNECEDOR + NR_CNPJ + NM_RAZAO_SOCIAL + NR_INSCRIC_ESTADUAL + DS_EMAIL + NR_TELEFONE + ID_ENDERECO**

## 1.2. Leitura da Estrutura
`@ ID_FORNECEDOR ` | Identifica qual fornecedor, e quais os materiais entregue pela empresa.
`CD_CNPJ` Identificador do CNPJ do fornecedor.
`NM_RAZAO_SOCIAL` Representa de forma direta a razão social do Fornecedor.
NR_INSCRIC_ESTADUAL Armazena o número de inscrição estadual da empresa, quando aplicável.
`DS_EMAIL` Informa o Email profissional do fornecedor.
`NR_TELEFONE` Cadastro do número do fornecedor para contatos diretos.
Por fim, `ID_ENDERECO` Identifica o endereço em que o fornecedor está localizado.

# 2.   Atributos da Entidade FORNECEDOR

| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_FORNECEDOR** | Integer | Sim (PK) | Identifica qual fornecedor, e quais os materiais entregue pela empresa. |
| **NR_CNPJ** | Varchar(18) | Sim | Identificador do CNPJ do fornecedor.|
| **NM_RAZAO_SOCIAL** | Varchar(100) | Sim | Representa de forma direta a razão social do Fornecedor.|
| **NR_INSCRIC_ESTADUAL** | Varchar(20) | Não | Armazena o número de inscrição estadual da empresa, quando aplicável. |
| **DS_EMAIL** | Varchar(100) | Sim  | Informa o Email profissional do fornecedor. |
| **NR_TELEFONE** | Varchar(14) | Sim | Cadastro do número do fornecedor para contatos diretos. |
| **ID_ENDERECO** | Integer | Sim(FK) | Identifica o endereço em que o fornecedor está localizado. |


**Tabela: PEDIDO**

# 1. PEDIDO
A entidade **PEDIDO** representa a separação de produtos, notas, e quantidades de itens que o cliente solicitou.
## 1.1. Estrutura Formal
**PEDIDO = @ID_PEDIDO + DT_DATA_DO_PEDIDO + VL_VALOR_TOTAL + ID_TIPO_DE_FRETE + ID_FORMA_DE_PAGAMENTO + DS_DESCONTO_APLICADO + ID_STATUS_PEDIDO** 

## 1.2. Leitura da Estrutura
`@ID_PEDIDO` Identifica o pedido solicitado no sistema 
`DT_DATA_DO_PEDIDO` Informativo da data em que o pedido foi solicitado.
`VL_VALOR_TOTAL` Identificador do valor total do pedido solicitado pelo cliente.
`ID_TIPO_FRETE` Identifica a forma de frete se transportadora ou correios para entrega do produto. 
`ID_FORMA_DE_PAGAMENTO` Identifica a forma de pagamento que o cliente escolheu pagar pelo produto.  
`DS_DESCONTO_APLICADO` Informa a porcentagem de desconto aplicada no pedido.
Por fim, `ID_STATUS_PEDIDO` Identificador para informar como o pedido está e em qual etapa do processo que o pedido está.

# 2.   Atributos da Entidade PEDIDO


| Atributo | Tipo Físico | Obrigatório | Significado e relevância |
|---|---|---|---|
| **ID_PEDIDO** | Integer | Sim (PK) | Identifica o pedido solicitado no sistema. |
| **DT_DATA_DO_PEDIDO** | Date | Sim | Informativo da data em que o pedido foi solicitado. |
| **VL_VALOR_TOTAL** | Decimal(18,2) | Sim | Identificador do valor total do pedido solicitado
pelo cliente. |
| **ID_TIPO_DE_FRETE** | Integer | Sim(FK) | Identifica a forma de frete se transportadora ou correios para entrega do produto.  |
| **ID_FORMA_DE_PAGAMENTO** | Integer | Sim(FK)  | Identifica a forma de pagamento que o cliente escolheu pagar pelo produto.  |
| **DS_DESCONTO_APLICADO** | Decimal(8,2) | Sim | Informa a porcentagem de desconto aplicada no pedido.  |
| **ID_STATUS_PEDIDO** | Integer | Sim(FK) | Identificador para informar como o pedido está e em qual etapa do processo que o pedido está. |


## 6. Modelagem Conceitual (Entidades, Atributos e Relacionamentos)

**1. Modelo Conceitual**
Este modelo representa um sistema corporativo de vendas B2B e controle de estoque, mapeando as interações desde o cadastro de clientes e parceiros até o faturamento e a movimentação física de produtos.

| Entidade | Relaciona-se com | Cardinalidade |
| **CLIENTES** | PEDIDO | **1:N** - Um cliente pode realizar vários pedidos, mas um pedido pertence a apenas um cliente. |
| **COLABORADORES** | PEDIDO | **1:N** - Um colaborador/vendedor pode emitir vários pedidos, mas um pedido tem apenas um vendedor responsável. |
| **PEDIDO** | ITEM_PEDIDO | **1:N** - Um pedido possui um ou vários itens de pedido; cada item pertence a um único pedido. |
| **PRODUTO** | ITEM_PEDIDO | **1:N** - Um produto pode estar presente em diversos itens de pedidos; cada item refere-se a um único produto. |
| **CATEGORIA** | PRODUTO | **1:N** - Uma categoria agrupa vários produtos; cada produto pertence a uma única categoria. |

**Definições das Entidades:**
CLIENTES: Pessoa jurídica compradora, com limite de crédito e controle de inadimplência.
COLABORADORES: Vendedores e representantes comerciais responsáveis pelo faturamento e comissão.
PEDIDO: Documento transacional de venda, incluindo notas fiscais, aprovações financeiras e entregas.
PRODUTO: Item comercializável com código fiscal, saldo de estoque físico e preços de custo e venda.
FORNECEDORES: Entidade externa emissora de notas de compra/importação.

**2. Fluxo de Dados (Visão Geral)**

FORNECEDOR fornece para a empresa. O CLIENTE cadastrado faz a solicitação de compra.  O COLABORADOR abre um PEDIDO, registrando os itens trazidos da entidade PRODUTO. caso o pedido seja no boleto( a prazo), o pedido passa por aprovação gerencial e análise crédito. Sendo aprovado, o PEDIDO segue para separação e faturamento.
3. Convenções do Dicionário de Dados

### Configurações do Banco de Dados
| Parâmetro | Configuração / Descrição |
| **SGBD** | MySQL 8, mecanismo de armazenamento InnoDB |
| **Codificação / Collation** | `utf8mb4` com collation `utf8mb4_0900_ai_ci` |

---

### Padronização de Prefixos
| Prefixo | Significado | Exemplo de Aplicação |
| `@ID_` | Identificador / Chave Primária (PK) | `@ID_CLIENTE` |
| `$NM_$` | Nome | `NM_RAZAO_SOCIAL` |
| `$DT_$` | Data / Hora | `DT_PEDIDO` |
| `$CD_$` | Código (identificador fiscal, barras ou SKU) | `CD_SKU`, `CD_NCM` |
| `$QT_$` | Quantidade | `QT_ESTOQUE` |
| `$VL_$` | Valor Monetário / Numérico Calculado | `VL_PRECO_VENDA` |
| `$IN_$` | Indicador Booleano / Flag | `IN_APROVACAO_GERENCIAL` |
| `$DS_$` | Descrição ou Texto Livre | `DS_ENDERECO` |
| `$NR_$` | Número (documento, nota fiscal ou telefone) | `NR_CNPJ`, `NR_NOTA_FISCAL` |

---

### Notação Formal
| Símbolo | Significado e Aplicação |
| `=` | **é composto de** (define a estrutura da entidade) |
| `+` | **e** (conecta elementos obrigatórios) |
| `()` | **opcional** (campos que podem ser nulos) |
| `[]` | **escolha obrigatória** entre alternativas exclusivas (`[A \| B]`) |
| `{}` | **iteração** / grupo repetitivo (`n{ /ITEM/ }m`) |
| `@` | **identificador** (chave primária) |

### Diagrama Entidade-Relacionamento (DER)
[IMAGEM DER](https://github.com/leticiasantoslht-cmyk/Docs-Rafimex2.git)

### Justificativa Técnica


