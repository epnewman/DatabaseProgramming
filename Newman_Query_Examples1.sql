/*Name: Elliott Newman
 Desc: Examples of queries I used for managing my NFL Oracle Database.
       While you may not have access to the Database I used, I hope
       the queries give context to my programming abilities. 
For app reviewers: If you want or need any code from my current work,
I will be able to directly provide it, but am happy share similar snippets or high level descriptions.
 */ 


/* Subsetting relevant data from a stadiums table, fits 3NF*/
Create Table NFL_STADIUMS AS(
SELECT 
    Stadium_name,
    stadium_location,
    stadium_open,
    stadium_close,
    stadium_type,
    stadium_address,
    stadium_weather_type,
    stadium_capacity,
    stadium_surface,
    longitude,
    latitude,
    elevation
FROM STADIUMS
);

/* Ensuring data has been set up properly*/
SELECT *
FROM SUPERBOWL;

/*No stadium has the same name, it can used as the primary key*/
ALTER TABLE NFL_STADIUMS
ADD CONSTRAINT stadium_key PRIMARY KEY (Stadium_name);

/*Team name is the primary key for the team*/
ALTER TABLE NFL_TEAMS
ADD CONSTRAINT team_key PRIMARY KEY (TEAM_NAME);


/*Normalizing a Spreadspoke dataset*/
CREATE TABLE GAME_T AS (
SELECT Schedule_Date,
       Team_Home,
       Team_Away,
       Score_Home,
       Score_Away,
       Team_Favorite_ID,
       Spread_Favorite,
       Over_Under_line,
       stadium
FROM SPREADSPOKE_SCORE1);

ALTER TABLE GAME_T
ADD CONSTRAINT game_pk PRIMARY KEY (Schedule_date, Team_Home, Team_Away);

ALTER TABLE GAME_T
ADD CONSTRAINT team_fk FOREIGN KEY (Team_Home) REFERENCES NFL_TEAMS(TEAM_NAME);

SELECT count(distinct team_name)
FROM NFL_TEAMS;

INSERT INTO NFL_STADIUMS VALUES ('Fenway Park', 'Boston, MA', 1912, NULL, 'outdoor', '4 Jersey St, Boston, MA 02215', 
                                'moderate', 37731, 'grass', 42.3467, 71.0972, 20);

INSERT INTO NFL_STADIUMS VALUES ('Legion Field', 'Birmingham, AL', 1927, NULL, 'outdoor', '400 Graymont Ave W, Birmingham, AL 35204', 
                                'warm', 71594, 'grass', 33.5115, 86.8425, 570);
                                
INSERT INTO NFL_STADIUMS VALUES ('Mercedes-Benz Stadium', 'Atlanta, GA', 1992, 2016, 'indoor', '1 AMB Dr NW, Atlanta, GA 30313', 
                                'dome', 71000, NULL, 33.7554, 84.4008, 305);
                                
INSERT INTO NFL_STADIUMS VALUES ('TIAA Bank Field', 'Jacksonvill, FL', 1995, NULL, 'outdoor', '1 TIAA Bank Field Dr, Jacksonville, FL 32202', 
                                'warm', 67814, NULL, 30.324, 81.6373, NULL);

INSERT INTO NFL_STADIUMS VALUES ('Tottenham Stadium', 'London, UK', 2019, NULL, 'indoor', NULL, 
                                'dome', 62062, 'grass', 51.6043,0.0664, 157.78);
                                
INSERT INTO NFL_STADIUMS VALUES ('Tottenham Hotspur Stadium', 'London, UK', 2019, NULL, 'indoor', NULL, 
                                'dome', 62062, 'grass', 51.6043,0.0664, 157.78);

INSERT INTO NFL_STADIUMS VALUES ('FedEx Field', 'Landover, MD', 1997, 2016, 'outdoor', '1600 Fedex Way, Hyattsville, MD 20785', 
                                'moderate', 79000, 'grass', 38.9133, 76.97, 15.2);

DELETE
FROM NFL_Stadiums
WHERE stadium_name = 'FedExField';
    
ALTER TABLE GAME_T
ADD CONSTRAINT stadium_fk FOREIGN KEY (stadium) REFERENCES NFL_STADIUMS(Stadium_Name);


/*Dropping a feature, schedule week. The week wasn't the same value or correct for each game*/
CREATE TABLE Date_T AS (
SELECT DISTINCT Schedule_date,
       Schedule_season,
       Schedule_Playoff
FROM SPREADSPOKE_SCORE1
);

DELETE
FROM date_T
WHERE schedule_date = '12/21/1969' and Schedule_playoff = 'TRUE';

DELETE
FROM date_T
WHERE schedule_date = '12/23/1967' and Schedule_playoff = 'FALSE';

DELETE
FROM date_T
WHERE schedule_date = '12/24/1967' and Schedule_playoff = 'FALSE';

ALTER TABLE Date_T
ADD CONSTRAINT date_pk PRIMARY KEY (Schedule_date);

ALTER TABLE GAME_T
ADD CONSTRAINT date_fk FOREIGN KEY (Schedule_Date) REFERENCES Date_T(Schedule_Date);


/*Creating a Weather Table*/
CREATE TABLE WEATHER_T AS (
SELECT DISTINCT Schedule_Date,
                Stadium,
                Weather_temperature,
                Weather_Humidity,
                Weather_Detail,
                Weather_Wind_MPH
FROM SPREADSPOKE_SCORE1);

ALTER TABLE WEATHER_T
ADD CONSTRAINT weather_pk PRIMARY KEY (Schedule_date, stadium);
ALTER TABLE WEATHER_T
ADD CONSTRAINT weather_fk FOREIGN KEY (schedule_date) REFERENCES DATE_T(schedule_date);
ALTER TABLE WEATHER_T
ADD CONSTRAINT weather_fk1 FOREIGN KEY (Stadium) REFERENCES NFL_STADIUMs(Stadium_Name);


/* CLEANING QUERIES */

/* finding fields non existent in stadium relation*/
SELECT DISTINCT g.stadium, ns.stadium_name
FROM game_t g LEFT JOIN nfl_stadiums ns
ON g.stadium = ns.stadium_name
WHERE stadium_name IS NULL;

/* Checking for errors, Making sure teams match up*/
SELECT DISTINCT NL.team_name, g.TEAM_HOME
FROM game_t g RIGHT JOIN NFL_TEAMS NL
ON g.team_home = NL.team_name
WHERE TEAM_HOME IS NULL;
