-- =============================================================================
-- RentFlow - Dados de Exemplo
-- =============================================================================
-- Cenários cobertos:
--   Locação 1 — ciclo completo encerrado sem ocorrências (pagamento via PIX)
--   Locação 2 — ciclo completo encerrado com avaria na devolução (+ cobrança extra)
--   Locação 3 — locação ativa em andamento (sem devolução ainda)
--   Locação 4 — locação cancelada antes da retirada
--   Manutenção — veículo em manutenção corretiva (ainda não saiu)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- CATEGORIAS
-- -----------------------------------------------------------------------------
INSERT INTO CATEGORIAS (id_cat, nome, valor_diaria)
OVERRIDING SYSTEM VALUE VALUES
    (1, 'Econômico', 80.00),
    (2, 'Padrão',    120.00),
    (3, 'Luxo',      250.00);

-- -----------------------------------------------------------------------------
-- SEGUROS
-- -----------------------------------------------------------------------------
INSERT INTO SEGUROS (id_seguro, nome, descricao_cobertura, valor_diario)
OVERRIDING SYSTEM VALUE VALUES
    (1, 'Básico',    'Cobertura contra terceiros e roubo parcial.',                15.00),
    (2, 'Completo',  'Cobertura contra terceiros, roubo total e avarias.',         35.00),
    (3, 'Premium',   'Cobertura total incluindo danos ao condutor e passageiros.', 60.00);

-- -----------------------------------------------------------------------------
-- CLIENTES
-- -----------------------------------------------------------------------------
INSERT INTO CLIENTES (
    cpf, nome, data_nascimento, email, inadimplente,
    cnh_numero, cnh_categoria, cnh_validade,
    endereco_rua, endereco_numero, endereco_bairro,
    endereco_cidade, endereco_estado, endereco_cep
) VALUES
    ('111.111.111-11', 'Ana Lima',       '1990-03-15', 'ana.lima@email.com',     FALSE,
     '00001111111', 'B', '2028-03-15',
     'Rua das Flores', '12', 'Boa Vista', 'Recife', 'PE', '50050-000'),

    ('222.222.222-22', 'Bruno Santos',   '1985-07-22', 'bruno.santos@email.com', FALSE,
     '00002222222', 'B', '2027-07-22',
     'Av. Agamenon Magalhães', '500', 'Derby', 'Recife', 'PE', '52010-000'),

    ('333.333.333-33', 'Carla Oliveira', '1995-11-08', 'carla.oli@email.com',    FALSE,
     '00003333333', 'B', '2029-11-08',
     'Rua do Sol', '88', 'Pina', 'Recife', 'PE', '51110-000');

-- -----------------------------------------------------------------------------
-- TELEFONES
-- -----------------------------------------------------------------------------
INSERT INTO TELEFONES_CLIENTE (cpf_cliente, numero, tipo) VALUES
    ('111.111.111-11', '(81) 99999-0001', 'celular'),
    ('222.222.222-22', '(81) 99999-0002', 'celular'),
    ('222.222.222-22', '(81) 3333-0002',  'residencial'),
    ('333.333.333-33', '(81) 99999-0003', 'celular');

-- -----------------------------------------------------------------------------
-- FUNCIONARIOS
-- -----------------------------------------------------------------------------
INSERT INTO FUNCIONARIOS (id_func, nome, cpf, cargo)
OVERRIDING SYSTEM VALUE VALUES
    (1, 'Marcos Souza',   '444.444.444-44', 'atendente'),
    (2, 'Patricia Costa', '555.555.555-55', 'atendente'),
    (3, 'Ricardo Alves',  '666.666.666-66', 'gerente');

-- -----------------------------------------------------------------------------
-- VEICULOS
-- -----------------------------------------------------------------------------
INSERT INTO VEICULOS (
    placa, id_cat, renavam, marca, modelo, cor,
    ano_fabricacao, tipo_combustivel, km_atual, nivel_combustivel, status
) VALUES
    ('ABC1D23', 1, '00000000001', 'Volkswagen', 'Gol',     'Prata',    2021, 'flex',     45350, 75,  'disponivel'),
    ('DEF2E34', 2, '00000000002', 'Toyota',     'Corolla', 'Preto',    2023, 'flex',     52100, 100, 'locado'),
    ('GHI3F45', 3, '00000000003', 'BMW',        '320i',    'Branco',   2024, 'gasolina', 12000, 100, 'disponivel'),
    ('JKL4G56', 1, '00000000004', 'Fiat',       'Uno',     'Vermelho', 2019, 'flex',     78500, 50,  'em_manutencao'),
    ('MNO5H67', 2, '00000000005', 'Honda',      'HR-V',    'Cinza',    2022, 'flex',     28620, 60,  'disponivel');

-- -----------------------------------------------------------------------------
-- LOCACOES
-- valor_total locação 1: (R$80 + R$15) × 3 dias = R$285,00
-- valor_total locação 2: (R$120 + R$35) × 5 dias + R$200 avaria = R$975,00
-- -----------------------------------------------------------------------------
INSERT INTO LOCACOES (
    id_loc, cpf_cliente, placa_veiculo,
    id_func_registro, id_func_autoriza, id_seguro,
    status, data_reserva, data_retirada, data_devol_prevista, data_devol_real, valor_total
) OVERRIDING SYSTEM VALUE VALUES
    -- Ciclo completo sem ocorrências
    (1, '111.111.111-11', 'ABC1D23', 1, NULL, 1,
     'encerrada',
     '2026-06-01 08:00:00-03', '2026-06-01 09:00:00-03',
     '2026-06-04 09:00:00-03', '2026-06-04 10:30:00-03', 285.00),

    -- Ciclo completo com avaria na devolução (autorizado pelo gerente)
    (2, '222.222.222-22', 'MNO5H67', 2, 3, 2,
     'encerrada',
     '2026-05-28 10:00:00-03', '2026-05-28 11:00:00-03',
     '2026-06-02 11:00:00-03', '2026-06-02 09:45:00-03', 975.00),

    -- Locação ativa em andamento
    (3, '333.333.333-33', 'DEF2E34', 1, NULL, 2,
     'ativa',
     '2026-06-07 14:00:00-03', '2026-06-08 08:00:00-03',
     '2026-06-12 08:00:00-03', NULL, NULL),

    -- Cancelada antes da retirada
    (4, '111.111.111-11', 'GHI3F45', 2, NULL, 3,
     'cancelada',
     '2026-06-05 16:00:00-03', NULL,
     '2026-06-08 16:00:00-03', NULL, NULL);

-- -----------------------------------------------------------------------------
-- VISTORIAS
-- -----------------------------------------------------------------------------
INSERT INTO VISTORIAS (id_vistoria, id_loc, id_func, tipo, data_hora, km, nivel_combustivel, observacoes)
OVERRIDING SYSTEM VALUE VALUES
    -- Locação 1: retirada e devolução sem ocorrências
    (1, 1, 1, 'retirada',  '2026-06-01 09:00:00-03', 45000, 100, NULL),
    (2, 1, 2, 'devolucao', '2026-06-04 10:30:00-03', 45350, 75,  NULL),

    -- Locação 2: retirada ok, devolução com avaria registrada
    (3, 2, 2, 'retirada',  '2026-05-28 11:00:00-03', 28000, 100, NULL),
    (4, 2, 1, 'devolucao', '2026-06-02 09:45:00-03', 28620, 60,
        'Arranhão na porta traseira direita.'),

    -- Locação 3: só vistoria de retirada (ainda ativa)
    (5, 3, 1, 'retirada',  '2026-06-08 08:00:00-03', 52100, 100, NULL);

-- -----------------------------------------------------------------------------
-- PAGAMENTOS
-- -----------------------------------------------------------------------------
INSERT INTO PAGAMENTOS (id_pagamento, id_loc, forma_pagamento, valor, data)
OVERRIDING SYSTEM VALUE VALUES
    (1, 1, 'pix',     285.00, '2026-06-04 10:30:00-03'),
    (2, 2, 'credito', 975.00, '2026-06-02 09:45:00-03');

-- -----------------------------------------------------------------------------
-- COBRANÇAS EXTRAS
-- Avaria da locação 2 originada na vistoria de devolução (id_vistoria = 4)
-- -----------------------------------------------------------------------------
INSERT INTO COBRANCAS_EXTRAS (id_cobranca, id_loc, id_vistoria, tipo, descricao, valor)
OVERRIDING SYSTEM VALUE VALUES
    (1, 2, 4, 'avaria',
     'Arranhão na porta traseira direita identificado na vistoria de devolução.',
     200.00);

-- -----------------------------------------------------------------------------
-- MANUTENCOES
-- Fiat Uno (JKL4G56) em manutenção corretiva, sem saída confirmada ainda
-- -----------------------------------------------------------------------------
INSERT INTO MANUTENCOES (
    id_manut, placa_veiculo, id_func, tipo, motivo, descricao,
    data_entrada, previsao_saida, data_saida_real, custo
) OVERRIDING SYSTEM VALUE VALUES
    (1, 'JKL4G56', 3, 'corretiva',
     'Superaquecimento do motor',
     'Veículo entrou com superaquecimento. Aguardando diagnóstico completo da oficina.',
     '2026-06-03', '2026-06-10', NULL, NULL);


-- =============================================================================
-- RESET DAS SEQUENCES
-- =============================================================================
-- Contexto:
--   As colunas de ID foram definidas como GENERATED ALWAYS AS IDENTITY no
--   schema.sql. Internamente, o PostgreSQL usa uma sequence para gerar esses
--   valores automaticamente.
--
-- Problema:
--   Quando inserimos registros com IDs explícitos usando OVERRIDING SYSTEM VALUE
--   (como feito neste seed), a sequence NÃO avança, ela permanece em 1.
--   Se um INSERT futuro omitir o ID, o banco tentaria gerar o valor 1, causando
--   erro de violação de chave primária (duplicate key).
--
-- Solução:
--   setval() reposiciona manualmente a sequence para o maior ID já existente
--   na tabela. Assim, o próximo valor gerado automaticamente será MAX(id) + 1.
--
-- Observação:
--   Como o seed é executado uma única vez em um banco limpo para fins
--   acadêmicos, este bloco não tem impacto prático imediato. Está presente
--   como boa prática e documentação do comportamento do PostgreSQL com colunas
--   IDENTITY.
-- =============================================================================

SELECT setval(pg_get_serial_sequence('categorias',      'id_cat'),       (SELECT MAX(id_cat)       FROM categorias));
SELECT setval(pg_get_serial_sequence('seguros',         'id_seguro'),    (SELECT MAX(id_seguro)    FROM seguros));
SELECT setval(pg_get_serial_sequence('funcionarios',    'id_func'),      (SELECT MAX(id_func)      FROM funcionarios));
SELECT setval(pg_get_serial_sequence('locacoes',        'id_loc'),       (SELECT MAX(id_loc)       FROM locacoes));
SELECT setval(pg_get_serial_sequence('vistorias',       'id_vistoria'),  (SELECT MAX(id_vistoria)  FROM vistorias));
SELECT setval(pg_get_serial_sequence('pagamentos',      'id_pagamento'), (SELECT MAX(id_pagamento) FROM pagamentos));
SELECT setval(pg_get_serial_sequence('cobrancas_extras','id_cobranca'),  (SELECT MAX(id_cobranca)  FROM cobrancas_extras));
SELECT setval(pg_get_serial_sequence('manutencoes',     'id_manut'),     (SELECT MAX(id_manut)     FROM manutencoes));
