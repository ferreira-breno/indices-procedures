-- ===========================
-- Parte 1 - Índices e Consultas Otimizadas
-- Banco: company
-- ===========================

-- Query 1: Departamento com maior número de pessoas
SELECT d.nome_departamento, COUNT(e.id_empregado) AS total_empregados
FROM departamento d
JOIN empregado e ON d.id_departamento = e.id_departamento
GROUP BY d.nome_departamento
ORDER BY total_empregados DESC
LIMIT 1;

-- Query 2: Departamentos por cidade
SELECT d.nome_departamento, d.cidade
FROM departamento d
GROUP BY d.nome_departamento, d.cidade;

-- Query 3: Relação de empregados por departamento
SELECT d.nome_departamento, e.nome_empregado
FROM departamento d
JOIN empregado e ON d.id_departamento = e.id_departamento
ORDER BY d.nome_departamento;

-- ===========================
-- Criação dos índices (com comentários)
-- ===========================

-- Índice para acelerar JOIN entre empregado e departamento
CREATE INDEX idx_empregado_departamento ON empregado(id_departamento);

-- Índice para buscas por cidade
CREATE INDEX idx_departamento_cidade ON departamento(cidade);

-- Índice usado para agrupamento por nome de departamento
CREATE INDEX idx_nome_departamento ON departamento(nome_departamento);


-- ===========================
-- Parte 2 - Procedure com estrutura condicional
-- Banco: universidade
-- ===========================

USE universidade;

DELIMITER //

CREATE PROCEDURE manipula_aluno (
    IN p_opcao INT,
    IN p_id_aluno INT,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    CASE p_opcao
        WHEN 1 THEN -- Inserção
            INSERT INTO aluno (id_aluno, nome, email)
            VALUES (p_id_aluno, p_nome, p_email);
        WHEN 2 THEN -- Atualização
            UPDATE aluno
            SET nome = p_nome, email = p_email
            WHERE id_aluno = p_id_aluno;
        WHEN 3 THEN -- Remoção
            DELETE FROM aluno
            WHERE id_aluno = p_id_aluno;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Opção inválida';
    END CASE;
END;

//
DELIMITER ;

-- Exemplos de chamada da procedure:
-- CALL manipula_aluno(1, 101, 'Carlos Silva', 'carlos@email.com');
-- CALL manipula_aluno(2, 101, 'Carlos Silva Jr.', 'carlosjr@email.com');
-- CALL manipula_aluno(3, 101, '', '');
