USE [AdventureWorks2016]
GO

/****** Object:  View [Sales].[vTopTenSalespeople]    Script Date: 22/02/2021 10:02:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vTopTenSalespeople]
/**
Summary: >
  Provides a list of the top ten best-performing salespeople and their managers.
Author: sa
Date: 20/02/2021
Database: AdventureWorks2016
Examples:
   - SELECT vTopTenSalespeople.SalesValue,
       vTopTenSalespeople.SalesPerson,
       vTopTenSalespeople.manager FROM vTopTenSalespeople
     ORDER BY SalesValue DESC;
Returns: >
  nothing
**/
AS
  SELECT
    SalesValue,
    Coalesce(salesperson.Title + ' ', '') + salesperson.FirstName
    + Coalesce(' ' + salesperson.MiddleName, '') + ' ' + salesperson.LastName
    + Coalesce(' ' + salesperson.Suffix, '') AS SalesPerson,
    Coalesce(bossperson.Title + ' ', '') + bossperson.FirstName
    + Coalesce(' ' + bossperson.MiddleName, '') + ' ' + bossperson.LastName
    + Coalesce(' ' + bossperson.Suffix, '') + ' (' + boss.JobTitle + ')' AS manager
    FROM
      (SELECT TOP 10
           SalesPerson.BusinessEntityID AS salesPerson_ID,
           Sum(SalesOrderHeader.TotalDue) AS SalesValue
         FROM
         Sales.SalesPerson
         INNER JOIN Sales.SalesOrderHeader
           ON SalesPerson.BusinessEntityID = SalesOrderHeader.SalesPersonID
         INNER JOIN Person.Person
           ON SalesPerson.BusinessEntityID = Person.BusinessEntityID
         GROUP BY SalesPerson.BusinessEntityID
         ORDER BY Sum(SalesOrderHeader.TotalDue) DESC) AS SalesPerformance(SalesPerson_ID, SalesValue)
      INNER JOIN Person.Person AS salesperson
        ON SalesPerson_ID = salesperson.BusinessEntityID
      INNER JOIN HumanResources.Employee AS Employee
        ON Employee.BusinessEntityID = salesperson.BusinessEntityID
      INNER JOIN HumanResources.Employee AS boss
        ON boss.OrganizationNode = Employee.OrganizationNode.GetAncestor(1)
      INNER JOIN Person.Person AS bossperson
        ON bossperson.BusinessEntityID = boss.BusinessEntityID;
GO


