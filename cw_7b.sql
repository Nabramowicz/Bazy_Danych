USE AdventureWorks2019;

--1. Napisz procedur� wypisuj�c� do konsoli ci�g Fibonacciego. 
--Procedura musi przyjmowa� jako argument wej�ciowy liczb� n. 
--Generowanie ci�gu Fibonacciego musi zosta� zaimplementowane jako osobna funkcja,
--wywo�ywana przez procedur�.

-- v1. - funkcja zwraca tablice z fib, procedura ja wy�wietla (table-valued function) 

--funkcja
CREATE FUNCTION dbo.FibSeqTab(@num INT)
RETURNS @fib_tab TABLE("Fibonacci sequence" INT)
AS
BEGIN
	DECLARE  @n_2 INT, @n_1 INT, @n_0 INT, @i INT;
	SET @n_2=0;
	SET @n_1=1;
	SET @n_0=0;
	SET @i=1;
	IF (@num=0)
		INSERT INTO @fib_tab VALUES(NULL);
	IF (@num>=1)
		WHILE (@num>=@i)
		BEGIN
			INSERT INTO @fib_tab VALUES(@n_0);
			SET @n_2=@n_0;
			SET @n_0=@n_1+@n_0;
			SET @n_1=@n_2;
			SET @i+=1;
		END
RETURN
END;

SELECT * FROM FibSeqTab(15);

--procedura
CREATE PROC FibonacciPrintTab @n INT
AS
DECLARE @i INT;
SET @i=0;
BEGIN
	WHILE(@i=0)
	BEGIN
		SELECT * FROM FibSeqTab(@n);
		SET @i+=1;
	END;
END;

EXEC FibonacciPrintTab 45;

-- v2. funkcja oblicza i zwraca ciag fib 
-- a w procedurze wyrazy sa wypisywane w konsoli (scalar-valued function)

--funkcja
CREATE FUNCTION dbo.FibSeqNum(@num INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE  @n_2 INT, @n_1 INT, @n_0 INT, @i INT, @fibseq VARCHAR(MAX);
	SET @n_2=0;
	SET @n_1=1;
	SET @n_0=0;
	SET @i=1;
	IF (@num=0)
		SET @n_0=NULL; 
	IF (@num>=1)
		WHILE (@num>=@i)
		BEGIN
			SET @fibseq = CONCAT(@fibseq, @n_0, ', ');
			SET @n_2=@n_0;
			SET @n_0=@n_1+@n_0;
			SET @n_1=@n_2;
			SET @i+=1;
		END
RETURN @fibseq
END;

SELECT dbo.FibSeqNum(45) AS 'Fibonacci sequence'

--procedura
CREATE PROC FibonacciPrintNum @n INT
AS
BEGIN
	DECLARE @FibSeq VARCHAR(MAX);
	SET @FibSeq = dbo.FibSeqNum(@n)
	PRINT @FibSeq
END;

PRINT 'Fibonacci sequence'
EXEC FibonacciPrintNum @n=45;



--2. Napisz trigger DML, kt�ry po wprowadzeniu danych do tabeli Person
--zmodyfikuje nazwisko tak, aby by�o napisane du�ymi literami. 

CREATE TRIGGER NewPerson 
ON Person.Person
AFTER UPDATE 
AS
	UPDATE Person.Person
	SET LastName = UPPER(LastName)
	WHERE LastName IN (SELECT LastName FROM inserted);


--�eby doda� dane do Person trzeba najpierw uzupe�nic BusinessEntity o ID (jest ot FK dla Person)
INSERT INTO Person.BusinessEntity(rowguid)		--Id i ModifiedDate generuje automatycznie system; rowguid to wbudowana funkcja
VALUES(NEWID());		--generuje nowy rowguid

INSERT INTO AdventureWorks2019.Person.Person(BusinessEntityID, PersonType, NameStyle, FirstName, LastName, EmailPromotion)
VALUES(20778, 'IN', 0, 'Natalia', 'Abramowicz', 1);

SELECT * FROM Person.Person 
ORDER BY BusinessEntityID DESC;

--3. Przygotuj trigger �taxRateMonitoring�, kt�ry wy�wietli komunikat o b��dzie, 
--je�eli nast�pi zmiana warto�ci w polu �TaxRate�o wi�cej ni� 30%.

CREATE TRIGGER taxRateMonitoring
ON Sales.SalesTaxRate
AFTER UPDATE
AS
	DECLARE @TaxRate SMALLMONEY, @UpdatedTaxRate SMALLMONEY
	SELECT @TaxRate = TaxRate FROM deleted
	SELECT @UpdatedTaxRate = TaxRate FROM inserted
	IF @UpdatedTaxRate > @TaxRate*1.3
	THROW 50000, 'Error: An attempt to change the tax rate by more than 30%!', 1;	--THROW(error_num, message, state)

UPDATE Sales.SalesTaxRate 
SET TaxRate = TaxRate*1.3001;

SELECT * FROM Sales.SalesTaxRate;
