# Roteiro da apresentação

Duração: 15 minutos de apresentação e 5 de perguntas.

| Tempo | Parte | Quem | O que mostrar |
|---|---|---|---|
| 2 min | 1. Banco escolhido e por quê | Igor Costa | Neo4j e Cypher; motivo da escolha em relação a ArangoDB e Memgraph |
| 3 min | 2. Modelagem | Moesio Lorran Almeida | Desenho de `docs/modelagem.md`; perguntas do sistema; por que `AMIGO_DE` é uma aresta |
| 7 min | 3. Demonstração ao vivo | Savio Rodrigues | Ambiente no ar, carga (33 nós), grafo desenhado, operações CRUD, as 5 consultas e o `shortestPath` |
| 3 min | 4. Comparativo e conclusão | Igor Costa | Diagrama ER; C3 em Cypher e em SQL lado a lado; conclusão |

## Ordem da demonstração (7 min)

1. `docker compose ps` mostrando `healthy` e o Neo4j Browser aberto (30 s)
2. Carga com a contagem de 33 nós; `MATCH (n)-[r]->(m) RETURN n, r, m` para mostrar o grafo (1 min)
3. CRUD: criar a Yasmin, atualizar e excluir (2 min)
4. C1 a C5, uma a uma, dizendo a pergunta de negócio antes de rodar (3 min)
5. C6: caminho entre Ana e William, e a vizinhança da Ana desenhada no grafo (30 s)
