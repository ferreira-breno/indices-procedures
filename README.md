# indices-procedures
Personalizando o banco de dados com índices e procedures 

# Otimização e Manipulação de Dados com SQL

## 📁 Projeto

Este projeto tem como objetivo aplicar boas práticas de desempenho e organização em banco de dados relacional (MySQL), incluindo:

- Criação de **índices otimizados** com base em consultas reais.
- Elaboração de **queries de recuperação de dados**.
- Implementação de uma **procedure condicional** para inserção, atualização e exclusão de registros.

---

## 📦 Estrutura do Repositório

```
📂 sql
├── 1_indices_e_consultas_company.sql
├── 2_procedure_manipulacao_universidade.sql
└── README.md
```

---

## 🧠 Parte 1 – Índices e Consultas (Banco: `company`)

### 🔍 Consultas

1. **Qual o departamento com maior número de pessoas?**
```sql
SELECT D.dname, COUNT(*) AS total
FROM employee E
JOIN department D ON E.dno = D.dnumber
GROUP BY D.dname
ORDER BY total DESC
LIMIT 1;
```

2. **Quais são os departamentos por cidade?**
```sql
SELECT D.dname, L.city
FROM department D
JOIN dept_locations L ON D.dnumber = L.dnumber;
```

3. **Relação de empregados por departamento**
```sql
SELECT D.dname, E.fname, E.lname
FROM employee E
JOIN department D ON E.dno = D.dnumber
ORDER BY D.dname;
```

---

### ⚙️ Índices Criados

```sql
-- Índice para acelerar junções e agrupamentos por dno
CREATE INDEX idx_employee_dno ON employee(dno); -- usado em todas as queries com JOINs

-- Índice para melhorar filtro e JOINs por dnumber (chave primária natural)
CREATE UNIQUE INDEX idx_department_dnumber ON department(dnumber);

-- Índice para facilitar agrupamentos e filtragem por nome do departamento
CREATE INDEX idx_department_dname ON department(dname);

-- Índice para consultas por cidade nos locais dos departamentos
CREATE INDEX idx_dept_locations_city ON dept_locations(city);
```

### 📌 Justificativa dos Índices

Os índices foram criados com base nas colunas envolvidas em cláusulas `JOIN`, `GROUP BY` e `ORDER BY`. Essas operações são diretamente beneficiadas por índices, reduzindo o custo de busca e ordenação:

- `employee.dno` e `department.dnumber`: usados em junções frequentes.
- `department.dname`: melhora o desempenho ao agrupar e ordenar nomes de departamentos.
- `dept_locations.city`: facilita recuperação por localização.

---

## 🔧 Parte 2 – Procedure de Manipulação (Banco: `universidade`)

### Procedure `manipular_aluno`

```sql
DELIMITER $$

USE universidade $$

CREATE PROCEDURE manipular_aluno (
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_curso_id INT,
    IN p_acao INT
)
BEGIN
    CASE p_acao
        WHEN 1 THEN
            -- Inserção
            INSERT INTO aluno (id, nome, email, curso_id)
            VALUES (p_id, p_nome, p_email, p_curso_id);
        
        WHEN 2 THEN
            -- Atualização
            UPDATE aluno
            SET nome = p_nome,
                email = p_email,
                curso_id = p_curso_id
            WHERE id = p_id;
        
        WHEN 3 THEN
            -- Exclusão
            DELETE FROM aluno
            WHERE id = p_id;

        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ação inválida. Use 1 (INSERT), 2 (UPDATE) ou 3 (DELETE)';
    END CASE;
END $$

DELIMITER ;
```

### 🔄 Exemplo de Chamadas

```sql
-- Inserção
CALL manipular_aluno(1, 'Maria Silva', 'maria@email.com', 2, 1);

-- Atualização
CALL manipular_aluno(1, 'Maria S. Costa', 'mariacosta@email.com', 3, 2);

-- Exclusão
CALL manipular_aluno(1, '', '', 0, 3);
```

---

## ✅ Conclusão

O projeto apresenta um exemplo prático de **otimização via índices** e **manipulação programada de dados**. Ambas as práticas são essenciais para garantir:

- **Desempenho** em consultas frequentes.
- **Organização e controle** sobre a integridade dos dados.
- **Reusabilidade** e manutenção facilitada via stored procedures.

---

## 🚀 Autor

Este projeto foi desenvolvido por **Breno Ferreira** como parte de um exercício de práticas avançadas de SQL.  
Sinta-se à vontade para utilizar como referência e aprimoramento pessoal.
