-- 1. Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS ecommerce_db;

USE ecommerce_db;

-- 2. Tabela de Categorias (Evita repetir nomes de categorias nos produtos)
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- 3. Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabela de Produtos (FK para categorias)
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT,
    nome VARCHAR(150) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT DEFAULT 0,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- 5. Tabela de Pedidos (FK para clientes)
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Pago', 'Enviado', 'Cancelado') DEFAULT 'Pendente',
    total_pedido DECIMAL(10, 2),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 6. Tabela de Itens do Pedido (Tabela de Relacionamento N:N entre Pedidos e Produtos)
-- Esta tabela é essencial para a normalização, permitindo que um pedido tenha vários produtos.
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);



-- A. Cadastrando Categorias e Clientes (As bases)
INSERT INTO categorias (nome, descricao) VALUES
('Eletrônicos', 'Produtos de tecnologia e hardware'),
('Livros', 'Livros físicos e digitais');

INSERT INTO clientes (nome, email, cpf) VALUES
('Ana Souza', 'ana.souza@email.com', '12345678901'),
('Carlos Lima', 'carlos.lima@email.com', '98765432100');

-- B. Cadastrando Produtos (Referenciando o ID da categoria)
-- Supondo que 'Eletrônicos' seja ID 1 e 'Livros' seja ID 2
INSERT INTO produtos (id_categoria, nome, preco, estoque) VALUES
(1, 'Smartphone X', 2500.00, 50),
(2, 'O Guia do Mochileiro das Galáxias', 42.00, 100);

-- C. Criando um Pedido (Referenciando o ID do cliente)
INSERT INTO pedidos (id_cliente, status, total_pedido) VALUES
(1, 'Pendente', 2542.00);

-- D. Adicionando Itens ao Pedido (Referenciando Pedido e Produto)
-- Aqui o aluno vê a normalização na prática: o item liga o pedido ao produto
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 2500.00), -- 1 Smartphone
(1, 2, 1, 42.00);    -- 1 Livro