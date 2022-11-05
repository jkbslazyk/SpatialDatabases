CREATE DATABASE BDP_LAB3;

--1
SELECT * FROM t2019_kar_buildings t19 LEFT JOIN t2018_kar_buildings t18 on t18.geom=t19.geom where t18.gid IS NULL;

--2
WITH
    new_buildings AS (SELECT t19.gid, t19.polygon_id, t19.type, t19.geom FROM t2019_kar_buildings t19 LEFT JOIN t2018_kar_buildings t18 on t18.geom=t19.geom where t18.gid IS NULL),
    new_points AS (SELECT p19.gid, p19.poi_id, p19.type, p19.geom FROM t2019_kar_poi_table p19 LEFT JOIN t2018_kar_poi_table p18 on p18.geom=p19.geom where p18.gid IS NULL)

SELECT COUNT(DISTINCT new_points.gid), new_points.type FROM new_points JOIN new_buildings ON ST_DWITHIN(new_points.geom,new_buildings.geom, 500) GROUP BY new_points.type;

--3
ALTER TABLE t2019_kar_streets ADD COLUMN geom_projected geometry;
UPDATE t2019_kar_streets SET geom_projected=ST_Transform(ST_SetSRID(t2019_kar_streets.geom,4326), 3068);
SELECT * FROM t2019_kar_streets;

--4
CREATE TABLE points( _id INTEGER NOT NULL PRIMARY KEY, geom GEOMETRY, name VARCHAR(50));
INSERT INTO points VALUES
(1, 'POINT(8.36093 49.03174)', 'p1'),
(2, 'POINT(8.39876 49.00644)', 'p2');

--5
ALTER TABLE points ADD COLUMN geom_projected geometry;
UPDATE points SET geom_projected=ST_Transform(ST_SetSRID(geom,4326), 3068) WHERE _id>0; -- bez klauzuli WHERE wyrzucalo blad
SELECT * FROM points;

--6
ALTER TABLE t2019_kar_street_node ADD COLUMN geom_projected geometry;
UPDATE t2019_kar_street_node SET geom_projected=ST_Transform(ST_SetSRID(geom,4326), 3068) WHERE gid>0;

WITH line AS (SELECT ST_MAKELINE(geom_projected) as l FROM points)

SELECT gid, geom_projected FROM t2019_kar_street_node JOIN line ON ST_DWITHIN(t2019_kar_street_node.geom_projected,line.l, 200);

--7
WITH
    stores AS (SELECT * FROM t2019_kar_poi_table WHERE type = 'Sporting Goods Store')


SELECT COUNT(DISTINCT stores.gid) FROM stores JOIN t2019_kar_land_use_a ON ST_DWITHIN(stores.geom,t2019_kar_land_use_a.geom, 300);

--8
SELECT DISTINCT ST_INTERSECTION(t2019_kar_water_lines.geom, t2019_kar_railways.geom) INTO junction FROM t2019_kar_water_lines, t2019_kar_railways;
SELECT * FROM junction;












