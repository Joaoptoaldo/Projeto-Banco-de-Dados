DROP DATABASE IF EXISTS biblioteca; 
CREATE DATABASE biblioteca;
USE biblioteca;

CREATE TABLE clientes(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    matricula INT,
    nome VARCHAR(100),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE autores(
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE livros(
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) UNIQUE,
    id_autor INT, 
    descricao TEXT,
    CONSTRAINT fk_autor_do_livro FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

CREATE TABLE emprestimos(
     id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
     id_cliente INT,
     id_livro INT,
     data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT fk_emprestimo_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
     CONSTRAINT fk_livro_emprestimo FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);


INSERT INTO autores (nome) VALUES ('Julio Verne');

INSERT INTO livros (titulo, id_autor, descricao) 
VALUES
('Gabi', 1, 'Romance e aventura'),
('Vinte mil léguas submarinas', 1, 'Ficção científica'),
('Viagem ao Centro da Terra', 1, 'Aventura épica');

INSERT INTO clientes (matricula, nome) VALUES (2024001, 'João Pedro');

-- João Pedro (ID 1) pegando Vinte mil léguas (ID 2)
INSERT INTO emprestimos (id_cliente, id_livro) VALUES (1, 2);