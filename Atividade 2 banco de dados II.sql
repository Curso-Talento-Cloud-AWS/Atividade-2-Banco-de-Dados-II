CREATE DATABASE IF NOT EXISTS Biblioteca_Atividade_2;
USE Biblioteca_Atividade_2;

CREATE TABLE IF NOT EXISTS livros (
    ID_LIVROS INT PRIMARY KEY AUTO_INCREMENT,
    TITULO VARCHAR(255) NOT NULL,
    AUTOR VARCHAR(255) NOT NULL,
    TIPO VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS clientes (
    NOME VARCHAR(255) NOT NULL,
    CPF VARCHAR(14) PRIMARY KEY,
    EMAIL VARCHAR(255) NOT NULL UNIQUE,
    ENDERECO VARCHAR(255) NOT NULL,
    LIVROS_ID INT,
    FOREIGN KEY (LIVROS_ID) REFERENCES livros(ID_LIVROS) ON DELETE SET NULL
);

INSERT INTO livros (TITULO, AUTOR, TIPO) VALUES
('O Senhor dos Anéis', 'J.R.R. Tolkien', 'Fantasia'),
('1984', 'George Orwell', 'Distopia'),
('Dom Casmurro', 'Machado de Assis', 'Romance'),
('A Revolução dos Bichos', 'George Orwell', 'Fábula'),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 'Infantil'),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 'Fantasia'),
('O Código Da Vinci', 'Dan Brown', 'Suspense'),
('A Arte da Guerra', 'Sun Tzu', 'Estratégia');

INSERT INTO clientes (NOME, CPF, EMAIL, ENDERECO, LIVROS_ID) VALUES
('João Silva', '111.222.333-44', 'joao@email.com', 'Rua A, 123 - SP', 1),
('Maria Oliveira', '222.333.444-55', 'maria@email.com', 'Rua B, 456 - RJ', 2),
('Carlos Mendes', '333.444.555-66', 'carlos@email.com', 'Rua C, 789 - MG', 3),
('Ana Souza', '444.555.666-77', 'ana@email.com', 'Av. D, 101 - BA', 4),
('Fernanda Lima', '555.666.777-88', 'fernanda@email.com', 'Rua E, 202 - RS', NULL),
('Pedro Rocha', '666.777.888-99', 'pedro@email.com', 'Av. F, 303 - SP', 5),
('Beatriz Almeida', '777.888.999-00', 'beatriz@email.com', 'Rua G, 404 - RJ', NULL),
('Diego Martins', '888.999.000-11', 'diego@email.com', 'Av. H, 505 - MG', 6);

DELIMITER //
CREATE TRIGGER impedir_exclusao_livro
BEFORE DELETE ON livros
FOR EACH ROW
BEGIN
    DECLARE cliente_existe INT;
    
    -- Verifica se há clientes com o livro emprestado
    SELECT COUNT(*) INTO cliente_existe FROM clientes WHERE LIVROS_ID = OLD.ID_LIVROS;
    
    -- Se existir um cliente com o livro emprestado, impede a exclusão
    IF cliente_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Este livro está emprestado e não pode ser excluído!';
    END IF;
END //

DELIMITER ;

-- TESTE DE ERRO: Se tentarmos excluir um livro emprestado (exemplo: ID 1, que está com João), ocorre um erro:
DELETE FROM livros WHERE ID_LIVROS = 1;

-- TESTE DE SUCESSO: Se quisermos excluir um livro não emprestado, basta remover o empréstimo antes:
UPDATE clientes SET LIVROS_ID = NULL WHERE LIVROS_ID = 1;
DELETE FROM livros WHERE ID_LIVROS = 1;

select * from livros;
