# Função PL/pgSQL para Calcular Pontuação de Times em uma Liga e Temporada

Este repositório contém uma função em PL/pgSQL que calcula a pontuação dos times em uma liga específica durante uma temporada. A função recebe como parâmetros o `id` da liga e a temporada (`season`) e retorna uma tabela com o `id` do time, o nome do time e a pontuação obtida.

---

## Estrutura do Banco de Dados

A função utiliza as seguintes tabelas do banco de dados:

### Tabela `Team`
Armazena informações sobre os times, incluindo `team_api_id` e `team_long_name`.

```sql
CREATE TABLE public."Team" (
    id int4 NOT NULL,
    team_api_id int4 NULL,
    team_fifa_api_id int4 NULL,
    team_long_name text NULL,
    team_short_name text NULL,
    CONSTRAINT "Team_pkey" PRIMARY KEY (id),
    CONSTRAINT "Team_team_api_id_key" UNIQUE (team_api_id)
);
```

### Tabela `match`
Armazena informações sobre as partidas, incluindo `league_id`, `season`, `home_team_api_id`, `away_team_api_id`, `home_team_goal` e `away_team_goal`.

```sql
CREATE TABLE public."match" (
    id int4 NOT NULL,
    country_id int4 NULL,
    league_id int4 NULL,
    season text NULL,
    stage int4 NULL,
    "date" text NULL,
    match_api_id int4 NULL,
    home_team_api_id int4 NULL,
    away_team_api_id int4 NULL,
    home_team_goal int4 NULL,
    away_team_goal int4 NULL,
    -- Outros campos omitidos para brevidade
    CONSTRAINT match_pkey PRIMARY KEY (id),
    CONSTRAINT match_away_team_api_id_fkey FOREIGN KEY (away_team_api_id) REFERENCES public."Team"(team_api_id),
    CONSTRAINT match_home_team_api_id_fkey FOREIGN KEY (home_team_api_id) REFERENCES public."Team"(team_api_id),
    CONSTRAINT match_league_id_fkey FOREIGN KEY (league_id) REFERENCES public.league(id)
);
```

---

## Função `calculate_league_standings`

A função `calculate_league_standings` calcula a pontuação de cada time em uma liga e temporada específica. A pontuação é calculada com base nas regras padrão do futebol:
- Vitória: 3 pontos
- Empate: 1 ponto
- Derrota: 0 pontos

### Parâmetros
- `p_league_id` (bigint): O ID da liga.
- `p_season` (text): A temporada (ex: `'2013/2014'`).

### Retorno
A função retorna uma tabela com as seguintes colunas:
- `team_id` (int): O ID do time.
- `team_name` (text): O nome do time.
- `points` (int): A pontuação total do time na temporada.
