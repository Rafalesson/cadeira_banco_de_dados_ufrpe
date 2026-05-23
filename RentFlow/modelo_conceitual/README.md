# Modelo Conceitual - RentFlow

Este diretório reúne a documentação do modelo conceitual do RentFlow. O diagrama em Mermaid e o PDF representam a visão de alto nível do sistema antes do mapeamento para o modelo relacional.

## Objetivo

Representar as entidades principais do domínio da locadora, seus atributos, relacionamentos e regras estruturais, servindo de base para a construção do modelo lógico.

## Principais decisões de modelagem

- O sistema foi modelado com foco em uma locadora de veículos, priorizando rastreabilidade do ciclo de locação.
- O cliente possui um endereço composto, organizado em atributos internos no próprio diagrama conceitual.
- Telefones de cliente foram tratados como entidade própria, permitindo múltiplos registros por cliente.
- Funcionários foram modelados com especialização em `ATENDENTE` e `GERENTE`, por meio de herança disjunta e total.
- O valor total da locação aparece como atributo derivado, reforçando que ele é calculado a partir do processo de locação.

## Esquema conceitual resumido

**CATEGORIA**
- `id_cat`
- `nome`
- `valor_diaria`

**VEICULO**
- `placa`
- `renavam`
- `marca`
- `modelo`
- `cor`
- `ano_fabricacao`
- `tipo_combustivel`
- `km_atual`
- `nivel_combustivel`
- `status`

**CLIENTE**
- `cpf`
- `nome`
- `data_nascimento`
- `email`
- `inadimplente`
- `cnh_numero`
- `cnh_categoria`
- `cnh_validade`
- `endereco` composto por rua, número, bairro, cidade, estado e CEP

**TELEFONE_CLIENTE**
- `numero`
- `tipo`

**FUNCIONARIO**
- `id_func`
- `nome`
- `cpf`
- especialização em `ATENDENTE` e `GERENTE`

**SEGURO**
- `id_seguro`
- `nome`
- `descricao_cobertura`
- `valor_diario`

**LOCACAO**
- `id_loc`
- `status`
- `data_reserva`
- `data_retirada`
- `data_devol_prevista`
- `data_devol_real`
- `valor_total` derivado

**VISTORIA**
- `id_vistoria`
- `tipo`
- `data_hora`
- `km`
- `nivel_combustivel`
- `observacoes`

**PAGAMENTO**
- `id_pagamento`
- `forma_pagamento`
- `valor`
- `data`

**COBRANCA_EXTRA**
- `id_cobranca`
- `tipo`
- `descricao`
- `valor`

**MANUTENCAO**
- `id_manut`
- `tipo`
- `motivo`
- `descricao`
- `data_entrada`
- `previsao_saida`
- `data_saida_real`
- `custo`

## Relacionamentos principais

- Uma categoria classifica vários veículos.
- Um cliente possui vários telefones e realiza locações.
- Uma locação vincula cliente, veículo, seguro e funcionário.
- Uma locação pode gerar vistorias, pagamentos e cobranças extras.
- Uma vistoria pode originar cobrança extra.
- Um veículo pode sofrer manutenções.
- Um funcionário pode registrar locações, realizar vistorias e registrar manutenções.

## Observação

O conteúdo deste README acompanha a versão atual do diagrama conceitual em Mermaid e do PDF. Se o conceito mudar, esta documentação deve ser atualizada junto.