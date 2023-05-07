USE AdventureWorks2019;

-- 1.Wykorzystuj�c wyra�enie CTE zbuduj zapytanie, 
--	kt�re znajdzie informacje na temat stawki pracownika 
--	oraz jego danych, a nast�pnie zapisze je do tabeli tymczasowej 
--	TempEmployeeInfo. Rozwi�� w oparciu o AdventureWorks.

WITH TempEmployeeInfo(
      NationalIDNumber,
      LoginID,
      JobTitle,
      BirthDate,
      MaritalStatus,
      Gender,
      HireDate,
      SalariedFlag,
      VacationHours,
      SickLeaveHours,
      CurrentFlag,
	  Rate)
AS 
(
SELECT	NationalIDNumber,
		LoginID,
		JobTitle,
		BirthDate,
		MaritalStatus,
		Gender,
		HireDate,
		SalariedFlag,
		VacationHours,
		SickLeaveHours,
		CurrentFlag,
		Rate
FROM AdventureWorks2019.HumanResources.Employee e
INNER JOIN AdventureWorks2019.HumanResources.EmployeePayHistory eph 
ON e.BusinessEntityID = eph.BusinessEntityID
)

SELECT * FROM TempEmployeeInfo;


-- 2. Uzyskaj informacje na temat przychod�w ze sprzeda�y 
--	wed�ug firmy i kontaktu (za pomoc� CTE i bazy AdventureWorksL).

WITH RevenueInfo(
	CompanyContact,
	Revnue
)
AS 
(
SELECT 	CONCAT(CompanyName, ' (', FirstName, LastName, ')') AS CompanyContact,
		TotalDue AS Revenue
FROM AdventureWorksLT2019.SalesLT.Customer c
INNER JOIN AdventureWorksLT2019.SalesLT.SalesOrderHeader soh
ON c.CustomerID = soh.CustomerID
)

SELECT * FROM RevenueInfo
ORDER BY CompanyContact;

-- 3. Napisz zapytanie, kt�re zwr�ci warto�� sprzeda�y dla poszczeg�lnych 
--	kategorii produkt�w. Wykorzystaj CTE i baz� AdventureWorksLT.

WITH SalesByProdCat(
	Category,
	SalesValue
)
AS
(
SELECT pc."Name" AS Category,
		SUM(ROUND((UnitPrice-UnitPriceDiscount)*OrderQty, 2)) AS SalesValue
FROM AdventureWorksLT2019.SalesLT.Product p
INNER JOIN AdventureWorksLT2019.SalesLT.ProductCategory pc
ON p.ProductCategoryID = pc.ProductCategoryID
INNER JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail sod
ON p.ProductID = sod.ProductID	
GROUP BY pc."Name"
)

SELECT * FROM SalesByProdCat;