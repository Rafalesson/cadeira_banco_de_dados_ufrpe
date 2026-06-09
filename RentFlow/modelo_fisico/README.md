# Modelo Físico - RentFlow

Este diretório reúne os artefatos do modelo físico do RentFlow. O arquivo `schema.sql` implementa o esquema relacional em PostgreSQL, e a pasta `dados_exemplo/` contém o script de população inicial do banco.

## Objetivo

Traduzir o modelo lógico em código SQL executável, definindo tipos de dados precisos, domínios controlados por ENUM, constraints de integridade, valores padrão e índices para os campos de maior acesso.

## Premissas, Restrições e Interpretações

- As premissas e restrições do minimundo foram preservadas e materializadas como constraints no banco (`CHECK`, `NOT NULL`, `UNIQUE`, `REFERENCES`).
- O SGBD alvo é **PostgreSQL 15+**, compatível com Supabase.
- As restrições de negócio que no modelo lógico estavam descritas em linguagem natural foram convertidas em `CHECK` constraints nomeadas no DDL.
- Campos genuinamente opcionais foram mantidos como `NULL` de forma consciente; os demais receberam `NOT NULL`.

## Principais decisões de modelagem

- Tipos ENUM nativos do PostgreSQL foram criados para todos os campos de domínio controlado: `status_veiculo`, `status_locacao`, `tipo_combustivel`, `tipo_vistoria`, `cargo_funcionario`, `tipo_cobranca`, `tipo_manutencao`, `forma_pagamento` e `categoria_cnh`.
- IDs inteiros utilizam `GENERATED ALWAYS AS IDENTITY` (padrão SQL moderno), em vez do `SERIAL` legado.
- Valores monetários usam `NUMERIC(10, 2)` para garantir precisão exata, evitando erros de arredondamento de ponto flutuante.
- O CPF foi armazenado como `VARCHAR(14)` para preservar zeros à esquerda e a máscara de formatação.
- `TIMESTAMPTZ` foi adotado em todos os campos de data e hora para registrar o fuso horário junto ao instante.
- `ON DELETE CASCADE` foi aplicado apenas em `TELEFONES_CLIENTE`, onde os telefones perdem sentido sem o cliente vinculado.
- A tabela `LOCACOES` registra separadamente o funcionário que cadastra (`id_func_registro`) e o que autoriza (`id_func_autoriza`, nullable), refletindo a distinção de papéis do modelo lógico.
- `valor_total` em `LOCACOES` é uma coluna real preenchida no encerramento da locação, não uma expressão calculada, garantindo rastreabilidade do valor consolidado.
- Índices adicionais foram criados em `VEICULOS(status)`, `LOCACOES(status)`, `LOCACOES(cpf_cliente)`, `LOCACOES(placa_veiculo)` e `MANUTENCOES(placa_veiculo)`, cobrindo os filtros mais frequentes das consultas operacionais.

## Arquivos

- [`schema.sql`](./schema.sql) — DDL completo: ENUMs, tabelas, constraints e índices
- [`dados_exemplo/seed.sql`](./dados_exemplo/seed.sql) — DML de população inicial com 4 cenários de locação

## Relação com os demais modelos

- O modelo físico é a implementação direta do modelo lógico.
- O `seed.sql` depende do `schema.sql` e deve ser executado após ele no mesmo banco.
