# Modelo Lógico Relacional - RentFlow

Este documento define a conversão do Modelo Conceitual do sistema RentFlow para o Modelo Lógico relacional. O esquema relacional abaixo demonstra as entidades (Tabelas), colunas, e as regras de restrição de Chaves Primárias (PK) e Chaves Estrangeiras (FK).

Destaques da Modelagem:
1. **Atributo Composto (Endereço):** Achatado/Flat na tabela `CLIENTE`.
2. **Atributo Multivalorado (Telefone):** Extraído para uma tabela `TELEFONE_CLIENTE` relacionada com a primária.
3. **Herança (Funcionário/Atendente/Gerente):** Utilizada a estratégia de preservação com junção (tabela da superclasse preserva os dados comuns, as tabelas filhas herdam sua PK como PK/FK).

---

## 1. Esquema Relacional de Tabelas

**CATEGORIA**
- `id_cat`: INT [PK]
- `nome`: VARCHAR(50)
- `valor_diaria`: NUMERIC(10,2)

**VEICULO**
- `placa`: VARCHAR(10) [PK]
- `renavam`: VARCHAR(20)
- `marca`: VARCHAR(50)
- `modelo`: VARCHAR(50)
- `cor`: VARCHAR(30)
- `ano_fabricacao`: INT
- `tipo_combustivel`: VARCHAR(30)
- `km_atual`: INT
- `nivel_combustivel`: INT
- `status`: VARCHAR(20)
- `id_cat`: INT [FK -> CATEGORIA(id_cat)]

**CLIENTE**
- `cpf`: VARCHAR(14) [PK]
- `nome`: VARCHAR(100)
- `data_nascimento`: DATE
- `email`: VARCHAR(100)
- `inadimplente`: BOOLEAN
- `cnh_numero`: VARCHAR(20)
- `cnh_categoria`: VARCHAR(5)
- `cnh_validade`: DATE
- `rua`: VARCHAR(100)
- `numero`: VARCHAR(10)
- `bairro`: VARCHAR(50)
- `cidade`: VARCHAR(50)
- `estado`: VARCHAR(2)
- `cep`: VARCHAR(10)

**TELEFONE_CLIENTE**
- `cpf_cliente`: VARCHAR(14) [PK, FK -> CLIENTE(cpf)]
- `numero`: VARCHAR(15) [PK]
- `tipo`: VARCHAR(20)

**FUNCIONARIO**
- `id_func`: INT [PK]
- `cpf`: VARCHAR(14)
- `nome`: VARCHAR(100)

**ATENDENTE**
- `id_func`: INT [PK, FK -> FUNCIONARIO(id_func)]

**GERENTE**
- `id_func`: INT [PK, FK -> FUNCIONARIO(id_func)]

**SEGURO**
- `id_seguro`: INT [PK]
- `nome`: VARCHAR(50)
- `descricao_cobertura`: TEXT
- `valor_diario`: NUMERIC(10,2)

**LOCACAO**
- `id_loc`: INT [PK]
- `status`: VARCHAR(20)
- `data_reserva`: DATETIME
- `data_retirada`: DATETIME
- `data_devol_prevista`: DATETIME
- `data_devol_real`: DATETIME
- `valor_total`: NUMERIC(10,2)
- `cpf_cliente`: VARCHAR(14) [FK -> CLIENTE(cpf)]
- `placa_veiculo`: VARCHAR(10) [FK -> VEICULO(placa)]
- `id_seguro`: INT [FK -> SEGURO(id_seguro)]
- `id_atendente_registro`: INT [FK -> ATENDENTE(id_func)]
- `id_gerente_autoriza`: INT [FK -> GERENTE(id_func)] -- NULLABLE (Apenas se a política exigir)

**VISTORIA**
- `id_vistoria`: INT [PK]
- `tipo`: VARCHAR(20) -- EX: 'Retirada' ou 'Devolucao'
- `data_hora`: DATETIME
- `km`: INT
- `nivel_combustivel`: INT
- `observacoes`: TEXT
- `id_loc`: INT [FK -> LOCACAO(id_loc)]
- `id_func_vistoriador`: INT [FK -> FUNCIONARIO(id_func)]

**PAGAMENTO**
- `id_pagamento`: INT [PK]
- `forma_pagamento`: VARCHAR(50)
- `valor`: NUMERIC(10,2)
- `data_pagamento`: DATETIME
- `id_loc`: INT [FK -> LOCACAO(id_loc)]

**COBRANCA_EXTRA**
- `id_cobranca`: INT [PK]
- `tipo`: VARCHAR(50)
- `descricao`: TEXT
- `valor`: NUMERIC(10,2)
- `id_loc`: INT [FK -> LOCACAO(id_loc)]
- `id_vistoria_origem`: INT [FK -> VISTORIA(id_vistoria)] -- NULLABLE

**MANUTENCAO**
- `id_manut`: INT [PK]
- `tipo`: VARCHAR(50)
- `motivo`: VARCHAR(100)
- `descricao`: TEXT
- `data_entrada`: DATETIME
- `previsao_saida`: DATETIME
- `data_saida_real`: DATETIME
- `custo`: NUMERIC(10,2)
- `placa_veiculo`: VARCHAR(10) [FK -> VEICULO(placa)]
- `id_func_registro`: INT [FK -> FUNCIONARIO(id_func)]

---

## 2. Diagrama (Visualização DBML)

Abaixo encontra-se a versão técnica em **DBML** do modelo lógico. Ela pode ser copiada e colada no famoso site [DBDiagram.io](https://dbdiagram.io) ou similar para renderizar um *Entity-Relationship Diagram* do modelo gerado acima:

```dbml
Table CATEGORIA {
  id_cat int [pk]
  nome varchar
  valor_diaria decimal
}

Table VEICULO {
  placa varchar [pk]
  renavam varchar
  marca varchar
  modelo varchar
  cor varchar
  ano_fabricacao int
  tipo_combustivel varchar
  km_atual int
  nivel_combustivel int
  status varchar
  id_cat int [ref: > CATEGORIA.id_cat]
}

Table CLIENTE {
  cpf varchar [pk]
  nome varchar
  data_nascimento date
  email varchar
  inadimplente boolean
  cnh_numero varchar
  cnh_categoria varchar
  cnh_validade date
  rua varchar
  numero varchar
  bairro varchar
  cidade varchar
  estado varchar
  cep varchar
}

Table TELEFONE_CLIENTE {
  cpf_cliente varchar [pk, ref: > CLIENTE.cpf]
  numero varchar [pk]
  tipo varchar
}

Table FUNCIONARIO {
  id_func int [pk]
  cpf varchar
  nome varchar
}

Table ATENDENTE {
  id_func int [pk, ref: - FUNCIONARIO.id_func]
}

Table GERENTE {
  id_func int [pk, ref: - FUNCIONARIO.id_func]
}

Table SEGURO {
  id_seguro int [pk]
  nome varchar
  descricao_cobertura text
  valor_diario decimal
}

Table LOCACAO {
  id_loc int [pk]
  status varchar
  data_reserva datetime
  data_retirada datetime
  data_devol_prevista datetime
  data_devol_real datetime
  valor_total decimal
  cpf_cliente varchar [ref: > CLIENTE.cpf]
  placa_veiculo varchar [ref: > VEICULO.placa]
  id_seguro int [ref: > SEGURO.id_seguro]
  id_atendente_registro int [ref: > ATENDENTE.id_func]
  id_gerente_autoriza int [ref: > GERENTE.id_func] // Nullable
}

Table VISTORIA {
  id_vistoria int [pk]
  tipo varchar
  data_hora datetime
  km int
  nivel_combustivel int
  observacoes text
  id_loc int [ref: > LOCACAO.id_loc]
  id_func_vistoriador int [ref: > FUNCIONARIO.id_func]
}

Table PAGAMENTO {
  id_pagamento int [pk]
  forma_pagamento varchar
  valor decimal
  data_pagamento datetime
  id_loc int [ref: > LOCACAO.id_loc]
}

Table COBRANCA_EXTRA {
  id_cobranca int [pk]
  tipo varchar
  descricao text
  valor decimal
  id_loc int [ref: > LOCACAO.id_loc]
  id_vistoria_origem int [ref: > VISTORIA.id_vistoria] // Nullable
}

Table MANUTENCAO {
  id_manut int [pk]
  tipo varchar
  motivo varchar
  descricao text
  data_entrada datetime
  previsao_saida datetime
  data_saida_real datetime
  custo decimal
  placa_veiculo varchar [ref: > VEICULO.placa]
  id_func_registro int [ref: > FUNCIONARIO.id_func]
}
```
