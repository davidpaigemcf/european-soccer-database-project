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
-- CONCLUSION: FC Barcelona scored the most goals- 112 goals- during 2015/2016

-- How old were top 10 players for 2008-16?
SELECT 
	rank() over(order by ROUND(AVG(Player_Attributes.overall_rating), 1) desc) as Ranking,
	Player.player_name AS Name,
	FLOOR((julianday('2016-12-31')-julianday(Player.birthday))/365.25) AS Age,
	ROUND(AVG(Player_Attributes.overall_rating), 1) AS Rating
FROM Player 
JOIN Player_Attributes  ON 
    	Player.player_api_id = Player_Attributes.player_api_id
GROUP BY 
    	Player.player_api_id
LIMIT 10;
-- Conclusion: Lionel Messi had the highest average rating between 2008-16

-- Top 3 Matches with the most goals scored by season
SELECT 
    a.Ranking,
    a.season,
    t.team_long_name as HomeTeam,
    a.home_team_goal as HomeGoals,
    t1.team_long_name as AwayTeam,
    a.away_team_goal as AwayGoals
FROM (
    SELECT 
        season,
        home_team_api_id as hid, 
        away_team_api_id as aid,
        home_team_goal,
        away_team_goal,
        row_number() over(partition by season order by home_team_goal+away_team_goal desc) as Ranking
    FROM 
        Match) as a
JOIN Team t  ON   a.hid = t.team_api_id
JOIN Team t1 ON   a.aid = t1.team_api_id
WHERE 
    a.ranking <= 3;


-- Most appearances in 2009/2010 season
WITH a as (
    SELECT home_player_1 as PlayerID from Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_2 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_3 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_4 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_5 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_6 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_7 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_8 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_9 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_10 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT home_player_11 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_1 as PlayerID from Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_2 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_3 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_4 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_5 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_6 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_7 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_8 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_9 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_10 FROM Match WHERE season = '2009/2010'
	UNION ALL
	SELECT away_player_11 FROM Match WHERE season = '2009/2010'
)
SELECT player_name, count(PlayerID) Appearances 
FROM a 
JOIN Player ON a.PlayerID = Player.player_api_id
GROUP BY a.PlayerID
ORDER BY Appearances DESC
LIMIT 1;
-- Conclusion: Robert Olejnik had the most appearances in 2009/2010 playing in 39 matches

