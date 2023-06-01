USE AdventureWorks2022;
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

--1. Napisz zapytanie,które wykorzystuje transakcję (zaczyna ją), 
--a następnie aktualizuje cenę produktu o ProductID równym 680 w tabeli 
--Production.Product o 10% i następnie zatwierdza transakcję.

BEGIN TRANSACTION;
	UPDATE Production.Product
	SET ListPrice = ListPrice*1.1
	WHERE ProductID = 680; 
COMMIT;


SELECT ROUND(ListPrice, 2) AS UpdatedPrice
FROM Production.Product
WHERE ProductID = 680;


--2.Napisz zapytanie, które zaczyna transakcję, usuwa produkt o ProductID
--równym 707 z tabeli Production.Product, ale następnie wycofuje transakcję.

BEGIN TRANSACTION;
	DELETE FROM Production.Product
	WHERE ProductID = 707
ROLLBACK;

SELECT * FROM Production.Product
WHERE ProductID = 707;

--3. Napisz zapytanie, które zaczyna transakcję, dodaje nowy produkt do tabeli
--Production.Product, a następnie zatwierdza transakcję.

BEGIN TRANSACTION;
	--dodanie nowego indeksu
	INSERT INTO Production.Product(rowguid)
	VALUES(NEWID());
	--dodanie produktu
	INSERT INTO Production.Product(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate) --niby błąd przy name ale sie dodaje :s
	VALUES('Nowyyy Produkt', 'NEWw-9999', 0, 0, 1000, 750, '0.00', '0.00', 1, '2023-05-30')
COMMIT;


SELECT * FROM Production.Product
ORDER BY ProductID DESC;

--4. Napisz zapytanie, które zaczyna transakcję i aktualizuje StandardCost wszystkich 
--produktów w tabeli Production.Product o 10%, jeżeli suma wszystkich StandardCost
--po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;
	UPDATE Production.Product 
	SET StandardCost = StandardCost*1.1
	IF (SELECT SUM(StandardCost) FROM Production.Product) <= 50000
COMMIT
	ELSE 
	PRINT 'Transakcja odrzucona'
ROLLBACK;

--sprawdzam, czy transakcja powinna zostać odrzucona - powinna być
SELECT SUM(ROUND(StandardCost, 2)) FROM Production.Product

--5. Napisz zapytanie SQL, które zaczyna transakcję i próbuje dodać nowy produkt do tabeli
--Production.Product. Jeśli ProductNumber już istnieje w tabeli, zapytanie powinno
--wycofać transakcję.

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

--6. Napisz zapytanie SQL, które zaczyna transakcję i aktualizuje wartość OrderQty
--dla każdego zamówienia w tabeli Sales.SalesOrderDetail. Jeżeli którykolwiek z zamówień
--ma OrderQty równą 0, zapytanie powinno wycofać transakcję.

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

--sprawdzam, czy transakcja powinna być odrzucona - nie powinna być 
SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty=0;


--7. Napisz zapytanie SQL, które zaczyna transakcję i usuwa wszystkie produkty, których
--StandardCost jest wyższy niż średni koszt wszystkich produktów w tabeli Production.Product.
--Jeżeli liczba produktów do usunięcia przekracza 10, zapytanie powinno wycofać transakcję.


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

--sprawdzam czy transakcja powinna być odrzucona - powinna być
SELECT COUNT(StandardCost) FROM Production.Product WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)



	
