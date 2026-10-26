# Apresentação e checklist de entrega

**Prazos:** entrega (repositório no GitHub) em **02/11**; apresentação em **09/11**. Entrega fora do prazo perde 0,3 por dia de atraso. Como 02/11 é feriado, confirme com o professor como enviar o link do repositório.

## Roteiro de 15 minutos (mais 5 de perguntas)

Todos os integrantes precisam falar. Sugestão de divisão (ajustem os nomes):

| Tempo | Parte | Quem | O que mostrar |
|---|---|---|---|
| 2 min | 1. Banco escolhido e por quê | _(integrante 1)_ | Neo4j, Cypher, motivo da escolha em relação a ArangoDB e Memgraph |
| 3 min | 2. Modelagem | _(integrante 2)_ | Desenho de `docs/modelagem.md`; perguntas do sistema; por que `AMIGO_DE` é uma aresta |
| 7 min | 3. Demonstração ao vivo | _(integrantes 3 e 4)_ | `docker compose up -d`, carga (33 nós), grafo desenhado, operações CRUD, as 5 consultas e o `shortestPath` |
| 3 min | 4. Comparativo e conclusão | _(integrante 1 ou 2)_ | Diagrama ER; C3 em Cypher e em SQL lado a lado; conclusão |

**Ordem sugerida da demo (7 min):**

1. `docker compose ps` mostrando `healthy` e o Neo4j Browser aberto (30 s)
2. Carga e contagem de 33 nós; `MATCH (n)-[r]->(m) RETURN n, r, m` para mostrar o grafo (1 min)
3. CRUD: criar a Yasmin, atualizar, excluir (2 min)
4. C1 a C5, uma a uma, dizendo a pergunta de negócio antes de rodar (3 min)
5. C6: caminho entre Ana e William, e a visualização do caminho desenhado (30 s)

## Dicas para não perder nota

- **Ensaiem a demo** e deixem o ambiente já no ar antes de começar: baixar a imagem Docker na hora estoura o tempo.
- **Gravem um vídeo da execução como reserva.** Se a demo ao vivo falhar, o vídeo é aceito com desconto de 0,1.
- **Todos precisam saber explicar qualquer consulta.** Perguntas podem ser dirigidas a qualquer integrante, e a nota da apresentação pode ser individual.
- **Não repitam a teoria da aula 10.**
- Cada integrante deve ter **commits no repositório durante a semana**; repositório sem commits dos integrantes será questionado.

## Como publicar no GitHub

```bash
git init
git add .
git commit -m "Trabalho NoSQL: grafos com Neo4j"
git branch -M main
git remote add origin <URL-DO-REPOSITORIO>
git push -u origin main
```

Cada integrante deve clonar o repositório e fazer ao menos um commit próprio (por exemplo, completar os prints ou o nome no README) durante a semana.

## Checklist da entrega (conforme o enunciado)

**1. Ambiente**
- [ ] Banco rodando via Docker com `docker-compose.yml` no repositório
- [ ] Passo a passo no `README.md` para subir do zero
- [ ] Uma linha explicando por que o grupo escolheu esse banco e não outro do mesmo tipo (está no README)

**2. Modelagem**
- [ ] Desenho dos nós e arestas (`docs/modelagem.md`)
- [ ] Lista das perguntas do sistema e como a modelagem facilita cada uma (`docs/modelagem.md`)

**3. Carga e operações**
- [ ] Script de carga com no mínimo 30 nós, dados realistas (`cypher/01_carga.cypher`: 33 nós)
- [ ] Exemplos de inserir, consultar, atualizar e excluir (`cypher/02_operacoes_crud.cypher`)

**4. Consultas do estudo de caso**
- [ ] 5 consultas, cada uma com comando e **print** do resultado (`cypher/03_consultas.cypher`, `docs/resultados.md` e `prints/`)
- [ ] 1 recurso ponto forte do tipo: caminho entre nós (`shortestPath`, C6)

**5. Comparativo com o relacional**
- [ ] Diagrama ER e criação das tabelas (`docs/comparativo.md`, `sql/01_schema.sql`)
- [ ] Duas das 5 consultas reescritas em SQL (`sql/03_consultas.sql`: C3 e C5)
- [ ] Meia página: qual modelo é melhor e por quê (final de `docs/comparativo.md`)

**Antes de entregar**
- [ ] Nomes dos integrantes no README
- [ ] Prints salvos em `prints/`
- [ ] Testar o passo a passo do README em outra máquina ou numa pasta limpa

## Critérios de avaliação (total 1,5)

| Critério | O que se espera | Valor |
|---|---|---|
| Ambiente e modelagem | Banco rodando, README com passo a passo, modelagem justificada pelas consultas | 0,3 |
| Carga e operações | Script com 30 ou mais registros realistas; inserir, consultar, atualizar e excluir funcionando | 0,3 |
| Consultas do caso | 5 consultas corretas e úteis, mais o recurso de ponto forte do tipo | 0,3 |
| Comparativo com o relacional | Modelo SQL coerente e conclusão bem justificada | 0,2 |
| Apresentação | Demo ao vivo funcionando, tempo respeitado, domínio nas respostas | 0,4 |
