--CREATE DATABASE estacionamento 
--  WITH OWNER = postgres
--    ENCODING = 'UTF8'
--    TABLESPACE = pg_default
--    LC_COLLATE = 'en_US.utf8'
--    LC_CTYPE = 'en_US.utf8'
--    CONNECTION LIMIT = -1; 

-- Criação da tabela Filiais
CREATE TABLE filiais (
  filial_id SERIAL primary key NOT NULL,
  endereco character varying(255),
  nome_gerente character varying(255)
);

-- Criação da tabela Cupom
CREATE TABLE cupons (
  cupom_id SERIAL primary key NOT NULL,
  filial_id integer references filiais(filial_id) NOT NULL,
  desconto integer NOT NULL,
  estabelecimento character varying(255)
);

-- Criação da tabela de Preços
CREATE TABLE tabela_precos (
  preco_id SERIAL primary key NOT NULL,
  filial_id integer references filiais(filial_id) NOT NULL,
  inicio integer NOT NULL,
  fim integer NOT NULL,
  dia_semana integer NOT NULL,
  valor numeric(3,2) NOT NULL
);


-- Criação da tabela Carros
CREATE TABLE carros (
  carro_id SERIAL primary key NOT NULL,
  filial_id integer references filiais(filial_id) NOT NULL,
  desconto integer NOT NULL,
  estabelecimento character varying(255)
);

-- Criação da tabela Cupons
CREATE TABLE vagas_ocupadas (
  vaga_id SERIAL primary key NOT NULL,
  filial_id integer references filiais(filial_id) NOT NULL,
  carro_id integer references carros(carro_id) NOT NULL,
  entrada timestamp NOT NULL,
  numero_vaga integer NOT NULL
);

-- Criação da tabela Clientes
CREATE TABLE clientes (
  cliente_id SERIAL primary key NOT NULL,
  rg character varying(255),
  carteira_motorista character varying(255),
  nome character varying(255)
);

-- Criação da tabela Carros
CREATE TABLE mensalistas (
  mensalista_id SERIAL primary key NOT NULL,
  cliente_id integer references clientes(cliente_id) NOT NULL,
  dia_pagamento integer NOT NULL,
  nome character varying(255)
);