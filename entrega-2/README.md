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
  - Perfil no Google Meu Negócio: ⚠️ PREENCHER (link do perfil da Rafimex, se houver)
  - Fotos (no repositório): [fachada](entrega-1/IMAGEM_FACHADA_RAFIMEX.jpeg) e [visita técnica](entrega-1/IMAGEM_VISITACAO_RAFIMEX.jpeg).
- **Responsável pela organização:** Gabriel Gedanken, diretor comercial. Telefone: (11) 99471-1531.

