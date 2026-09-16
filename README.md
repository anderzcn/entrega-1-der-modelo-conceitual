# Entrega 1 — Modelo Conceitual (DER)

### Modelagem de um sistema de gestão de vendas, crédito e estoque para a Rafimex - Mesa Posta e Decorações


## Metadados

| NOME | RGM |

| **Anderson Rafael da Silva** [ **49031937**] 
|**Leticia Souza Santos**     [**49439286**]  
|**Maria Eduarda Sobrinho dos Santos** [**49020595**]
|**Nathan Vieira De Lara** [**49462725**]
|**Ketlyn Nayara da Silva Cezar** [**48862347**]
## Introdução

Este projeto tem como objetivo desenvolver o Modelo Conceitual de Banco de Dados para a Rafimex - Mesa Posta e Decorações, uma empresa atacadista que vende artigos de mesa posta e decoração para outras empresas (B2B).

A Rafimex já opera com regras de negócio bem definidas para crédito, desconto e controle de estoque futuro ,como análise de crédito para venda no boleto, restrição automática para clientes com pendências no Serasa ou internas, com descontos de até 4% liberado para representante conceder ao cliente , e sinalização de estoque futuro com previsão de chegada. O problema real que encontramos está em outro lugar: o cadastro de clientes é feito manualmente pelo representante, e quando um cliente fica um tempo sem comprar, informações como telefone, e-mail e endereço podem ficar desatualizadas sem que ninguém perceba ,o que já gerou casos de boleto não recebido e cobrança de taxa de reentrega por mudança de endereço não informada. Pior ainda, esse problema só é percebido depois que já causou prejuízo: hoje não existe nada que avise a empresa, com antecedência, quais cadastros estão parados há muito tempo sem confirmação.

O objetivo deste trabalho é modelar um banco de dados que represente corretamente as regras que a Rafimex já segue, e que resolva esse problema específico de cadastro desatualizado de forma preventiva, avisando antes que vire prejuízo, e não só depois.

O escopo deste projeto é a modelagem conceitual: mapear clientes, equipe comercial (interna e externa), catálogo de produtos, fornecedores e pedidos de venda, incluindo o controle de preço praticado e produtos que ainda estão a caminho (importação). A implementação do banco de dados em si fica para a Entrega 2.

## 1. Caracterização da Organização

 - **Nome e natureza da organização:** Rafimex Comercial Importação e Exportação Ltda, conhecida comercialmente como Rafimex  Mesa Posta e Decorações, empresa privada com fins lucrativos que atua no comércio atacadista de utilidades domésticas e decoração,com parte do catálogo vindo de produtos importados.
 
 - **Contexto e porte:** A empresa está no mercado há 35 anos. Hoje conta com 25 funcionários internos ,5 na expedição, 2 auxiliares administrativos,além de 1 faturamento, 1 contas a pagar, financeiro e diretoria  e 20 representantes comerciais externos espalhados pelo Brasil. A carteira de clientes é de aproximadamente 10.000 empresas ativas, o catálogo tem cerca de 1.550 produtos, e o volume de vendas gira em torno de 5 a 10 pedidos por dia (140 a 200 por mês).

 
 - **Problemas e necessidades identificados:** Na visita, vimos que o principal ponto de melhoria não está nas regras comerciais da empresa ,que já são claras e bem aplicadas (crédito, desconto, estoque futuro) ,**mas no processo de manutenção do cadastro dos clientes. Como esse cadastro é atualizado manualmente pelo representante, só quando ele lembra de perguntar, clientes que compram com pouca frequência correm o risco de ficar com dados de contato desatualizados. Isso já causou boleto não entregue por telefone/e-mail errado, causando em casos mais graves até cnpj indo para cartório e cobrança de taxa de reentrega por mudança de endereço não avisada. E o pior: a empresa só descobre isso depois que já deu problema, porque não existe hoje nenhum aviso prévio de quais cadastros estão desatualizados.**

 - **Justificativa da escolha:** Escolhemos a Rafimex por ser uma empresa real, de porte médio-grande, com volume de dados suficiente para justificar uma modelagem robusta, mas ainda viável de mapear no prazo da disciplina. Além disso, uma das integrantes do grupo, Letícia, trabalha na Rafimex e tem acesso direto ao dia a dia da empresa, o que ajudou a entender os problemas reais descritos aqui.
 - **Evidências da organização:** 
  - *Localização:* [Visualizar Rafimex no Google Maps](https://share.google/HcLa1pSVyl08VBVME)
  - *Endereço e Contato:* [R. Barra do Tibagi, 537 - Bom Retiro, São Paulo - SP, 01128-000 | Tel: (11) 99471-1531- Gabriel Gedanken- DIRETOR COMERCIAL]
    -**Registro visual:** [FOTO] (https://github.com/leticiasantoslht-cmyk/Docs-Rafimex2.git) 
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
- 



