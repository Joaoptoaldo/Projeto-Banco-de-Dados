-- Criar e usar o banco
CREATE DATABASE faculdade;
USE faculdade;

-- Tabela de alunos
CREATE TABLE aluno (
    numero_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    curso VARCHAR(100),
    tipo_aluno INT
);


INSERT INTO aluno (numero_aluno, nome, curso, tipo_aluno) VALUES
    (17, 'Silva', 'cc', 1),
    (18, 'Braga', 'cc', 2),
    (19, 'Toaldo', 'si', 2);

CREATE TABLE disciplina (
    numero_disciplina INT PRIMARY KEY,
    nome_disciplina VARCHAR(100),
    creditos INT,
    departamento VARCHAR(20)
);
INSERT INTO disciplina (numero_disciplina, nome_disciplina, creditos, departamento) VALUES
    (1310, 'Introd. a ciência da computação', 4, 'cc'),
    (3320, 'Estruturas de dados', 4, 'cc'),
    (2410, 'Matemática discreta', 3, 'mat'),
    (3380, 'Banco de dados', 3, 'cc'),
    (3018, 'Projeto a banco de dados', 3, 'g03');

-- Tabela de pré-requisitos
CREATE TABLE pre_requisito (
    numero_disciplina INT,
    numero_pre_requisito INT,
    PRIMARY KEY (numero_disciplina, numero_pre_requisito),
    FOREIGN KEY (numero_disciplina) REFERENCES disciplina(numero_disciplina),
    FOREIGN KEY (numero_pre_requisito) REFERENCES disciplina(numero_disciplina)
);

INSERT INTO pre_requisito (numero_disciplina, numero_pre_requisito) VALUES
    (3320, 1310),
    (3380, 2410),
    (3018, 3380);

CREATE TABLE turma (
    identificacao_turma INT AUTO_INCREMENT PRIMARY KEY,
    numero_disciplina INT, 
    semestre VARCHAR(20),f
    ano INT,
    professor VARCHAR(100),
    FOREIGN KEY (numero_disciplina) REFERENCES disciplina(numero_disciplina)
);

-- Inserir turmas
INSERT INTO turma (numero_disciplina, semestre, ano, professor) VALUES
    (2410, 'segundo', 2007, 'Kleber'),
    (1310, 'segundo', 2007, 'Anderson'),
    (3320, 'primeiro', 2008, 'Carlos'),
    (2410, 'segundo', 2008, 'Chang'),
    (1310, 'segundo', 2008, 'Anderson'),
    (3380, 'segundo', 2008, 'Santos'),
    (3018, 'sexto', 2008, 'Herysson');

-- Tabela de histórico escolar
CREATE TABLE historico_escolar (
    historico_id INT AUTO_INCREMENT PRIMARY KEY,
    numero_aluno INT,
    identificacao_turma INT,
    nota VARCHAR(1),
    FOREIGN KEY (numero_aluno) REFERENCES aluno(numero_aluno),
    FOREIGN KEY (identificacao_turma) REFERENCES turma(identificacao_turma)
);

-- Inserir histórico escolar
INSERT INTO historico_escolar (numero_aluno, identificacao_turma, nota) VALUES
    (17, 4, 'B'),
    (17, 5, 'C'),
    (18, 1, 'A'),
    (18, 2, 'A'),
    (18, 3, 'B'),
    (18, 6, 'A'),
    (18, 7, 'A');

-- Testes solicitados na parte final:

-- A) Tentativa de inserir aluno com número duplicado — ERRO intencional para teste
-- INSERT INTO aluno (numero_aluno, nome, tipo_aluno, curso) VALUES (17, 'Juca', 2, 'cc');

-- B) Tentativa de histórico com aluno que não existe — ERRO intencional para teste
-- INSERT INTO historico_escolar (numero_aluno, identificacao_turma, nota) VALUES (99, 4, 'A');

-- C) Atualizar créditos de disciplina com valor negativo — permitido, mas ilógico
UPDATE disciplina SET creditos = -3 WHERE numero_disciplina = 1310;

-- D) Deletar disciplina (irá falhar se houver dependências via chave estrangeira)
-- DELETE FROM disciplina WHERE numero_disciplina = 1310;
