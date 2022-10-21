--2
CREATE DATABASE BDP_LAB2;

--3
CREATE EXTENSION postgis;

--4
CREATE TABLE buildings( _id INTEGER NOT NULL PRIMARY KEY, geometry GEOMETRY, name VARCHAR(50));
CREATE TABLE roads( _id INTEGER NOT NULL PRIMARY KEY, geometry GEOMETRY, name VARCHAR(50));
CREATE TABLE poi( _id INTEGER NOT NULL PRIMARY KEY, geometry GEOMETRY, name VARCHAR(50));

--5
INSERT INTO buildings VALUES  (1, 'POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))', 'BuildingA'),
                              (2, 'POLYGON((4 7, 4 5, 6 5, 6 7, 4 7))', 'BuildingB'),
                              (3, 'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
                              (4, 'POLYGON((9 9, 9 8, 10 8, 10 9, 9 9))', 'BuildingD'),
                              (5, 'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 'BuildingE');

INSERT INTO roads VALUES (1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
                         (2, 'LINESTRING(7.5 0, 7.5 10.5)', 'RoadY');

INSERT INTO poi VALUES (1,'POINT(1 3.5)','G'),
                       (2,'POINT(5.5 1.5)','H'),
                       (3,'POINT(9.5 6)','I'),
                       (4,'POINT(6.5 6)','J'),
                       (5,'POINT(6 9.5)','K');

--6
--a
SELECT SUM(ST_LENGTH(geometry)) FROM roads;

--b
SELECT ST_AsText(geometry), ST_Area(geometry), ST_Perimeter(geometry) FROM buildings WHERE name='BuildingA';

--c
SELECT name, ST_Area(geometry) FROM buildings ORDER BY name;

--d
SELECT name, ST_Perimeter(geometry) FROM buildings ORDER BY ST_Perimeter(geometry) DESC LIMIT 2;

--e
SELECT ST_Distance(buildings.geometry, poi.geometry) FROM buildings, poi WHERE poi.name = 'K' and buildings.name = 'BuildingC';

--f
WITH BB AS (SELECT geometry FROM buildings WHERE name = 'BuildingB'),
     BC AS (SELECT geometry FROM buildings WHERE name = 'BuildingC')

SELECT ST_Area(BC.geometry) - ST_Area(ST_Intersection(ST_Buffer(BB.geometry,0.5),BC.geometry)) as res FROM BB,BC;

--g
WITH temp AS (SELECT geometry FROM roads WHERE name = 'RoadX')
SELECT name FROM buildings,temp WHERE ST_Y(ST_CENTROID(buildings.geometry))>ST_Y(ST_Centroid(temp.geometry));

--h
WITH BC AS (SELECT geometry FROM buildings WHERE name = 'BuildingC')
SELECT ST_Area(BC.geometry) + ST_Area(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) - 2 * ST_Area(ST_Intersection(BC.geometry,ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) FROM BC;


