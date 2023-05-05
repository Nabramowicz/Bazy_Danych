SET language 'Polish';

--prze��czenie na baz� danych 'firma'
USE firma;

-- a) Zmodyfikuj numer telefonu w tabeli pracownicy, 
--    dodaj�c do niego kierunkowy dla Polski w nawiasie (+48)

-- dodanie nowej kolumny 
ALTER TABLE ksi�gowo��.pracownicy ADD "telefon z (+48)" CHAR(14);

-- dodanie (+48)
UPDATE ksi�gowo��.pracownicy SET "telefon z (+48)" = CONCAT('(+48)', telefon);

-- sprawdzenie
SELECT * FROM ksi�gowo��.pracownicy;

-- b)  Zmodyfikuj atrybut telefon�w tabeli pracownicy tak, 
--     aby numer oddzielony by� my�lnikami wg wzoru: �555-222-333� 

-- dodanie nowej kolumny
ALTER TABLE ksi�gowo��.pracownicy ADD "telefon z '-'" CHAR(11);

-- dodanie '-'
UPDATE ksi�gowo��.pracownicy
SET	"telefon z '-'" = CONCAT(SUBSTRING(telefon, 1, 3), '-', SUBSTRING(telefon, 3, 3), '-', SUBSTRING(telefon, 6, 3));

-- sprawdzenie
SELECT * FROM ksi�gowo��.pracownicy;

-- c) Wy�wietl dane pracownika, kt�rego nazwisko jest najd�u�sze, u�ywaj�c du�ych liter

SELECT TOP 1 
	id_pracownika, 
	UPPER(imie) AS imi�, 
	UPPER(nazwisko) AS nazwisko, 
	UPPER(adres) AS adres, 
	"telefon z '-'"
FROM ksi�gowo��.pracownicy 
ORDER BY LEN(nazwisko) DESC;

-- d) Wy�wietl dane pracownik�w i ich pensje zakodowane przy pomocy algorytmu md5

--md5 nie b�dzie dzia�a� na type int i money, wi�c potrzeba jest konwersja na char (przy pomocy fkcji CAST)
SELECT
	HASHBYTES('MD5', CAST(pr.id_pracownika AS CHAR)) AS id_pracownika_md5,
	HASHBYTES('MD5', pr.imie) AS imie_md5,
	HASHBYTES('MD5', pr.nazwisko) AS nazwisko_md5,
	HASHBYTES('MD5', pr.adres) AS adres_md5,
	HASHBYTES('MD5', pr.telefon) AS telefon_md5,
	HASHBYTES('MD5', CAST(pen.kwota AS CHAR)) AS pensja_md5
FROM ksi�gowo��.pracownicy pr
INNER JOIN ksi�gowo��.wynagrodzenie w ON pr.id_pracownika = w.id_pracownika
INNER JOIN ksi�gowo��.pensja pen ON w.id_pensji = pen.id_pensji;

-- f) Wy�wietl pracownik�w, ich pensje oraz premie. Wykorzystaj z��czenie lewostronne

SELECT pr.[id_pracownika], imie, nazwisko, pen.[kwota] AS pensja, pre.[kwota] AS premia
FROM ksi�gowo��.pracownicy pr
LEFT OUTER JOIN ksi�gowo��.wynagrodzenie w ON pr.[id_pracownika] = w.[id_pracownika]
LEFT OUTER JOIN ksi�gowo��.pensja pen ON w.[id_pensji] = pen.[id_pensji]
LEFT OUTER JOIN ksi�gowo��.premia pre ON w.[id_premii] = pre.[id_premii];

-- g) wygeneruj raport (zapytanie), kt�re zwr�ci w wyniki tre�� wg poni�szego szablonu:
--	Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma� pensj� ca�kowit� na kwot� 7540 z�, 
--	gdzie wynagrodzenie zasadnicze wynosi�o: 5000 z�, premia: 2000 z�, nadgodziny: 540 z�

SELECT CONCAT('Pracownik ', pr.[imie], ' ', pr.[nazwisko], ', w dniu ', godz.[data],
	' otrzyma� pensj� ca�kowit� na kwot� ', 
	pen.[kwota]+ISNULL(pre.[kwota], 0)+(CASE WHEN (liczba_godzin-160 <= 0) THEN 0 ELSE (liczba_godzin-160)*40 END),
	' z�, gdzie wynagrodzenie zasadnicze wynosi�o: ', pen.[kwota], ' z�, premia: ', ISNULL(pre.[kwota], 0),
	' z�, nadgodziny: ', (CASE WHEN (liczba_godzin-160 <= 0) THEN 0 ELSE (liczba_godzin-160)*40 END), ' z�') AS raport
FROM ksi�gowo��.pracownicy pr
LEFT OUTER JOIN ksi�gowo��.wynagrodzenie w ON pr.[id_pracownika] = w.[id_pracownika]
LEFT OUTER JOIN ksi�gowo��.pensja pen ON w.[id_pensji] = pen.[id_pensji]
LEFT OUTER JOIN ksi�gowo��.premia pre ON w.[id_premii] = pre.[id_premii]
LEFT OUTER JOIN ksi�gowo��.godziny godz ON pr.[id_pracownika] = godz.[id_pracownika];
