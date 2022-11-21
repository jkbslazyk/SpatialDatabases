CREATE DATABASE bdp_lab5;

CREATE EXTENSION postgis;

CREATE TABLE objects( _id INTEGER NOT NULL PRIMARY KEY, geometry GEOMETRY, name VARCHAR(50));

--ZAD1
INSERT INTO objects VALUES
	        (1,ST_Collect(ARRAY[
	        ST_GeomFromText('LINESTRING(0 1, 1 1)'),
	        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)')),
	        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)')),
			ST_GeomFromText('LINESTRING(5 1, 6 1)')]), 'obiekt1');

INSERT INTO objects VALUES
            (2, ST_Collect(ARRAY[
            ST_GeomFromText('LINESTRING(10 6, 14 6)'),
            ST_GeomFromText('LINESTRING(14 6, 13 2)'),
            ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(13 2, 12 3, 11 2)')),
            ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(11 2, 12 1, 13 2)')),
            ST_GeomFromText('LINESTRING(13 2, 14 6)'),
            ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)')),
            ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)')),
            ST_GeomFromText('LINESTRING(10 2, 10 6)')]), 'obiekt2');

INSERT INTO objects VALUES
            (3, ST_Collect(ARRAY[
            ST_GeomFromText('LINESTRING(7 15, 10 17)'),
            ST_GeomFromText('LINESTRING(10 17, 12 13)'),
            ST_GeomFromText('LINESTRING(12 13, 7 15)')]), 'obiekt3');

INSERT INTO objects VALUES
            (4, ST_LineFromMultiPoint('MULTIPOINT(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'), 'obiekt4');

INSERT INTO objects VALUES
            (5,ST_Collect(
            ST_GeomFromText('POINT(30 30 59)'),
            ST_GeomFromText('POINT(38 32 234)')), 'obiekt5');

INSERT INTO objects VALUES
            (6,ST_Collect(
            ST_GeomFromText('POINT(4 2)'),
            ST_GeomFromText('LINESTRING(1 1, 3 2)')), 'obiekt6');

--ZAD2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(object3.geometry,object4.geometry),5))
FROM (SELECT * FROM objects WHERE _id=3) as object3, (SELECT * FROM objects WHERE _id=4) as object4;

--ZAD3
UPDATE objects
SET geometry = ST_GeomFromText('POLYGON((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))')
WHERE _id = 4;

--ZAD4
INSERT INTO objects
            SELECT 7, ST_Collect(object3.geometry, object4.geometry), 'obiekt7'
            FROM (SELECT * FROM objects WHERE _id=3) as object3, (SELECT * FROM objects WHERE _id=4) as object4;

SELECT * FROM objects;

--ZAD5
SELECT _id, ST_Area(ST_Buffer(geometry,5)), name FROM objects WHERE ST_HasArc(ST_LineToCurve(geometry))=FALSE;




