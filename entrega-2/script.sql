-- ============================================================
-- Projeto: Banco de Dados da Rafimex Comercial Importação e Exportação Ltda
--          (Rafimex Mesa Posta e Decorações)
-- Entrega 2 - Modelo Lógico e Implementação SQL
-- Grupo: Anderson Rafael da Silva, Leticia Souza Santos,
--        Maria Eduarda Sobrinho dos Santos, Nathan Vieira De Lara,
--        Ketlyn Nayara da Silva Cezar
-- SGBD: MySQL 8.0 (InnoDB, utf8mb4)
--
-- Como executar: abrir no MySQL Workbench e clicar no raio (sem
-- selecionar nada). O script apaga e recria o banco do zero.
--
-- Todos os dados são fictícios (nomes, CNPJs, CPFs e valores
-- inventados). CNPJ, CPF e chave de acesso da NF-e têm dígitos
-- verificadores válidos, mas não pertencem a ninguém.
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================
DROP DATABASE IF EXISTS db_rafimex;
CREATE DATABASE db_rafimex
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;
USE db_rafimex;


-- ============================================================
-- 2 e 3. CREATE TABLE + CONSTRAINTS (PK, FK, NOT NULL, UNIQUE, CHECK)
-- Ordem: primeiro as tabelas sem FK, depois as que dependem delas.
-- ============================================================

-- ---------- Tabelas de domínio (criadas na 3FN) ----------
-- Na Entrega 1, frete, forma de pagamento e status eram texto livre
-- dentro de PEDIDO. Viraram tabelas para não repetir o texto em cada
-- pedido e para impedir valores digitados errado ("boleto", "Boleto ").

CREATE TABLE TIPO_FRETE (
    ID_TIPO_FRETE  INT AUTO_INCREMENT PRIMARY KEY,
    DS_TIPO_FRETE  VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE FORMA_PAGAMENTO (
    ID_FORMA_PAGAMENTO  INT AUTO_INCREMENT PRIMARY KEY,
    DS_FORMA_PAGAMENTO  VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE STATUS_PEDIDO (
    ID_STATUS_PEDIDO  INT AUTO_INCREMENT PRIMARY KEY,
    DS_STATUS_PEDIDO  VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------- Cadastros ----------

CREATE TABLE COLABORADOR (
    ID_COLABORADOR         INT AUTO_INCREMENT PRIMARY KEY,
    NM_COLABORADOR         VARCHAR(120) NOT NULL,
    NR_CPF                 VARCHAR(14)  NOT NULL UNIQUE,
    DT_DATA_DE_NASCIMENTO  DATE         NOT NULL,
    CD_CEP                 VARCHAR(9)   NOT NULL,
    CD_UF                  CHAR(2)      NOT NULL,
    DS_CIDADE              VARCHAR(100) NOT NULL,
    DS_BAIRRO              VARCHAR(100) NOT NULL,
    DS_RUA                 VARCHAR(150) NOT NULL,
    NR_NUMERO              VARCHAR(10)  NOT NULL,
    DS_COMPLEMENTO         VARCHAR(100),
    DS_EMAIL               VARCHAR(100) NOT NULL,
    CD_DDD                 CHAR(2)      NOT NULL,
    NR_NUMERO_TEL          VARCHAR(14)  NOT NULL,
    TP_TIPO_COLABORADOR    VARCHAR(10)  NOT NULL,
    DS_COMISSAO            NUMERIC(5,2) NOT NULL,   -- percentual de comissão do colaborador
    CONSTRAINT CK_COLAB_CPF      CHECK (NR_CPF REGEXP '^[0-9]{3}[.][0-9]{3}[.][0-9]{3}-[0-9]{2}$'),
    CONSTRAINT CK_COLAB_CEP      CHECK (CD_CEP REGEXP '^[0-9]{5}-[0-9]{3}$'),
    CONSTRAINT CK_COLAB_EMAIL    CHECK (DS_EMAIL LIKE '%_@_%._%'),
    CONSTRAINT CK_COLAB_TIPO     CHECK (TP_TIPO_COLABORADOR IN ('Interno','Externo')),
    CONSTRAINT CK_COLAB_COMISSAO CHECK (DS_COMISSAO BETWEEN 0 AND 20)
) ENGINE=InnoDB;

CREATE INDEX IX_COLABORADOR_NOME ON COLABORADOR (NM_COLABORADOR);

CREATE TABLE CLIENTE (
    ID_CLIENTE              INT AUTO_INCREMENT PRIMARY KEY,
    ID_COLABORADOR          INT          NOT NULL,   -- representante que atende o cliente (COLABORADOR 1:N CLIENTE)
    NM_RAZAO_SOCIAL         VARCHAR(100) NOT NULL,
    NR_CNPJ                 VARCHAR(18)  NOT NULL UNIQUE,
    NR_INSCRIC_ESTADUAL     VARCHAR(20),
    CD_CEP                  VARCHAR(9)   NOT NULL,
    CD_UF                   CHAR(2)      NOT NULL,
    DS_CIDADE               VARCHAR(100) NOT NULL,
    DS_BAIRRO               VARCHAR(100) NOT NULL,
    DS_RUA                  VARCHAR(150) NOT NULL,
    NR_NUMERO               VARCHAR(10)  NOT NULL,
    DS_COMPLEMENTO          VARCHAR(100),
    DS_EMAIL                VARCHAR(100) NOT NULL,
    CD_DDD                  CHAR(2)      NOT NULL,
    NR_NUMERO_TEL           VARCHAR(10)  NOT NULL,
    VL_LIMITE_CREDITO       DECIMAL(15,2) NOT NULL DEFAULT 0,
    IN_ATIVO                BOOLEAN      NOT NULL DEFAULT TRUE,
    ID_SERASA               VARCHAR(50)  NOT NULL,
    ST_SITUACAO_CREDITO     VARCHAR(20)  NOT NULL DEFAULT 'Ativo',
    DT_DATA_DE_ATUALIZACAO  DATE         NOT NULL,
    CONSTRAINT CK_CLIENTE_CNPJ     CHECK (NR_CNPJ REGEXP '^[0-9]{2}[.][0-9]{3}[.][0-9]{3}/[0-9]{4}-[0-9]{2}$'),  -- RF01 / RN01
    CONSTRAINT CK_CLIENTE_CEP      CHECK (CD_CEP REGEXP '^[0-9]{5}-[0-9]{3}$'),
    CONSTRAINT CK_CLIENTE_EMAIL    CHECK (DS_EMAIL LIKE '%_@_%._%'),
    CONSTRAINT CK_CLIENTE_LIMITE   CHECK (VL_LIMITE_CREDITO >= 0),
    CONSTRAINT CK_CLIENTE_SITUACAO CHECK (ST_SITUACAO_CREDITO IN ('Ativo','Bloqueado Serasa','Inadimplente')),
    CONSTRAINT FK_CLIENTE_COLABORADOR FOREIGN KEY (ID_COLABORADOR) REFERENCES COLABORADOR(ID_COLABORADOR)
) ENGINE=InnoDB;

CREATE INDEX IX_CLIENTE_RAZAO_SOCIAL   ON CLIENTE (NM_RAZAO_SOCIAL);
CREATE INDEX IX_CLIENTE_DT_ATUALIZACAO ON CLIENTE (DT_DATA_DE_ATUALIZACAO);   -- usado pela trava de 90 dias (RN09)

CREATE TABLE PRODUTO (
    ID_PRODUTO         INT AUTO_INCREMENT PRIMARY KEY,
    CD_SKU             VARCHAR(30)   NOT NULL UNIQUE,
    CD_NCM             VARCHAR(10)   NOT NULL,
    DS_DESCRICAO       VARCHAR(150)  NOT NULL,
    VL_PRECO_CUSTO     NUMERIC(10,2) NOT NULL,
    VL_PRECO_UNITARIO  NUMERIC(10,2) NOT NULL,
    QT_ESTOQUE         INT NOT NULL DEFAULT 0,
    QT_PONTO_PEDIDO    INT NOT NULL DEFAULT 0,   -- RF08: abaixo disso, alerta de reposição
    CONSTRAINT CK_PRODUTO_CUSTO   CHECK (VL_PRECO_CUSTO > 0),
    CONSTRAINT CK_PRODUTO_PRECO   CHECK (VL_PRECO_UNITARIO > 0),
    CONSTRAINT CK_PRODUTO_ESTOQUE CHECK (QT_ESTOQUE >= 0),
    CONSTRAINT CK_PRODUTO_PONTO   CHECK (QT_PONTO_PEDIDO >= 0)
) ENGINE=InnoDB;

CREATE INDEX IX_PRODUTO_NCM ON PRODUTO (CD_NCM);

CREATE TABLE FORNECEDOR (
    ID_FORNECEDOR        INT AUTO_INCREMENT PRIMARY KEY,
    NR_CNPJ              VARCHAR(18)  NOT NULL UNIQUE,
    NM_RAZAO_SOCIAL      VARCHAR(100) NOT NULL,
    NR_INSCRIC_ESTADUAL  VARCHAR(20),
    DS_EMAIL             VARCHAR(100) NOT NULL,
    CD_DDD               CHAR(2)      NOT NULL,
    NR_NUMERO_TEL        VARCHAR(10)  NOT NULL,
    CD_CEP               VARCHAR(9)   NOT NULL,
    CD_UF                CHAR(2)      NOT NULL,
    DS_CIDADE            VARCHAR(100) NOT NULL,
    DS_BAIRRO            VARCHAR(100) NOT NULL,
    DS_RUA               VARCHAR(150) NOT NULL,
    NR_NUMERO_ENDERECO   VARCHAR(10)  NOT NULL,
    DS_COMPLEMENTO       VARCHAR(100),
    CONSTRAINT CK_FORNECEDOR_CNPJ  CHECK (NR_CNPJ REGEXP '^[0-9]{2}[.][0-9]{3}[.][0-9]{3}/[0-9]{4}-[0-9]{2}$'),
    CONSTRAINT CK_FORNECEDOR_CEP   CHECK (CD_CEP REGEXP '^[0-9]{5}-[0-9]{3}$'),
    CONSTRAINT CK_FORNECEDOR_EMAIL CHECK (DS_EMAIL LIKE '%_@_%._%')
) ENGINE=InnoDB;

CREATE INDEX IX_FORNECEDOR_RAZAO_SOCIAL ON FORNECEDOR (NM_RAZAO_SOCIAL);

-- FORNECEDOR (1,n) fornece (1,n) PRODUTO: o N:N da Entrega 1 vira tabela associativa.
CREATE TABLE FORNECEDOR_PRODUTO (
    ID_FORNECEDOR  INT NOT NULL,
    ID_PRODUTO     INT NOT NULL,
    PRIMARY KEY (ID_FORNECEDOR, ID_PRODUTO),
    CONSTRAINT FK_FORNPROD_FORNECEDOR FOREIGN KEY (ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR),
    CONSTRAINT FK_FORNPROD_PRODUTO    FOREIGN KEY (ID_PRODUTO)    REFERENCES PRODUTO(ID_PRODUTO)
) ENGINE=InnoDB;

-- ---------- Ciclo de vendas ----------

CREATE TABLE PEDIDO (
    ID_PEDIDO               INT AUTO_INCREMENT PRIMARY KEY,
    ID_CLIENTE              INT NOT NULL,             -- RF03 / RN05
    ID_COLABORADOR          INT NOT NULL,             -- RF03 / RN05
    DT_DATA_DO_PEDIDO       DATE NOT NULL,
    VL_VALOR_VENDA          DECIMAL(18,2) NOT NULL,   -- total já com o desconto aplicado
    ID_TIPO_FRETE           INT NOT NULL,             -- RF06
    ID_FORMA_PAGAMENTO      INT NOT NULL,
    VL_DESCONTO_APLICADO    DECIMAL(8,2) NOT NULL DEFAULT 0,   -- em %
    IN_APROVACAO_DIRETORIA  BOOLEAN NOT NULL DEFAULT FALSE,    -- RF04
    ID_STATUS_PEDIDO        INT NOT NULL,
    CONSTRAINT CK_PEDIDO_VALOR    CHECK (VL_VALOR_VENDA > 0),
    CONSTRAINT CK_PEDIDO_DESCONTO CHECK (VL_DESCONTO_APLICADO BETWEEN 0 AND 100),
    -- RN06 / RF04: desconto acima de 4% só com aprovação da diretoria registrada
    CONSTRAINT CK_PEDIDO_APROVACAO CHECK (VL_DESCONTO_APLICADO <= 4 OR IN_APROVACAO_DIRETORIA = TRUE),
    CONSTRAINT FK_PEDIDO_CLIENTE     FOREIGN KEY (ID_CLIENTE)         REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_PEDIDO_COLABORADOR FOREIGN KEY (ID_COLABORADOR)     REFERENCES COLABORADOR(ID_COLABORADOR),
    CONSTRAINT FK_PEDIDO_TIPO_FRETE  FOREIGN KEY (ID_TIPO_FRETE)      REFERENCES TIPO_FRETE(ID_TIPO_FRETE),
    CONSTRAINT FK_PEDIDO_FORMA_PGTO  FOREIGN KEY (ID_FORMA_PAGAMENTO) REFERENCES FORMA_PAGAMENTO(ID_FORMA_PAGAMENTO),
    CONSTRAINT FK_PEDIDO_STATUS      FOREIGN KEY (ID_STATUS_PEDIDO)   REFERENCES STATUS_PEDIDO(ID_STATUS_PEDIDO)
) ENGINE=InnoDB;

CREATE INDEX IX_PEDIDO_DATA ON PEDIDO (DT_DATA_DO_PEDIDO);

-- PEDIDO x PRODUTO (N:N) vira ITEM_PEDIDO, com PK composta.
CREATE TABLE ITEM_PEDIDO (
    ID_PEDIDO              INT NOT NULL,
    ID_PRODUTO             INT NOT NULL,
    QT_VENDIDA             INT NOT NULL,
    VL_UNITARIO_VENDIDO    DECIMAL(10,2) NOT NULL,     -- RF05 / RN07: preço do dia da venda, não muda depois
    IN_ENTREGA_PROGRAMADA  BOOLEAN NOT NULL DEFAULT FALSE,   -- RF07: FALSE = sai do estoque; TRUE = aguarda importação
    DT_PREVISAO_CHEGADA    DATE,                       -- RF07 / RN08: obrigatória quando a entrega é programada
    PRIMARY KEY (ID_PEDIDO, ID_PRODUTO),
    CONSTRAINT CK_ITEM_PEDIDO_QTD   CHECK (QT_VENDIDA > 0),
    CONSTRAINT CK_ITEM_PEDIDO_VALOR CHECK (VL_UNITARIO_VENDIDO > 0),
    CONSTRAINT CK_ITEM_PEDIDO_PROGRAMADA CHECK (
        (IN_ENTREGA_PROGRAMADA = FALSE AND DT_PREVISAO_CHEGADA IS NULL) OR
        (IN_ENTREGA_PROGRAMADA = TRUE  AND DT_PREVISAO_CHEGADA IS NOT NULL)),
    CONSTRAINT FK_ITEMPED_PEDIDO  FOREIGN KEY (ID_PEDIDO)  REFERENCES PEDIDO(ID_PEDIDO) ON DELETE CASCADE,
    CONSTRAINT FK_ITEMPED_PRODUTO FOREIGN KEY (ID_PRODUTO) REFERENCES PRODUTO(ID_PRODUTO)
) ENGINE=InnoDB;

-- PEDIDO (1,1) emite (1,1) NOTA_FISCAL: 1:1 vira FK com UNIQUE.
CREATE TABLE NOTA_FISCAL (
    ID_NF                  INT AUTO_INCREMENT PRIMARY KEY,
    ID_PEDIDO              INT NOT NULL UNIQUE,
    NR_NF                  INT NOT NULL UNIQUE,
    NR_CHAVE_ACESSO        VARCHAR(44) NOT NULL UNIQUE,
    DT_DATA_EMISSAO        DATE NOT NULL,
    VL_IMPOSTO_IMPORTACAO  DECIMAL(18,2),            -- só quando a nota tem produto importado
    VL_TOTAL_IMPOSTOS      DECIMAL(18,2) NOT NULL,
    VL_TOTAL_NF            DECIMAL(18,2) NOT NULL,
    DS_STATUS_NF           VARCHAR(20) NOT NULL DEFAULT 'Emitida',
    CONSTRAINT CK_NF_CHAVE   CHECK (NR_CHAVE_ACESSO REGEXP '^[0-9]{44}$'),
    CONSTRAINT CK_NF_VALORES CHECK (VL_TOTAL_NF > 0 AND VL_TOTAL_IMPOSTOS >= 0 AND VL_TOTAL_IMPOSTOS < VL_TOTAL_NF),
    CONSTRAINT CK_NF_STATUS  CHECK (DS_STATUS_NF IN ('Emitida','Cancelada')),
    CONSTRAINT FK_NF_PEDIDO  FOREIGN KEY (ID_PEDIDO) REFERENCES PEDIDO(ID_PEDIDO)
) ENGINE=InnoDB;

CREATE INDEX IX_NF_DT_EMISSAO ON NOTA_FISCAL (DT_DATA_EMISSAO);

-- ---------- Ciclo de compras (reposição e importações) ----------

CREATE TABLE PEDIDO_COMPRA (
    ID_PEDIDO_COMPRA       INT AUTO_INCREMENT PRIMARY KEY,
    ID_FORNECEDOR          INT NOT NULL,
    DT_DATA_PEDIDO_COMPRA  DATE NOT NULL,
    DT_PREVISAO_CHEGADA    DATE,
    VL_VALOR_TOTAL_COMPRA  DECIMAL(18,2) NOT NULL,
    ST_STATUS_COMPRA       VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    CONSTRAINT CK_PCOMPRA_DATAS  CHECK (DT_PREVISAO_CHEGADA IS NULL OR DT_PREVISAO_CHEGADA >= DT_DATA_PEDIDO_COMPRA),
    CONSTRAINT CK_PCOMPRA_VALOR  CHECK (VL_VALOR_TOTAL_COMPRA > 0),
    CONSTRAINT CK_PCOMPRA_STATUS CHECK (ST_STATUS_COMPRA IN ('Pendente','Recebido','Cancelado')),
    CONSTRAINT FK_PCOMPRA_FORNECEDOR FOREIGN KEY (ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR)
) ENGINE=InnoDB;

CREATE TABLE ITEM_PEDIDO_COMPRA (
    ID_PEDIDO_COMPRA          INT NOT NULL,
    ID_PRODUTO                INT NOT NULL,
    QT_SOLICITADA             INT NOT NULL,
    VL_CUSTO_UNITARIO_COMPRA  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ID_PEDIDO_COMPRA, ID_PRODUTO),
    CONSTRAINT CK_ITEMCOMPRA_QTD   CHECK (QT_SOLICITADA > 0),
    CONSTRAINT CK_ITEMCOMPRA_CUSTO CHECK (VL_CUSTO_UNITARIO_COMPRA > 0),
    CONSTRAINT FK_ITEMCOMPRA_PCOMPRA FOREIGN KEY (ID_PEDIDO_COMPRA) REFERENCES PEDIDO_COMPRA(ID_PEDIDO_COMPRA) ON DELETE CASCADE,
    CONSTRAINT FK_ITEMCOMPRA_PRODUTO FOREIGN KEY (ID_PRODUTO)       REFERENCES PRODUTO(ID_PRODUTO)
) ENGINE=InnoDB;

CREATE TABLE CONTAS_A_PAGAR (
    ID_CONTA_PAGAR       INT AUTO_INCREMENT PRIMARY KEY,
    ID_PEDIDO_COMPRA     INT NOT NULL UNIQUE,
    VL_VALOR             DECIMAL(18,2) NOT NULL,
    DT_VENCIMENTO        DATE NOT NULL,
    DT_PAGAMENTO         DATE,
    ST_STATUS_PAGAMENTO  VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    CONSTRAINT CK_CPAGAR_VALOR  CHECK (VL_VALOR > 0),
    CONSTRAINT CK_CPAGAR_STATUS CHECK (ST_STATUS_PAGAMENTO IN ('Pendente','Pago','Atrasado')),
    CONSTRAINT CK_CPAGAR_PAGO   CHECK ((ST_STATUS_PAGAMENTO = 'Pago') = (DT_PAGAMENTO IS NOT NULL)),
    CONSTRAINT FK_CPAGAR_PCOMPRA FOREIGN KEY (ID_PEDIDO_COMPRA) REFERENCES PEDIDO_COMPRA(ID_PEDIDO_COMPRA)
) ENGINE=InnoDB;

-- ---------- Regras de negócio que um CHECK não consegue garantir ----------
-- CHECK só enxerga a própria linha. As regras abaixo precisam olhar o
-- cadastro do cliente, então ficam em triggers.
--
-- A validação vale para pedidos com data de hoje em diante. Os pedidos
-- antigos da carga histórica (bloco 4) já foram aprovados na época em
-- que foram feitos; por isso não passam pela trava de novo.

DELIMITER $$

CREATE TRIGGER TRG_PEDIDO_VALIDA_CLIENTE
BEFORE INSERT ON PEDIDO
FOR EACH ROW
BEGIN
    DECLARE v_ativo          BOOLEAN;
    DECLARE v_situacao       VARCHAR(20);
    DECLARE v_dt_atualizacao DATE;
    DECLARE v_limite         DECIMAL(15,2);
    DECLARE v_forma          VARCHAR(30);

    IF NEW.DT_DATA_DO_PEDIDO >= CURDATE() THEN
        SELECT IN_ATIVO, ST_SITUACAO_CREDITO, DT_DATA_DE_ATUALIZACAO, VL_LIMITE_CREDITO
          INTO v_ativo, v_situacao, v_dt_atualizacao, v_limite
          FROM CLIENTE
         WHERE ID_CLIENTE = NEW.ID_CLIENTE;

        SELECT DS_FORMA_PAGAMENTO INTO v_forma
          FROM FORMA_PAGAMENTO
         WHERE ID_FORMA_PAGAMENTO = NEW.ID_FORMA_PAGAMENTO;

        IF v_ativo = FALSE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente inativo: pedido bloqueado.';
        END IF;

        IF v_situacao = 'Inadimplente' THEN          -- RN04 / RF02
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: cliente inadimplente com a Rafimex. Pedido bloqueado.';
        END IF;

        IF DATEDIFF(NEW.DT_DATA_DO_PEDIDO, v_dt_atualizacao) > 90 THEN   -- RN09 / RF09
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN09: cadastro sem confirmação há mais de 90 dias. Atualize o cliente antes do pedido.';
        END IF;

        IF v_situacao = 'Bloqueado Serasa' AND v_forma = 'Boleto' THEN   -- RN03
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN03: cliente com restrição no Serasa só compra no PIX ou no cartão.';
        END IF;

        IF v_forma = ' Boleto' AND NEW.VL_VALOR_VENDA > v_limite THEN     -- RN02 / RF02
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN02: valor do pedido acima do limite de crédito do cliente.';
        END IF;
    END IF;
END$$

-- RN07 / RF05: o preço praticado fica gravado para sempre.
CREATE TRIGGER TRG_ITEM_PEDIDO_PRECO_FIXO
BEFORE UPDATE ON ITEM_PEDIDO
FOR EACH ROW
BEGIN
    IF NEW.VL_UNITARIO_VENDIDO <> OLD.VL_UNITARIO_VENDIDO THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN07: o preço praticado na venda não pode ser alterado.';
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- 4. INSERT (massa de dados fictícia)
-- Inserida na mesma ordem em que as tabelas foram criadas.
-- ============================================================

-- Domínios
INSERT INTO TIPO_FRETE (DS_TIPO_FRETE) VALUES ('Transportadora'), ('Retirada na Empresa');
INSERT INTO FORMA_PAGAMENTO (DS_FORMA_PAGAMENTO) VALUES ('Boleto'), ('PIX'), ('Cartão');
INSERT INTO STATUS_PEDIDO (DS_STATUS_PEDIDO) VALUES ('Pendente'), ('Em Separação'), ('Faturado'), ('Cancelado');

-- 12 colaboradores (10 externos e 2 internos)
INSERT INTO COLABORADOR (NM_COLABORADOR, NR_CPF, DT_DATA_DE_NASCIMENTO, CD_CEP, CD_UF, DS_CIDADE, DS_BAIRRO, DS_RUA, NR_NUMERO, DS_COMPLEMENTO, DS_EMAIL, CD_DDD, NR_NUMERO_TEL, TP_TIPO_COLABORADOR, DS_COMISSAO) VALUES


-- 40 clientes. De propósito: 3 com restrição no Serasa (2, 19, 27), 3 inadimplentes (4, 29, 38),
-- 1 inativo (39), 5 que nunca compraram (15, 28, 37, 39, 40) e 7 com cadastro vencido há mais de 90 dias.
INSERT INTO CLIENTE (ID_COLABORADOR, NM_RAZAO_SOCIAL, NR_CNPJ, NR_INSCRIC_ESTADUAL, CD_CEP, CD_UF, DS_CIDADE, DS_BAIRRO, DS_RUA, NR_NUMERO, DS_COMPLEMENTO, DS_EMAIL, CD_DDD, NR_NUMERO_TEL, VL_LIMITE_CREDITO, IN_ATIVO, ID_SERASA, ST_SITUACAO_CREDITO, DT_DATA_DE_ATUALIZACAO) VALUES
--
-- 30 produtos. Abaixo do ponto de pedido de propósito: SKU-002, 006, 013, 018 (sem estoque), 022 e 030.
INSERT INTO PRODUTO (CD_SKU, CD_NCM, DS_DESCRICAO, VL_PRECO_CUSTO, VL_PRECO_UNITARIO, QT_ESTOQUE, QT_PONTO_PEDIDO) VALUES


-- 8 fornecedores
INSERT INTO FORNECEDOR (NR_CNPJ, NM_RAZAO_SOCIAL, NR_INSCRIC_ESTADUAL, DS_EMAIL, CD_DDD, NR_NUMERO_TEL, CD_CEP, CD_UF, DS_CIDADE, DS_BAIRRO, DS_RUA, NR_NUMERO_ENDERECO, DS_COMPLEMENTO) VALUES


INSERT INTO FORNECEDOR_PRODUTO (ID_FORNECEDOR, ID_PRODUTO) VALUES


-- 149 pedidos de maio a outubro/2026. Pedidos anteriores a 01/09/2026 usam a tabela de preços antiga
-- (6% menor): é o preço praticado do dia, que fica gravado no item (RN07).
INSERT INTO PEDIDO (ID_CLIENTE, ID_COLABORADOR, DT_DATA_DO_PEDIDO, VL_VALOR_VENDA, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, VL_DESCONTO_APLICADO, IN_APROVACAO_DIRETORIA, ID_STATUS_PEDIDO) VALUES


-- 342 itens de pedido
INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QT_VENDIDA, VL_UNITARIO_VENDIDO, IN_ENTREGA_PROGRAMADA, DT_PREVISAO_CHEGADA) VALUES


-- 129 notas fiscais (2 canceladas após a emissão)
INSERT INTO NOTA_FISCAL (ID_PEDIDO, NR_NF, NR_CHAVE_ACESSO, DT_DATA_EMISSAO, VL_IMPOSTO_IMPORTACAO, VL_TOTAL_IMPOSTOS, VL_TOTAL_NF, DS_STATUS_NF) VALUES


-- 15 pedidos de compra
INSERT INTO PEDIDO_COMPRA (ID_FORNECEDOR, DT_DATA_PEDIDO_COMPRA, DT_PREVISAO_CHEGADA, VL_VALOR_TOTAL_COMPRA, ST_STATUS_COMPRA) VALUES


INSERT INTO ITEM_PEDIDO_COMPRA (ID_PEDIDO_COMPRA, ID_PRODUTO, QT_SOLICITADA, VL_CUSTO_UNITARIO_COMPRA) VALUES


INSERT INTO CONTAS_A_PAGAR (ID_PEDIDO_COMPRA, VL_VALOR, DT_VENCIMENTO, DT_PAGAMENTO, ST_STATUS_PAGAMENTO) VALUES



-- ============================================================
-- 5. SELECT COM JOIN
-- ============================================================

-- 5.1 Quais produtos foram vendidos em cada pedido, para quem e por qual representante?
SELECT
    p.ID_PEDIDO,
    p.DT_DATA_DO_PEDIDO,
    c.NM_RAZAO_SOCIAL                        AS CLIENTE,
    col.NM_COLABORADOR                       AS REPRESENTANTE,
    pr.DS_DESCRICAO                          AS PRODUTO,
    ip.QT_VENDIDA,
    ip.VL_UNITARIO_VENDIDO,
    ip.QT_VENDIDA * ip.VL_UNITARIO_VENDIDO   AS SUBTOTAL,
    IF(ip.IN_ENTREGA_PROGRAMADA, CONCAT('Programada p/ ', DATE_FORMAT(ip.DT_PREVISAO_CHEGADA, '%d/%m/%Y')), 'Estoque') AS ENTREGA
FROM PEDIDO p
JOIN CLIENTE c       ON c.ID_CLIENTE       = p.ID_CLIENTE
JOIN COLABORADOR col ON col.ID_COLABORADOR = p.ID_COLABORADOR
JOIN ITEM_PEDIDO ip  ON ip.ID_PEDIDO       = p.ID_PEDIDO
JOIN PRODUTO pr      ON pr.ID_PRODUTO      = ip.ID_PRODUTO
ORDER BY p.ID_PEDIDO, pr.DS_DESCRICAO;

-- 5.2 Quais notas fiscais foram emitidas, para qual cliente, com qual frete e forma de pagamento?
SELECT
    nf.NR_NF,
    nf.DT_DATA_EMISSAO,
    c.NM_RAZAO_SOCIAL      AS CLIENTE,
    tf.DS_TIPO_FRETE       AS FRETE,
    fp.DS_FORMA_PAGAMENTO  AS PAGAMENTO,
    nf.VL_TOTAL_NF,
    nf.DS_STATUS_NF
FROM NOTA_FISCAL nf
JOIN PEDIDO p           ON p.ID_PEDIDO           = nf.ID_PEDIDO
JOIN CLIENTE c          ON c.ID_CLIENTE          = p.ID_CLIENTE
JOIN TIPO_FRETE tf      ON tf.ID_TIPO_FRETE      = p.ID_TIPO_FRETE
JOIN FORMA_PAGAMENTO fp ON fp.ID_FORMA_PAGAMENTO = p.ID_FORMA_PAGAMENTO
ORDER BY nf.NR_NF;

-- 5.3 Quais fornecedores atendem cada produto?
SELECT
    pr.CD_SKU,
    pr.DS_DESCRICAO,
    GROUP_CONCAT(f.NM_RAZAO_SOCIAL ORDER BY f.NM_RAZAO_SOCIAL SEPARATOR ' / ') AS FORNECEDORES
FROM PRODUTO pr
JOIN FORNECEDOR_PRODUTO fp ON fp.ID_PRODUTO   = pr.ID_PRODUTO
JOIN FORNECEDOR f          ON f.ID_FORNECEDOR = fp.ID_FORNECEDOR
GROUP BY pr.ID_PRODUTO, pr.CD_SKU, pr.DS_DESCRICAO
ORDER BY pr.CD_SKU;

-- 5.4 Qual é a carteira de cada representante (quantos clientes e quantos pedidos)?
SELECT
    col.NM_COLABORADOR,
    col.TP_TIPO_COLABORADOR,
    COUNT(DISTINCT c.ID_CLIENTE) AS QTD_CLIENTES,
    COUNT(DISTINCT p.ID_PEDIDO)  AS QTD_PEDIDOS_DA_CARTEIRA
FROM COLABORADOR col
LEFT JOIN CLIENTE c ON c.ID_COLABORADOR = col.ID_COLABORADOR
LEFT JOIN PEDIDO p  ON p.ID_CLIENTE     = c.ID_CLIENTE
GROUP BY col.ID_COLABORADOR, col.NM_COLABORADOR, col.TP_TIPO_COLABORADOR
ORDER BY QTD_PEDIDOS_DA_CARTEIRA DESC;

-- 5.5 Quais pedidos de compra estão em aberto, de qual fornecedor e com que conta a pagar?
SELECT
    pc.ID_PEDIDO_COMPRA,
    f.NM_RAZAO_SOCIAL AS FORNECEDOR,
    pc.DT_DATA_PEDIDO_COMPRA,
    pc.DT_PREVISAO_CHEGADA,
    pc.VL_VALOR_TOTAL_COMPRA,
    cp.DT_VENCIMENTO,
    cp.ST_STATUS_PAGAMENTO
FROM PEDIDO_COMPRA pc
JOIN FORNECEDOR f          ON f.ID_FORNECEDOR     = pc.ID_FORNECEDOR
LEFT JOIN CONTAS_A_PAGAR cp ON cp.ID_PEDIDO_COMPRA = pc.ID_PEDIDO_COMPRA
WHERE pc.ST_STATUS_COMPRA = 'Pendente'
ORDER BY pc.DT_PREVISAO_CHEGADA;


-- ============================================================
-- 6. UPDATE
-- ============================================================
SET SQL_SAFE_UPDATES = 0;   -- o Workbench bloqueia UPDATE/DELETE sem chave no WHERE

-- 6.1 Cliente confirmou os dados pelo Portal de Confirmação Ativa: reinicia a trava de 90 dias (RN09)
UPDATE CLIENTE
SET DT_DATA_DE_ATUALIZACAO = CURDATE()
WHERE ID_CLIENTE = 9;

-- 6.2 Financeiro deu baixa na conta a pagar que estava atrasada
UPDATE CONTAS_A_PAGAR
SET DT_PAGAMENTO = CURDATE(),
    ST_STATUS_PAGAMENTO = 'Pago'
WHERE ID_CONTA_PAGAR = 12;

-- 6.3 Reajuste de 5% na tabela de preços dos produtos da Cristais Europa (fornecedor 2).
-- Os itens já vendidos continuam com o preço antigo (RN07): confira na consulta 9.7.
UPDATE PRODUTO
SET VL_PRECO_UNITARIO = ROUND(VL_PRECO_UNITARIO * 1.05, 2)
WHERE ID_PRODUTO IN (SELECT ID_PRODUTO FROM FORNECEDOR_PRODUTO WHERE ID_FORNECEDOR = 2);

-- 6.4 Chegou o pedido de compra 15: soma as quantidades no estoque e marca como recebido
UPDATE PRODUTO pr
JOIN ITEM_PEDIDO_COMPRA ipc ON ipc.ID_PRODUTO = pr.ID_PRODUTO
JOIN PEDIDO_COMPRA pc       ON pc.ID_PEDIDO_COMPRA = ipc.ID_PEDIDO_COMPRA
SET pr.QT_ESTOQUE = pr.QT_ESTOQUE + ipc.QT_SOLICITADA
WHERE pc.ID_PEDIDO_COMPRA = 15 AND pc.ST_STATUS_COMPRA = 'Pendente';

UPDATE PEDIDO_COMPRA
SET ST_STATUS_COMPRA = 'Recebido'
WHERE ID_PEDIDO_COMPRA = 15;

-- 6.5 Pedido pendente liberado pelo financeiro: vai para a separação
UPDATE PEDIDO
SET ID_STATUS_PEDIDO = (SELECT ID_STATUS_PEDIDO FROM STATUS_PEDIDO WHERE DS_STATUS_PEDIDO = 'Em Separação')
WHERE ID_PEDIDO = 142;


-- ============================================================
-- 7. DELETE
-- Pedido com nota fiscal, cliente com pedido e produto já vendido
-- não podem ser apagados: as FKs bloqueiam (RNF02).
-- ============================================================

-- 7.1 Pedido cancelado lançado em duplicidade (não tem NF). Os itens saem juntos (ON DELETE CASCADE).
DELETE FROM PEDIDO
WHERE ID_PEDIDO = 106
  AND ID_STATUS_PEDIDO = (SELECT ID_STATUS_PEDIDO FROM STATUS_PEDIDO WHERE DS_STATUS_PEDIDO = 'Cancelado');

-- 7.2 Pedido de compra cancelado, sem conta a pagar. Os itens saem juntos (ON DELETE CASCADE).
DELETE FROM PEDIDO_COMPRA
WHERE ID_PEDIDO_COMPRA = 12
  AND ST_STATUS_COMPRA = 'Cancelado';

-- 7.3 A Cerâmica Artesanal do Sul deixou de fornecer a Sopeira de Porcelana
DELETE FROM FORNECEDOR_PRODUTO
WHERE ID_FORNECEDOR = 5 AND ID_PRODUTO = 22;

-- 7.4 Cliente inativo que nunca comprou (cadastro de prospecção antigo)
DELETE FROM CLIENTE
WHERE IN_ATIVO = FALSE
  AND NOT EXISTS (SELECT 1 FROM PEDIDO p WHERE p.ID_CLIENTE = CLIENTE.ID_CLIENTE);

SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- 8. CONSULTAS GERENCIAIS
-- ============================================================

-- 8.1 Quanto a Rafimex faturou por mês e qual foi o ticket médio?
SELECT
    DATE_FORMAT(nf.DT_DATA_EMISSAO, '%Y-%m') AS MES,
    COUNT(*)                                 AS QTD_NOTAS,
    SUM(nf.VL_TOTAL_NF)                      AS FATURAMENTO,
    ROUND(AVG(nf.VL_TOTAL_NF), 2)            AS TICKET_MEDIO
FROM NOTA_FISCAL nf
WHERE nf.DS_STATUS_NF = 'Emitida'
GROUP BY MES
ORDER BY MES;

-- 8.2 Quanto cada colaborador deve receber de comissão em outubro/2026?
SELECT
    col.NM_COLABORADOR,
    col.TP_TIPO_COLABORADOR,
    col.DS_COMISSAO                                     AS PERC_COMISSAO,
    SUM(nf.VL_TOTAL_NF)                                 AS VALOR_FATURADO,
    ROUND(SUM(nf.VL_TOTAL_NF) * col.DS_COMISSAO / 100, 2) AS VALOR_COMISSAO
FROM COLABORADOR col
JOIN PEDIDO p       ON p.ID_COLABORADOR = col.ID_COLABORADOR
JOIN NOTA_FISCAL nf ON nf.ID_PEDIDO     = p.ID_PEDIDO
WHERE nf.DS_STATUS_NF = 'Emitida'
  AND nf.DT_DATA_EMISSAO BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY col.ID_COLABORADOR, col.NM_COLABORADOR, col.TP_TIPO_COLABORADOR, col.DS_COMISSAO
ORDER BY VALOR_COMISSAO DESC;

-- 8.3 Quais são os 10 clientes que mais compraram?
SELECT
    c.NM_RAZAO_SOCIAL,
    c.DS_CIDADE,
    COUNT(nf.ID_NF)      AS QTD_NOTAS,
    SUM(nf.VL_TOTAL_NF)  AS FATURAMENTO_TOTAL
FROM CLIENTE c
JOIN PEDIDO p       ON p.ID_CLIENTE = c.ID_CLIENTE
JOIN NOTA_FISCAL nf ON nf.ID_PEDIDO = p.ID_PEDIDO AND nf.DS_STATUS_NF = 'Emitida'
GROUP BY c.ID_CLIENTE, c.NM_RAZAO_SOCIAL, c.DS_CIDADE
ORDER BY FATURAMENTO_TOTAL DESC
LIMIT 10;

-- 8.4 Quais são os 5 produtos mais vendidos e quanto deram de margem bruta?
SELECT
    pr.CD_SKU,
    pr.DS_DESCRICAO,
    SUM(ip.QT_VENDIDA)                                              AS UNIDADES,
    SUM(ip.QT_VENDIDA * ip.VL_UNITARIO_VENDIDO)                     AS RECEITA,
    SUM(ip.QT_VENDIDA * (ip.VL_UNITARIO_VENDIDO - pr.VL_PRECO_CUSTO)) AS MARGEM_BRUTA
FROM ITEM_PEDIDO ip
JOIN PRODUTO pr      ON pr.ID_PRODUTO       = ip.ID_PRODUTO
JOIN PEDIDO p        ON p.ID_PEDIDO         = ip.ID_PEDIDO
JOIN STATUS_PEDIDO s ON s.ID_STATUS_PEDIDO  = p.ID_STATUS_PEDIDO
WHERE s.DS_STATUS_PEDIDO <> 'Cancelado'
GROUP BY pr.ID_PRODUTO, pr.CD_SKU, pr.DS_DESCRICAO
ORDER BY UNIDADES DESC
LIMIT 5;

-- 8.5 Qual é a taxa de cancelamento de pedidos por mês?
SELECT
    DATE_FORMAT(p.DT_DATA_DO_PEDIDO, '%Y-%m')                     AS MES,
    COUNT(*)                                                      AS TOTAL_PEDIDOS,
    SUM(s.DS_STATUS_PEDIDO = 'Cancelado')                         AS CANCELADOS,
    ROUND(100 * SUM(s.DS_STATUS_PEDIDO = 'Cancelado') / COUNT(*), 1) AS TAXA_CANCELAMENTO_PCT
FROM PEDIDO p
JOIN STATUS_PEDIDO s ON s.ID_STATUS_PEDIDO = p.ID_STATUS_PEDIDO
GROUP BY MES
ORDER BY MES;

-- 8.6 Quais produtos estão abaixo do ponto de pedido e quanto já está a caminho? (alerta de reposição - RF08)
SELECT
    pr.CD_SKU,
    pr.DS_DESCRICAO,
    pr.QT_ESTOQUE,
    pr.QT_PONTO_PEDIDO,
    COALESCE(cam.QT_A_CAMINHO, 0) AS QT_A_CAMINHO,
    cam.PROXIMA_CHEGADA
FROM PRODUTO pr
LEFT JOIN (
    SELECT ipc.ID_PRODUTO,
           SUM(ipc.QT_SOLICITADA)      AS QT_A_CAMINHO,
           MIN(pc.DT_PREVISAO_CHEGADA) AS PROXIMA_CHEGADA
    FROM ITEM_PEDIDO_COMPRA ipc
    JOIN PEDIDO_COMPRA pc ON pc.ID_PEDIDO_COMPRA = ipc.ID_PEDIDO_COMPRA
    WHERE pc.ST_STATUS_COMPRA = 'Pendente'
    GROUP BY ipc.ID_PRODUTO
) cam ON cam.ID_PRODUTO = pr.ID_PRODUTO
WHERE pr.QT_ESTOQUE <= pr.QT_PONTO_PEDIDO
ORDER BY pr.QT_ESTOQUE;

-- 8.7 Como as vendas se dividem por forma de pagamento?
SELECT
    fp.DS_FORMA_PAGAMENTO,
    COUNT(*)                                           AS QTD_PEDIDOS,
    SUM(p.VL_VALOR_VENDA)                              AS VALOR_TOTAL,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM PEDIDO), 1) AS PCT_PEDIDOS
FROM PEDIDO p
JOIN FORMA_PAGAMENTO fp ON fp.ID_FORMA_PAGAMENTO = p.ID_FORMA_PAGAMENTO
GROUP BY fp.ID_FORMA_PAGAMENTO, fp.DS_FORMA_PAGAMENTO
ORDER BY QTD_PEDIDOS DESC;


-- ============================================================
-- 9. CONSULTAS DE AUDITORIA
-- ============================================================

-- 9.1 Quais clientes estão com o cadastro sem confirmação há mais de 90 dias? (RN09 / RF09)
SELECT
    c.ID_CLIENTE,
    c.NM_RAZAO_SOCIAL,
    col.NM_COLABORADOR AS REPRESENTANTE,
    c.DT_DATA_DE_ATUALIZACAO,
    DATEDIFF(CURDATE(), c.DT_DATA_DE_ATUALIZACAO) AS DIAS_SEM_ATUALIZAR
FROM CLIENTE c
JOIN COLABORADOR col ON col.ID_COLABORADOR = c.ID_COLABORADOR
WHERE DATEDIFF(CURDATE(), c.DT_DATA_DE_ATUALIZACAO) > 90
ORDER BY DIAS_SEM_ATUALIZAR DESC;

-- 9.2 Há pedidos em aberto de clientes com restrição de crédito? (devem ser segurados - RN03 / RN04)
SELECT
    p.ID_PEDIDO,
    p.DT_DATA_DO_PEDIDO,
    c.NM_RAZAO_SOCIAL,
    c.ST_SITUACAO_CREDITO,
    fp.DS_FORMA_PAGAMENTO,
    s.DS_STATUS_PEDIDO,
    p.VL_VALOR_VENDA
FROM PEDIDO p
JOIN CLIENTE c          ON c.ID_CLIENTE          = p.ID_CLIENTE
JOIN STATUS_PEDIDO s    ON s.ID_STATUS_PEDIDO    = p.ID_STATUS_PEDIDO
JOIN FORMA_PAGAMENTO fp ON fp.ID_FORMA_PAGAMENTO = p.ID_FORMA_PAGAMENTO
WHERE s.DS_STATUS_PEDIDO IN ('Pendente', 'Em Separação')
  AND c.ST_SITUACAO_CREDITO <> 'Ativo';

-- 9.3 Quais contas a pagar estão vencidas e ainda não foram pagas?
SELECT
    cp.ID_CONTA_PAGAR,
    f.NM_RAZAO_SOCIAL AS FORNECEDOR,
    cp.DT_VENCIMENTO,
    DATEDIFF(CURDATE(), cp.DT_VENCIMENTO) AS DIAS_DE_ATRASO,
    cp.VL_VALOR,
    cp.ST_STATUS_PAGAMENTO
FROM CONTAS_A_PAGAR cp
JOIN PEDIDO_COMPRA pc ON pc.ID_PEDIDO_COMPRA = cp.ID_PEDIDO_COMPRA
JOIN FORNECEDOR f     ON f.ID_FORNECEDOR     = pc.ID_FORNECEDOR
WHERE cp.ST_STATUS_PAGAMENTO <> 'Pago'
  AND cp.DT_VENCIMENTO < CURDATE();

-- 9.4 Quais itens de entrega programada já passaram da data prometida ao cliente? (RN08)
SELECT
    ip.ID_PEDIDO,
    c.NM_RAZAO_SOCIAL AS CLIENTE,
    pr.DS_DESCRICAO,
    ip.QT_VENDIDA,
    ip.DT_PREVISAO_CHEGADA
FROM ITEM_PEDIDO ip
JOIN PEDIDO p   ON p.ID_PEDIDO   = ip.ID_PEDIDO
JOIN CLIENTE c  ON c.ID_CLIENTE  = p.ID_CLIENTE
JOIN PRODUTO pr ON pr.ID_PRODUTO = ip.ID_PRODUTO
WHERE ip.IN_ENTREGA_PROGRAMADA = TRUE
  AND ip.DT_PREVISAO_CHEGADA < CURDATE();

-- 9.5 Há pedidos faturados sem nota fiscal, ou nota com valor diferente do pedido? (o esperado é vazio)
SELECT
    p.ID_PEDIDO,
    s.DS_STATUS_PEDIDO,
    p.VL_VALOR_VENDA,
    nf.NR_NF,
    nf.VL_TOTAL_NF
FROM PEDIDO p
JOIN STATUS_PEDIDO s    ON s.ID_STATUS_PEDIDO = p.ID_STATUS_PEDIDO
LEFT JOIN NOTA_FISCAL nf ON nf.ID_PEDIDO      = p.ID_PEDIDO
WHERE (s.DS_STATUS_PEDIDO = 'Faturado' AND nf.ID_NF IS NULL)
   OR (nf.ID_NF IS NOT NULL AND nf.VL_TOTAL_NF <> p.VL_VALOR_VENDA);

-- 9.6 Há pedidos sem nenhum item? (o esperado é vazio)
SELECT p.ID_PEDIDO, p.DT_DATA_DO_PEDIDO
FROM PEDIDO p
LEFT JOIN ITEM_PEDIDO ip ON ip.ID_PEDIDO = p.ID_PEDIDO
WHERE ip.ID_PEDIDO IS NULL;

-- 9.7 Quais vendas usaram um preço diferente da tabela atual? (prova de que a RN07 funciona)
SELECT
    ip.ID_PEDIDO,
    p.DT_DATA_DO_PEDIDO,
    pr.DS_DESCRICAO,
    ip.VL_UNITARIO_VENDIDO AS PRECO_NA_VENDA,
    pr.VL_PRECO_UNITARIO   AS PRECO_ATUAL
FROM ITEM_PEDIDO ip
JOIN PEDIDO p   ON p.ID_PEDIDO   = ip.ID_PEDIDO
JOIN PRODUTO pr ON pr.ID_PRODUTO = ip.ID_PRODUTO
WHERE ip.VL_UNITARIO_VENDIDO <> pr.VL_PRECO_UNITARIO
ORDER BY p.DT_DATA_DO_PEDIDO DESC;

-- 9.8 Quais clientes nunca compraram?
SELECT c.ID_CLIENTE, c.NM_RAZAO_SOCIAL, c.DS_CIDADE, c.DT_DATA_DE_ATUALIZACAO
FROM CLIENTE c
WHERE NOT EXISTS (SELECT 1 FROM PEDIDO p WHERE p.ID_CLIENTE = c.ID_CLIENTE);

-- 9.9 Quais pedidos tiveram desconto acima de 4%? (conferência das aprovações da diretoria - RN06)
SELECT
    p.ID_PEDIDO,
    p.DT_DATA_DO_PEDIDO,
    c.NM_RAZAO_SOCIAL,
    col.NM_COLABORADOR,
    p.VL_DESCONTO_APLICADO,
    p.IN_APROVACAO_DIRETORIA
FROM PEDIDO p
JOIN CLIENTE c       ON c.ID_CLIENTE       = p.ID_CLIENTE
JOIN COLABORADOR col ON col.ID_COLABORADOR = p.ID_COLABORADOR
WHERE p.VL_DESCONTO_APLICADO > 4
ORDER BY p.VL_DESCONTO_APLICADO DESC;


-- ============================================================
-- TESTES DAS REGRAS (para a apresentação)
-- Cada comando abaixo DEVE dar erro. Estão comentados para o script
-- rodar inteiro sem parar. Para testar, selecione uma linha (sem os
-- dois traços) e execute só ela.
-- ============================================================

-- RN04: cliente 4 é inadimplente
-- INSERT INTO PEDIDO (ID_CLIENTE, ID_COLABORADOR, DT_DATA_DO_PEDIDO, VL_VALOR_VENDA, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, ID_STATUS_PEDIDO) VALUES (4, 7, CURDATE(), 500.00, 1, 2, 1);

-- RN09: cliente 14 está com o cadastro vencido há mais de 90 dias
-- INSERT INTO PEDIDO (ID_CLIENTE, ID_COLABORADOR, DT_DATA_DO_PEDIDO, VL_VALOR_VENDA, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, ID_STATUS_PEDIDO) VALUES (14, 1, CURDATE(), 500.00, 1, 2, 1);

-- RN03: cliente 2 tem restrição no Serasa e tentou pagar com boleto
-- INSERT INTO PEDIDO (ID_CLIENTE, ID_COLABORADOR, DT_DATA_DO_PEDIDO, VL_VALOR_VENDA, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, ID_STATUS_PEDIDO) VALUES (2, 1, CURDATE(), 500.00, 1, 1, 1);

-- RN06: desconto de 6% sem aprovação da diretoria (CHECK CK_PEDIDO_APROVACAO)
-- INSERT INTO PEDIDO (ID_CLIENTE, ID_COLABORADOR, DT_DATA_DO_PEDIDO, VL_VALOR_VENDA, ID_TIPO_FRETE, ID_FORMA_PAGAMENTO, VL_DESCONTO_APLICADO, ID_STATUS_PEDIDO) VALUES (1, 1, CURDATE(), 500.00, 1, 2, 6.00, 1);

-- RN07: tentar mudar o preço de um item já vendido
-- UPDATE ITEM_PEDIDO SET VL_UNITARIO_VENDIDO = 1.00 WHERE ID_PEDIDO = 1;

-- RNF02: apagar um produto que já foi vendido e tem fornecedor vinculado (as FKs bloqueiam)
-- DELETE FROM PRODUTO WHERE ID_PRODUTO = 1;

