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

