DROP DATABASE IF EXISTS loja_virtual;
CREATE DATABASE loja_virtual;
USE loja_virtual;

-- entidade independente (cliente)
CREATE TABLE clientes(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE, -- cpf não pode repetir
    nome VARCHAR(100) NOT NULL, -- nome do cliente é obrigatório
    email VARCHAR(120) UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- evita repetir "Eletrônicos", "Roupas" etc
CREATE TABLE categorias(
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE
);

-- produtos relacionam com Categoria
CREATE TABLE produtos(
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    id_categoria INT,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- garante que a categoria exista antes de criar o produto
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- pedidos relacionam com Cliente
CREATE TABLE pedidos(
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberto', 'Pago', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Aberto',
    -- garante que o cliente exista antes de criar o pedido
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- relacionamento N pra N entre Pedido e Produto
-- (um pedido tem vários produtos e um produto pode estar em vários pedidos)
CREATE TABLE itens_pedido(
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL, -- salva o preço no momento da compra
    -- garante que o pedido e o produto existam
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- pagamentos relacionam com Pedido (1 pedido pode ter 0..n pagamentos, dependendo da regra)
CREATE TABLE pagamentos(
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    forma_pagamento ENUM('Pix', 'Cartao', 'Boleto') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('Pendente', 'Aprovado', 'Recusado', 'Estornado') DEFAULT 'Pendente',
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- garante que o pedido exista antes de criar o pagamento
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- entregas relacionam com Pedido (normalmente 1:1)
CREATE TABLE entregas(
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNIQUE, -- um pedido tem uma entrega
    endereco VARCHAR(200) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    transportadora VARCHAR(80),
    codigo_rastreio VARCHAR(80) UNIQUE,
    status ENUM('Preparando', 'Em transporte', 'Entregue', 'Devolvida') DEFAULT 'Preparando',
    data_envio DATETIME NULL,
    data_entrega DATETIME NULL,
    -- garante que o pedido exista antes de criar a entrega
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- =========================
-- inserção de dados (exemplo)
-- =========================

INSERT INTO categorias (nome_categoria)
VALUES
('Eletrônicos'),
('Livros'),
('Roupas');

INSERT INTO produtos (nome, id_categoria, descricao, preco, estoque)
VALUES
('Fone Bluetooth', 1, 'Fone sem fio com microfone', 129.90, 50),
('Teclado Mecânico', 1, 'Teclado ABNT2 switches azuis', 249.90, 20),
('Livro - Banco de Dados', 2, 'Modelagem e SQL para iniciantes', 79.90, 100);

INSERT INTO clientes (cpf, nome, email)
VALUES
('123.456.789-00', 'João Pedro', 'joao.pedro@email.com'),
('987.654.321-00', 'Maria Silva', 'maria.silva@email.com');

-- cria um pedido para o cliente 1
INSERT INTO pedidos (id_cliente, status)
VALUES
(1, 'Aberto');

-- coloca itens no pedido 1 (salvando o preço unitário do momento)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 1, 129.90), -- 1x Fone Bluetooth
(1, 3, 2, 79.90);  -- 2x Livro - Banco de Dados

-- pagamento do pedido 1
INSERT INTO pagamentos (id_pedido, forma_pagamento, valor, status)
VALUES
(1, 'Pix', 289.70, 'Aprovado');

-- entrega do pedido 1
INSERT INTO entregas (id_pedido, endereco, cidade, uf, cep, transportadora, codigo_rastreio, status, data_envio)
VALUES
(1, 'Rua A, 123', 'São Paulo', 'SP', '01000-000', 'Correios', 'BR1234567890', 'Em transporte', CURRENT_TIMESTAMP);

-- =========================
-- consultas para verificar
-- =========================

-- lista produtos
SELECT * FROM produtos;

-- lista pedidos do cliente com total calculado
SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome, p.data_pedido, p.status;

-- detalhes do pedido (itens)
SELECT
    p.id_pedido,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal
FROM pedidos p
JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
JOIN produtos pr ON pr.id_produto = ip.id_produto
WHERE p.id_pedido = 1;

-- ver pagamento e entrega de um pedido
SELECT
    p.id_pedido,
    p.status AS status_pedido,
    pg.forma_pagamento,
    pg.valor,
    pg.status AS status_pagamento,
    e.status AS status_entrega,
    e.codigo_rastreio
FROM pedidos p
LEFT JOIN pagamentos pg ON pg.id_pedido = p.id_pedido
LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
WHERE p.id_pedido = 1;
