# Rede social acadêmica com banco de grafos (Neo4j)

Trabalho Avaliativo de Bancos de Dados NoSQL, tipo **Grafos**.

**Integrantes:** Moesio Lorran Almeida, Savio Rodrigues e Igor Costa

**Caso:** rede social acadêmica com alunos, disciplinas, professores e amizades, incluindo recomendação de "amigos de amigos".

**Banco escolhido:** [Neo4j](https://neo4j.com) 5, com a linguagem Cypher.

**Por que Neo4j e não outro banco de grafos (ArangoDB, Memgraph)?** O Neo4j é o banco de grafos mais difundido, tem imagem Docker oficial e um navegador que desenha o grafo (ótimo para demonstrar), e o Cypher descreve o caminho da consulta quase como um desenho, ao contrário do ArangoDB, que é multimodelo e usa outra linguagem (AQL).

---

## Estrutura do repositório

```
.
├── README.md                    este arquivo (ambiente do zero)
├── docker-compose.yml           Neo4j (e SQL Server opcional para o comparativo)
├── cypher/
│   ├── 01_carga.cypher          33 nós e 99 relações
│   ├── 02_operacoes_crud.cypher inserir, consultar, atualizar e excluir
│   └── 03_consultas.cypher      5 consultas do caso + ponto forte (caminho entre nós)
├── sql/                         SQL Server (T-SQL)
│   ├── 01_schema.sql            modelo relacional (criação das tabelas)
│   ├── 02_carga.sql             mesmos dados do grafo
│   └── 03_consultas.sql         2 consultas reescritas + caminho em SQL
├── docs/
│   ├── modelagem.md             desenho do grafo e perguntas que o sistema responde
│   ├── comparativo.md           diagrama ER, consultas lado a lado e conclusão
│   ├── resultados.md            comando e resultado de cada consulta
│   └── apresentacao.md          roteiro da apresentação
└── prints/                      prints das consultas (C1 a C6) e saída do CRUD
```

---

## Passo a passo para subir o ambiente do zero

### Pré-requisito

[Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e aberto (Windows, macOS) ou Docker Engine com o plugin Compose (Linux). Confira:

```bash
docker --version
docker compose version
```

### 1. Baixar o projeto

```bash
git clone <URL-DO-REPOSITORIO>
cd <pasta-do-repositorio>
```

### 2. Subir o Neo4j

```bash
docker compose up -d
```

Na primeira vez o Docker baixa a imagem, o que pode demorar alguns minutos. Acompanhe até a coluna `STATUS` mostrar **healthy** (cerca de 30 a 60 segundos):

```bash
docker compose ps
```

### 3. Abrir o Neo4j Browser

Acesse **http://localhost:7474** e entre com:

- **Connect URL:** `neo4j://localhost:7687` (já vem preenchido)
- **Usuário:** `neo4j`
- **Senha:** `senha12345`

### 4. Carregar os dados (33 nós)

```bash
docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/01_carga.cypher
```

No final aparecem as contagens esperadas: 20 alunos, 8 disciplinas, 5 professores, 8 LECIONA, 60 MATRICULADO_EM e 31 AMIGO_DE, e o total de **33 nós**.

Para ver o grafo desenhado, cole no Neo4j Browser:

```cypher
MATCH (n)-[r]->(m) RETURN n, r, m
```

### 5. Rodar as operações (inserir, consultar, atualizar, excluir)

```bash
docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/02_operacoes_crud.cypher
```

### 6. Rodar as consultas do estudo de caso

```bash
docker compose exec neo4j cypher-shell -u neo4j -p senha12345 -f /scripts/03_consultas.cypher
```

Para a demonstração, é mais visual copiar cada consulta do arquivo `cypher/03_consultas.cypher` e colar no Neo4j Browser, que mostra o resultado em tabela ou em grafo.

### 7. (Opcional) Rodar o comparativo em SQL Server (T-SQL)

**Opção A, SQL Server já instalado (SSMS ou Azure Data Studio):** crie um banco chamado `rede_academica` e execute nele, nesta ordem, `sql/01_schema.sql`, `sql/02_carga.sql` e `sql/03_consultas.sql`.

**Opção B, SQL Server via Docker:** suba o container e aguarde cerca de 30 segundos até o SQL Server iniciar.

```bash
docker compose --profile comparativo up -d
docker compose exec sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Senha@12345" -C -Q "CREATE DATABASE rede_academica"
docker compose exec sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Senha@12345" -C -f 65001 -d rede_academica -i /sql/01_schema.sql,/sql/02_carga.sql,/sql/03_consultas.sql
```

O `-f 65001` lê os scripts como UTF-8, para os acentos dos nomes saírem corretos.

### 8. Encerrar

```bash
docker compose down        # desliga e mantém os dados
docker compose down -v     # desliga e apaga os dados
```

---

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `docker: command not found` | Instale e abra o Docker Desktop |
| `http://localhost:7474` não abre | Espere até o `docker compose ps` mostrar `healthy`; veja `docker compose logs neo4j` |
| Porta 7474 ou 7687 em uso | Feche outro Neo4j ou mude a porta à esquerda em `docker-compose.yml` |
| `sqlcmd` não conecta ao SQL Server | Aguarde uns 30 segundos depois do `up`; veja `docker compose logs sqlserver` |
| `ConstraintValidationFailed` | A carga já havia sido feita; o próprio `01_carga.cypher` começa limpando, então rode-o de novo |
| Consulta devolve vazio | Confira se a carga foi executada e se o nome está escrito com acento, como `"João Pereira"` |

---

## Documentação

- [Modelagem e perguntas do sistema](docs/modelagem.md)
- [Resultados de cada consulta](docs/resultados.md)
- [Comparativo com o relacional](docs/comparativo.md)
- [Roteiro da apresentação](docs/apresentacao.md)
