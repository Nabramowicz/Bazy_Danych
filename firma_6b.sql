SET language 'Polish';

--prze³¹czenie na bazê danych 'firma'
USE firma;

-- a) Zmodyfikuj numer telefonu w tabeli pracownicy, 
--    dodaj¹c do niego kierunkowy dla Polski w nawiasie (+48)

-- dodanie nowej kolumny 
ALTER TABLE ksiêgowoœæ.pracownicy ADD "telefon z (+48)" CHAR(14);

-- dodanie (+48)
UPDATE ksiêgowoœæ.pracownicy SET "telefon z (+48)" = CONCAT('(+48)', telefon);

-- sprawdzenie
SELECT * FROM ksiêgowoœæ.pracownicy;

-- b)  Zmodyfikuj atrybut telefonów tabeli pracownicy tak, 
--     aby numer oddzielony by³ myœlnikami wg wzoru: ‘555-222-333’ 

-- dodanie nowej kolumny
ALTER TABLE ksiêgowoœæ.pracownicy ADD "telefon z '-'" CHAR(11);

-- dodanie '-'
UPDATE ksiêgowoœæ.pracownicy
SET	"telefon z '-'" = CONCAT(SUBSTRING(telefon, 1, 3), '-', SUBSTRING(telefon, 3, 3), '-', SUBSTRING(telefon, 6, 3));

-- sprawdzenie
SELECT * FROM ksiêgowoœæ.pracownicy;

-- c) Wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze, u¿ywaj¹c du¿ych liter

SELECT TOP 1 
	id_pracownika, 
	UPPER(imie) AS imiê, 
	UPPER(nazwisko) AS nazwisko, 
	UPPER(adres) AS adres, 
	"telefon z '-'"
FROM ksiêgowoœæ.pracownicy 
ORDER BY LEN(nazwisko) DESC;

-- d) Wyœwietl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5

--md5 nie bêdzie dzia³aæ na type int i money, wiêc potrzeba jest konwersja na char (przy pomocy fkcji CAST)
SELECT
	HASHBYTES('MD5', CAST(pr.id_pracownika AS CHAR)) AS id_pracownika_md5,
	HASHBYTES('MD5', pr.imie) AS imie_md5,
	HASHBYTES('MD5', pr.nazwisko) AS nazwisko_md5,
	HASHBYTES('MD5', pr.adres) AS adres_md5,
	HASHBYTES('MD5', pr.telefon) AS telefon_md5,
	HASHBYTES('MD5', CAST(pen.kwota AS CHAR)) AS pensja_md5
FROM ksiêgowoœæ.pracownicy pr
INNER JOIN ksiêgowoœæ.wynagrodzenie w ON pr.id_pracownika = w.id_pracownika
INNER JOIN ksiêgowoœæ.pensja pen ON w.id_pensji = pen.id_pensji;

-- f) Wyœwietl pracowników, ich pensje oraz premie. Wykorzystaj z³¹czenie lewostronne

SELECT pr.[id_pracownika], imie, nazwisko, pen.[kwota] AS pensja, pre.[kwota] AS premia
FROM ksiêgowoœæ.pracownicy pr
LEFT OUTER JOIN ksiêgowoœæ.wynagrodzenie w ON pr.[id_pracownika] = w.[id_pracownika]
LEFT OUTER JOIN ksiêgowoœæ.pensja pen ON w.[id_pensji] = pen.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia pre ON w.[id_premii] = pre.[id_premii];

-- g) wygeneruj raport (zapytanie), które zwróci w wyniki treœæ wg poni¿szego szablonu:
--	Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma³ pensjê ca³kowit¹ na kwotê 7540 z³, 
--	gdzie wynagrodzenie zasadnicze wynosi³o: 5000 z³, premia: 2000 z³, nadgodziny: 540 z³

SELECT CONCAT('Pracownik ', pr.[imie], ' ', pr.[nazwisko], ', w dniu ', godz.[data],
	' otrzyma³ pensjê ca³kowit¹ na kwotê ', 
	pen.[kwota]+ISNULL(pre.[kwota], 0)+(CASE WHEN (liczba_godzin-160 <= 0) THEN 0 ELSE (liczba_godzin-160)*40 END),
	' z³, gdzie wynagrodzenie zasadnicze wynosi³o: ', pen.[kwota], ' z³, premia: ', ISNULL(pre.[kwota], 0),
	' z³, nadgodziny: ', (CASE WHEN (liczba_godzin-160 <= 0) THEN 0 ELSE (liczba_godzin-160)*40 END), ' z³') AS raport
FROM ksiêgowoœæ.pracownicy pr
LEFT OUTER JOIN ksiêgowoœæ.wynagrodzenie w ON pr.[id_pracownika] = w.[id_pracownika]
LEFT OUTER JOIN ksiêgowoœæ.pensja pen ON w.[id_pensji] = pen.[id_pensji]
LEFT OUTER JOIN ksiêgowoœæ.premia pre ON w.[id_premii] = pre.[id_premii]
LEFT OUTER JOIN ksiêgowoœæ.godziny godz ON pr.[id_pracownika] = godz.[id_pracownika];
