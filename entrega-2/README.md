# Documentos complementares da Entrega 2 - Modelagem de Banco de Dados Rafimex.

> Modelagem e Implementação de Banco de Dados para a Gestão de Vendas, Crédito e Estoque da Rafimex
Entrega 2 — Modelo Lógico, Implementação SQL e Apresentação Final. Banco de dados da Rafimex Comercial Importação e Exportação Ltda (Rafimex Mesa Posta e Decorações), atacadista B2B de artigos de mesa posta e decoração.

| NOME | RGM |
|---|---|
| **Anderson Rafael da Silva** | **49031937** |
| **Leticia Souza Santos** | **49439286** |
| **Maria Eduarda Sobrinho dos Santos** | **49020595** |
| **Nathan Vieira De Lara** | **49462725** |
| **Ketlyn Nayara da Silva Cezar** | **48862347** |

## Artefatos do repositório

| Artefato | Arquivo |
| :---- | :---- |
| Relatório técnico | este `README.md` |
| Levantamento | [levantamento/levantamento.md](levantamento/levantamento.md) |
| DER conceitual revisado | [diagramas/der-revisado.png](diagramas/der-revisado.png) |
| Modelo lógico | [diagramas/modelo-logico.png](diagramas/modelo-logico.png) |
| Dicionário de dados | [docs/dicionario-dados.md](docs/dicionario-dados.md) |
| Script SQL completo (com a massa de dados) | [docs/script.sql](docs/script.sql) |
| Slides | [slides/apresentacao.pdf](slides/apresentacao.pdf) |

---

## 1. Relatório Técnico Final

### 1.1 Revisão do Modelo Conceitual

#### Caracterização da organização

- **Nome e natureza:** Rafimex Comercial Importação e Exportação Ltda, nome fantasia Rafimex Mesa Posta e Decorações. Empresa privada, com fins lucrativos, que atua no comércio atacadista (B2B) de utilidades domésticas e decoração. Parte do catálogo é importada.
- **Contexto e porte:**
  - 35 anos de mercado.
  - 14 funcionários internos: 5 na expedição, 2 auxiliares administrativos, 1 no faturamento, 1 no contas a pagar, 1 no financeiro, 2 vendedores internos e a diretoria.
  - 20 representantes comerciais externos espalhados pelo Brasil.
  - Cerca de 10.000 empresas clientes ativas e cerca de 1.550 produtos no catálogo.
  - De 5 a 10 pedidos por dia útil, ou seja, de 140 a 200 pedidos por mês.
- **Problemas e necessidades identificados:** as regras comerciais da Rafimex (crédito, desconto, estoque futuro) já são claras e aplicadas. O ponto fraco é a **manutenção do cadastro dos clientes**. Hoje o representante atualiza o cadastro à mão, só quando lembra de perguntar. Por isso os clientes que compram pouco ficam com contato e endereço desatualizados sem que ninguém perceba. Isso gera três problemas:
  - **P1 — Cadastro desatualizado sem aviso prévio:** a empresa só descobre que o telefone, o e-mail ou o endereço mudaram depois que o prejuízo aconteceu. Não existe alerta de quais cadastros estão parados há muito tempo.
  - **P2 — Boleto não recebido e inadimplência:** boleto enviado para o contato financeiro errado não é pago. Em casos graves, o CNPJ do cliente chega a ir para cartório.
  - **P3 — Devolução e taxa de reentrega:** mercadoria enviada para um endereço que mudou volta. A Rafimex paga a reentrega e corre o risco de faturar o próximo pedido para o mesmo endereço errado.
- **Escopo do sistema:** o banco reúne todos os dados da operação, não só o cadastro:
  - clientes e análise de crédito;
  - equipe comercial (interna e externa) e comissões;
  - catálogo de produtos e estoque (disponível e programado);
  - fornecedores, pedidos de compra e importação, e contas a pagar;
  - pedidos de venda, notas fiscais, cobrança (contas a receber) e devoluções.
- **Justificativa da escolha:** a Rafimex é uma empresa real, com volume de dados que justifica uma modelagem robusta e acesso garantido para pesquisa de campo. **Declaração de vínculo:** a integrante Letícia Souza Santos trabalha na Rafimex. O vínculo ajudou a entender a rotina, mas a entrevista foi feita com o diretor comercial, no ambiente da empresa (ver relato abaixo).
- **Evidências da organização:**
  - Endereço: R. Barra do Tibagi, 537 — Bom Retiro, São Paulo/SP, CEP 01128-000.
  - Google Maps: [Rafimex no Google Maps](https://maps.app.goo.gl/PDXnt86jRLMjDYKF8)
   - Fotos (no repositório): [fachada](entrega-1/IMAGEM_FACHADA_RAFIMEX.jpeg) e [visita técnica](entrega-1/IMAGEM_VISITACAO_RAFIMEX.jpeg).
- **Responsável pela organização:** Gabriel Gedanken, diretor comercial. Telefone: (11) 99471-1531.

- 
#### Relato da entrevista

- **Quem:** Gabriel Gedanken, diretor comercial da Rafimex. Participantes do grupo: LETICIA SOUZA SANTOS.
- **Quando e onde:** 10.09.2026, na sede da Rafimex (R. Barra do Tibagi, 537 — Bom Retiro, São Paulo/SP).
- **Comprovação:** [foto da visita técnica](entrega-1/IMAGEM_VISITACAO_RAFIMEX.jpeg), com uma integrante e o entrevistado dentro da loja.
- **Achados pela observação no local:** 
  - O cadastro do cliente é preenchido à mão pelo representante, sem nenhuma data de validade.
  - Quando uma mercadoria volta por endereço errado, a logística registra o retorno, mas nada impede um novo pedido para o mesmo endereço.
  - O pedido mostra se o item sai do estoque ou chega por importação (entrega programada, com data prevista).
- **Achados pelas respostas do entrevistado:**
  - Desconto de até 4% é do representante; acima disso, só com aprovação da diretoria.
  - Venda no boleto passa pela análise de crédito do financeiro (limite e Serasa).
  - Cliente com pendência no Serasa só compra à vista ou no cartão.
  - Cliente inadimplente com a Rafimex não tem venda liberada.
  - A comissão é de 8% para o representante externo e 3% para o vendedor interno, e só é paga depois que o cliente quita o boleto.
  - Compras são feitas de fornecedores homologados. A importação tem previsão de chegada e, ao chegar, gera o título no contas a pagar.
- **O que mudou em relação à Entrega 1:** a correção mostrou que faltavam o ciclo de compras, a cobrança, a devolução e a comissão. Esses processos foram confirmados com a empresa e entraram no modelo (processos 2.2 e 2.4, regras RN10 a RN13). O levantamento completo está em [levantamento/levantamento.md](levantamento/levantamento.md).

#### Processos de negócio

**1. Cadastro e revalidação de clientes**
- O representante cadastra a empresa cliente com:
  - razão social, CNPJ (válido e único) e inscrição estadual (opcional);
  - endereço completo: CEP, UF, cidade, bairro, rua, número e complemento;
  - e-mail, DDD e telefone;
  - representante responsável.
- O financeiro define o limite de crédito, o código de consulta no Serasa e a situação de crédito (Ativo, Bloqueado Serasa ou Inadimplente).
- Cada confirmação dos dados grava a **data de atualização**. Quando ela passa de 90 dias, o cliente fica bloqueado para novos pedidos até ser revalidado (P1).

**2. Análise de crédito**
- Todo pedido no boleto é comparado com o limite de crédito e com a situação do cliente.
- Cliente inadimplente com a Rafimex: o pedido é bloqueado.
- Cliente com restrição no Serasa: só pode pagar no PIX ou no cartão.

**3. Orçamento e emissão do pedido**
- O representante (ou o vendedor interno) registra no pedido:
  - data, cliente e colaborador que emitiu;
  - tipo de frete (transportadora ou retirada na empresa);
  - forma de pagamento (boleto, PIX ou cartão);
  - percentual de desconto e, se passar de 4%, o registro da aprovação da diretoria;
  - para cada item: produto, quantidade, preço unitário praticado e se o item sai do estoque ou é entrega programada (com a data prevista de chegada).
- O pedido nasce como *Pendente* e passa por *Em Separação*, *Faturado* ou *Cancelado*.

**4. Faturamento e nota fiscal**
- Com o crédito aprovado e a mercadoria disponível, o pedido é faturado. A nota fiscal guarda:
  - número da NF, chave de acesso de 44 dígitos e data de emissão;
  - imposto de importação (quando a nota tem produto importado), total de impostos e valor total;
  - situação (*Emitida* ou *Cancelada*).

**5. Separação e expedição**
- A expedição separa o pedido e despacha pela transportadora, ou o cliente retira na empresa.

**6. Cobrança e recebimento**
- Cada nota gera um título a receber, com valor, vencimento e situação (*Aberto*, *Pago* ou *Cancelado*).
- PIX e cartão são pagos na emissão. O boleto vence em 28 dias.
- A baixa grava a data de pagamento. Boleto vencido e não pago leva o cliente à situação *Inadimplente* (P2).

- **7. Devolução e reentrega**
- Quando a mercadoria volta, a logística registra a nota, a data, o motivo (endereço desatualizado, avaria no transporte ou recusa do cliente) e a taxa de reentrega.
- Devolução por endereço desatualizado bloqueia o cliente até o cadastro ser revalidado (P3).

**8. Comissão dos colaboradores**
- O percentual depende do tipo de vínculo: 8% para representante externo e 3% para vendedor interno.
- A comissão é calculada sobre o valor da nota e só é liberada depois que o título é pago.

**9. Compras e importação**
- Quando um produto atinge o ponto de pedido, o setor de compras emite um pedido de compra para um fornecedor cadastrado.
- O pedido de compra registra a data, a previsão de chegada, o valor total e a situação (*Pendente*, *Recebido* ou *Cancelado*). Para cada item: produto, quantidade e custo unitário.

**10. Recebimento de mercadoria**
- A chegada da importação soma as quantidades ao estoque.
- Enquanto a mercadoria não chega, a previsão de chegada permite vender o produto como entrega programada.

**11. Contas a pagar**
- Todo pedido de compra que não foi cancelado gera uma conta a pagar, com valor, vencimento, data de pagamento e situação (*Pendente* ou *Pago*).

**12. Controle de estoque**
- Cada produto tem SKU, NCM, descrição, preço de custo, preço de venda, quantidade em estoque e ponto de pedido.
- Abaixo do ponto de pedido, o produto entra no alerta de reposição.

**Processos típicos não incluídos:**
| Processo | Por que ficou fora |
| :---- | :---- |
| Reserva de estoque no momento do pedido | A Rafimex controla a disponibilidade no momento da separação. O banco registra só o saldo e a entrega programada. |
| Parcelamento de boleto | O modelo trabalha com um título por nota fiscal. A Rafimex parcela boletos. |
| Escrituração fiscal e contábil completa | É feita pelo sistema emissor de NF-e e pela contabilidade. O banco guarda só os dados da nota necessários à gestão. |
| Folha de pagamento e RH | Fora do problema de gestão comercial. O banco guarda só os dados do colaborador necessários a vendas e comissão. |
| Cadastro de transportadoras e rotas | O frete é registrado apenas como modalidade (transportadora ou retirada), que é o que a regra de negócio exige. |

#### Requisitos

**Requisitos funcionais**

- **RF01** — Cadastrar cliente somente com CNPJ válido e único, com razão social, inscrição estadual (opcional), endereço completo (CEP, UF, cidade, bairro, rua, número, complemento), e-mail, DDD e telefone, limite de crédito, código Serasa, situação de crédito, representante responsável e data de atualização.
- **RF02** — Bloquear pedido de cliente inadimplente com a Rafimex. Em pedido no boleto, conferir o limite de crédito e a restrição no Serasa antes de liberar.
- **RF03** — Registrar todo pedido com cliente, colaborador emissor, data, valor, tipo de frete, forma de pagamento, desconto e situação.
- **RF04** — Exigir o registro da aprovação da diretoria em pedido com desconto acima de 4%.
- **RF05** — Gravar em cada item do pedido o preço unitário praticado, que não pode ser alterado depois.
- **RF06** — Registrar a modalidade de entrega do pedido (transportadora ou retirada na empresa).
- **RF07** — Indicar em cada item se ele sai do estoque ou é entrega programada; na entrega programada, a data prevista de chegada é obrigatória.
- **RF08** — Listar os produtos com estoque igual ou abaixo do ponto de pedido, com a quantidade já a caminho e a próxima chegada.
- **RF09** — Avisar quais cadastros vão vencer em até 15 dias e bloquear novos pedidos de cliente com data de atualização superior a 90 dias.
- **RF10** — Registrar pedido de compra com fornecedor cadastrado, data, previsão de chegada, valor e itens (produto, quantidade e custo unitário). No recebimento, somar as quantidades ao estoque.
- **RF11** — Gerar uma conta a pagar para cada pedido de compra não cancelado (valor, vencimento, pagamento e situação).
- **RF12** — Gerar um título a receber para cada nota fiscal e registrar a baixa com a data de pagamento.
- **RF13** — Registrar a devolução de mercadoria (nota, data, motivo e taxa de reentrega) e bloquear o cliente quando o motivo for endereço desatualizado.
- **RF14** — Calcular a comissão de cada colaborador pelo percentual do tipo de vínculo, separando a comissão liberada (título pago) da retida (título em aberto).

**Requisitos não funcionais**

- **RNF01** — Manter a data de atualização cadastral para garantir dados exatos, em conformidade com a LGPD (art. 6º, V — qualidade dos dados).
- **RNF02** — Integridade referencial estrita: nenhum item sem pedido, nenhum pedido sem cliente, e nenhuma exclusão de cliente, produto ou pedido com histórico de vendas.
- **RNF03** — Bom desempenho com o volume real (10.000 clientes, 1.550 produtos, até 200 pedidos por mês), com índices nas colunas de busca e de filtro por data.
- **RNF04** — Acesso aos dados cadastrais e de crédito restrito a usuários autorizados (LGPD, art. 6º, III — necessidade).

**Requisitos típicos não incluídos:** 
- *Integração automática com a Sefaz e com o Serasa:* a consulta e a emissão continuam nos sistemas próprios. O banco guarda o resultado (código Serasa, situação, chave da NF).
- *Portal web para o cliente confirmar os dados:* é a solução proposta para o P1. O banco já guarda a data de confirmação e lista quem precisa confirmar (G02), mas o portal em si é um sistema à parte.

#### Regras de negócio

- **RN01** — Só empresas com CNPJ regular podem comprar da Rafimex.
- **RN02** — Toda venda no boleto passa por análise de crédito: o valor não pode passar do limite de crédito do cliente.
- **RN03** — Cliente com pendência no Serasa só compra no PIX ou no cartão.
- **RN04** — Cliente com pendência direta com a Rafimex (boleto vencido e não pago) não tem nenhuma venda liberada.
- **RN05** — Todo pedido tem um cliente e um colaborador vinculados.
- **RN06** — O representante concede até 4% de desconto sozinho; acima disso, precisa da aprovação da diretoria registrada no pedido.
- **RN07** — O preço praticado em cada item fica gravado para sempre, mesmo que a tabela de preços mude depois.
- **RN08** — Produto com chegada programada (importação) pode ser vendido, desde que a data prevista de chegada esteja no item do pedido.
- **RN09** — É proibido emitir pedido para cliente cujos dados (endereço, telefone e contato financeiro) não foram confirmados nos últimos 90 dias.
- **RN10** — Compra e importação só com fornecedor cadastrado com CNPJ válido.
- **RN11** — Toda ordem de compra ou importação registra a previsão de chegada e, quando não é cancelada, gera uma conta a pagar.
- **RN12** — Comissão de 8% para representante externo e 3% para vendedor interno, liberada só depois que o cliente paga o título.
- **RN13** — Devolução por endereço incorreto ou desatualizado bloqueia o cliente até a revalidação do cadastro, independentemente da trava de 90 dias da RN09.

**Restrições legais (LGPD):** os dados de pessoa física (CPF, nascimento, endereço e contato dos colaboradores; contato do responsável em cada empresa cliente) só são acessados por quem precisa deles. Os papéis por operação, a base legal e a retenção estão no [dicionário de dados](docs/dicionario-dados.md).

**Regras típicas não incluídas:** 
- *Pedido mínimo por cliente:* Acima de R$1.500,00.
- *Prazo máximo para devolução (direito de arrependimento):* 7 dias contando a partir da data de entrega.

#### DER conceitual revisado

- **Software:** brModelo Web (<https://app.brmodeloweb.com>).
- **Imagem:** [diagramas/der-revisado.png](diagramas/der-revisado.png)

![DER conceitual revisado](diagramas/der-revisado.png)

**Revisão a partir da correção da Entrega 1 (Caso A — mesma organização)**

| Apontamento da correção da E1 | O que mudou no trabalho | Por quê |
| :---- | :---- | :---- |
| Critério 5 — sem cobrança, expedição, devolução e comissão | Processos 5 a 8 descritos; criadas as entidades DEVOLUCAO e TIPO_COLABORADOR | Cobertura dos processos da empresa (P2, P3, RN12, RN13) |
| Critério 5 — sem ciclo de compras (cadastro de fornecedores, pedido de importação, recebimento, contas a pagar) | Processos 9 a 12 descritos | O ciclo de compras existe na Rafimex e alimenta o estoque e o contas a pagar |
| Critério 5 — cadastro de clientes, orçamento e faturamento só citados | Processos 1, 3 e 4 detalhados com os dados envolvidos | Cobertura completa do ciclo de vendas |
| Critério 8 — faltavam regras de compras e de comissão | Incluídas RN10, RN11, RN12 e RN13 | Cobrem os processos que faltavam |
| Critério 8 — nota fiscal no faturamento e modalidade de entrega só como processo ou RF | Incluídas RN14 (pedido faturado tem uma única NF) e RN15 (modalidade de entrega obrigatória) | Viraram regras verificáveis: `UNIQUE` em NOTA_FISCAL.ID_PEDIDO, auditoria A07 e FK obrigatória ID_TIPO_FRETE |
| Critério 8 — reserva de estoque só citada | Justificada em "Regras típicas não incluídas" | A disponibilidade é conferida na separação, não ao lançar o pedido |
| Critério 9 — índice de CLIENTE usava CD_CNPJ | Corrigido para NR_CNPJ | Nome do atributo real |
| Critério 9 — FORNECEDOR com NR_NUMERO_TEL duas vezes e sem número de endereço | Corrigido: NR_NUMERO_TEL (telefone) e NR_NUMERO_ENDERECO (endereço) | Eram dois dados diferentes com o mesmo nome |
| Critério 9 — tipo de frete, forma de pagamento e status como "Integer" | Viraram tabelas de domínio (TIPO_FRETE, FORMA_PAGAMENTO, STATUS_PEDIDO), referenciadas por chave | Elimina a repetição de texto e valores digitados errado (3FN) |
| Critério 9 — PEDIDO sem ID_CLIENTE e ID_COLABORADOR no dicionário | Incluídos no dicionário como chaves estrangeiras | O modelo lógico precisa deles |
| Critério 9 — sem entrada de ITEM_PEDIDO, log de acesso, papéis por operação (ler, inserir, atualizar, apagar), base legal, retenção, versão com data, justificativa da collation e os símbolos / / e * * na notação | Incluídos no [dicionário de dados](docs/dicionario-dados.md); a justificativa da collation também está na seção 1.5 | Pedido explícito da correção |
| COLABORADOR com atributo `comissao` | Percentual movido para TIPO_COLABORADOR (Interno 3%, Externo 8%) | A comissão depende só do tipo de vínculo (RN12); guardá-la em cada colaborador seria dependência transitiva |
| Observação — integrante trabalha na Rafimex | Vínculo declarado na caracterização; a entrevista foi com o diretor comercial | Transparência sobre possível conflito de interesse |


### 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

- **Entidades → tabelas:** cada entidade virou uma tabela com o mesmo nome em maiúsculas: CLIENTE, COLABORADOR, PRODUTO, FORNECEDOR, PEDIDO, NOTA_FISCAL, PEDIDO_COMPRA, CONTAS_A_PAGAR, CONTAS_A_RECEBER e DEVOLUCAO. As associativas ITEM_PEDIDO e ITEM_PEDIDO_COMPRA também viraram tabelas.
- **Atributos → colunas:** cada atributo simples virou uma coluna com prefixo de tipo (`ID_`, `NM_`, `DT_`, `CD_`, `QT_`, `VL_`, `IN_`, `DS_`, `NR_`, `ST_`). Os atributos compostos foram quebrados em colunas atômicas:
  - endereço → `CD_CEP`, `CD_UF`, `DS_CIDADE`, `DS_BAIRRO`, `DS_RUA`, `NR_NUMERO`, `DS_COMPLEMENTO`;
  - telefone → `CD_DDD` e `NR_NUMERO_TEL`.
  - Não há atributo multivalorado: a Rafimex registra um telefone e um e-mail por cadastro.
- **Relacionamentos 1:N → FK no lado N:**
  - COLABORADOR atende CLIENTE → `CLIENTE.ID_COLABORADOR`;
  - CLIENTE realiza PEDIDO → `PEDIDO.ID_CLIENTE`;
  - COLABORADOR emite PEDIDO → `PEDIDO.ID_COLABORADOR`;
  - FORNECEDOR recebe PEDIDO_COMPRA → `PEDIDO_COMPRA.ID_FORNECEDOR`.
- **Relacionamentos 1:1 → FK com UNIQUE:**
  - PEDIDO emite NOTA_FISCAL → `NOTA_FISCAL.ID_PEDIDO UNIQUE`;
  - NOTA_FISCAL gera CONTAS_A_RECEBER → `CONTAS_A_RECEBER.ID_NF UNIQUE`;
  - NOTA_FISCAL tem DEVOLUCAO → `DEVOLUCAO.ID_NF UNIQUE`;
  - PEDIDO_COMPRA gera CONTAS_A_PAGAR → `CONTAS_A_PAGAR.ID_PEDIDO_COMPRA UNIQUE`.
- **Relacionamentos N:N → tabela com as duas chaves:**
  - PEDIDO–PRODUTO → `ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO)`;
  - PEDIDO_COMPRA–PRODUTO → `ITEM_PEDIDO_COMPRA (ID_PEDIDO_COMPRA, ID_PRODUTO)`;
  - FORNECEDOR–PRODUTO → `FORNECEDOR_PRODUTO (ID_FORNECEDOR, ID_PRODUTO)`.
- **Cardinalidades mínimas:**
  - mínima 1 do lado "um" → FK `NOT NULL` (todo pedido tem cliente e colaborador);
  - mínima 0 do lado da nota → a nota só existe depois do faturamento;
  - "pedido com ao menos um item" não tem constraint própria: é conferido pela auditoria A08.
- **Generalização/especialização:** colaborador interno e externo diferem só no percentual de comissão, sem atributos próprios. Por isso não viraram tabelas separadas: a diferença ficou na tabela TIPO_COLABORADOR (estratégia de tabela única, com o tipo como referência).

- ### 1.3 Definição de Chaves Primárias e Estrangeiras

| Tabela | PK | FK | Aponta para |
| :---- | :---- | :---- | :---- |
| TIPO_FRETE | ID_TIPO_FRETE | — | — |
| FORMA_PAGAMENTO | ID_FORMA_PAGAMENTO | — | — |
| STATUS_PEDIDO | ID_STATUS_PEDIDO | — | — |
| TIPO_COLABORADOR | ID_TIPO_COLABORADOR | — | — |
| COLABORADOR | ID_COLABORADOR | ID_TIPO_COLABORADOR | TIPO_COLABORADOR |
| CLIENTE | ID_CLIENTE | ID_COLABORADOR | COLABORADOR |
| PRODUTO | ID_PRODUTO | — | — |
| FORNECEDOR | ID_FORNECEDOR | — | — |
| FORNECEDOR_PRODUTO | ID_FORNECEDOR + ID_PRODUTO | ID_FORNECEDOR, ID_PRODUTO | FORNECEDOR, PRODUTO |
| PEDIDO | ID_PEDIDO | ID_CLIENTE, ID_COLABORADOR, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, ID_STATUS_PEDIDO | CLIENTE, COLABORADOR, TIPO_FRETE, FORMA_PAGAMENTO, STATUS_PEDIDO |
| ITEM_PEDIDO | ID_PEDIDO + ID_PRODUTO | ID_PEDIDO, ID_PRODUTO | PEDIDO, PRODUTO |
| NOTA_FISCAL | ID_NF | ID_PEDIDO (UNIQUE) | PEDIDO |
| CONTAS_A_RECEBER | ID_CONTA_RECEBER | ID_NF (UNIQUE) | NOTA_FISCAL |
| DEVOLUCAO | ID_DEVOLUCAO | ID_NF (UNIQUE) | NOTA_FISCAL |
| COMPRA_IMPORTACAO | ID_COMPRA | ID_FORNECEDOR | FORNECEDOR |
| ITEM_COMPRA | ID_COMPRA + ID_PRODUTO | ID_COMPRA, ID_PRODUTO | COMPRA_IMPORTACAO, PRODUTO |
| CONTAS_A_PAGAR | ID_CONTA_PAGAR | ID_COMPRA (UNIQUE) | COMPRA_IMPORTACAO |

### 1.4 Processo de Normalização (1FN, 2FN e 3FN)




