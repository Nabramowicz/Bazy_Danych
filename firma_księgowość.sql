-- Stworzenie bazy danych
CREATE DATABASE firma;
USE firma;

SET language 'Polish';

-- Stworzenie schematu 
CREATE SCHEMA ksiêgowoœæ;

-- Stworzenie tabel

CREATE TABLE ksiêgowoœæ.pracownicy (
id_pracownika INT PRIMARY KEY,
imie VARCHAR(50) NOT NULL,
nazwisko VARCHAR(70) NOT NULL,
adres VARCHAR(100),
telefon CHAR(15) UNIQUE
);

CREATE TABLE ksiêgowoœæ.godziny (
id_godziny INT PRIMARY KEY,
"data" DATE,
liczba_godzin INT NOT NULL,
id_pracownika INT NOT NULL
);

CREATE TABLE ksiêgowoœæ.premia (
id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50),
kwota MONEY NOT NULL
);

CREATE TABLE ksiêgowoœæ.pensja (
id_pensji INT PRIMARY KEY,
stanowisko VARCHAR(100),
kwota MONEY NOT NULL
);

CREATE TABLE ksiêgowoœæ.wynagrodzenie (
id_wynagrodzenia CHAR(4) PRIMARY KEY,
"data" DATE,
id_pracownika INT NOT NULL FOREIGN KEY REFERENCES ksiêgowoœæ.pracownicy(id_pracownika),
id_godziny INT NOT NULL FOREIGN KEY REFERENCES ksiêgowoœæ.godziny(id_godziny),
id_pensji INT NOT NULL FOREIGN KEY REFERENCES ksiêgowoœæ.pensja(id_pensji),
id_premii INT FOREIGN KEY REFERENCES ksiêgowoœæ.premia(id_premii)
);

-- Wype³nienie tabel 

INSERT INTO ksiêgowoœæ.pracownicy(id_pracownika, nazwisko, imie, adres, telefon) VALUES
(1, 'Koj', 'Adam', 'al.Mickiewicza 15 31-867 Kraków', '+48 000-000-000'),
(3, 'Koc', 'Ewa', 'ul.Maki 22/34 22-005 Warszawa', '+48 444-444-444'),
(2, 'Maj', 'Stefan', 'ul.Zwierzyniecka 5 32-890 Bochnia', '+48 555-555-555'),
(4, 'Kowalski', 'Mateusz', 'ul.Dobczycka 78/1 32-768 Wieliczka', '+48 222-222-222'),
(5, 'Nowak', 'Katarzyna', 'ul.D¹browskiej 80 33-657 Niepo³omice', '+48 777-777-777'),
(6, 'Adamczyk', 'Jan', 'ul.Prosta 65/45 30-059 Kraków', '+48 666-666-666'),
(7, 'Kula', 'Weronika', 'ul.Magnoliowa 1b 35-890 Katowice', '+48 111-111-111'),
(8, 'Las', 'Filip', 'ul.Zak¹tek 3/49 70-388 Lublin', '+48 333-333-333'),
(9, 'Drabek', 'Natalia', 'ul.Krótka 56 31-098 Kraków', '+48 888-888-888'),
(11, 'Maj', 'Wojciech', 'ul.D¹browskiej 3a 90-001 £ódŸ', '+48 999-999-999');

INSERT INTO ksiêgowoœæ.godziny(id_godziny, "data", liczba_godzin, id_pracownika) VALUES
(33, '2022.07.21', 120, 3),
(10, '2022.07.21', 120, 1),
(66, '2022.07.23', 136, 6),
(77, '2022.07.23', 136, 7),
(88, '2022.07.23', 136, 8),
(99, '2022.07.23', 136, 9),
(22, '2022.07.23', 136, 2),
(44, '2022.07.24', 144, 4),
(55, '2022.07.24', 144, 5),
(11, '2022.07.27', 168, 11);

INSERT INTO ksiêgowoœæ.premia(id_premii, rodzaj, kwota) VALUES
(333, 'motywacyjna', '46.03'),
(100, 'motywacyjna', '50.00'),
(666, 'zadaniowa', '78.06'),
(777, 'motywacyjna', '54.07'),
(888, 'uznaniowa', '88.08'),
(999, 'zadaniowa', '76.09'),
(222, 'regulaminowa', '77.02'),
(444, 'zadaniowa', '93.04'),
(555, 'uznaniowa', '91.05'),
(111, 'uznaniowa', '160.01');

INSERT INTO ksiêgowoœæ.pensja(id_pensji, stanowisko, kwota) VALUES
(343, 'asystent/ka', '3128.45'),
(532, 'manager/ka', '5609.57'),
(864, 'starszy/a specjalista/ka', '5110.11'),
(842, 'recepcjonista/ka', '3002.45'),
(927, 'dyrektor/ka', '7889.90'),
(564, 'asystent/ka', '3128.45'),
(721, 'm³odszy/a specjalista/ka', '4990.12'),
(555, 'm³odszy/a specjalista/ka', '4990.12'),
(799, 'starszy/a specjalista/ka', '5110.11'),
(234, 'asystent/ka', '3128.45');

INSERT INTO ksiêgowoœæ.wynagrodzenie VALUES 
('WM11', '2022-08-08', 11, 11, 343, NULL),
('ND09', '2022-08-09', 9, 99, 532, 100),
('FL08', '2022-08-08', 8, 88, 864, 666),
('WK07', '2022-08-10', 7, 77, 842, 777),
('JA06', '2022-08-09', 6, 66, 927, NULL),
('KN05', '2022-08-07', 5, 55, 564, 999),
('MK04', '2022-08-09', 4, 44, 721, 222),
('EK03', '2022-08-10', 3, 33, 555, 444),
('SM02', '2022-08-10', 2, 22, 799, 555),
('AK01', '2022-08-09', 1, 10, 234, 111);

-- Komentarze do tabel

EXEC sys.sp_addextendedproperty
@name = N'Opis tabeli "pracownicy"',
@value = N'Informacje o pracownikach',
@level0type = N'SCHEMA', @level0name = 'ksiêgowoœæ',
@level1type = N'TABLE', @level1name = 'pracownicy';
GO

EXEC sys.sp_addextendedproperty
@name = N'Opis tabeli "pensja"',
@value = N'Informacje o pensjach',
@level0type = N'SCHEMA', @level0name = 'ksiêgowoœæ',
@level1type = N'TABLE', @level1name = 'pensja';
GO

EXEC sys.sp_addextendedproperty
@name = N'Opis tabeli "godziny"',
@value = N'Informacje o godzinach pracy ka¿dego z pracowników',
@level0type = N'SCHEMA', @level0name = 'ksiêgowoœæ',
@level1type = N'TABLE', @level1name = 'godziny';
GO

EXEC sys.sp_addextendedproperty
@name = N'Opis tabeli "premia"',
@value = N'Informacje o premiach',
@level0type = N'SCHEMA', @level0name = 'ksiêgowoœæ',
@level1type = N'TABLE', @level1name = 'premia';
GO

EXEC sys.sp_addextendedproperty
@name = N'Opis tabeli "wynagrodzenie"',
@value = N'Informacje o wynagrodzeniach',
@level0type = N'SCHEMA', @level0name = 'ksiêgowoœæ',
@level1type = N'TABLE', @level1name = 'wynagrodzenie';
GO

-- Wyœwietlanie komentarzy do tabel

SELECT value AS Comment
FROM sys.extended_properties
WHERE major_id = 
OBJECT_ID('ksiêgowoœæ.pracownicy')
AND minor_id = 0
AND class = 1;


-- a) Wyœwietl tylko id pracownika oraz jego nazwisko

SELECT id_pracownika, nazwisko 
FROM ksiêgowoœæ.pracownicy;


-- b) Wyœwietl id pracowników, których p³aca jest wiêksza ni¿ 1000

SELECT id_pracownika
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
WHERE (pensja.[kwota]+ ISNULL(premia.[kwota], 0)) > 1000;


-- c) Wyœwietl id pracowników nieposiadaj¹cych premii, których p³aca jest wiêksza ni¿ 2000

SELECT id_pracownika
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
WHERE wynagrodzenie.[id_premii] IS NULL AND (pensja.[kwota]+ ISNULL(premia.[kwota], 0)) > 2000;

-- d) Wyœwietl pracowników, których pierwsza litera imienia zaczyna siê na literê 'J'

SELECT *
FROM ksiêgowoœæ.pracownicy
WHERE imie LIKE 'J%';

-- e) Wyœwietl pracowników, których nazwisko zawiera literê ‘n’ oraz imiê koñczy siê na literê ‘a’

SELECT *
FROM ksiêgowoœæ.pracownicy
WHERE nazwisko LIKE '%n%' OR nazwisko LIKE 'N%' AND imie LIKE '%a';

-- f) Wyœwietl imiê i nazwisko pracowników oraz liczbê ich nadgodzin, przyjmuj¹c, i¿ standardowy czas pracy to 160 h miesiêcznie

SELECT imie, nazwisko, godziny.[liczba_godzin]-160 as liczba_nadgodzin
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.godziny ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.godziny.[id_pracownika]
WHERE (liczba_godzin-160) > 0;

-- g) Wyœwietl imiê i nazwisko pracowników, których pensja zawiera siê w przedziale 1500 –3000PLN

SELECT imie, nazwisko
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
WHERE (pensja.[kwota]+ ISNULL(premia.[kwota], 0)) BETWEEN 1500 AND 3200;

-- h) Wyœwietl imiê i nazwisko pracowników, którzy pracowali w nadgodzinachi nie otrzymali premii

SELECT imie, nazwisko
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.godziny ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.godziny.[id_pracownika]
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.godziny.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
WHERE (liczba_godzin-160) > 0 AND wynagrodzenie.[id_premii] IS NULL;

-- i) Uszereguj pracowników wed³ug pensji

SELECT pracownicy.[id_pracownika], imie, nazwisko, kwota
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
ORDER BY pensja.[kwota];

-- j) Uszereguj pracowników wed³ug pensji i premii malej¹co

SELECT pracownicy.[id_pracownika], imie, nazwisko, pensja.[kwota] as pensja, premia.[kwota] as premia
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
ORDER BY pensja.[kwota] desc, premia.[kwota] desc; 

-- k) Zlicz i pogrupuj pracowników wed³ug pola ‘stanowisko'

SELECT pensja.stanowisko, count(pracownicy.id_pracownika) AS iloœæ_pracowników  
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
GROUP BY pensja.[stanowisko];

--l) Policz œredni¹, minimaln¹ i maksymaln¹ p³acê dla stanowiska ‘kierownik’ (je¿eli takiego nie masz, to przyjmij dowolne inne).

SELECT stanowisko, MIN(pensja.[kwota]+ISNULL(premia.[kwota],0)) AS "minimalna", MAX(pensja.[kwota]+ISNULL(premia.[kwota],0)) AS "maksymalna", AVG(pensja.[kwota]+ISNULL(premia.[kwota],0)) AS "œrednia"
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
WHERE stanowisko = 'asystent/ka'
GROUP BY stanowisko;

-- m) Policz sumê wszystkich wynagrodzeñ

SELECT (SUM(pensja.[kwota])) + SUM(ISNULL(premia.[kwota],0)) AS suma_wynagrodzeñ
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
;

-- n) Policz sumê wynagrodzeñ w ramach danego stanowiska

SELECT pensja.[stanowisko], (SUM(pensja.[kwota])) + SUM(ISNULL(premia.[kwota],0)) AS suma_wynagrodzeñ
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
GROUP BY pensja.stanowisko 
;

-- o) Wyznacz liczbê premii przyznanych dla pracowników danego stanowiska.

SELECT pensja.[stanowisko], COUNT(premia.id_premii) AS liczba_premii
FROM ksiêgowoœæ.wynagrodzenie
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia ON ksiêgowoœæ.wynagrodzenie.[id_premii] = ksiêgowoœæ.premia.[id_premii]
GROUP BY pensja.[stanowisko];

-- p) Usuñ wszystkich pracowników maj¹cych pensjê mniejsz¹ ni¿ 1200 z³.

EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
DELETE pracownicy
FROM ksiêgowoœæ.pracownicy
INNER JOIN ksiêgowoœæ.wynagrodzenie ON ksiêgowoœæ.pracownicy.[id_pracownika] = ksiêgowoœæ.wynagrodzenie.[id_pracownika]
INNER JOIN ksiêgowoœæ.pensja ON ksiêgowoœæ.wynagrodzenie.[id_pensji] = ksiêgowoœæ.pensja.[id_pensji]
	WHERE pensja.[kwota] < 1200;
GO

SELECT * FROM ksiêgowoœæ.pracownicy;
