# Modelo Lógico Relacional - RentFlow

Este diretório reúne o modelo lógico do RentFlow. O PDF e o arquivo Mermaid (`.mmd`) descrevem a mesma modelagem relacional, com tabelas, atributos, chaves e restrições revisadas para representar melhor as regras do sistema.

## Objetivo

Transformar o modelo conceitual do sistema em um esquema relacional coerente, destacando as decisões de normalização, os relacionamentos entre entidades e as restrições que garantem consistência dos dados.

## Principais decisões de modelagem

- O atributo composto de endereço foi achatado na tabela `CLIENTES`, com colunas separadas para rua, número, bairro, cidade, estado e CEP.
- O atributo multivalorado de telefone foi deslocado para a tabela `TELEFONES_CLIENTE`, ligada ao cliente por chave estrangeira.
- A especialização de funcionários foi simplificada em uma única tabela `FUNCIONARIOS`, com o atributo `cargo` para distinguir funções como atendente e gerente.
- Alguns atributos receberam restrições adicionais de integridade, como `UNIQUE`, `CHECK` e valores do tipo `ENUM`/domínio controlado.
- A locação passou a guardar separadamente o funcionário que registra e, quando necessário, o funcionário que autoriza.
- O valor total da locação é tratado como informação consolidada no encerramento do processo.

## Esquema relacional resumido

**CATEGORIAS**
- `id_cat` [PK]
- `nome`
- `valor_diaria`

**VEICULOS**
- `placa` [PK]
- `id_cat` [FK -> CATEGORIAS(id_cat)]
- `renavam` [UNIQUE]
- `marca`
- `modelo`
- `cor`
- `ano_fabricacao`
- `tipo_combustivel`
- `km_atual`
- `nivel_combustivel`
- `status`

**CLIENTES**
- `cpf` [PK]
- `nome`
- `data_nascimento`
- `email` [UNIQUE]
- `inadimplente`
- `cnh_numero` [UNIQUE]
- `cnh_categoria` [CHECK]
- `cnh_validade`
- `endereco_rua`
- `endereco_numero`
- `endereco_bairro`
- `endereco_cidade`
- `endereco_estado`
- `endereco_cep`

**TELEFONES_CLIENTE**
- `cpf_cliente` [PK, FK -> CLIENTES(cpf)]
- `numero` [PK]
- `tipo`

**FUNCIONARIOS**
- `id_func` [PK]
- `nome`
- `cpf` [UNIQUE]
- `cargo`

**SEGUROS**
- `id_seguro` [PK]
- `nome`
- `descricao_cobertura`
- `valor_diario`

**LOCACOES**
- `id_loc` [PK]
- `cpf_cliente` [FK -> CLIENTES(cpf)]
- `placa_veiculo` [FK -> VEICULOS(placa)]
- `id_func_registro` [FK -> FUNCIONARIOS(id_func)]
- `id_func_autoriza` [FK -> FUNCIONARIOS(id_func), nullable]
- `id_seguro` [FK -> SEGUROS(id_seguro)]
- `status`
- `data_reserva`
- `data_retirada`
- `data_devol_prevista`
- `data_devol_real` [nullable]
- `valor_total` [calculado no encerramento]

**VISTORIAS**
- `id_vistoria` [PK]
- `id_loc` [FK -> LOCACOES(id_loc)]
- `id_func` [FK -> FUNCIONARIOS(id_func)]
- `tipo`
- `data_hora`
- `km`
- `nivel_combustivel`
- `observacoes`

**PAGAMENTOS**
- `id_pagamento` [PK]
- `id_loc` [FK -> LOCACOES(id_loc)]
- `forma_pagamento`
- `valor`
- `data`

**COBRANCAS_EXTRAS**
- `id_cobranca` [PK]
- `id_loc` [FK -> LOCACOES(id_loc)]
- `id_vistoria` [FK -> VISTORIAS(id_vistoria), nullable]
- `tipo`
- `descricao`
- `valor`

**MANUTENCOES**
- `id_manut` [PK]
- `placa_veiculo` [FK -> VEICULOS(placa)]
- `id_func` [FK -> FUNCIONARIOS(id_func)]
- `tipo`
- `motivo`
- `descricao`
- `data_entrada`
- `previsao_saida`
- `data_saida_real` [nullable]
- `custo`

## Relacionamentos principais

- Uma categoria classifica vários veículos.
- Um cliente pode possuir vários telefones e realizar várias locações.
- Um veículo pode participar de várias locações e manutenções ao longo do tempo.
- Uma locação pode gerar vistorias, pagamentos e cobranças extras.
- Cobranças extras podem ou não estar ligadas a uma vistoria de origem.
- Funcionários registram locações, vistorias e manutenções, e podem autorizar locações quando necessário.

## Observação

O conteúdo deste README acompanha a versão atual do diagrama em Mermaid e do PDF do modelo lógico. Se o diagrama mudar, este documento deve ser atualizado junto.
