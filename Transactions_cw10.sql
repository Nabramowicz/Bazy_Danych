USE AdventureWorks2022;
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

--1. Napisz zapytanie,które wykorzystuje transakcjê (zaczyna j¹), 
--a nastêpnie aktualizuje cenê produktu o ProductID równym 680 w tabeli 
--Production.Product o 10% i nastêpnie zatwierdza transakcjê.

BEGIN TRANSACTION;
	UPDATE Production.Product
	SET ListPrice = ListPrice*1.1
	WHERE ProductID = 680; 
COMMIT;


SELECT ROUND(ListPrice, 2) AS UpdatedPrice
FROM Production.Product
WHERE ProductID = 680;


--2.Napisz zapytanie, które zaczyna transakcjê, usuwa produkt o ProductID
--równym 707 z tabeli Production.Product, ale nastêpnie wycofuje transakcjê.

BEGIN TRANSACTION;
	DELETE FROM Production.Product
	WHERE ProductID = 707
ROLLBACK;

SELECT * FROM Production.Product
WHERE ProductID = 707;

--3. Napisz zapytanie, które zaczyna transakcjê, dodaje nowy produkt do tabeli
--Production.Product, a nastêpnie zatwierdza transakcjê.

BEGIN TRANSACTION;
	--dodanie nowego indeksu
	INSERT INTO Production.Product(rowguid)
	VALUES(NEWID());
	--dodanie produktu
	INSERT INTO Production.Product(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate) --niby b³¹d przy name ale sie dodaje :s
	VALUES('Nowyyy Produkt', 'NEWw-9999', 0, 0, 1000, 750, '0.00', '0.00', 1, '2023-05-30')
COMMIT;


SELECT * FROM Production.Product
ORDER BY ProductID DESC;

--4. Napisz zapytanie, które zaczyna transakcjê i aktualizuje StandardCost wszystkich 
--produktów w tabeli Production.Product o 10%, je¿eli suma wszystkich StandardCost
--po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie powinno wycofaæ transakcjê.

BEGIN TRANSACTION;
	UPDATE Production.Product 
	SET StandardCost = StandardCost*1.1
	IF (SELECT SUM(StandardCost) FROM Production.Product) <= 50000
COMMIT
	ELSE 
	PRINT 'Transakcja odrzucona'
ROLLBACK;

--sprawdzam, czy transakcja powinna zostaæ odrzucona - powinna byæ
SELECT SUM(ROUND(StandardCost, 2)) FROM Production.Product

--5. Napisz zapytanie SQL, które zaczyna transakcjê i próbuje dodaæ nowy produkt do tabeli
--Production.Product. Jeœli ProductNumber ju¿ istnieje w tabeli, zapytanie powinno
--wycofaæ transakcjê.

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

--6. Napisz zapytanie SQL, które zaczyna transakcjê i aktualizuje wartoœæ OrderQty
--dla ka¿dego zamówienia w tabeli Sales.SalesOrderDetail. Je¿eli którykolwiek z zamówieñ
--ma OrderQty równ¹ 0, zapytanie powinno wycofaæ transakcjê.

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

--sprawdzam, czy transakcja powinna byæ odrzucona - nie powinna byæ 
SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty=0;


--6. Napisz zapytanie SQL, które zaczyna transakcjê i usuwa wszystkie produkty, których
--StandardCost jest wy¿szy ni¿ œredni koszt wszystkich produktów w tabeli Production.Product.
--Je¿eli liczba produktów do usuniêcia przekracza 10, zapytanie powinno wycofaæ transakcjê.


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

--sprawdzam czy transakcja powinna byæ odrzucona - powinna byæ
SELECT COUNT(StandardCost) FROM Production.Product WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)



	
