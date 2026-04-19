# RentFlow - Sistema de Locação de Veículos

Bem-vindo ao repositório do **RentFlow**, um projeto acadêmico de modelagem e desenvolvimento de banco de dados para um sistema de gestão de locação de veículos. 

Este repositório documenta todo o ciclo de vida do desenvolvimento do banco de dados, partindo do levantamento de requisitos (Minimundo) até a implementação física.

## 🗂️ Estrutura do Repositório

A organização dos diretórios reflete as etapas clássicas de projeto de banco de dados:

- 📂 **`minimundo/`**
  Contém o documento de requisitos do sistema que descreve textualmente o escopo e as regras de negócio do RentFlow.
  
- 📂 **`modelo_conceitual/`**
  Guarda o diagrama Entidade-Relacionamento (MER). Aqui as regras de negócio foram transformadas em Entidades, Atributos e Relacionamentos.

- 📂 **`modelo_logico/`**
  Onde fica registrado o mapeamento do modelo conceitual para o modelo relacional (Tabelas, Tipos, Chaves Primárias e Estrangeiras).

- 📂 **`modelo_fisico/`**
  A etapa final. Aqui ficam os scripts DDL de criação do banco de dados (tabelas e constraints) e DML (inserts) para testes (Scripts SQL).

## 🎯 Sobre o Projeto

O **RentFlow** visa criar uma modelagem sólida que consiga gerenciar o ciclo complexo de locadora de carros, tratando aspectos cruciais como:
- Gestão diferenciada de **Clientes** (Pessoa Física e Pessoa Jurídica) e seus **Motoristas**.
- Especificações exclusivas para modalidades de locação (Diária, Mensal e Assinatura/Frotas).
- Controle de ciclo de vida e estado do **Veículo** (Disponível, Locado, Manutenção, etc).
- Precisão no registro de Ocorrências e Avarias (Multas e Danos) ocorridas durante as locações.

## 📄 Documentação

- [📄 Minimundo do Sistema (PDF)](./RentFlow/minimundo/MINIMUNDO_%20SISTEMA%20RENTFLOW.pdf)
- [🧩 Modelo Lógico (Texto / Mermaid)](./RentFlow/modelo_logico/modelo_logico_rentflow.md)

---
*Projeto desenvolvido como estudo prático para a disciplina de Banco de Dados da UFRPE.*
