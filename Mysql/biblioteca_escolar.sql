DROP DATABASE IF EXISTS biblioteca; 
CREATE DATABASE biblioteca;
USE biblioteca;

-- entidade independente
CREATE TABLE clientes(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    matricula INT UNIQUE, -- matricula não pode repetir
    nome VARCHAR(100) NOT NULL, -- nome do cliente é obrigatório
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  evita repetir nome do autor no livro)
CREATE TABLE autores(
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- aplicação que evita repetir 'romance', 'ficção' várias vezes)
CREATE TABLE categorias(
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL
);

-- livros relaciona com Autor e Categoria)
CREATE TABLE livros(
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL UNIQUE,
    id_autor INT, -- o que relaciona o livro com o autor
    id_categoria INT, -- Novo relacionamento
    descricao TEXT,
    -- o que garante que o autor e a categoria existam antes de criar o livro
    CONSTRAINT fk_livro_autor FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    CONSTRAINT fk_livro_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- relacionamento N pra N entre Cliente e Livro 
CREATE TABLE emprestimos(
     id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
     id_cliente INT, -- o que relaciona o empréstimo com o cliente
     id_livro INT, -- o que relaciona o empréstimo com o livro
     data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
     status ENUM('Ativo', 'Devolvido') DEFAULT 'Ativo',
     -- o que garante que o cliente e o livro existam antes de criar o empréstimo
     CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
     CONSTRAINT fk_livro FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);

-- inserção de dados
INSERT INTO autores (nome) 
VALUES 
('Julio Verne'),
('Joana Darc'),
('Machado de Assis');

-- primeiro as categorias depois os livros, pq o livro tem um relacionamento com a categoria
INSERT INTO categorias (nome_categoria) 
VALUES 
('Aventura'), 
('Ficção Científica'), 
('Clássico');

-- numero '1' pq foi o ID gerado para o Julio Verne acima   
INSERT INTO livros (titulo, id_autor, descricao) 
VALUES
('Volta ao mundo em 80 dias', 1, 'Romance e aventura'),
('Vinte mil léguas submarinas', 1, 'Ficção científica'),
('Viagem ao Centro da Terra', 1, 'Aventura épica');


-- registro: o cliente 1 (João Pedro) pegou o livro 1 (volta ao mundo)
INSERT INTO clientes (matricula, nome) 
VALUES 
(2024001, 'João Pedro');
    
-- registro: o cliente 1 (João Pedro) pegou o livro 2 (vinte mil léguas)
INSERT INTO emprestimos (id_cliente, id_livro) VALUES (1, 2);

-- consulta para verificar os livros cadastrados
select * from livros;