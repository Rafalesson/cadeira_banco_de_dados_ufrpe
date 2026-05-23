# RentFlow - Sistema de Locação de Veículos

Repositório acadêmico do **RentFlow**, um projeto de modelagem de banco de dados para uma locadora de veículos. O material está organizado para mostrar a evolução do projeto a partir do levantamento de requisitos até a modelagem relacional atual.

## Estrutura do Repositório

As pastas presentes no projeto representam as etapas já documentadas:

- **`RentFlow/minimundo/`**
  Contém o documento de requisitos do sistema, com o escopo e as regras de negócio base do projeto.

- **`RentFlow/modelo_conceitual/`**
  Guarda o modelo conceitual em Mermaid e em PDF. Essa versão organiza as principais entidades do domínio, como categoria, veículo, cliente, telefone, funcionário, seguro, locação, vistoria, pagamento, cobrança extra e manutenção.

- **`RentFlow/modelo_logico/`**
  Contém o modelo lógico em Mermaid, PDF e README. Nesta etapa, o modelo conceitual foi mapeado para o esquema relacional, com decisões como endereço achatado em `CLIENTES`, telefones separados em `TELEFONES_CLIENTE` e funcionários reunidos em `FUNCIONARIOS`.

## Visão do Projeto

O RentFlow modela o fluxo de uma locadora com foco em consistência e rastreabilidade dos dados. A documentação atual cobre:

- cadastro e classificação de veículos;
- cadastro de clientes e seus telefones;
- controle de funcionários, seguros e locações;
- registro de vistorias, pagamentos, cobranças extras e manutenções;
- regras de integridade e relacionamentos entre as entidades.

## Documentação

- [Minimundo do sistema](./RentFlow/minimundo/MINIMUNDO_%20SISTEMA%20RENTFLOW.pdf)
- [README do minimundo](./RentFlow/minimundo/README.md)
- [Modelo conceitual em README](./RentFlow/modelo_conceitual/README.md)
- [Modelo conceitual em Mermaid](./RentFlow/modelo_conceitual/modelo_conceitual_rentflow_v2.mmd)
- [Modelo conceitual em PDF](./RentFlow/modelo_conceitual/modelo_conceitual_rentflow_v2.pdf)
- [Modelo lógico em Mermaid](./RentFlow/modelo_logico/modelo_logico_rentflow.mmd)
- [Modelo lógico em PDF](./RentFlow/modelo_logico/modelo_logico_rentflow.pdf)
- [README do modelo lógico](./RentFlow/modelo_logico/README.md)

---

Projeto desenvolvido como estudo prático para a disciplina de Banco de Dados da UFRPE.
