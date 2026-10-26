-- ============================================================
-- MODELO RELACIONAL do mesmo caso (Rede social acadêmica)
-- Compatível com PostgreSQL e SQLite.
-- Ordem de execução: 01_schema.sql -> 02_carga.sql -> 03_consultas.sql
-- (PostgreSQL via Docker: veja docs/comparativo.md)
-- ============================================================

DROP VIEW  IF EXISTS amizade_bi;
DROP TABLE IF EXISTS amizade;
DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS leciona;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS disciplina;
DROP TABLE IF EXISTS aluno;

CREATE TABLE aluno (
  id        INT PRIMARY KEY,
  nome      VARCHAR(60) NOT NULL UNIQUE,
  curso     VARCHAR(60) NOT NULL,
  semestre  INT NOT NULL
);

CREATE TABLE disciplina (
  id             INT PRIMARY KEY,
  nome           VARCHAR(60) NOT NULL UNIQUE,
  carga_horaria  INT NOT NULL
);

CREATE TABLE professor (
  id          INT PRIMARY KEY,
  nome        VARCHAR(60) NOT NULL UNIQUE,
  titulacao   VARCHAR(20)
);

-- N:N Professor x Disciplina
CREATE TABLE leciona (
  professor_id   INT NOT NULL REFERENCES professor(id),
  disciplina_id  INT NOT NULL REFERENCES disciplina(id),
  PRIMARY KEY (professor_id, disciplina_id)
);

-- N:N Aluno x Disciplina
CREATE TABLE matricula (
  aluno_id       INT NOT NULL REFERENCES aluno(id),
  disciplina_id  INT NOT NULL REFERENCES disciplina(id),
  periodo        VARCHAR(10) NOT NULL,
  PRIMARY KEY (aluno_id, disciplina_id)
);

-- N:N Aluno x Aluno (autorrelacionamento)
CREATE TABLE amizade (
  aluno_id  INT NOT NULL REFERENCES aluno(id),
  amigo_id  INT NOT NULL REFERENCES aluno(id),
  desde     INT,
  PRIMARY KEY (aluno_id, amigo_id),
  CHECK (aluno_id <> amigo_id)
);

-- A amizade é gravada uma vez só. Para consultar "nos dois sentidos"
-- é preciso esta view (no Cypher bastava omitir a seta do padrão).
CREATE VIEW amizade_bi AS
  SELECT aluno_id AS a, amigo_id AS b FROM amizade
  UNION ALL
  SELECT amigo_id AS a, aluno_id AS b FROM amizade;
