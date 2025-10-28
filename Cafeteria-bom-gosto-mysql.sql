-- =====================================================
-- SISTEMA DE VENDAS CAFETERIA BOMGOSTO
-- =====================================================

-- Criação das Tabelas
-- =====================================================

-- Tabela Cardápio
CREATE TABLE Cardapio (
    codigo_cardapio INT PRIMARY KEY AUTO_INCREMENT,
    nome_cafe VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- Tabela Comanda
CREATE TABLE Comanda (
    codigo_comanda INT PRIMARY KEY AUTO_INCREMENT,
    data_comanda DATE NOT NULL,
    numero_mesa INT NOT NULL,
    nome_cliente VARCHAR(100) NOT NULL
);

-- Tabela Itens da Comanda
CREATE TABLE ItemComanda (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    codigo_comanda INT NOT NULL,
    codigo_cardapio INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (codigo_comanda) REFERENCES Comanda(codigo_comanda),
    FOREIGN KEY (codigo_cardapio) REFERENCES Cardapio(codigo_cardapio),
    UNIQUE KEY uk_comanda_cardapio (codigo_comanda, codigo_cardapio)
);

-- Dados de Exemplo
-- =====================================================

INSERT INTO Cardapio (nome_cafe, descricao, preco_unitario) VALUES
('Espresso', 'Café espresso tradicional italiano', 7.00),
('Cappuccino', 'Espresso com leite vaporizado e espuma', 9.50),
('Café com Leite', 'Café coado com leite quente', 8.00),
('Mocha', 'Espresso com chocolate e leite vaporizado', 11.50),
('Americano', 'Espresso diluído em água quente', 7.50),
('Latte', 'Espresso com bastante leite vaporizado', 10.00);

INSERT INTO Comanda (data_comanda, numero_mesa, nome_cliente) VALUES
('2025-10-20', 5, 'João Silva'),
('2025-10-20', 3, 'Maria Santos'),
('2025-10-21', 7, 'Pedro Oliveira'),
('2025-10-21', 2, 'Ana Costa'),
('2025-10-22', 4, 'Carlos Souza');

INSERT INTO ItemComanda (codigo_comanda, codigo_cardapio, quantidade) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(3, 2, 2),
(3, 4, 1),
(3, 6, 1),
(4, 1, 1),
(4, 5, 2),
(5, 2, 3);

-- =====================================================
-- CONSULTAS SOLICITADAS
-- =====================================================

-- 1) Listagem do cardápio ordenada por nome
-- =====================================================
SELECT 
    codigo_cardapio,
    nome_cafe,
    descricao,
    preco_unitario
FROM Cardapio
ORDER BY nome_cafe;


-- 2) Todas as comandas com seus itens ordenados por data, código e nome do café
-- =====================================================
SELECT 
    c.codigo_comanda,
    c.data_comanda,
    c.numero_mesa,
    c.nome_cliente,
    card.nome_cafe,
    card.descricao,
    ic.quantidade,
    card.preco_unitario,
    (ic.quantidade * card.preco_unitario) AS preco_total_cafe
FROM Comanda c
INNER JOIN ItemComanda ic ON c.codigo_comanda = ic.codigo_comanda
INNER JOIN Cardapio card ON ic.codigo_cardapio = card.codigo_cardapio
ORDER BY c.data_comanda, c.codigo_comanda, card.nome_cafe;


-- 3) Comandas com valor total ordenadas por data
-- =====================================================
SELECT 
    c.codigo_comanda,
    c.data_comanda,
    c.numero_mesa,
    c.nome_cliente,
    SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda
FROM Comanda c
INNER JOIN ItemComanda ic ON c.codigo_comanda = ic.codigo_comanda
INNER JOIN Cardapio card ON ic.codigo_cardapio = card.codigo_cardapio
GROUP BY c.codigo_comanda, c.data_comanda, c.numero_mesa, c.nome_cliente
ORDER BY c.data_comanda;


-- 4) Comandas com mais de um tipo de café
-- =====================================================
SELECT 
    c.codigo_comanda,
    c.data_comanda,
    c.numero_mesa,
    c.nome_cliente,
    SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda
FROM Comanda c
INNER JOIN ItemComanda ic ON c.codigo_comanda = ic.codigo_comanda
INNER JOIN Cardapio card ON ic.codigo_cardapio = card.codigo_cardapio
GROUP BY c.codigo_comanda, c.data_comanda, c.numero_mesa, c.nome_cliente
HAVING COUNT(DISTINCT ic.codigo_cardapio) > 1
ORDER BY c.data_comanda;


-- 5) Total de faturamento por data
-- =====================================================
SELECT 
    c.data_comanda,
    SUM(ic.quantidade * card.preco_unitario) AS faturamento_total
FROM Comanda c
INNER JOIN ItemComanda ic ON c.codigo_comanda = ic.codigo_comanda
INNER JOIN Cardapio card ON ic.codigo_cardapio = card.codigo_cardapio
GROUP BY c.data_comanda
ORDER BY c.data_comanda;
