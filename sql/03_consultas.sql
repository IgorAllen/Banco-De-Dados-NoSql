-- ============================================================
-- CONSULTAS REESCRITAS EM SQL (SQL Server / T-SQL)
-- Rode depois de 01_schema.sql e 02_carga.sql.
-- C3 e C5: duas das 5 consultas do caso. C6: caminho mais curto (extra).
-- Observações de T-SQL no C6:
--   * a CTE recursiva não usa a palavra RECURSIVE
--   * concatenação com +  e  SELECT TOP 1
--   * CAST para VARCHAR(1000), porque os dois lados da CTE precisam ter o mesmo tipo
-- ============================================================


-- ------------------------------------------------------------
-- C3 em SQL: AMIGOS DE AMIGOS (sugestão para a Ana)
-- ------------------------------------------------------------
SELECT fof.nome AS sugestao,
       COUNT(DISTINCT f1.b) AS amigos_em_comum
FROM aluno ana
JOIN amizade_bi f1 ON f1.a = ana.id
JOIN amizade_bi f2 ON f2.a = f1.b
JOIN aluno fof     ON fof.id = f2.b
WHERE ana.nome = 'Ana Costa'
  AND fof.id <> ana.id
  AND NOT EXISTS (
        SELECT 1 FROM amizade_bi x
        WHERE x.a = ana.id AND x.b = fof.id
      )
GROUP BY fof.nome
ORDER BY amigos_em_comum DESC, sugestao;


-- ------------------------------------------------------------
-- C5 em SQL: RECOMENDAÇÃO DE DISCIPLINAS (o que os amigos cursam e ela não)
-- ------------------------------------------------------------
SELECT d.nome AS disciplina_recomendada,
       COUNT(DISTINCT f.b) AS amigos_que_cursam
FROM aluno ana
JOIN amizade_bi f  ON f.a = ana.id
JOIN matricula m   ON m.aluno_id = f.b
JOIN disciplina d  ON d.id = m.disciplina_id
WHERE ana.nome = 'Ana Costa'
  AND NOT EXISTS (
        SELECT 1 FROM matricula x
        WHERE x.aluno_id = ana.id AND x.disciplina_id = d.id
      )
GROUP BY d.nome
ORDER BY amigos_que_cursam DESC, disciplina_recomendada;


-- ------------------------------------------------------------
-- C6 em SQL (extra): MENOR CAMINHO entre Ana e William (T-SQL)
-- ------------------------------------------------------------
WITH caminho (atual, rota, saltos) AS (
  SELECT a.id,
         CAST('>' + a.nome + '>' AS VARCHAR(1000)),
         0
  FROM aluno a
  WHERE a.nome = 'Ana Costa'
  UNION ALL
  SELECT b.b,
         CAST(c.rota + n.nome + '>' AS VARCHAR(1000)),
         c.saltos + 1
  FROM caminho c
  JOIN amizade_bi b ON b.a = c.atual
  JOIN aluno n      ON n.id = b.b
  WHERE c.saltos < 8
    AND c.rota NOT LIKE '%>' + n.nome + '>%'   -- não volta a quem já passou
)
SELECT TOP 1 c.rota AS caminho_de_amizades, c.saltos
FROM caminho c
JOIN aluno a ON a.id = c.atual
WHERE a.nome = 'William Santos'
ORDER BY c.saltos;
