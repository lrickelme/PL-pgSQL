CREATE OR REPLACE FUNCTION calculate_league_standings(p_league_id bigint)
RETURNS TABLE (
    team_id int,
    team_name text,
    points int
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.team_api_id AS team_id,
        t.team_long_name AS team_name,
        COALESCE(SUM(
            CASE 
                WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 3
                WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal THEN 3
                WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal = m.away_team_goal THEN 1
                WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal = m.home_team_goal THEN 1
                ELSE 0 
            END
        ), 0) AS points
    FROM public.Team t
    LEFT JOIN public.match m 
        ON t.team_api_id = m.home_team_api_id OR t.team_api_id = m.away_team_api_id
    WHERE m.league_id = p_league_id
    GROUP BY t.team_api_id, t.team_long_name;
END;
$$ LANGUAGE plpgsql;
