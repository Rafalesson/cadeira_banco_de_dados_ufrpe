-- =============================================================================
-- RentFlow - Modelo Físico
-- Schema: public
-- =============================================================================

-- =============================================================================
-- TIPOS ENUM
-- =============================================================================

CREATE TYPE status_veiculo     AS ENUM ('disponivel', 'locado', 'em_manutencao', 'inativo');
CREATE TYPE status_locacao     AS ENUM ('reservada', 'ativa', 'encerrada', 'cancelada');
CREATE TYPE tipo_combustivel   AS ENUM ('gasolina', 'etanol', 'flex', 'diesel', 'eletrico');
CREATE TYPE tipo_vistoria      AS ENUM ('retirada', 'devolucao');
CREATE TYPE cargo_funcionario  AS ENUM ('atendente', 'gerente');
CREATE TYPE tipo_cobranca      AS ENUM ('avaria', 'combustivel', 'multa', 'outros');
CREATE TYPE tipo_manutencao    AS ENUM ('preventiva', 'corretiva');
CREATE TYPE forma_pagamento    AS ENUM ('dinheiro', 'credito', 'debito', 'pix');
CREATE TYPE categoria_cnh      AS ENUM ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE');

-- =============================================================================
-- TABELAS (ordem respeita dependências de FK)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Nível 0 — sem dependências externas
-- -----------------------------------------------------------------------------

CREATE TABLE CATEGORIAS (
    id_cat       INT             GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome         VARCHAR(100)    NOT NULL,
    valor_diaria NUMERIC(10, 2)  NOT NULL CHECK (valor_diaria > 0)
);

CREATE TABLE CLIENTES (
    cpf               VARCHAR(14)    PRIMARY KEY,
    nome              VARCHAR(150)   NOT NULL,
    data_nascimento   DATE           NOT NULL,
    email             VARCHAR(200)   NOT NULL UNIQUE,
    inadimplente      BOOLEAN        NOT NULL DEFAULT FALSE,
    cnh_numero        VARCHAR(20)    NOT NULL UNIQUE,
    cnh_categoria     categoria_cnh  NOT NULL,
    cnh_validade      DATE           NOT NULL,
    endereco_rua      VARCHAR(200)   NOT NULL,
    endereco_numero   VARCHAR(20)    NOT NULL,
    endereco_bairro   VARCHAR(100)   NOT NULL,
    endereco_cidade   VARCHAR(100)   NOT NULL,
    endereco_estado   CHAR(2)        NOT NULL,
    endereco_cep      VARCHAR(9)     NOT NULL,

    CONSTRAINT chk_clientes_cnh_validade
        CHECK (cnh_validade > data_nascimento)
);

CREATE TABLE FUNCIONARIOS (
    id_func  INT               GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome     VARCHAR(150)      NOT NULL,
    cpf      VARCHAR(14)       NOT NULL UNIQUE,
    cargo    cargo_funcionario NOT NULL
);

CREATE TABLE SEGUROS (
    id_seguro           INT             GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                VARCHAR(100)    NOT NULL,
    descricao_cobertura TEXT            NOT NULL,
    valor_diario        NUMERIC(10, 2)  NOT NULL CHECK (valor_diario > 0)
);

-- -----------------------------------------------------------------------------
-- Nível 1 — dependem de nível 0
-- -----------------------------------------------------------------------------

CREATE TABLE VEICULOS (
    placa             VARCHAR(8)       PRIMARY KEY,
    id_cat            INT              NOT NULL REFERENCES CATEGORIAS (id_cat),
    renavam           VARCHAR(11)      NOT NULL UNIQUE,
    marca             VARCHAR(50)      NOT NULL,
    modelo            VARCHAR(100)     NOT NULL,
    cor               VARCHAR(50)      NOT NULL,
    ano_fabricacao    SMALLINT         NOT NULL CHECK (ano_fabricacao >= 1886),
    tipo_combustivel  tipo_combustivel NOT NULL,
    km_atual          INT              NOT NULL DEFAULT 0 CHECK (km_atual >= 0),
    nivel_combustivel SMALLINT         NOT NULL DEFAULT 100
                          CHECK (nivel_combustivel BETWEEN 0 AND 100),
    status            status_veiculo   NOT NULL DEFAULT 'disponivel'
);

CREATE TABLE TELEFONES_CLIENTE (
    cpf_cliente  VARCHAR(14)  NOT NULL REFERENCES CLIENTES (cpf) ON DELETE CASCADE,
    numero       VARCHAR(20)  NOT NULL,
    tipo         VARCHAR(20)  NOT NULL,

    PRIMARY KEY (cpf_cliente, numero)
);

-- -----------------------------------------------------------------------------
-- Nível 2 — dependem de nível 0 e 1
-- -----------------------------------------------------------------------------

CREATE TABLE LOCACOES (
    id_loc               INT             GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cpf_cliente          VARCHAR(14)     NOT NULL REFERENCES CLIENTES (cpf),
    placa_veiculo        VARCHAR(8)      NOT NULL REFERENCES VEICULOS (placa),
    id_func_registro     INT             NOT NULL REFERENCES FUNCIONARIOS (id_func),
    id_func_autoriza     INT                      REFERENCES FUNCIONARIOS (id_func),
    id_seguro            INT             NOT NULL REFERENCES SEGUROS (id_seguro),
    status               status_locacao  NOT NULL DEFAULT 'reservada',
    data_reserva         TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    data_retirada        TIMESTAMPTZ,
    data_devol_prevista  TIMESTAMPTZ     NOT NULL,
    data_devol_real      TIMESTAMPTZ,
    valor_total          NUMERIC(10, 2),

    CONSTRAINT chk_locacoes_devolucao
        CHECK (data_devol_real IS NULL OR data_devol_real >= data_retirada),
    CONSTRAINT chk_locacoes_previsao
        CHECK (data_devol_prevista > data_reserva),
    CONSTRAINT chk_locacoes_valor_total
        CHECK (valor_total IS NULL OR valor_total >= 0)
);

-- -----------------------------------------------------------------------------
-- Nível 3 — dependem de LOCACOES
-- -----------------------------------------------------------------------------

CREATE TABLE VISTORIAS (
    id_vistoria       INT            GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_loc            INT            NOT NULL REFERENCES LOCACOES (id_loc),
    id_func           INT            NOT NULL REFERENCES FUNCIONARIOS (id_func),
    tipo              tipo_vistoria  NOT NULL,
    data_hora         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    km                INT            NOT NULL CHECK (km >= 0),
    nivel_combustivel SMALLINT       NOT NULL
                          CHECK (nivel_combustivel BETWEEN 0 AND 100),
    observacoes       TEXT
);

CREATE TABLE PAGAMENTOS (
    id_pagamento    INT             GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_loc          INT             NOT NULL REFERENCES LOCACOES (id_loc),
    forma_pagamento forma_pagamento NOT NULL,
    valor           NUMERIC(10, 2)  NOT NULL CHECK (valor > 0),
    data            TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE TABLE COBRANCAS_EXTRAS (
    id_cobranca  INT            GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_loc       INT            NOT NULL REFERENCES LOCACOES (id_loc),
    id_vistoria  INT                     REFERENCES VISTORIAS (id_vistoria),
    tipo         tipo_cobranca  NOT NULL,
    descricao    TEXT           NOT NULL,
    valor        NUMERIC(10, 2) NOT NULL CHECK (valor > 0)
);

CREATE TABLE MANUTENCOES (
    id_manut        INT              GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    placa_veiculo   VARCHAR(8)       NOT NULL REFERENCES VEICULOS (placa),
    id_func         INT              NOT NULL REFERENCES FUNCIONARIOS (id_func),
    tipo            tipo_manutencao  NOT NULL,
    motivo          VARCHAR(200)     NOT NULL,
    descricao       TEXT,
    data_entrada    DATE             NOT NULL DEFAULT CURRENT_DATE,
    previsao_saida  DATE             NOT NULL,
    data_saida_real DATE,
    custo           NUMERIC(10, 2)            CHECK (custo IS NULL OR custo >= 0),

    CONSTRAINT chk_manutencoes_previsao
        CHECK (previsao_saida >= data_entrada),
    CONSTRAINT chk_manutencoes_saida_real
        CHECK (data_saida_real IS NULL OR data_saida_real >= data_entrada)
);

-- =============================================================================
-- ÍNDICES
-- =============================================================================

-- Consultas por disponibilidade de veículo
CREATE INDEX idx_veiculos_status        ON VEICULOS  (status);

-- Consultas por status e cliente/veículo nas locações
CREATE INDEX idx_locacoes_status        ON LOCACOES  (status);
CREATE INDEX idx_locacoes_cpf_cliente   ON LOCACOES  (cpf_cliente);
CREATE INDEX idx_locacoes_placa         ON LOCACOES  (placa_veiculo);

-- Histórico de manutenção por veículo
CREATE INDEX idx_manutencoes_placa      ON MANUTENCOES (placa_veiculo);
