USE firma;

CREATE DATABASE firma;
CREATE SCHEMA rozliczenia;

/*
DROP TABLE rozliczenia.pensje;
DROP TABLE rozliczenia.premie;
DROP TABLE rozliczenia.godziny;
DROP TABLE rozliczenia.pracownicy;
*/

CREATE TABLE rozliczenia.pracownicy (
id_pracownika INT PRIMARY KEY,
imie VARCHAR(50) NOT NULL,
nazwisko VARCHAR(70) NOT NULL,
adres VARCHAR(100) NOT NULL,
telefon CHAR(9) NOT NULL UNIQUE
);

INSERT INTO rozliczenia.pracownicy(id_pracownika, nazwisko, imie, adres, telefon) VALUES
(1, 'Koj', 'Adam', 'al.Mickiewicza 15 31-867 Kraków', '000000000'),
(3, 'Koc', 'Ewa', 'ul.Maki 22/34 22-005 Warszawa', '444444444'),
(2, 'Maj', 'Stefan', 'ul.Zwierzyniecka 5 32-890 Bochnia', '555555555'),
(4, 'Kowalski', 'Mateusz', 'ul.Dobczycka 78/1 32-768 Wieliczka', '222222222'),
(5, 'Nowak', 'Katarzyna', 'ul.D¹browskiej 80 33-657 Niepo³omice', '777777777'),
(6, 'Adamczyk', 'Jan', 'ul.Prosta 65/45 30-059 Kraków', '666666666'),
(7, 'Kula', 'Weronika', 'ul.Magnoliowa 1b 35-890 Katowice', '111111111'),
(8, 'Las', 'Filip', 'ul.Zak¹tek 3/49 70-388 Lublin', '333333333'),
(9, 'Drabek', 'Natalia', 'ul.Krótka 56 31-098 Kraków', '888888888'),
(11, 'Maj', 'Wojciech', 'ul.D¹browskiej 3a 90-001 £ódŸ', '999999999');

CREATE TABLE rozliczenia.godziny (
id_godziny INT PRIMARY KEY,
"data" DATE,
liczba_godzin INT NOT NULL,
id_pracownika INT NOT NULL
);

CREATE TABLE rozliczenia.premie (
id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50),
kwota MONEY NOT NULL
);

CREATE TABLE rozliczenia.pensje (
id_pensji INT PRIMARY KEY,
stanowisko VARCHAR(100),
kwota MONEY NOT NULL,
id_premii INT NOT NULL
);

ALTER TABLE rozliczenia.godziny ADD FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy(id_pracownika);
ALTER TABLE rozliczenia.pensje ADD FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie(id_premii);


--SELECT * FROM rozliczenia.pracownicy;

INSERT INTO rozliczenia.godziny(id_godziny, "data", liczba_godzin, id_pracownika) VALUES
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

INSERT INTO rozliczenia.premie(id_premii, rodzaj, kwota) VALUES
(333, 'motywacyjna', 46),
(100, 'motywacyjna', 50),
(666, 'zadaniowa', 78),
(777, 'motywacyjna', 54),
(888, 'uznaniowa3', 88),
(999, 'zadaniowa', 76),
(222, 'regulaminowa', 77),
(444, 'zadaniowa', 93),
(555, 'uznaniowa', 91),
(111, 'uznaniowa', 160);

INSERT INTO rozliczenia.pensje(id_pensji, stanowisko, kwota, id_premii) VALUES
(343, 'asystent/ka', '3128.45', 666),
(532, 'manager/ka', '5609.57', 222),
(864, 'starszy/a specjalista/ka', '5110.11', 555),
(842, 'recepcjonista/ka', '3002.45', 888),
(927, 'dyrektor/ka', '7889.90', 999),
(564, 'asystent/ka', '3128.45', 111),
(721, 'm³odszy/a specjalista/ka', '4990.12', 444),
(555, 'm³odszy/a specjalista/ka', '4990.12', 333),
(799, 'starszy/a specjalista/ka', '5110.11', 777),
(234, 'asystent/ka', '3128.45', 100);


SELECT nazwisko, adres FROM rozliczenia.pracownicy;

SELECT CONCAT(DATEPART(dd, "data"),'.',DATEPART(mm, "data")) as "data" FROM rozliczenia.godziny; 
 
EXEC sp_rename 'rozliczenia.pensje.[kwota]', 'kwota_brutto', 'COLUMN'; 

ALTER TABLE rozliczenia.pensje ADD kwota_netto MONEY;

UPDATE rozliczenia.pensje SET kwota_netto = kwota_brutto-(kwota_brutto*0.12);