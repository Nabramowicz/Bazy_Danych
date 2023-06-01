USE AdventureWorks2022;
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

--1. Napisz zapytanie,kt�re wykorzystuje transakcj� (zaczyna j�), 
--a nast�pnie aktualizuje cen� produktu o ProductID r�wnym 680 w tabeli 
--Production.Product o 10% i nast�pnie zatwierdza transakcj�.

BEGIN TRANSACTION;
	UPDATE Production.Product
	SET ListPrice = ListPrice*1.1
	WHERE ProductID = 680; 
COMMIT;


SELECT ROUND(ListPrice, 2) AS UpdatedPrice
FROM Production.Product
WHERE ProductID = 680;


--2.Napisz zapytanie, kt�re zaczyna transakcj�, usuwa produkt o ProductID
--r�wnym 707 z tabeli Production.Product, ale nast�pnie wycofuje transakcj�.

BEGIN TRANSACTION;
	DELETE FROM Production.Product
	WHERE ProductID = 707
ROLLBACK;

SELECT * FROM Production.Product
WHERE ProductID = 707;

--3. Napisz zapytanie, kt�re zaczyna transakcj�, dodaje nowy produkt do tabeli
--Production.Product, a nast�pnie zatwierdza transakcj�.

BEGIN TRANSACTION;
	--dodanie nowego indeksu
	INSERT INTO Production.Product(rowguid)
	VALUES(NEWID());
	--dodanie produktu
	INSERT INTO Production.Product(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate) --niby b��d przy name ale sie dodaje :s
	VALUES('Nowyyy Produkt', 'NEWw-9999', 0, 0, 1000, 750, '0.00', '0.00', 1, '2023-05-30')
COMMIT;


SELECT * FROM Production.Product
ORDER BY ProductID DESC;

--4. Napisz zapytanie, kt�re zaczyna transakcj� i aktualizuje StandardCost wszystkich 
--produkt�w w tabeli Production.Product o 10%, je�eli suma wszystkich StandardCost
--po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie powinno wycofa� transakcj�.

BEGIN TRANSACTION;
	UPDATE Production.Product 
	SET StandardCost = StandardCost*1.1
	IF (SELECT SUM(StandardCost) FROM Production.Product) <= 50000
COMMIT
	ELSE 
	PRINT 'Transakcja odrzucona'
ROLLBACK;

--sprawdzam, czy transakcja powinna zosta� odrzucona - powinna by�
SELECT SUM(ROUND(StandardCost, 2)) FROM Production.Product

--5. Napisz zapytanie SQL, kt�re zaczyna transakcj� i pr�buje doda� nowy produkt do tabeli
--Production.Product. Je�li ProductNumber ju� istnieje w tabeli, zapytanie powinno
--wycofa� transakcj�.

BEGIN TRANSACTION
	INSERT INTO Production.Product(rowguid)
	VALUES(NEWID());
	INSERT INTO Production.Product(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate)
	VALUES('NajNajNowszyProdukt', 'NEWNEW-9999',  0, 0, 1000, 750, '0.00', '0.00', 1, '2023-05-30')
	IF EXISTS(SELECT COUNT(ProductNumber) FROM Production.Product GROUP BY ProductNumber HAVING COUNT(ProductNumber) > 1)
BEGIN
ROLLBACK
PRINT 'Transakcja odrzucona'
END
	ELSE
COMMIT;

SELECT * FROM Production.Product ORDER BY ProductID DESC;

--6. Napisz zapytanie SQL, kt�re zaczyna transakcj� i aktualizuje warto�� OrderQty
--dla ka�dego zam�wienia w tabeli Sales.SalesOrderDetail. Je�eli kt�rykolwiek z zam�wie�
--ma OrderQty r�wn� 0, zapytanie powinno wycofa� transakcj�.

BEGIN TRANSACTION;
	IF EXISTS(SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty=0)
BEGIN
ROLLBACK
PRINT 'Transakcja odrzucona'
END
	ELSE
BEGIN
	UPDATE Sales.SalesOrderDetail
	SET OrderQty = OrderQty+10
COMMIT
END;

--sprawdzam, czy transakcja powinna by� odrzucona - nie powinna by� 
SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty=0;


--6. Napisz zapytanie SQL, kt�re zaczyna transakcj� i usuwa wszystkie produkty, kt�rych
--StandardCost jest wy�szy ni� �redni koszt wszystkich produkt�w w tabeli Production.Product.
--Je�eli liczba produkt�w do usuni�cia przekracza 10, zapytanie powinno wycofa� transakcj�.


BEGIN TRANSACTION;
	IF (SELECT COUNT(StandardCost) FROM Production.Product WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)) > 10
BEGIN
ROLLBACK
PRINT 'Transakcja odrzucona'
END
	ELSE
BEGIN
	DELETE FROM Production.Product
	WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)
COMMIT
END;

--sprawdzam czy transakcja powinna by� odrzucona - powinna by�
SELECT COUNT(StandardCost) FROM Production.Product WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)



	
