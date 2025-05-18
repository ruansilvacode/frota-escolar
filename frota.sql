-- Tabela de Alunos
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    endereco TEXT,
    responsavel VARCHAR(100),
    telefone_responsavel VARCHAR(20)
);

-- Tabela de Motoristas
CREATE TABLE motoristas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT
);

-- Tabela de Veículos
CREATE TABLE veiculos (
    id SERIAL PRIMARY KEY,
    placa VARCHAR(10) NOT NULL UNIQUE,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    capacidade INT,
    motorista_id INT REFERENCES motoristas(id)
);

-- Tabela de Rotas
CREATE TABLE rotas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT,
    turno VARCHAR(20) CHECK (turno IN ('manhã', 'tarde', 'noite'))
);

-- Tabela de associação Alunos-Rotas (N:N)
CREATE TABLE alunos_rotas (
    aluno_id INT REFERENCES alunos(id),
    rota_id INT REFERENCES rotas(id),
    PRIMARY KEY (aluno_id, rota_id)
);

-- Tabela de Horários
CREATE TABLE horarios (
    id SERIAL PRIMARY KEY,
    rota_id INT REFERENCES rotas(id),
    horario_partida TIME,
    horario_chegada TIME,
    dias_da_semana VARCHAR(50)
);

-- Inserção de Alunos
INSERT INTO alunos (nome, idade, endereco, responsavel, telefone_responsavel) VALUES
('Lucas Silva', 10, 'Rua das Flores, 123', 'Maria Silva', '1199999-0001'),
('Ana Costa', 12, 'Av. Brasil, 456', 'Carlos Costa', '1199999-0002'),
('Pedro Martins', 9, 'Rua da Paz, 88', 'Luciana Martins', '1199999-0003'),
('Julia Almeida', 11, 'Rua Verde, 321', 'Paulo Almeida', '1199999-0004'),
('Mariana Rocha', 10, 'Rua Azul, 654', 'Fernanda Rocha', '1199999-0005');

-- Inserção de Motoristas
INSERT INTO motoristas (nome, cnh, telefone, endereco) VALUES
('João Pereira', '12345678900', '1198888-0001', 'Rua dos Motoristas, 10'),
('Marcos Souza', '98765432100', '1198888-0002', 'Av. Central, 100'),
('Carlos Lima', '32165498700', '1198888-0003', 'Rua Nova, 55'),
('Fernando Reis', '65478932100', '1198888-0004', 'Av. Oeste, 88'),
('Roberta Nunes', '78945612300', '1198888-0005', 'Rua Leste, 22');

-- Inserção de Veículos
INSERT INTO veiculos (placa, marca, modelo, capacidade, motorista_id) VALUES
('ABC-1234', 'Volkswagen', 'Kombi', 12, 1),
('XYZ-5678', 'Fiat', 'Ducato', 16, 2),
('DEF-2468', 'Mercedes', 'Sprinter', 20, 3),
('GHI-1357', 'Renault', 'Master', 15, 4),
('JKL-8642', 'Peugeot', 'Boxer', 18, 5);

-- Inserção de Rotas
INSERT INTO rotas (nome, descricao, turno) VALUES
('Rota Norte', 'Bairros do norte da cidade', 'manhã'),
('Rota Sul', 'Bairros do sul da cidade', 'tarde'),
('Rota Leste', 'Bairros da zona leste', 'manhã'),
('Rota Oeste', 'Bairros da zona oeste', 'tarde'),
('Rota Central', 'Centro da cidade', 'noite');

-- Associação Alunos-Rotas
INSERT INTO alunos_rotas (aluno_id, rota_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 5);

-- Inserção de Horários
INSERT INTO horarios (rota_id, horario_partida, horario_chegada, dias_da_semana) VALUES
(1, '06:30', '07:15', 'Segunda a Sexta'),
(2, '12:30', '13:15', 'Segunda a Sexta'),
(3, '06:45', '07:30', 'Segunda a Sexta'),
(4, '13:00', '13:45', 'Segunda a Sexta'),
(5, '18:00', '18:45', 'Segunda a Sexta');

-- CONSULTAS ÚTEIS

-- 1. Listar todos os alunos com a rota em que estão cadastrados
SELECT a.nome AS aluno, r.nome AS rota, r.turno
FROM alunos a
JOIN alunos_rotas ar ON a.id = ar.aluno_id
JOIN rotas r ON r.id = ar.rota_id;

-- 2. Ver quais motoristas estão com quais veículos
SELECT m.nome AS motorista, v.placa, v.marca, v.modelo
FROM motoristas m
JOIN veiculos v ON v.motorista_id = m.id;

-- 3. Ver horários das rotas por turno
SELECT r.nome AS rota, r.turno, h.horario_partida, h.horario_chegada, h.dias_da_semana
FROM rotas r
JOIN horarios h ON r.id = h.rota_id
ORDER BY r.turno;

-- 4. Listar alunos com nome do responsável e telefone
SELECT nome, responsavel, telefone_responsavel
FROM alunos;

-- 5. Capacidade total da frota disponível
SELECT SUM(capacidade) AS capacidade_total
FROM veiculos;
