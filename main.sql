/*
EUROPEAN SOCCER DATABASE EXPLORATION
This Kaggle Dataset has eight tables containing 25,000+ matches and 10,000+ players. Learn more here https://www.kaggle.com/datasets/hugomathien/soccer
SKILLS USED: Joins, CTE's
*/

-- Which team scored the most goals for 2015/16? Using CTE's and JOINS
WITH h as 
    (SELECT 
        home_team_api_id AS id, 
        SUM(home_team_goal) AS goals 
    FROM 
        Match
    WHERE 
        season =  "2015/2016"
    GROUP BY 
        home_team_api_id),

a AS 
    (SELECT 
        away_team_api_id AS id, 
        SUM(away_team_goal) AS goals 
FROM 
    Match
WHERE 
    season =  "2015/2016"
GROUP BY 
    away_team_api_id)

SELECT 
	Team.team_long_name as Team,
    (h.goals + a.goals) as Goals
FROM h 
	JOIN a ON 
    a.id = h.id 
	JOIN Team ON
	h.id=Team.team_api_id
GROUP BY 
    h.id 
ORDER BY 
    goals DESC
	LIMIT 10;
-- CONCLUSION: FC Barcelona scored the most goals during 2015/2016
