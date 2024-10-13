-- 0
SELECT population FROM world
  WHERE name = 'Germany'

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

-- 1
SELECT name FROM world
  WHERE name LIKE 'Y%'

SELECT name FROM world
  WHERE name LIKE '%y'

SELECT name FROM world
  WHERE name LIKE '%x%'

SELECT name FROM world
  WHERE name LIKE '%land'

SELECT name FROM world
  WHERE name LIKE 'C%ia'

SELECT name FROM world
  WHERE name LIKE '%oo%'

SELECT name FROM world
  WHERE name LIKE '%a%a%a%'

SELECT name FROM world
 WHERE name LIKE '_t%'
ORDER BY name

SELECT name FROM world
 WHERE name LIKE '%o__o%'

 SELECT name FROM world
 WHERE LENGTH(name) = 4

SELECT name
  FROM world
 WHERE name = capital

SELECT name
  FROM world
 WHERE capital = concat(name, ' City')

SELECT capital, name
  FROM world
 WHERE capital like concat('%', name, '%')

SELECT capital, name
  FROM world
 WHERE capital like concat('%', name, '%')
AND capital <> name

SELECT name, REPLACE(capital, name, '')
  FROM world
 WHERE capital like concat('%', name, '%')
AND capital <> name

-- 2
SELECT name FROM world
WHERE population >= 200000000

SELECT name, gdp / population FROM world
WHERE population >= 200000000

SELECT name, population / 1000000 FROM world WHERE continent = 'South America';
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy')
SELECT name FROM world WHERE name LIKE '%United%'
SELECT name, population, area FROM world WHERE area > 3000000 OR population > 250000000
SELECT name, population, area FROM world WHERE area > 3000000 XOR population > 250000000
SELECT name, ROUND(population / 1000000, 2) AS Population, ROUND(gdp / 1000000000, 2) GDP FROM world WHERE continent = 'South America';
SELECT name, ROUND((gdp / population) / 1000, 0) * 1000 AS gdp_per_capita FROM world
WHERE gdp >= 1000000000000

SELECT name, capital
  FROM world
 WHERE LENGTH(name) = LENGTH(capital);

SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1) AND name <> capital

SELECT name
   FROM world
WHERE lower(name) LIKE '%a%' AND LOWER(name) LIKE '%e%' AND LOWER(name) LIKE '%i%' AND LOWER(name) LIKE '%o%' AND LOWER(name) LIKE '%u%'
  AND name NOT LIKE '% %'

-- 3
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'
  
SELECT yr, subject
  FROM nobel
 WHERE winner = 'Albert Einstein'

SELECT winner
  FROM nobel
 WHERE yr >= 2000 AND subject = 'Peace'

SELECT yr, subject, winner
  FROM nobel
 WHERE yr >= 1980 AND yr <= 1989 AND subject = 'Literature'

SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt'
,'Woodrow Wilson'
,'Jimmy Carter'
,'Barack Obama')

SELECT winner FROM nobel
 WHERE winner LIKE 'John %'

SELECT yr, subject, winner FROM nobel 
WHERE (subject = 'Physics' AND yr = 1980) OR (subject = 'Chemistry' AND yr = 1984)

SELECT yr, subject, winner FROM nobel 
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')

SELECT yr, subject, winner FROM nobel 
WHERE (subject = 'Medicine' AND yr < 1910) OR (subject = 'Literature' AND yr >= 2004)

SELECT * FROM nobel WHERE winner = 'PETER GRÜNBERG'

SELECT * FROM nobel WHERE winner = 'EUGENE O''NEILL'

SELECT winner, yr, subject FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner ASC

SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('chemistry','physics'), subject,winner

-- 4
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

SELECT name FROM world
  WHERE gdp / population >
     (SELECT gdp / population FROM world
      WHERE name='United Kingdom') AND continent = 'Europe'

SELECT name, continent FROM world
  WHERE continent IN
     (SELECT continent FROM world
      WHERE name in ('Argentina', 'Australia'))
ORDER BY name

SELECT name, population FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name = 'United Kingdom')
AND population < (SELECT population FROM world
      WHERE name = 'Germany')

SELECT name, CONCAT(ROUND(population / (SELECT population FROM world
      WHERE name = 'Germany') * 100, 0), '%') AS percentage FROM world
  WHERE continent = 'Europe' AND population > 0

SELECT name FROM world
WHERE gdp > 0 AND gdp > (SELECT MAX(gdp) FROM world  WHERE continent = 'Europe' AND gdp > 0)

SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

SELECT DISTINCT continent, (SELECT name FROM world b WHERE b.continent = a.continent ORDER BY name LIMIT 1) FROM world a

SELECT name, continent, population
  FROM world a
WHERE (SELECT MAX(population) FROM world b WHERE b.continent = a.continent) <= 25000000

SELECT name, continent
  FROM world a
WHERE a.population >= (SELECT SUM(population) FROM world b WHERE b.continent = a.continent AND b.name <> a.name AND b.population > 0) * 3

-- 5
SELECT SUM(population)
FROM world

SELECT DISTINCT continent
FROM world

SELECT SUM(gdp)
FROM world WHERE continent = 'Africa'

SELECT COUNT(*)
FROM world WHERE area >= 1000000

SELECT SUM(population)
FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

SELECT continent, COUNT(*)
FROM world
GROUP BY continent

SELECT continent, COUNT(*)
FROM world
WHERE population >= 10000000
GROUP BY continent

SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000

-- 6
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER'

SELECT team1, team2, player
  FROM game JOIN goal ON (id=matchid)
WHERE player LIKE 'Mario%'

SELECT player, teamid, coach, gtime
  FROM goal 
JOIN eteam ON teamid=id
 WHERE gtime<=10

SELECT mdate, teamname FROM game
JOIN eteam ON (team1=eteam.id)
WHERE coach = 'Fernando Santos'

SELECT player FROM goal
JOIN game ON id = matchid
WHERE stadium = 'National Stadium, Warsaw'

SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER') AND teamid <> 'GER'

SELECT teamname, COUNT(teamid)
  FROM eteam JOIN goal ON id=teamid
GROUP BY teamname

SELECT stadium, COUNT(teamid) FROM game
JOIN goal ON id = matchid
GROUP BY stadium

SELECT matchid,mdate, COUNT(matchid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid,mdate

SELECT matchid, mdate, COUNT(matchid) FROM goal
JOIN game ON id = matchid
WHERE teamid = 'GER'
GROUP BY matchid, mdate

SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1
,team2
,SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game JOIN goal ON matchid = id

GROUP BY mdate, team1, team2
order BY mdate ASC, team1, team2

-- 7
SELECT id, title
 FROM movie
 WHERE yr=1962

SELECT yr
 FROM movie
 WHERE title = 'Citizen Kane'

SELECT id, title, yr
 FROM movie
 WHERE title LIKE '%Star Trek%'
ORDER BY yr

SELECT id FROM actor WHERE name = 'Glenn Close'
SELECT id FROM movie WHERE title = 'Casablanca'

SELECT name FROM actor JOIN casting ON actorid=id AND movieid=11768

SELECT name FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid AND title='Alien'

SELECT title FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE name = 'Harrison Ford'

SELECT title FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE name = 'Harrison Ford' AND ord > 1

SELECT title, name FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE ord = 1 and yr = 1962

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

SELECT title, name FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE ord = 1 and 
movieid IN (
  SELECT movieid FROM actor
join casting ON id=actorid
  WHERE name='Julie Andrews')

SELECT name FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE ord = 1
GROUP BY name
HAVING COUNT(*) >= 15
ORDER BY name

SELECT title, COUNT(*) FROM actor JOIN casting ON actorid=actor.id
JOIN movie ON movie.id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(*) DESC, TITLE

SELECT DISTINCT a.name FROM actor a
JOIN casting c ON a.id = c.actorid
JOIN casting c2 ON c.movieid=c2.movieid
JOIN actor a2 ON c2.actorid=a2.id AND a2.name = 'Art Garfunkel'
WHERE a.name <> 'Art Garfunkel'

-- 8
SELECT name FROM teacher WHERE dept IS NULL

SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)

SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher

SELECT teacher.name, COALESCE(dept.name, 'None')
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

SELECT COUNT(name), COUNT(mobile) FROM teacher

SELECT dept.name, COUNT(teacher.name)
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)
GROUP BY dept.name

-- 9
SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'

SELECT institution, subject
  FROM nss
 WHERE question='Q15' AND score >= 100

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND subject='(8) Computer Science'
AND score < 50

SELECT subject, SUM(response)
  FROM nss
 WHERE question='Q22'
   AND institution='Edinburgh Napier University'
   AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject

SELECT subject, SUM(response)
  FROM nss
 WHERE question='Q15'
   AND institution='Edinburgh Napier University'
   AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
AND A_STRONGLY_AGREE > 0
GROUP BY subject

-- 10
SELECT lastName, party, votes
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC

SELECT party, votes,
       RANK() OVER (ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes

SELECT yr,party, votes,
      RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000021'
ORDER BY party,yr

-- 11
SELECT name, DAY(whn),
 confirmed, deaths, recovered
 FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn
