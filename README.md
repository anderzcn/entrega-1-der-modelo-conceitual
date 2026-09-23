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

O escopo deste projeto é a modelagem conceitual: mapear clientes, equipe comercial (interna e externa), catálogo de produtos, fornecedores e pedidos de venda, incluindo o controle de preço praticado e produtos que ainda estão a caminho (importação).

---

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
- **Registro visual:**
    - [Visualiza Foto da Visitação](https://github.com/anderzcn/entrega-1-der-modelo-conceitual/blob/main/IMAGEM_VISITACAO_RAFIMEX.jpeg)
    - [Visualiza Foto da Fachada](https://github.com/anderzcn/entrega-1-der-modelo-conceitual/blob/main/IMAGEM_FACHADA_RAFIMEX.jpeg)

    
## 2. Processos de Negócio
- **Cadastro de clientes:** só empresas (CNPJ) podem se cadastrar como clientes, e o cadastro deveria passar por revalidação periódica.

- **Análise de crédito:** antes de aprovar um pedido no boleto, o Financeiro verifica se o cliente tem restrição no Serasa ou pendência com a própria Rafimex, bloqueando a venda ou limitando a forma de pagamento conforme o caso.

- **Controle de estoque:** a empresa separa o que já está fisicamente disponível no galpão ("Disponível/Reservado") do que ainda está vindo de importação (Entrega Programada), mostrando a data prevista de chegada no orçamento.

- **Emissão de pedidos:** todo pedido é aberto vinculado a um cliente e a um representante, com desconto aplicado dentro da alçada permitida (até 4%, acima disso precisa de aprovação da diretoria) e a modalidade de entrega/frete definida. Depois de passar pelas checagens de crédito e estoque, o pedido é faturado, com a emissão da nota fiscal correspondente.


**Fluxograma:** [Visualiza imagem Fluxograma]() 

---

 ## 3. Requisitos do Sistema   
**Requisitos Funcionais**
- RF01 — O sistema só pode cadastrar clientes com CNPJ válido e único.
- RF02 — O sistema deve bloquear automaticamente a emissão de qualquer pedido para clientes inadimplentes diretos com a Rafimex. Para pedidos com pagamento a prazo (boleto), o sistema deve reter a venda e exigir a aprovação manual do setor Financeiro (que avaliará o limite e as restrições no Serasa).  
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
- RNF04 — O acesso aos dados cadastrais dos clientes (CNPJ, contatos, limite de crédito) deve ser restrito a usuários autorizados do sistema, seguindo o princípio da necessidade/minimização previsto no art. 6º, inciso III, da LGPD. 

  ---
  
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
 

 ## Conformidade Legal (LGPD)

Embora a Rafimex opere no modelo B2B (empresa para empresa), o modelo de dados também trata informações de pessoas físicas , como o CPF dos colaboradores e o nome e contato do responsável dentro de cada empresa cliente. Por isso, mesmo numa operação majoritariamente entre empresas, parte dos dados tratados se enquadra como dado pessoal sob a LGPD (Lei nº 13.709/2018).

Princípios da lei aplicados diretamente no modelo:

- **Qualidade dos dados (art. 6º, V):** a trava de atualização cadastral de 90 dias (RN09) garante que os dados de contato permaneçam exatos e atualizados, evitando o problema real identificado na Rafimex.
- **Necessidade/minimização (art. 6º, III):** o dicionário de dados coleta apenas os campos necessários pra operação comercial — não há coleta de dado supérfluo sobre clientes ou colaboradores.
- **Controle de acesso:** informações sensíveis do ponto de vista comercial, como limite de crédito e situação no Serasa, têm acesso restrito a usuários autorizados (RNF04).

**Tratamento de Dados por Entidade**

| Entidade | Contém dado pessoal (LGPD)? | Quais campos | Tratamento aplicado |
|---|---|---|---|
| CLIENTE | Indireto | Nome/e-mail/telefone do contato responsável na empresa | Acesso restrito (RNF04) + revalidação a cada 90 dias (RN09) |
| COLABORADOR | Sim | CPF, nome, data de nascimento, e-mail, telefone, endereço | Acesso restrito a RH/administrativo; dado de identificação de pessoa física |
| FORNECEDOR | Indireto | CNPJ (não é dado pessoal — é de pessoa jurídica) + contato, se pessoa física | Acesso restrito (RNF04) |
| PRODUTO | Não se aplica | — | Não há dado pessoal envolvido |
| PEDIDO | Não diretamente | Vincula CLIENTE e COLABORADOR por chave estrangeira | Integridade referencial protege o histórico sem duplicar dado pessoal |
| NOTA_FISCAL | Não diretamente | Vincula-se ao PEDIDO, que por sua vez vincula-se ao CLIENTE | Não duplica dado pessoal, os dados do cliente são obtidos por referência ao pedido, não armazenados de novo na nota |

*Observação: CNPJ identifica pessoa jurídica, não pessoa física ,por isso não é, por si só, dado pessoal sob a LGPD. O que exige cuidado é o nome/contato da pessoa física responsável dentro de cada empresa (cliente, fornecedor) e os dados dos colaboradores, que são pessoas físicas.*

 ---
  
## 5. Dicionário de Dados Conceitual

O dicionário de dados conceitual reúne a documentação das entidades que formam o modelo de dados do sistema: ***CLIENTE, COLABORADOR, PRODUTO, FORNECEDOR ,PEDIDO e NOTA FISCAL*** cada uma descrita por meio de sua estrutura formal, da leitura dos atributos e de uma tabela com os respectivos tipos físicos, obrigatoriedade e significado.



## 5.1 CLIENTE (PJ)

A entidade **CLIENTE** representa o armazenamento das informações das pessoas jurídicas que consomem os produtos e serviços da empresa.

---

### Estrutura Formal

**CLIENTE = @ID_CLIENTE + NM_RAZAO_SOCIAL + NR_CNPJ + NR_INSCRIC_ESTADUAL + ENDERECO + DS_EMAIL + TELEFONE + VL_LIMITE_CREDITO + IN_ATIVO + ID_SERASA + DT_DATA_DE_ATUALIZACAO**

**ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + DS_COMPLEMENTO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**

---

### Leitura da Estrutura

`@ID_CLIENTE` é a chave primária (**PK**) e identifica de forma única e exclusiva cada registro de cliente no sistema.

`NM_RAZAO_SOCIAL` representa o nome empresarial do cliente. `NR_CNPJ` armazena o número do CNPJ. `NR_INSCRIC_ESTADUAL` armazena o número da inscrição estadual, quando aplicável.

`ENDERECO` é um atributo composto que reúne os dados de localização do cliente, sendo decomposto em `CD_CEP` (código postal), `CD_UF` (sigla do estado), `DS_CIDADE` (cidade), `DS_BAIRRO` (bairro), `DS_RUA` (rua), `NR_NUMERO` (número) e `DS_COMPLEMENTO` (complemento).

`DS_EMAIL` armazena o e-mail empresarial utilizado para contato e identificação no sistema.

`TELEFONE` é um atributo composto que reúne os dados de contato telefônico do cliente, sendo decomposto em `CD_DDD` (código de área) e `NR_NUMERO_TEL` (número do telefone).

`VL_LIMITE_CREDITO` representa o limite de crédito concedido ao cliente. `IN_ATIVO` indica se o cadastro está ativo. `ID_SERASA` permite associar o cliente ao histórico de crédito no Serasa.

`DT_DATA_DE_ATUALIZACAO` registra os dados da última atualização das informações do cadastro.

---

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

**Índices:** PK `ID_CLIENTE` (clusterizado); índice único em `CD_CNPJ` (impedir o cadastro duplicado de clientes); índice secundário em `NM_RAZAO_SOCIAL` (busca de clientes pela razão social); índice secundário em `DT_DATA_DE_ATUALIZACAO` (identificação de cadastros sem atualização há mais de 90 dias).

## 5.2 COLABORADOR

A entidade **COLABORADOR** representa a coleta de dados operacionais, contratuais e funcionais para a atuação do profissional no sistema.

---

### Estrutura Formal

**COLABORADOR = @ID_COLABORADOR + NM_COLABORADOR + NR_CPF + DT_DATA_DE_NASCIMENTO + DS_ENDERECO + DS_EMAIL + TELEFONE + DS_COMISSAO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**

---

### Leitura da Estrutura

`@ID_COLABORADOR` é a chave primária (**PK**) e identifica de forma única o colaborador no sistema.

`NM_COLABORADOR` representa o nome completo do colaborador. `NR_CPF` armazena o número do CPF do colaborador. `DT_DATA_DE_NASCIMENTO` registra a data de nascimento do colaborador.

`DS_ENDERECO` armazena o endereço do colaborador. `DS_EMAIL` armazena o e-mail utilizado para contato e identificação no sistema.

`TELEFONE` é um atributo composto formado por `CD_DDD` e `NR_NUMERO_TEL`, utilizado para armazenar o telefone de contato do colaborador.

`DS_COMISSAO` representa a porcentagem de comissão de venda atribuída ao colaborador.

---

### Atributos da Entidade COLABORADOR

| **Atributo** | **Tipo Físico** | **Obrigatório** | **Descrição** |
|---|---|---|---|
| **ID_COLABORADOR** | Número inteiro | Sim (PK) | Identifica de forma única o colaborador no sistema. |
| **NM_COLABORADOR** | Varchar(120) | Sim | Representa o nome completo do colaborador. |
| **NR_CPF** | Varchar(14) | Sim | Armazena o número do CPF do colaborador. |
| **DT_DATA_DE_NASCIMENTO** | Data | Sim | Registra a data de nascimento do colaborador. |
| **DS_ENDERECO** | Varchar(200) | Sim | Armazena o endereço do colaborador. |
| **DS_EMAIL** | Varchar(100) | Sim | Armazena o e-mail utilizado para contato e identificação no sistema. |
| **CD_DDD** | Char(2) | Sim | Armazena o código de área do telefone do colaborador. |
| **NR_NUMERO_TEL** | Varchar(14) | Sim | Armazena o número de telefone do colaborador. |
| **DS_COMISSAO** | Numérico(5,2) | Sim | Representa a porcentagem de comissão de venda atribuída ao colaborador. |

---

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
unitário de venda do produto. `QT_ESTOQUE` indica a quantidade disponível em estoque. `DS_DESCRICAO` Descreve qual produto está sendo adquirido 

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

**ENDERECO = CD_CEP + CD_UF + DS_CIDADE + DS_BAIRRO + DS_RUA + NR_NUMERO + DS_COMPLEMENTO**

**TELEFONE = CD_DDD + NR_NUMERO_TEL**

-

### Leitura da Estrutura

`@ID_FORNECEDOR` é a chave primária (**PK**) e identifica de forma única o fornecedor no sistema.

`NR_CNPJ` armazena o CNPJ do fornecedor. `NM_RAZAO_SOCIAL` representa a razão social do fornecedor. `NR_INSCRIC_ESTADUAL` armazena o número de inscrição estadual da empresa, quando aplicável.

`DS_EMAIL` armazena o e-mail do fornecedor. `TELEFONE` é um atributo composto formado por `CD_DDD` e `NR_NUMERO_TEL`.

`ENDERECO` é um atributo composto que reúne os dados de localização do fornecedor, sendo decomposto em `CD_CEP`, `CD_UF`, `DS_CIDADE`, `DS_BAIRRO`, `DS_RUA`, `NR_NUMERO` e `DS_COMPLEMENTO`.

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
| **NR_NUMERO (TELEFONE)** | Varchar(14) | Sim | Armazena o número de telefone do fornecedor. |

### Índices

**Índices:** PK `ID_FORNECEDOR` (clusterizado); índice único em `NR_CNPJ` (impede o cadastro duplicado do fornecedor); índice secundário em `NM_RAZAO_SOCIAL` (facilita a busca de fornecedores pela razão social).
## 5.5 PEDIDO
A entidade **PEDIDO** representa a separação de produtos e quantidades de itens que o cliente solicitou.

- ### Estrutura Formal
**PEDIDO = @ID_PEDIDO + DT_DATA_DO_PEDIDO + VL_VALOR_VENDA + DS_TIPO_DE_FRETE + DS_FORMA_DE_PAGAMENTO + VL_DESCONTO_APLICADO + DS_STATUS_PEDIDO** 

- ### Leitura da Estrutura
`@ID_PEDIDO` Identifica o pedido solicitado no sistema 
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
| **DT_DATA_DO_PEDIDO** | Date | Sim | Informativo da data em que o pedido foi solicitado. |
| **VL_VALOR_VENDA** | Decimal(18,2) | Sim | Valor de venda do pedido solicitado. |
| **DS_TIPO_DE_FRETE** | Integer | Sim | Descreve a forma de frete se transportadora ou correios para entrega do produto.   |
| **DS_FORMA_DE_PAGAMENTO** | Integer | Sim  | Descreve a forma de pagamento que o cliente escolheu pagar pelo produto.    |
| **VL_DESCONTO_APLICADO** | Decimal(8,2) | Sim | Valor da porcentagem de desconto aplicada no pedido.  |
| **DS_STATUS_PEDIDO** | Integer | Sim | Descreve o status do pedido e em qual etapa do processo que o pedido está.|

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
`DT_DATA_EMISSAO` informa data quando a nota foi emitida.  
`VL_IMPOSTO_IMPORTACAO` registra o valor de imposto de importação incidente, quando aplicável.
`VL_TOTAL_IMPOSTOS` soma todos os tributos da nota. 
`VL_TOTAL_NF` é o valor final faturado, já com os impostos inclusos.
`DS_STATUS_NF` indica se a nota foi emitida ou ainda nescessario imprimir.

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

### Índices

**Índices:** PK `ID_NF` (clusterizado); índice único em `ID_PEDIDO` (garante a relação 1:1 entre pedido e nota fiscal); índice único em `NR_NF` (impede números de nota fiscal duplicados); índice único em `NR_CHAVE_ACESSO` (garante a unicidade da chave de acesso da NF-e); índice secundário em `DT_DATA_EMISSAO` (consulta de notas fiscais por período).

---

## 6. Modelagem Conceitual (Entidades, Atributos e Relacionamentos)

## Modelo Conceitual
Este modelo representa um sistema corporativo de vendas B2B e controle de estoque, mapeando as interações desde o cadastro de clientes e parceiros até o faturamento e a movimentação física de produtos.

| Entidade | Relaciona-se com | Cardinalidade |
| ------ | ---- | ------|
| **CLIENTES** | PEDIDO | **1:N** - Um cliente pode realizar vários pedidos, mas um pedido pertence a apenas um cliente. |
| **COLABORADORES** | PEDIDO | **1:N** - Um colaborador/vendedor pode emitir vários pedidos, mas um pedido tem apenas um vendedor responsável. |
| **PEDIDO** | ITEM_PEDIDO | **1:N** - Um pedido possui um ou vários itens de pedido; cada item pertence a um único pedido. |
| **PRODUTO** | ITEM_PEDIDO | **1:N** - Um produto pode estar presente em diversos itens de pedidos; cada item refere-se a um único produto. |
| **CATEGORIA** | PRODUTO | **1:N** - Uma categoria agrupa vários produtos; cada produto pertence a uma única categoria.|
| **NOTA_FISCAL** | PRODUTO | **1:N** - Registra a movimentação de um produto no estoque. |
| **PEDIDO** | **NOTA FISCAL** | **1:1** - Um pedido gera apenas uma nota fiscal. |

## Definições das Entidades:
CLIENTES: Pessoa jurídica compradora, com limite de crédito e controle de inadimplência.

COLABORADORES: Vendedores e representantes comerciais responsáveis pelo faturamento e comissão.

PEDIDO: Documento transacional de venda, incluindo notas fiscais, aprovações financeiras e entregas.

PRODUTO: Item comercializável com código fiscal, saldo de estoque físico e preços de custo e venda.

ITEM PEDIDO: Associativa com Detalhamento dos produtos que compõem um pedido, registrando a descrição, quantidade vendida e valor unitário  praticado em cada venda.

FORNECEDORES: Entidade externa emissora de notas de compra/importação.

NOTA FISCAL: Registro mercadorias vendidas que movimentam o saldo físico do estoque.

## Fluxo de Dados (Visão Geral)

FORNECEDOR fornece para a empresa. O CLIENTE cadastrado faz a solicitação de compra.  O COLABORADOR abre um PEDIDO, registrando os itens da entidade PRODUTO através do ITEM PEDIDO. caso o pedido seja no boleto( a prazo), o pedido passa por aprovação gerencial e análise crédito. Sendo aprovado, o PEDIDO segue para separação e faturamento de NOTA FISCAL.

3. Convenções do Dicionário de Dados

## Configurações do Banco de Dados
| Parâmetro | Configuração / Descrição |
| **SGBD** | MySQL 8, mecanismo de armazenamento InnoDB |
| **Codificação / Collation** | `utf8mb4` com collation `utf8mb4_0900_ai_ci` |


## Padronização de Prefixos
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


##  Notação Formal
| Símbolo | Significado e Aplicação |
| `=` | **é composto de** (define a estrutura da entidade) |
| `+` | **e** (conecta elementos obrigatórios) |
| `()` | **opcional** (campos que podem ser nulos) |
| `[]` | **escolha obrigatória** entre alternativas exclusivas (`[A \| B]`) |
| `{}` | **iteração** / grupo repetitivo (`n{ /ITEM/ }m`) |
| `@` | **identificador** (chave primária) |

---

# 7. Diagrama Entidade-Relacionamento (DER)
[Visualiza imagem DER](https://github.com/anderzcn/entrega-1-der-modelo-conceitual/blob/main/DER%20MODELO%20CONCEITUAL%20PNG.png)

---

# 8. Justificativa Técnica
A modelagem do banco de dados da Rafimex foi pensada pra refletir de verdade a operação B2B da empresa e, ao mesmo tempo, resolver o problema real identificado: a desatualização silenciosa do cadastro dos clientes. As decisões abaixo seguem princípios de integridade referencial e normalização, mas cada uma delas nasceu de uma necessidade concreta da empresa:

- **Trava de 90 dias como prevenção, não como remendo:** o campo DT_DATA_DE_ATUALIZACAO, em CLIENTE, é a peça central que resolve o problema real da Rafimex. Em vez de depender de alguém lembrar de checar manualmente, o próprio banco consegue calcular quando um cadastro passou da validade e bloquear novos pedidos antes que isso vire prejuízo, cumprindo RF09 e RN09. Chegamos a pensar em criar uma tabela separada só de "Histórico de Atualizações" pra controlar esse tempo, mas descartamos a ideia. Isso só ia inflar o banco com dados secundários. Deixar o controle direto no cadastro do cliente resolve a dor de forma muito mais direta.

- **A documentação do ITEM_PEDIDO no MER (sem representação no diagrama):** Mapeamos o ITEM_PEDIDO na documentação escrita do nosso Modelo Entidade-Relacionamento porque ele é essencial para o negócio: é esse conceito que garante o registro permanente do preço cobrado na venda (RF05), blindando o pedido contra mudanças futuras na tabela de produtos. Chegamos a debater se já desenhávamos essa entidade no diagrama visual agora, mas descartamos a ideia para seguir a orientação de manter o desenho puramente conceitual nesta entrega. O conceito já está estruturado e defendido no MER.

- **Controle de crédito misto (Automático + decisão humana):** os campos ID_SERASA e LM_LIMITE_CREDITO, direto na tabela CLIENTE, servem pra dar munição rápida pro setor financeiro avaliar as regras RN02, RN03 e RN04. O sistema  bloqueia sozinho quem já deve pra própria Rafimex. Mas a liberação de venda no boleto não é robótica: ela exige o aval manual do financeiro caso a caso. Até pensamos em criar uma tabela separada só para "Dados Financeiros", mas descartamos a ideia. Como o financeiro puxa essa análise o tempo todo, separar esses dados ia exigir cruzamentos (JOINs) a cada nova consulta, deixando o banco lento à toa. E vale lembrar que isso é totalmente diferente do campo IN_ATIVO, que serve apenas pra dizer se o cadastro do cliente ainda é válido ou foi desativado.

- **Nomenclatura e tipos pensados pro volume real da empresa:** o dicionário de dados usa prefixos padronizados (@ID_ pra chaves primárias, IN_ pra campos booleanos, etc.) pra manter tudo rastreável no MySQL 8. Os tipos de campo também já consideram o volume real , VARCHAR maior pros contatos corporativos (pra não cortar e-mails/nomes longos) e Decimal(15,2) pros valores financeiros, garantindo que os cálculos de limite de crédito não percam precisão.

- **Cada pedido amarrado a um único dono (Relação 1:N):** Quando fomos ligar o Cliente ao Pedido, a gente até chegou a pensar em usar uma relação N:N, pra caso empresas parceiras (tipo matriz e filial) quisessem juntar tudo numa compra só. Mas descartamos a ideia rapidinho pensando na vida real. A regra do faturamento não perdoa: a nota fiscal e o boleto têm que sair no nome de um CNPJ só. Então deixamos cravado em 1:N mesmo. O cliente pode fazer quantos pedidos quiser no sistema, mas cada pedido pertence a um único CNPJ. Isso evita qualquer confusão na hora de cobrar e entregar a mercadoria.

- **Por que NOTA_FISCAL é uma entidade separada, e não só um campo em PEDIDO:** a nota fiscal tem seus próprios dados legais (número, chave de acesso, status) que só existem depois que o pedido é faturado , mantê-la separada evita que o PEDIDO fique com campos vazios antes da emissão, e permite cancelar uma nota sem mexer no pedido original. A tabela NOTA_FISCAL guarda só o vínculo com o pedido (não duplica dados do cliente); o documento fiscal completo, com todos os dados exigidos por lei.

---

# 9. Uso de Inteligência Artificial

Durante o desenvolvimento deste projeto, foram utilizadas ferramentas de Inteligência Artificial como apoio em etapas específicas, pesquisa, esclarecimento de dúvidas técnicas e organização da documentação. O uso teve caráter auxiliar, servindo de suporte ao aprendizado e desenvolvimento da equipe, sem substituir a análise crítica e as decisões técnicas, que permanecem de responsabilidade dos integrantes do grupo.

Abaixo, estão detalhadas as ferramentas utilizadas, as etapas em que foram aplicadas e sua contribuição para a entrega 1.

| Critério | Detalhamento |
|------|------------------|
| **Ferramentas e etapa** | Foram feito uso das ferramentas ChatGPT, Gemini e Claude, em todas as etapas que exigiam conhecimento e compreensão técnica.|
| **Motivação** | Compreender a teoria, obter uma visão mais clara do projeto, esclarecer termos técnicos e exigências da disciplina que o grupo não dominava, além de auxiliar na correção ortográfica dos textos produzidos. |
| **Prompt(s) utilizados** | "Você é um mentor na área de T.I, o professor pediu esse trabalho em anexo para o grupo fazer composto por 5 pessoas. Faça um resumo detalhado deste esqueleto de entrega, apontando tudo o que é preciso fazer e todos os pontos de atenção. Explique a estrutura do trabalho e os termos mais técnicos. O que o trabalho pede? O que é preciso para executá-lo? Como separar cada conteúdo de forma que fique bem dividido entre os integrantes do grupo?"<br><br>"Me explica como funciona a notação algébrica de um dicionário de dados"<br><br> |
| **Resposta recebida** | "O professor está propondo que o grupo investigue uma organização real, compreenda como ela funciona e, a partir dessa pesquisa, desenvolva um modelo conceitual de banco de dados que represente suas principais informações, processos e regras. <br>A construção do trabalho deve seguir uma sequência lógica: <br>Conhecer a organização → compreender seus processos → identificar problemas e necessidades → levantar requisitos e regras de negócio → identificar as informações necessárias → definir entidades e atributos → estabelecer os relacionamentos e cardinalidades → construir o modelo conceitual e o DER → justificar tecnicamente as decisões tomadas. <br> Assim, o objetivo principal da entrega é demonstrar como o grupo saiu da realidade da organização e chegou a uma representação estruturada de seus dados, justificando as escolhas feitas durante a modelagem." <br><br>Como complemento, a IA também apresentou uma estrutura geral para a elaboração de um modelo Entidade-Relacionamento (MER), indicando a necessidade de definir o escopo e as regras de negócio, identificar as entidades envolvidas, definir seus atributos, estabelecer os relacionamentos e suas respectivas cardinalidades e, por fim, representar essas informações graficamente por meio do DER. Também foi apresentado um exemplo prático de modelagem de um sistema de vendas, utilizado como referência para compreender a relação entre entidades, atributos e cardinalidades. |
| **Fontes consultadas e verificadas** | Foram consultadas fontes técnicas confiáveis sobre modelagem de dados, relacionamentos entre entidades e cardinalidades. As fontes foram utilizadas como referência teórica para verificar conceitos como relacionamentos 1:1, 1 e N, além da diferença entre cardinalidade mínima e máxima. <br><br> IBM Documentation — Modelos de dados: utilizada para verificar conceitos de relacionamentos e cardinalidades entre entidades.<br><br>https://www.ibm.com/docs/pt-br/sc-and-ds/9.0.0?topic=views-data-models |
| **Trechos rejeitados ou corrigidos** |  O Gemini forneceu uma estrutura de entidades, atributos e a notação formal correspondente, porém presumiu, de forma incorreta, que a Rafimex não possuía controle de crédito nem de desconto. Na prática, verificamos que tais controles já existem e funcionam adequadamente. Com o auxílio do Claude, o grupo identificou precisamente o ponto em que ocorreu esse equívoco e reescreveu as seções afetadas. <br><br> Dessa forma, o grupo descartou a suposição de ausência desses controles e revisou a Introdução, a Caracterização e as Regras de Negócio a fim de refletir a realidade da empresa, já que uma de suas integrantes tem a vivência real na empresa. também corrigimos manualmente a razão social completa da Rafimex, informação que nenhuma das duas ferramentas de IA possuía até ser fornecida pelo grupo.|
| **Justificativa da escolha final** | O grupo adotou um mesmo critério para avaliar todas as sugestões da IA: aquelas relacionadas a conceitos teóricos, notação ou organização do trabalho foram consideradas quando puderam ser verificadas em fontes externas confiáveis. Já as sugestões relacionadas ao funcionamento real da Rafimex só foram consideradas quando puderam ser confirmadas por evidências de campo, como a experiência de uma integrante do grupo na empresa e a visita técnica realizada. <br>A partir desse critério, o grupo aproveitou a estrutura geral de entidades e atributos sugerida pelo Gemini, mas realizou adaptações no conteúdo para adequá-lo às regras de negócio observadas na Rafimex. <br>Assim, a decisão de aceitar, adaptar ou rejeitar uma sugestão não foi baseada apenas na resposta da IA, mas principalmente na possibilidade de verificar essas informações por meio de fontes confiáveis e, quando relacionadas à empresa, confrontá-las com a realidade observada pelo grupo. |
| **Reflexão crítica** | O uso da IA nessa etapa evidenciou um viés de generalização: a IA presumiu, sem evidências, que determinados controles não existiam, aplicando um padrão genérico a uma organização cuja realidade era distinta. Esse erro só foi identificado porque o grupo possuía vivência direta na empresa, o que reforça que a IA não substitui o conhecimento de negócio do usuário, apenas o complementa. Constatou-se, ainda, que não existe uma resposta única, correta ou incorreta, para a modelagem: a validação dos relacionamentos entre entidades depende da leitura e da compreensão aprofundada das regras de negócio da organização, algo que a IA, isoladamente, não é capaz de garantir. |


---

- # Conclusão
Este modelo conceitual entrega uma estrutura capaz de sustentar a operação real da Rafimex de vendas, análise de crédito e controle de estoque, organizada de um jeito que dá pra confiar nos dados registrados. Ao longo do levantamento, ficou claro que o maior risco pra empresa não estava nas regras comerciais (que já funcionam bem), mas na desatualização silenciosa dos dados de contato e endereço dos clientes, o que já gerou boleto não entregue e taxa de reentrega de fretes de endereços errados.

A solução desenhada transforma esse problema, que hoje é descoberto só depois de já ter causado prejuízo, numa regra que o próprio banco de dados consegue aplicar sozinho: a trava de 90 dias na atualização cadastral. Junto com os controles de crédito e o registro histórico de preço em cada venda, o modelo passa a ter um caráter preventivo, e não apenas reativo.

Com as entidades, atributos e relacionamentos definidos e normalizados,  o projeto está pronto para avançar à normalização e à implementação física do banco de dados na Entrega 2.


---

## 10. Referências Bibliográficas

* *ANDRADE, Cid.* Aspectos Éticos, Legais e Tecnológicos no Uso de Dados. Material didático da disciplina Modelagem de Banco de Dados, 2026.
* *ANDRADE, Cid.* Construção de Dicionário de Dados. Material didático da disciplina Modelagem de Banco de Dados, Unidade 2, Aula 2.4, 2026.
* *ANDRADE, Cid.* Dado e Informação. Material didático da disciplina Modelagem de Banco de Dados, 2026.
* *ANDRADE, Cid.* Ferramentas para Modelagem: DB Designer. Material didático da disciplina Modelagem de Banco de Dados, Unidade 2, Aula 2.3, 2026.
* *BRASIL.* Lei nº 13.709, de 14 de agosto de 2018. Lei Geral de Proteção de Dados Pessoais (LGPD). Diário Oficial da União, Brasília, DF, 2018.
* *BRMODELO WEB.* Ferramenta online de modelagem de diagramas entidade-relacionamento. Disponível em: <https://www.brmodeloweb.com>. Acesso em: set. 2026.
* *CADONÁ.* Modelagem Conceitual - Exemplo. YouTube, 2020. Disponível em: <https://youtu.be/BzQ7kkTZVIo>. Acesso em: set. 2026.
* *COSTA, Dalton.* Um guia de como criar um dicionário de dados para a sua pesquisa. Datapsico, 29 out. 2021. 
* *ENTREVISTA TÉCNICA E LEVANTAMENTO DE DADOS.* Visita técnica presencial realizada na empresa Rafimex Comercial Importação e Exportação Ltda (R. Barra do Tibagi, 537 - Bom Retiro). Entrevista conduzida com a Diretoria Comercial. São Paulo, 2026.
* *GITHUB.* 02.04 Introdução ao GitHub: Do Zero ao Primeiro Repositório.pdf. Material de apoio técnico sobre versionamento, repositórios e boas práticas de commits.
* *IBM.* Modelos de Dados. IBM Docs. Documentação técnica consultada para referência em estruturação de dados. Disponível em: <https://www.ibm.com/docs/pt-br/sc-and-ds/9.0.0?topic=views-data-models>. Acesso em: set. 2026.
* *MONITOR DIGITAL IFF.* Banco de Dados: Diagrama Entidade-Relacionamento: cardinalidades em relacionamentos. YouTube, 2020. Disponível em: <https://youtu.be/GdxodSoV_5k>. Acesso em: set. 2026.
* *MYSQL.* MySQL 8.0 Reference Manual: Data Types. Documentação oficial utilizada para definição da arquitetura e tipagem dos atributos no Dicionário de Dados. Disponível em: <https://dev.mysql.com/doc/refman/8.0/en/data-types.html>. Acesso em: set. 2026.
