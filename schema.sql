-- criação do banco de dados
CREATE DATABASE saep_db3

-- criação tabela usuários
CREATE TABLE IF NOT EXISTS usuarios(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    senha_criptografada VARCHAR(128) NOT NULL,
    perfil VARCHAR(128) NOT NULL CHECK (perfil IN ('admin', 'veterinario', 'recepcionista')),
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- criação tabela tutores
CREATE TABLE IF NOT EXISTS tutores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    cpf_criptografado VARCHAR(128) NOT NULL,
    telefone VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Criação tabela pets
CREATE TABLE IF NOT EXISTS pets (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id) ON DELETE CASCADE,
    nome VARCHAR(128) NOT NULL,
    especie VARCHAR(128) NOT NULL,
    raca VARCHAR(128) NOT NULL,
    data_nascimento DATE NOT NULL,
    cadastrado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- criação tabela agendamentos
CREATE TABLE IF NOT EXISTS agendamentos (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id) ON DELETE RESTRICT,
    pet_id INTEGER NOT NULL REFERENCES pets(id) ON DELETE RESTRICT,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    data_agendamento DATE NOT NULL,
    hora_agendamento TIME NOT NULL,
    servico VARCHAR(128) NOT NULL,
    status VARCHAR(128) NOT NULL DEFAULT 'AGENDADO' CHECK (status IN ('AGENDADO', 'CONCLUIDO', 'CANCELADO')),
    observacao TEXT,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- registros iniciais de cada tabela

-- usuários
INSERT INTO usuarios (nome, email, senha_criptografada, perfil) VALUES
('Dr. Osvaldo Ribeiro', 'osvald0@email.com', 'senhaNaoSegura', 'veterinario'),
('Hortência Flores', 'flores@email.com', 'senhaNaoSegura', 'recepcionista'),
('Lena Pontes', 'lenaP@email.com', 'senhaNaoSegura', 'admin')

-- tutores
-- CPFs originais
-- 1. '111.222.333-44'
-- 2. '555.666.777-88'
-- 3. '999.888.777-66'
INSERT INTO tutores (id, nome, cpf_criptografado, telefone, email) VALUES
(1, 'João Mendes', 'u6P8bE2VdG8rS1k9xL4q+w==', '(11) 11111-1111', 'joao@email.com'),
(2, 'Joana Souza', 'z8K9jF3WdH9sT2l0yM5r+x==', '(11) 22222-1111', 'joana@email.com'),
(3, 'Maria Rocha', 'w7L0kG4XeI0tU3m1zN6s+y==', '(11) 33333-1111', 'maria@email.com')

-- pets
INSERT INTO pets (id, tutor_id, nome, especie, raca, data_nascimento) VALUES
(1, 1, 'Bidu', 'Canina', 'Vira-lata', '2020-12-11'),
(2, 2, 'Mingau', 'Felina', 'Persa', '2018-08-25'),
(3, 3, 'Giselda', 'Aviano', 'Galinha', '2023-06-22')

-- agendamentos
INSERT INTO agendamentos (id, tutor_id, pet_id, usuario_id, data_agendamento, hora_agendamento, servico, status, observacao) VALUES
(1, 1, 1, 1, '2026-12-15', '09:30:00', 'Consulta Geral', 'AGENDADO', 'Animal dócil'),
(2, 2, 2, 1, '2026-06-22', '14:30:00', 'Profilaxia Dentária e Tartarectomia', 'CONCLUIDO', 'Exames pré-operatórios normais'),
(3, 3, 3, 1, '2026-03-10', '10:30:00', 'Check-up Preventivo', 'CONCLUIDO', 'Paciente alérgico a dipirona')

-- ajuste nos contadores
SELECT setval('usuarios_id_seq', (SELECT MAX(id) FROM usuarios));
SELECT setval('tutores_id_seq', (SELECT MAX(id) FROM tutores));
SELECT setval('pets_id_seq', (SELECT MAX(id) FROM pets));
SELECT setval('agendamentos_id_seq', (SELECT MAX(id) FROM agendamentos));