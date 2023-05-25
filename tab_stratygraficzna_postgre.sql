CREATE DATABASE cw9_bazy_danych;

CREATE SCHEMA Tabela_stratygraficzna;


--Stworzenie tabel

CREATE TABLE Tabela_stratygraficzna.GeoEon(
id_eon INTEGER PRIMARY KEY,
nazwa_eon CHAR(10) NOT NULL
);

CREATE TABLE Tabela_stratygraficzna.GeoEra(
id_era INTEGER PRIMARY KEY,
id_eon INTEGER REFERENCES Tabela_stratygraficzna.GeoEon(id_eon),
nazwa_era VARCHAR(45) NOT NULL
);

CREATE TABLE Tabela_stratygraficzna.GeoOkres(
id_okres INTEGER PRIMARY KEY,
id_era INTEGER REFERENCES Tabela_stratygraficzna.GeoEra(id_era),
nazwa_okres VARCHAR(45) NOT NULL
);

CREATE TABLE Tabela_stratygraficzna.GeoEpoka(
id_epoka INTEGER NOT NULL PRIMARY KEY,
id_okres INTEGER REFERENCES Tabela_stratygraficzna.GeoOkres(id_okres),
nazwa_epoka VARCHAR(45) NOT NULL
);

CREATE TABLE Tabela_stratygraficzna.GeoPietro(
id_pietro INTEGER NOT NULL PRIMARY KEY,
id_epoka INTEGER REFERENCES Tabela_stratygraficzna.GeoEpoka(id_epoka),
nazwa_pietro VARCHAR(45) NOT NULL
);

-- Wypełnienie tabel

--eon(id_eon, nazwa)
INSERT INTO Tabela_stratygraficzna.GeoEon VALUES
(1, 'Fanerozoik');

--era(id_era, id_eon, nazwa)
INSERT INTO Tabela_stratygraficzna.GeoEra VALUES
(1, 1, 'Paleozoik'),
(2, 1, 'Mezozoik'),
(3, 1, 'Kenozoik');

--(id_okres, id_era, nazwa)
INSERT INTO Tabela_stratygraficzna.GeoOkres VALUES
(1, 1, 'Dewon'),
(2, 1, 'Karbon'),
(3, 1, 'Perm'),
(4, 2, 'Trias'),
(5, 2, 'Jura'),
(6, 2, 'Kreda'),
(7, 3, 'TrzeciorzadPaleogen'),
(8, 3, 'TrzeciorzadNeogen'),
(9, 3, 'Czwartorzad');

--(id_epoka, id_okres, nazwa)
INSERT INTO Tabela_stratygraficzna.GeoEpoka VALUES
(1, 1, 'Dolny'),
(2, 1, 'Srodkowy'),
(3, 1, 'Gorny'),
(4, 2, 'Dolny'),
(5, 2, 'Gorny'),
(6, 3, 'Dolny'),
(7, 3, 'Gorny'),
(8, 4, 'Dolna'),
(9, 4, 'Srodkowa'),
(10, 4, 'Gorna'),
(11, 5, 'Dolna'),
(12, 5, 'Srodkowa'),
(13, 5, 'Gorna'),
(14, 6, 'Dolna'),
(15, 6, 'Gorna'),
(16, 7, 'Paleocen'),
(17, 7, 'Eocen'),
(18, 7, 'Oligocen'),
(19, 8, 'Miocen'),
(20, 8, 'Pliocen'),
(21, 9, 'Plejstocen'),
(22, 9, 'Holocen');

--pietro(id_pietro, id_epoka, nazwa)
INSERT INTO Tabela_stratygraficzna.GeoPietro VALUES
(1, 1, 'Lachkow'),
(2, 1, 'Prag'),
(3, 1, 'Ems'),
(4, 2, 'Eifel'),
(5, 2, 'Zywet'),
(6, 3, 'Fran'),
(7, 3, 'Famen'),
(8, 4, 'Turnej'),
(9, 4, 'Wizen'),
(10, 4, 'Serpuchow'),
(11, 5, 'Baszkir'),
(12, 5, 'Moskow'),
(13, 5, 'Kasimow'),
(14, 5, 'Gzel'),
(15, 6, 'Assel'),
(16, 6, 'Sakmar'),
(17, 6, 'Artinsk'),
(18, 6, 'Kangur'),
(19, 7, 'Ufa'),
(20, 7, 'Kazan'),
(21, 7, 'Tatar'),
(22, 8, 'Ind'),
(23, 8, 'Olenek'),
(24, 9, 'Anizyk'),
(25, 9, 'Ladyn'),
(26, 10, 'Karnik'),
(27, 10, 'Noryk'),
(28, 10, 'Retyk'),
(29, 11, 'Hettang'),
(30, 11, 'Synemur'),
(31, 11, 'Pliensbach'),
(32, 11, 'Toark'),
(33, 12, 'Aalen'),
(34, 12, 'Bajos'),
(35, 12, 'Baton'),
(36, 12, 'Kelowej'),
(37, 13, 'Oksford'),
(38, 13, 'Kimeryd'),
(39, 13, 'Tyton'),
(40, 14, 'Berias'),
(41, 14, 'Walanzyn'),
(42, 14, 'Hoteryw'),
(43, 14, 'Barrem'),
(44, 14, 'Apt'),
(45, 14, 'Alb'),
(46, 15, 'Cenoman'),
(47, 15, 'Turon'),
(48, 15, 'Koniak'),
(49, 15, 'Santon'),
(50, 15, 'Kampan'),
(51, 15, 'Mastrycht'),
(52, 16, 'Dan'),
(53, 16, 'Zeland'),
(54, 16, 'Tanet'),
(55, 17, 'Iprez'),
(56, 17, 'Lutet'),
(57, 17, 'Barton'),
(58, 17, 'Priabon'),
(59, 18, 'Rupel'),
(60, 18, 'Szat'),
(61, 19, 'Akwitan'),
(62, 19, 'Burdygal'),
(63, 19, 'Lang'),
(64, 19, 'Serrawal'),
(65, 19, 'Torton'),
(66, 19, 'Mesyn'),
(67, 20, 'Zankl'),
(68, 20, 'Piacent'),
(69, 21, 'Gelas'),
(70, 21, 'Kalabr'),
(71, 21, 'Chiban'),
(72, 21, 'Tarant'),
(73, 22, 'Granland'),
(74, 22, 'Nortgryp'),
(75, 22, 'Megalaj');

SELECT 
pi.id_pietro AS ID_pietro,
pi.nazwa_pietro AS Nazwa_pietro,
ep.id_epoka AS ID_epoka,
ep.nazwa_epoka AS Nazwa_epoka,
o.id_okres AS ID_okres,
o.nazwa_okres AS Nazwa_okres,
er.id_era AS ID_era,
er.nazwa_era AS Nazwa_era,
eo.id_eon AS ID_eon,
eo.nazwa_eon AS Nazwa_eon
INTO
Tabela_stratygraficzna.GeoTabela
FROM
Tabela_stratygraficzna.GeoPietro pi
INNER JOIN 
Tabela_stratygraficzna.GeoEpoka ep ON pi.id_epoka=ep.id_epoka
INNER JOIN 
Tabela_stratygraficzna.GeoOkres o ON ep.id_okres=o.id_okres
INNER JOIN
Tabela_stratygraficzna.GeoEra er ON o.id_era=er.id_era
INNER JOIN
Tabela_stratygraficzna.GeoEon eo ON er.id_eon=eo.id_eon;

ALTER TABLE tabela_stratygraficzna.GeoTabela ADD PRIMARY KEY(ID_pietro);

--Tabela Milion

CREATE TABLE Tabela_stratygraficzna.Milion(
liczba INTEGER NOT NULL
);
--Recursive CTE
WITH RECURSIVE ID(number)
AS
(
--Non-recursive term
 SELECT 0 AS number
 UNION ALL
--Recursive term (połączone z non-recursive term operatorem union all;
--odwołuje się do samej nazwy CTE)
 SELECT number + 1 
 FROM ID
 WHERE number < 999999
)
INSERT INTO Tabela_stratygraficzna.Milion SELECT number FROM ID;


--Dodanie indeksow

CREATE INDEX id_eon ON Tabela_stratygraficzna.GeoEon(id_eon);
CREATE INDEX id_era ON Tabela_stratygraficzna.GeoEra(id_era);
CREATE INDEX id_epoka ON Tabela_stratygraficzna.GeoEpoka(id_epoka);
CREATE INDEX id_okres ON Tabela_stratygraficzna.GeoOkres(id_okres);
CREATE INDEX id_piet ON Tabela_stratygraficzna.GeoPietro(id_pietro);
CREATE INDEX id_pietro ON Tabela_stratygraficzna.GeoTabela(id_pietro);
CREATE INDEX liczba ON Tabela_stratygraficzna.Milion(liczba);


--Zapytanie 1

SELECT COUNT(*) AS ZL1
FROM Tabela_stratygraficzna.Milion
JOIN Tabela_stratygraficzna.GeoTabela ON (Tabela_stratygraficzna.Milion.liczba % 75) = GeoTabela.id_pietro;


--Zapytanie 2

SELECT COUNT(*) AS ZL2
FROM Tabela_stratygraficzna.Milion mi
INNER JOIN Tabela_stratygraficzna.GeoPietro pi ON (mi.liczba % 75) = pi.id_pietro
INNER JOIN Tabela_stratygraficzna.GeoEpoka ep ON ep.id_epoka = pi.id_epoka
INNER JOIN Tabela_stratygraficzna.GeoOkres o ON o.id_okres = ep.id_okres
INNER JOIN Tabela_stratygraficzna.GeoEra er ON er.id_era = o.id_era
INNER JOIN Tabela_stratygraficzna.GeoEon eo ON eo.id_eon = eo.id_eon;


--Zapytanie 3

SELECT COUNT(*) AS ZG3
FROM Tabela_stratygraficzna.Milion
WHERE (Tabela_stratygraficzna.Milion.liczba % 75) =
(SELECT id_pietro
FROM Tabela_stratygraficzna.GeoTabela
WHERE (Tabela_stratygraficzna.Milion.liczba % 75) = id_pietro);


--Zapytanie 4

SELECT COUNT(*) AS ZG4
FROM Tabela_stratygraficzna.Milion
WHERE (Tabela_stratygraficzna.Milion.liczba % 75) IN
(SELECT pi.id_pietro 
FROM Tabela_stratygraficzna.GeoPietro pi
INNER JOIN Tabela_stratygraficzna.GeoEpoka ep ON ep.id_epoka = pi.id_epoka
INNER JOIN Tabela_stratygraficzna.GeoOkres o ON o.id_okres = ep.id_okres
INNER JOIN Tabela_stratygraficzna.GeoEra er ON er.id_era = o.id_era
INNER JOIN Tabela_stratygraficzna.GeoEon eo ON eo.id_eon = er.id_eon);


