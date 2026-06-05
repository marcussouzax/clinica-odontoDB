# Banco de Dados - Clínica Odontológica

Projeto de banco de dados desenvolvido em SQL para simular o sistema de gestão de uma clínica odontológica.

## Sobre o projeto

Este banco de dados tem como objetivo representar a estrutura de um sistema real de clínica odontológica, permitindo o gerenciamento de pacientes, dentistas, consultas e tratamentos.

O projeto foi desenvolvido para fins acadêmicos, com foco em modelagem de dados, relacionamentos e organização de informações em um sistema relacional.

## Estrutura do banco de dados

O banco é composto pelas seguintes entidades principais:

### Pacientes
Armazena os dados dos pacientes cadastrados na clínica.

### Dentistas
Contém informações dos profissionais da clínica, incluindo especialidades.

### Consultas
Registra os agendamentos realizados entre pacientes e dentistas, incluindo data e horário.

### Tratamentos
Registra os procedimentos realizados durante as consultas.

## Relacionamentos

- Um paciente pode realizar várias consultas
- Um dentista pode atender várias consultas
- Cada consulta pode conter um ou mais tratamentos

## Tecnologias utilizadas

- MySQL

## Objetivo

O objetivo deste projeto é praticar conceitos de:

- Modelagem de banco de dados relacional
- Criação de tabelas e chaves primárias/estrangeiras
- Relacionamentos entre entidades
- Estruturação de sistemas de informação

## Observações

Este projeto foi desenvolvido para fins de estudo e prática acadêmica da disciplina de DataBase Application, podendo ser expandido futuramente com novas funcionalidades como:

- Sistema de login para usuários
- Controle financeiro
- Histórico completo de pacientes
- Integração com aplicações web ou mobile
