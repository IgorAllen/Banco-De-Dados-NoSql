// ============================================================
// OPERAÇÕES: INSERIR, CONSULTAR, ATUALIZAR e EXCLUIR (Cypher)
// Rode DEPOIS de 01_carga.cypher. Usa uma aluna nova (Yasmin Prado)
// e termina excluindo ela, então os dados originais ficam intactos.
//   docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/02_operacoes_crud.cypher
// ============================================================


// ------------------------------------------------------------
// INSERIR (CREATE / MATCH + CREATE)
// ------------------------------------------------------------

// 1. Criar um novo nó Aluno
CREATE (:Aluno {nome: "Yasmin Prado", curso: "Sistemas de Informação", semestre: 1});

// 2. Matricular a Yasmin em duas disciplinas (cria relações entre nós existentes)
MATCH (y:Aluno {nome: "Yasmin Prado"}), (d:Disciplina)
WHERE d.nome IN ["Banco de Dados", "Cálculo I"]
CREATE (y)-[:MATRICULADO_EM {periodo: "2026.2"}]->(d);

// 3. Criar uma amizade entre a Yasmin e a Ana
MATCH (y:Aluno {nome: "Yasmin Prado"}), (a:Aluno {nome: "Ana Costa"})
CREATE (y)-[:AMIGO_DE {desde: 2026}]->(a);


// ------------------------------------------------------------
// CONSULTAR (MATCH ... RETURN)
// ------------------------------------------------------------

// 4. Dados da Yasmin e suas disciplinas
MATCH (y:Aluno {nome: "Yasmin Prado"})-[:MATRICULADO_EM]->(d:Disciplina)
RETURN y.nome AS aluna, y.semestre AS semestre, collect(d.nome) AS disciplinas;

// 5. Amigos da Yasmin
MATCH (:Aluno {nome: "Yasmin Prado"})-[:AMIGO_DE]-(amigo:Aluno)
RETURN amigo.nome AS amigo;

// 6. Busca com filtro: alunos de Ciência da Computação a partir do 4º semestre
MATCH (a:Aluno)
WHERE a.curso = "Ciência da Computação" AND a.semestre >= 4
RETURN a.nome AS aluno, a.semestre AS semestre
ORDER BY semestre DESC, aluno;


// ------------------------------------------------------------
// ATUALIZAR (SET / MERGE / DELETE de relação)
// ------------------------------------------------------------

// 7. Alterar uma propriedade e criar uma nova (sem ALTER TABLE: o grafo é flexível)
MATCH (y:Aluno {nome: "Yasmin Prado"})
SET y.semestre = 2,
    y.email = "yasmin.prado@faculdade.edu"
RETURN y;

// 8. Trocar de disciplina: sai de Cálculo I e entra em Programação Web
MATCH (:Aluno {nome: "Yasmin Prado"})-[r:MATRICULADO_EM]->(:Disciplina {nome: "Cálculo I"})
DELETE r;

MATCH (y:Aluno {nome: "Yasmin Prado"}), (d:Disciplina {nome: "Programação Web"})
MERGE (y)-[:MATRICULADO_EM {periodo: "2026.2"}]->(d);

// 9. Conferir a troca
MATCH (:Aluno {nome: "Yasmin Prado"})-[:MATRICULADO_EM]->(d:Disciplina)
RETURN d.nome AS disciplina
ORDER BY disciplina;

// 10. Atualizar uma relação: a amizade com a Ana existe desde 2025
MATCH (:Aluno {nome: "Yasmin Prado"})-[r:AMIGO_DE]-(:Aluno {nome: "Ana Costa"})
SET r.desde = 2025
RETURN r.desde AS desde;


// ------------------------------------------------------------
// EXCLUIR (DELETE / DETACH DELETE)
// ------------------------------------------------------------

// 11. Excluir só a relação de amizade
MATCH (:Aluno {nome: "Yasmin Prado"})-[r:AMIGO_DE]-(:Aluno {nome: "Ana Costa"})
DELETE r;

// 12. Excluir o nó inteiro com todas as relações que sobraram
MATCH (y:Aluno {nome: "Yasmin Prado"})
DETACH DELETE y;

// 13. Conferir: a Yasmin não existe mais e voltamos a ter 20 alunos
MATCH (y:Aluno {nome: "Yasmin Prado"}) RETURN count(y) AS yasmin_existe;
MATCH (a:Aluno) RETURN count(a) AS total_de_alunos;
