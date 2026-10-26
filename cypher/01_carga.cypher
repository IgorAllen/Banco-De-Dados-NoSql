// ============================================================
// CARGA DE DADOS - Rede social acadêmica (Neo4j / Cypher)
// 20 alunos + 8 disciplinas + 5 professores = 33 nós
// 8 LECIONA + 60 MATRICULADO_EM + 31 AMIGO_DE = 99 relações
//
// Como rodar (com o docker compose já no ar):
//   docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/01_carga.cypher
// Ou copie e cole no Neo4j Browser (http://localhost:7474), bloco a bloco.
// ============================================================


// 0. Limpeza (permite rodar o script do zero quantas vezes quiser)
MATCH (n) DETACH DELETE n;

// 1. Restrições: nomes únicos (também criam índice para busca rápida)
CREATE CONSTRAINT aluno_nome IF NOT EXISTS FOR (a:Aluno) REQUIRE a.nome IS UNIQUE;
CREATE CONSTRAINT disciplina_nome IF NOT EXISTS FOR (d:Disciplina) REQUIRE d.nome IS UNIQUE;
CREATE CONSTRAINT professor_nome IF NOT EXISTS FOR (p:Professor) REQUIRE p.nome IS UNIQUE;

// 2. Alunos (20)
UNWIND [
  {nome: "Ana Costa", curso: "Ciência da Computação", semestre: 3},
  {nome: "Bruno Martins", curso: "Ciência da Computação", semestre: 3},
  {nome: "Carla Mendes", curso: "Sistemas de Informação", semestre: 4},
  {nome: "Daniel Ribeiro", curso: "Ciência da Computação", semestre: 2},
  {nome: "Eduarda Lopes", curso: "Sistemas de Informação", semestre: 4},
  {nome: "Felipe Barros", curso: "Ciência da Computação", semestre: 2},
  {nome: "Gabriela Rocha", curso: "Sistemas de Informação", semestre: 5},
  {nome: "Hugo Teixeira", curso: "Ciência da Computação", semestre: 3},
  {nome: "Isabela Nunes", curso: "Sistemas de Informação", semestre: 5},
  {nome: "João Pereira", curso: "Ciência da Computação", semestre: 1},
  {nome: "Larissa Freitas", curso: "Sistemas de Informação", semestre: 4},
  {nome: "Mateus Cardoso", curso: "Ciência da Computação", semestre: 2},
  {nome: "Natália Araújo", curso: "Ciência da Computação", semestre: 3},
  {nome: "Otávio Ramos", curso: "Sistemas de Informação", semestre: 1},
  {nome: "Paula Moreira", curso: "Ciência da Computação", semestre: 5},
  {nome: "Rafael Duarte", curso: "Sistemas de Informação", semestre: 3},
  {nome: "Sofia Carvalho", curso: "Ciência da Computação", semestre: 4},
  {nome: "Thiago Batista", curso: "Sistemas de Informação", semestre: 2},
  {nome: "Vitória Azevedo", curso: "Sistemas de Informação", semestre: 5},
  {nome: "William Santos", curso: "Ciência da Computação", semestre: 1}
] AS a
CREATE (:Aluno {nome: a.nome, curso: a.curso, semestre: a.semestre});

// 3. Disciplinas (8)
UNWIND [
  {nome: "Banco de Dados", carga_horaria: 60},
  {nome: "Estruturas de Dados", carga_horaria: 80},
  {nome: "Redes de Computadores", carga_horaria: 60},
  {nome: "Engenharia de Software", carga_horaria: 60},
  {nome: "Inteligência Artificial", carga_horaria: 80},
  {nome: "Sistemas Operacionais", carga_horaria: 60},
  {nome: "Programação Web", carga_horaria: 60},
  {nome: "Cálculo I", carga_horaria: 80}
] AS d
CREATE (:Disciplina {nome: d.nome, carga_horaria: d.carga_horaria});

// 4. Professores (5)
UNWIND [
  {nome: "Marcos Andrade", titulacao: "Doutor"},
  {nome: "Helena Souza", titulacao: "Doutora"},
  {nome: "Ricardo Lima", titulacao: "Mestre"},
  {nome: "Fernando Alves", titulacao: "Mestre"},
  {nome: "Patrícia Gomes", titulacao: "Doutora"}
] AS p
CREATE (:Professor {nome: p.nome, titulacao: p.titulacao});

// 5. Professor LECIONA Disciplina (8)
UNWIND [
  ["Marcos Andrade", "Banco de Dados"],
  ["Marcos Andrade", "Inteligência Artificial"],
  ["Helena Souza", "Estruturas de Dados"],
  ["Helena Souza", "Engenharia de Software"],
  ["Ricardo Lima", "Redes de Computadores"],
  ["Ricardo Lima", "Sistemas Operacionais"],
  ["Fernando Alves", "Programação Web"],
  ["Patrícia Gomes", "Cálculo I"]
] AS par
MATCH (p:Professor {nome: par[0]}), (d:Disciplina {nome: par[1]})
CREATE (p)-[:LECIONA]->(d);

// 6. Aluno MATRICULADO_EM Disciplina (60)
UNWIND [
  ["Ana Costa", "Banco de Dados"],
  ["Ana Costa", "Estruturas de Dados"],
  ["Ana Costa", "Inteligência Artificial"],
  ["Bruno Martins", "Banco de Dados"],
  ["Bruno Martins", "Redes de Computadores"],
  ["Bruno Martins", "Sistemas Operacionais"],
  ["Carla Mendes", "Banco de Dados"],
  ["Carla Mendes", "Engenharia de Software"],
  ["Carla Mendes", "Inteligência Artificial"],
  ["Daniel Ribeiro", "Estruturas de Dados"],
  ["Daniel Ribeiro", "Redes de Computadores"],
  ["Daniel Ribeiro", "Cálculo I"],
  ["Eduarda Lopes", "Banco de Dados"],
  ["Eduarda Lopes", "Estruturas de Dados"],
  ["Eduarda Lopes", "Programação Web"],
  ["Felipe Barros", "Redes de Computadores"],
  ["Felipe Barros", "Engenharia de Software"],
  ["Felipe Barros", "Sistemas Operacionais"],
  ["Gabriela Rocha", "Inteligência Artificial"],
  ["Gabriela Rocha", "Engenharia de Software"],
  ["Gabriela Rocha", "Programação Web"],
  ["Hugo Teixeira", "Banco de Dados"],
  ["Hugo Teixeira", "Inteligência Artificial"],
  ["Hugo Teixeira", "Sistemas Operacionais"],
  ["Isabela Nunes", "Estruturas de Dados"],
  ["Isabela Nunes", "Engenharia de Software"],
  ["Isabela Nunes", "Cálculo I"],
  ["João Pereira", "Redes de Computadores"],
  ["João Pereira", "Inteligência Artificial"],
  ["João Pereira", "Programação Web"],
  ["Larissa Freitas", "Banco de Dados"],
  ["Larissa Freitas", "Programação Web"],
  ["Larissa Freitas", "Engenharia de Software"],
  ["Mateus Cardoso", "Estruturas de Dados"],
  ["Mateus Cardoso", "Sistemas Operacionais"],
  ["Mateus Cardoso", "Cálculo I"],
  ["Natália Araújo", "Banco de Dados"],
  ["Natália Araújo", "Inteligência Artificial"],
  ["Natália Araújo", "Estruturas de Dados"],
  ["Otávio Ramos", "Redes de Computadores"],
  ["Otávio Ramos", "Sistemas Operacionais"],
  ["Otávio Ramos", "Programação Web"],
  ["Paula Moreira", "Engenharia de Software"],
  ["Paula Moreira", "Inteligência Artificial"],
  ["Paula Moreira", "Cálculo I"],
  ["Rafael Duarte", "Banco de Dados"],
  ["Rafael Duarte", "Redes de Computadores"],
  ["Rafael Duarte", "Estruturas de Dados"],
  ["Sofia Carvalho", "Inteligência Artificial"],
  ["Sofia Carvalho", "Programação Web"],
  ["Sofia Carvalho", "Banco de Dados"],
  ["Thiago Batista", "Sistemas Operacionais"],
  ["Thiago Batista", "Cálculo I"],
  ["Thiago Batista", "Redes de Computadores"],
  ["Vitória Azevedo", "Engenharia de Software"],
  ["Vitória Azevedo", "Estruturas de Dados"],
  ["Vitória Azevedo", "Programação Web"],
  ["William Santos", "Inteligência Artificial"],
  ["William Santos", "Sistemas Operacionais"],
  ["William Santos", "Banco de Dados"]
] AS par
MATCH (a:Aluno {nome: par[0]}), (d:Disciplina {nome: par[1]})
CREATE (a)-[:MATRICULADO_EM {periodo: "2026.2"}]->(d);

// 7. Aluno AMIGO_DE Aluno (31). Cada amizade é gravada UMA vez;
//    nas consultas omitimos a seta, então vale nos dois sentidos.
UNWIND [
  ["Ana Costa", "Bruno Martins", 2024],
  ["Ana Costa", "Carla Mendes", 2025],
  ["Ana Costa", "Natália Araújo", 2026],
  ["Ana Costa", "Paula Moreira", 2024],
  ["Bruno Martins", "Daniel Ribeiro", 2025],
  ["Bruno Martins", "Rafael Duarte", 2026],
  ["Carla Mendes", "Eduarda Lopes", 2024],
  ["Carla Mendes", "Paula Moreira", 2025],
  ["Daniel Ribeiro", "Felipe Barros", 2026],
  ["Daniel Ribeiro", "Mateus Cardoso", 2024],
  ["Eduarda Lopes", "Gabriela Rocha", 2025],
  ["Eduarda Lopes", "Larissa Freitas", 2026],
  ["Felipe Barros", "Hugo Teixeira", 2024],
  ["Felipe Barros", "Thiago Batista", 2025],
  ["Gabriela Rocha", "Isabela Nunes", 2026],
  ["Gabriela Rocha", "Sofia Carvalho", 2024],
  ["Hugo Teixeira", "João Pereira", 2025],
  ["Hugo Teixeira", "William Santos", 2026],
  ["Isabela Nunes", "João Pereira", 2024],
  ["Isabela Nunes", "Vitória Azevedo", 2025],
  ["João Pereira", "Otávio Ramos", 2026],
  ["Larissa Freitas", "Mateus Cardoso", 2024],
  ["Larissa Freitas", "William Santos", 2025],
  ["Mateus Cardoso", "Natália Araújo", 2026],
  ["Natália Araújo", "Otávio Ramos", 2024],
  ["Otávio Ramos", "Paula Moreira", 2025],
  ["Paula Moreira", "Rafael Duarte", 2026],
  ["Rafael Duarte", "Sofia Carvalho", 2024],
  ["Sofia Carvalho", "Thiago Batista", 2025],
  ["Thiago Batista", "Vitória Azevedo", 2026],
  ["Vitória Azevedo", "William Santos", 2024]
] AS par
MATCH (a:Aluno {nome: par[0]}), (b:Aluno {nome: par[1]})
CREATE (a)-[:AMIGO_DE {desde: par[2]}]->(b);

// 8. Conferência (esperado: 20 / 8 / 5 / 8 / 60 / 31)
MATCH (a:Aluno) RETURN "Alunos" AS item, count(a) AS total
UNION ALL MATCH (d:Disciplina) RETURN "Disciplinas" AS item, count(d) AS total
UNION ALL MATCH (p:Professor) RETURN "Professores" AS item, count(p) AS total
UNION ALL MATCH ()-[r:LECIONA]->() RETURN "LECIONA" AS item, count(r) AS total
UNION ALL MATCH ()-[r:MATRICULADO_EM]->() RETURN "MATRICULADO_EM" AS item, count(r) AS total
UNION ALL MATCH ()-[r:AMIGO_DE]->() RETURN "AMIGO_DE" AS item, count(r) AS total;

// 9. Total de nós (esperado: 33)
MATCH (n) RETURN count(n) AS total_de_nos;
