// ============================================================
// CONSULTAS DO ESTUDO DE CASO (Cypher)
// 5 consultas de negócio + 1 recurso ponto forte (caminho entre nós)
// Rode DEPOIS de 01_carga.cypher.
//   docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/03_consultas.cypher
// ============================================================


// ------------------------------------------------------------
// C1. Quais disciplinas a Ana cursa e quem leciona cada uma?
// ------------------------------------------------------------
MATCH (:Aluno {nome: "Ana Costa"})-[:MATRICULADO_EM]->(d:Disciplina)<-[:LECIONA]-(p:Professor)
RETURN d.nome AS disciplina, d.carga_horaria AS carga_horaria, p.nome AS professor
ORDER BY disciplina;


// ------------------------------------------------------------
// C2. Ranking de turmas: quantos alunos tem cada disciplina e qual professor leciona?
// ------------------------------------------------------------
MATCH (a:Aluno)-[:MATRICULADO_EM]->(d:Disciplina)<-[:LECIONA]-(p:Professor)
RETURN d.nome AS disciplina, p.nome AS professor, count(a) AS alunos
ORDER BY alunos DESC, disciplina;


// ------------------------------------------------------------
// C3. AMIGOS DE AMIGOS: sugestão de novas amizades para a Ana
//     (pessoas que ela ainda não conhece, ordenadas por amigos em comum)
// ------------------------------------------------------------
MATCH (ana:Aluno {nome: "Ana Costa"})-[:AMIGO_DE]-(amigo:Aluno)-[:AMIGO_DE]-(sugestao:Aluno)
WHERE sugestao <> ana AND NOT (ana)-[:AMIGO_DE]-(sugestao)
RETURN sugestao.nome AS sugestao,
       count(DISTINCT amigo) AS amigos_em_comum,
       collect(DISTINCT amigo.nome) AS via
ORDER BY amigos_em_comum DESC, sugestao;


// ------------------------------------------------------------
// C4. Grupo de estudo: colegas com mais disciplinas em comum com a Ana
// ------------------------------------------------------------
MATCH (ana:Aluno {nome: "Ana Costa"})-[:MATRICULADO_EM]->(d:Disciplina)<-[:MATRICULADO_EM]-(colega:Aluno)
WHERE colega <> ana
RETURN colega.nome AS colega,
       count(d) AS disciplinas_em_comum,
       collect(d.nome) AS quais
ORDER BY disciplinas_em_comum DESC, colega
LIMIT 5;


// ------------------------------------------------------------
// C5. RECOMENDAÇÃO DE DISCIPLINAS: o que os amigos da Ana cursam e ela ainda não
// ------------------------------------------------------------
MATCH (ana:Aluno {nome: "Ana Costa"})-[:AMIGO_DE]-(amigo:Aluno)-[:MATRICULADO_EM]->(d:Disciplina)
WHERE NOT (ana)-[:MATRICULADO_EM]->(d)
RETURN d.nome AS disciplina_recomendada,
       count(DISTINCT amigo) AS amigos_que_cursam,
       collect(DISTINCT amigo.nome) AS quais
ORDER BY amigos_que_cursam DESC, disciplina_recomendada;


// ------------------------------------------------------------
// PONTO FORTE DO TIPO: CAMINHO ENTRE NÓS
// C6. Qual o menor caminho de amizades entre a Ana e o William?
//     (grau de separação; no SQL exige CTE recursiva)
// ------------------------------------------------------------
MATCH caminho = shortestPath(
  (:Aluno {nome: "Ana Costa"})-[:AMIGO_DE*]-(:Aluno {nome: "William Santos"})
)
RETURN [n IN nodes(caminho) | n.nome] AS caminho_de_amizades,
       length(caminho) AS saltos;


// C6b. Existe mais de um caminho com o mesmo tamanho mínimo. Para ver TODOS:
MATCH caminho = allShortestPaths(
  (:Aluno {nome: "Ana Costa"})-[:AMIGO_DE*]-(:Aluno {nome: "William Santos"})
)
RETURN [n IN nodes(caminho) | n.nome] AS caminho_de_amizades,
       length(caminho) AS saltos;


// ------------------------------------------------------------
// EXTRA (opcional, bom para a demo): visualizar a vizinhança da Ana no grafo
// (no Neo4j Browser aparece o desenho clicável)
// ------------------------------------------------------------
MATCH caminho = (:Aluno {nome: "Ana Costa"})-[:AMIGO_DE*1..2]-(:Aluno)
RETURN caminho;
