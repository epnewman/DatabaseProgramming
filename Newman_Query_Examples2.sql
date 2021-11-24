/*Name: Elliott Newman
 Desc: Extra queries, showing some examples of Case statement usage 
 */ 


/* finding fields non existent in stadium relation*/
SELECT DISTINCT g.stadium, ns.stadium_name
FROM game_t g LEFT JOIN nfl_stadiums ns
ON g.stadium = ns.stadium_name
WHERE stadium_name IS NULL;

/* Making sure teams match up*/
SELECT DISTINCT NL.team_name, g.TEAM_HOME
FROM game_t g RIGHT JOIN NFL_TEAMS NL
ON g.team_home = NL.team_name
WHERE TEAM_HOME IS NULL;

/*Using CASE statements to reduce data dimensionality and sey away/home winning statuses.
Having 4 different HOME/AWAY status columns helped with color coding on a Heat map. For other cases, might not be necessary.*/
SELECT DISTINCT schedule_date, team_home, team_away, score_home, score_away, stadium, elevation,
 CASE 
     WHEN elevation >= 0 AND elevation < 100 THEN '0-100'
     WHEN elevation >= 100 AND elevation < 200 THEN '100-200'
     WHEN elevation >= 200 AND elevation < 300 THEN '200-300'
     WHEN elevation >= 300 AND elevation < 400 THEN '300-400'
     WHEN elevation >= 400 AND elevation < 600 THEN '400-600'
     WHEN elevation >= 600 AND elevation < 2000 THEN '600+'
     Else 'Unknown'
     END AS Elevation_BIN,
 CASE
     WHEN score_home > score_away THEN 1
     WHEN score_away > score_home THEN 0
     END AS Home_Winner,
CASE
     WHEN score_home > score_away THEN 0
     WHEN score_away > score_home THEN 1
     END AS Home_Loser,
CASE
     WHEN score_home > score_away THEN 0
     WHEN score_away > score_home THEN 1
     END AS Away_Winner,
CASE
     WHEN score_home > score_away THEN 1
     WHEN score_away > score_home THEN 0
     END AS Away_Loser
FROM NFL_Stadiums NS, GAME_t GT
WHERE NS.stadium_name = GT.stadium
AND team_home is not null
AND schedule_date >= '01/01/1995';

/* Adding elevations*/
UPDATE nfl_stadiums
SET elevation = 11
WHERE stadium_name = 'Twickenham Stadium';

SELECT distinct stadium, elevation
FROM GAME_T, NFL_STADIUMS
WHERE GAME_T.stadium = NFL_STADIUMS.stadium_NAME AND 
schedule_date >= '01/01/1995'
ORDER BY stadium;
