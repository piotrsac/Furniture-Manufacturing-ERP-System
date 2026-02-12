CREATE TYPE ORDERPRODUCTTYPE AS TABLE
(
    Product_Id INT NOT NULL,
    Quantity   INT NOT NULL
)
go

CREATE TABLE Categories
(
    Id   INT IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    CONSTRAINT Pk_Categories
        PRIMARY KEY (Id)
)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Categories TO Rola_Planista
go

GRANT SELECT ON Categories TO Rola_Sprzedaz
go

CREATE TABLE Clients
(
    Id          INT IDENTITY,
    Name        NVARCHAR(50) NOT NULL,
    Email       VARCHAR(320),
    Phonenumber VARCHAR(15)  NOT NULL,
    Nip         VARCHAR(10),
    Address     NVARCHAR(50) NOT NULL,
    Postalcode  VARCHAR(15),
    City        NVARCHAR(50) NOT NULL,
    Country     NVARCHAR(50) NOT NULL,
    Clienttype  CHAR         NOT NULL,
    CONSTRAINT Pk_Clients
        PRIMARY KEY (Id),
    CONSTRAINT Ck_Clients_Atleastonecontact
        CHECK ([Email] IS NOT NULL OR [PhoneNumber] IS NOT NULL),
    CONSTRAINT Ck_Clients_Clienttype
        CHECK ([ClientType] = 'I' OR [ClientType] = 'F'),
    CONSTRAINT Ck_Clients_Emailvalid
        CHECK (NOT [Email] LIKE '% %' AND (LEN([Email]) - LEN(REPLACE([Email], '@', ''))) = 1 AND
               PATINDEX('%_@_%._%', [Email]) > 0 AND LEN(RIGHT([Email], CHARINDEX('.', REVERSE([Email])) - 1)) >= 2)
)
go

CREATE INDEX Ix_Clients_Name
    ON Clients (Name)
go

CREATE INDEX Ix_Clients_Email
    ON Clients (Email)
go

CREATE INDEX Ix_Clients_Nip
    ON Clients (Nip)
    WHERE [NIP] IS NOT NULL
go

CREATE INDEX Ix_Clients_Clienttype
    ON Clients (Clienttype)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Clients TO Rola_Sprzedaz
go

CREATE TABLE Daysoff
(
    Id        INT IDENTITY,
    Startdate DATE          NOT NULL,
    Enddate   DATE          NOT NULL,
    Name      NVARCHAR(100) NOT NULL,
    CONSTRAINT Daysoff_Pk
        PRIMARY KEY (Id),
    CONSTRAINT Ck_Daysoff_Startdatebeforeenddate
        CHECK ([StartDate] <= [EndDate])
)
go

CREATE INDEX Ix_Daysoff_Daterange
    ON Daysoff (Startdate, Enddate)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Daysoff TO Rola_Planista
go

CREATE TABLE Parameters
(
    Id                INT DEFAULT 1 NOT NULL,
    Margin            DECIMAL(3, 2) NOT NULL,
    Discountstepvalue DECIMAL(3, 2),
    Discountthreshold DECIMAL(10, 2),
    Maxdiscount       DECIMAL(3, 2),
    CONSTRAINT Pk_Parameters
        PRIMARY KEY (Id),
    CONSTRAINT Ck_Parameters_Singleton
        CHECK ([ID] = 1),
    CONSTRAINT Ck_Parameters_Values
        CHECK ([Margin] >= 0 AND [DiscountStepValue] >= 0),
)
go

CREATE TABLE Parttypes
(
    Id   INT IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    CONSTRAINT Pk_Parttypes
        PRIMARY KEY (Id)
)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Parttypes TO Rola_Magazyn
go

CREATE TABLE Parts
(
    Id                 INT IDENTITY,
    Name               NVARCHAR(50)  NOT NULL,
    Parttype_Id        INT           NOT NULL,
    Price              DECIMAL(10, 2),
    Productioncapacity INT,
    Quantity           INT DEFAULT 0 NOT NULL,
    CONSTRAINT Pk_Parts
        PRIMARY KEY (Id),
    CONSTRAINT Fk_Parts_Parttypes
        FOREIGN KEY (Parttype_Id) REFERENCES Parttypes,
    CONSTRAINT Ck_Parts_Priveoverzero
        CHECK ([Price] > 0),
    CONSTRAINT Ck_Parts_Quantitynotnegative
        CHECK ([Quantity] >= 0),
)
go

CREATE INDEX Ix_Parts_Parttypeid
    ON Parts (Parttype_Id)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Parts TO Rola_Magazyn
go

CREATE TABLE Products
(
    Id               INT IDENTITY,
    Name             NVARCHAR(50)                 NOT NULL,
    Category_Id      INT                          NOT NULL,
    Quantity         INT DEFAULT 0                NOT NULL,
    Assemblycapacity INT
        CONSTRAINT Df_Products_Quantity DEFAULT 0 NOT NULL,
    Discontinued     BIT DEFAULT 0                NOT NULL,
    Productioncost   AS [dbo].[ObliczKosztProdukcji]([ID]),
    Price            AS [dbo].[ObliczCeneSprzedazy]([ID]),
    CONSTRAINT Pk_Products
        PRIMARY KEY (Id),
    CONSTRAINT Fk_Products_Categories
        FOREIGN KEY (Category_Id) REFERENCES Categories,
    CONSTRAINT Ck_Products_Assemblycapacitynotnegative
        CHECK ([AssemblyCapacity] >= 0),
    CONSTRAINT Ck_Products_Quantitynotnegative
        CHECK ([Quantity] >= 0), , ,
)
go

CREATE TABLE Productparts
(
    Product_Id INT NOT NULL,
    Part_Id    INT NOT NULL,
    Quantity   INT NOT NULL,
    CONSTRAINT Pk_Productparts
        PRIMARY KEY (Product_Id, Part_Id),
    CONSTRAINT Fk_Productparts_Parts
        FOREIGN KEY (Part_Id) REFERENCES Parts,
    CONSTRAINT Fk_Productparts_Products
        FOREIGN KEY (Product_Id) REFERENCES Products,
    CONSTRAINT Ck_Productparts_Quantitynotnegative
        CHECK ([Quantity] >= 0)
)
go

CREATE INDEX Ix_Productparts_Partid
    ON Productparts (Part_Id)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Productparts TO Rola_Planista
go

CREATE TABLE Productionplans
(
    Id             INT IDENTITY,
    Quantity       INT  NOT NULL,
    Enddate        DATE NOT NULL,
    Product_Id     INT  NOT NULL,
    Productiontype CHAR NOT NULL,
    Status_Id      INT,
    CONSTRAINT Pk_Productionplans
        PRIMARY KEY (Id),
    CONSTRAINT Products_Productionplans
        FOREIGN KEY (Product_Id) REFERENCES Products,
    CONSTRAINT Ck_Productionplans_Productiontype
        CHECK ([ProductionType] = 'O' OR [ProductionType] = 'C'),
    CONSTRAINT Ck_Productionplans_Quantitynotnegative
        CHECK ([Quantity] >= 0)
)
go

CREATE TABLE Productiondailylog
(
    Id                INT IDENTITY,
    Productionplan_Id INT                    NOT NULL,
    Dailylog          NVARCHAR(100)          NOT NULL,
    Date              DATE DEFAULT GETDATE() NOT NULL,
    Quantity          INT                    NOT NULL,
    Qualitystatus     CHAR                   NOT NULL,
    CONSTRAINT Productiondailylog_Pk
        PRIMARY KEY (Id),
    CONSTRAINT Productionplans_Productiondailylog
        FOREIGN KEY (Productionplan_Id) REFERENCES Productionplans,
    CONSTRAINT Ck_Productiondailylog_Qualitystatus
        CHECK ([QualityStatus] = 'F' OR [QualityStatus] = 'K'),
    CONSTRAINT Ck_Productiondailylog_Quantitynotnegative
        CHECK ([Quantity] >= 0),
)
go

CREATE INDEX Ix_Productiondailylog_Productionplanid
    ON Productiondailylog (Productionplan_Id)
go

CREATE INDEX Ix_Productiondailylog_Qualitystatus
    ON Productiondailylog (Qualitystatus)
go

CREATE INDEX Ix_Productiondailylog_Date
    ON Productiondailylog (Date)
go

CREATE INDEX Ix_Productiondailylog_Planid_Date
    ON Productiondailylog (Productionplan_Id, Date)
go

CREATE   TRIGGER trg_ProductionDailyLog_QualityCheck
    ON dbo.ProductionDailyLog
    AFTER INSERT
    AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Sprawdzamy, czy w ogóle jest błąd w tym wpisie
    -- Zakładamy, że w inserted jest tylko 1 wiersz naraz
    DECLARE @DailyLogID INT;

    SELECT @DailyLogID = ID
    FROM inserted
    WHERE QualityStatus = 'F' AND Quantity > 0;

    -- Jeśli nie znaleziono błędu, kończymy działanie
    IF @DailyLogID IS NULL
        RETURN;

    -- 2. Uruchamiamy procedurę naprawczą dla tego jednego ID
    SAVE TRANSACTION TrgSavePoint;

    BEGIN TRY
        EXEC dbo.sp_ProcessQualityFailure @DailyLogID = @DailyLogID;
    END TRY
    BEGIN CATCH
        -- Wycofujemy tylko logikę naprawczą w razie awarii procedury
        -- Sam wpis pracownika (INSERT) zostaje w bazie
        IF XACT_STATE() <> -1
            BEGIN
                ROLLBACK TRANSACTION TrgSavePoint;
            END
    END CATCH
END;
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Productiondailylog TO Rola_Magazyn
go

CREATE INDEX Ix_Productionplans_Productid
    ON Productionplans (Product_Id)
go

CREATE INDEX Ix_Productionplans_Statusid
    ON Productionplans (Status_Id)
go

CREATE INDEX Ix_Productionplans_Productiontype
    ON Productionplans (Productiontype)
go

CREATE INDEX Ix_Productionplans_Enddate
    ON Productionplans (Enddate)
go

CREATE INDEX Ix_Productionplans_Productid_Enddate
    ON Productionplans (Product_Id, Enddate)
go

CREATE INDEX Ix_Productionplans_Productiontype_Enddate
    ON Productionplans (Productiontype, Enddate)
go

-- 2. Tworzymy/Nadpisujemy ten NOWY (Twój kod)
CREATE   TRIGGER trg_ProductionPlans_ValidateStatus
    ON dbo.ProductionPlans
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    -- DEBUG: Żebyś widział w zakładce Output, że ten konkretny trigger działa
    -- (Jeśli to zobaczysz, a błędu nie będzie, to znaczy że warunki logiczne nie są spełnione)
    -- PRINT '>> Trigger ValidateStatus sprawdzany...';

    IF UPDATE(Status_ID)
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM inserted i
                         JOIN deleted d ON i.ID = d.ID
                WHERE i.Status_ID != d.Status_ID
                  AND (
                    -- Stary status: 2 (Done) lub 3 (Cancelled)
                    d.Status_ID IN (2, 3)
                    )
            )
                BEGIN
                    THROW 51000, N'BŁĄD: Statusy "Zakończony" (2) i "Anulowany" (3) są ostateczne!', 1;
                END
        END
END;
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Productionplans TO Rola_Planista
go

CREATE INDEX Ix_Products_Categoryid
    ON Products (Category_Id)
go

CREATE INDEX Ix_Products_Discontinued
    ON Products (Discontinued)
go

CREATE INDEX Ix_Products_Categoryid_Quantity
    ON Products (Category_Id, Quantity)
go

CREATE INDEX Ix_Products_Categoryid_Discontinued
    ON Products (Category_Id, Discontinued)
    WHERE [Discontinued] = 0
go

GRANT UPDATE (Quantity) ON Products TO Rola_Magazyn
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Products TO Rola_Planista
go

GRANT SELECT ON Products TO Rola_Sprzedaz
go

CREATE TABLE Status
(
    Id   INT IDENTITY,
    Name NVARCHAR(20) NOT NULL,
    CONSTRAINT Pk_Status
        PRIMARY KEY (Id)
)
go

CREATE TABLE Orders
(
    Id        INT IDENTITY,
    Client_Id INT  NOT NULL,
    Status_Id INT  NOT NULL,
    Orderdate DATE NOT NULL,
    Enddate   DATE NOT NULL,
    Discount  AS [dbo].[ObliczZnizke]([dbo].[PobierzWartoscKoszyka]([ID])),
    CONSTRAINT Pk_Orders
        PRIMARY KEY (Id),
    CONSTRAINT Fk_Orders_Clients
        FOREIGN KEY (Client_Id) REFERENCES Clients,
    CONSTRAINT Fk_Orders_Status
        FOREIGN KEY (Status_Id) REFERENCES Status,
    CONSTRAINT Ck_Orders_Enddateafterorderdate
        CHECK ([EndDate] >= [OrderDate])
)
go

CREATE TABLE Orderdetails
(
    Id         INT IDENTITY,
    Order_Id   INT            NOT NULL,
    Product_Id INT            NOT NULL,
    Quantity   INT            NOT NULL,
    Unitprice  DECIMAL(10, 2) NOT NULL,
    CONSTRAINT Pk_Orderdetails
        PRIMARY KEY (Id),
    CONSTRAINT Fk_Orderdetails_Orders
        FOREIGN KEY (Order_Id) REFERENCES Orders,
    CONSTRAINT Fk_Orderdetails_Products
        FOREIGN KEY (Product_Id) REFERENCES Products,
    CONSTRAINT Ck_Orderdetails_Quantitynotnegative
        CHECK ([Quantity] >= 0),
    CONSTRAINT Ck_Orderdetails_Unitpriceoverzero
        CHECK ([UnitPrice] > 0)
)
go

CREATE INDEX Ix_Orderdetails_Orderid
    ON Orderdetails (Order_Id)
go

CREATE INDEX Ix_Orderdetails_Productid
    ON Orderdetails (Product_Id)
go

CREATE INDEX Ix_Orderdetails_Orderid_Productid
    ON Orderdetails (Order_Id, Product_Id)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Orderdetails TO Rola_Sprzedaz
go

CREATE INDEX Ix_Orders_Clientid
    ON Orders (Client_Id)
go

CREATE INDEX Ix_Orders_Statusid
    ON Orders (Status_Id)
go

CREATE INDEX Ix_Orders_Orderdate
    ON Orders (Orderdate)
go

CREATE INDEX Ix_Orders_Enddate
    ON Orders (Enddate)
go

CREATE INDEX Ix_Orders_Clientid_Orderdate
    ON Orders (Client_Id, Orderdate)
go

CREATE INDEX Ix_Orders_Statusid_Orderdate
    ON Orders (Status_Id, Orderdate)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Orders TO Rola_Sprzedaz
go

CREATE TABLE Productionallocations
(
    Id                 INT IDENTITY,
    Productionplans_Id INT NOT NULL,
    Quantityallocated  INT NOT NULL,
    Orderdetails_Id    INT,
    CONSTRAINT Productionallocations_Pk
        PRIMARY KEY (Id),
    CONSTRAINT Fk_Productionallocations_Orderdetails
        FOREIGN KEY (Orderdetails_Id) REFERENCES Orderdetails,
    CONSTRAINT Productionallocations_Productionplans
        FOREIGN KEY (Productionplans_Id) REFERENCES Productionplans,
    CONSTRAINT Ck_Productionallocations_Quantityallocatednotnegative
        CHECK ([QuantityAllocated] >= 0)
)
go

CREATE INDEX Ix_Productionallocations_Productionplansid
    ON Productionallocations (Productionplans_Id)
go

CREATE INDEX Ix_Productionallocations_Orderdetailsid
    ON Productionallocations (Orderdetails_Id)
go

GRANT DELETE, INSERT, SELECT, UPDATE ON Productionallocations TO Rola_Planista
go

GRANT SELECT ON Status TO Rola_Sprzedaz
go

CREATE   VIEW vw_BestSellingProducts
AS
SELECT TOP 3
    p.ID AS ProductID,
    p.Name AS ProductName,
    c.Name AS CategoryName,
    SUM(od.Quantity) AS TotalSoldQuantity
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.ID
JOIN Products p ON od.Product_ID = p.ID
JOIN Categories c ON p.Category_ID = c.ID
GROUP BY p.ID, p.Name, c.Name
ORDER BY TotalSoldQuantity DESC;
go

CREATE   VIEW vw_ClientOrdersHistory
AS
SELECT
    o.ID AS OrderID,
    o.OrderDate,
    o.EndDate,
    c.ID AS ClientID,
    c.Name AS ClientName,
    p.Name AS ProductName,
    od.Quantity,
    od.UnitPrice,
    o.Discount,
    (od.Quantity * od.UnitPrice) * (1 - o.Discount) AS FinalValue,
    status.name as status
FROM Orders o
JOIN Clients c ON c.ID = o.Client_ID
JOIN OrderDetails od ON od.Order_ID = o.ID
JOIN Products p ON p.ID = od.Product_ID
Join status on status.id=o.status_id;
go

CREATE VIEW vw_CurrentStock
AS
SELECT
    p.ID,
    p.Name,
    c.Name AS CategoryName,
    p.Quantity AS CurrentStock,
    p.Price,
    p.Discontinued
FROM Products p
JOIN Categories c ON c.ID = p.Category_ID;
go

CREATE   VIEW vw_InventoryStatus
AS
SELECT
    p.ID AS PartID,
    p.Name AS PartName,
    pt.Name AS PartType,
    p.Quantity AS CurrentStock,
    p.Price
FROM Parts p
JOIN PartTypes pt ON p.PartType_ID = pt.ID
go

CREATE VIEW vw_Management_ProductionCosts
AS
SELECT
    Year,
    Month,
    CategoryName,
    ProductName,
    SUM(TotalProductionCost) AS ProductionCost
FROM vw_ProductionCost_Base
GROUP BY Year, Month, CategoryName, ProductName;
go

CREATE   VIEW vw_OrdersSummary AS
WITH CartValue AS (
    -- KROK 1: Używamy funkcji pomocniczej (zamiast GROUP BY)
    SELECT
        ID AS Order_ID,
        dbo.PobierzWartoscKoszyka(ID) AS SumValue
    FROM Orders
),
     DiscountPercent AS (
         -- KROK 2: Wyliczamy procent rabatu funkcją
         SELECT
             o.ID AS OrderID,
             o.Client_ID,
             o.OrderDate,
             -- Pobieramy wartość z poprzedniego kroku
             ISNULL(cv.SumValue, 0.00) AS Base,
             dbo.ObliczZnizke(ISNULL(cv.SumValue, 0.00)) AS Discount
         FROM Orders o
                  JOIN CartValue cv ON o.ID = cv.Order_ID
     )
-- KROK 3: Ostateczne wyświetlenie
SELECT
    OrderID,
    Client_ID,
    OrderDate,
    CAST(Base AS DECIMAL(18,2)) AS BaseValue,

    Discount AS DiscountPercent,

    CAST(Base * Discount AS DECIMAL(18,2)) AS DiscountValue,

    CAST(Base * (1.00 - Discount) AS DECIMAL(18,2)) AS FinalValue
FROM DiscountPercent
go

CREATE VIEW vw_PlannedProduction
AS
SELECT
    pp.ID AS ProductionPlanID,
    p.Name AS ProductName,
    pp.Quantity,
    pp.EndDate,
    s.Name AS Status,
    pp.ProductionType
FROM ProductionPlans pp
JOIN Products p ON p.ID = pp.Product_ID
JOIN Status s ON s.ID = pp.Status_ID;
go

CREATE VIEW vw_ProductionCost_Annually
AS
SELECT
    Year,
    CategoryName,
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    AVG(UnitProductionCost) AS AvgUnitCost,
    SUM(TotalProductionCost) AS TotalCost
FROM vw_ProductionCost_Base
GROUP BY Year, CategoryName, ProductName;
go

CREATE VIEW vw_ProductionCost_Base
AS
SELECT
    pp.Product_ID,
    p.Name AS ProductName,
    c.Name AS CategoryName,
    pp.EndDate,
    YEAR(pp.EndDate) AS Year,
    MONTH(pp.EndDate) AS Month,
    DATEPART(QUARTER, pp.EndDate) AS Quarter,
    pp.Quantity,
    dbo.ObliczKosztProdukcji(pp.Product_ID) AS UnitProductionCost,
    pp.Quantity * dbo.ObliczKosztProdukcji(pp.Product_ID) AS TotalProductionCost
FROM ProductionPlans pp
JOIN Products p ON p.ID = pp.Product_ID
JOIN Categories c ON c.ID = p.Category_ID;
go

CREATE VIEW vw_ProductionCost_Monthly
AS
SELECT
    Year,
    Month,
    CategoryName,
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    AVG(UnitProductionCost) AS AvgUnitCost,
    SUM(TotalProductionCost) AS TotalCost
FROM vw_ProductionCost_Base
GROUP BY Year, Month, CategoryName, ProductName;
go

 CREATE VIEW vw_ProductionCost_Quarterly
AS
SELECT
    Year,
    QUARTER,
    CategoryName,
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    AVG(UnitProductionCost) AS AvgUnitCost,
    SUM(TotalProductionCost) AS TotalCost
FROM vw_ProductionCost_Base
GROUP BY Year, QUARTER, CategoryName, ProductName;
go

CREATE VIEW vw_ProductionPlan_Report
AS
SELECT
    p.Name AS ProductName,
    c.Name AS CategoryName,
    pp.Quantity,
    pp.EndDate,
    YEAR(pp.EndDate) AS Year,
    MONTH(pp.EndDate) AS Month,
    DATEPART(QUARTER, pp.EndDate) AS Quarter,
    s.Name AS Status,
    pp.ProductionType
FROM ProductionPlans pp
JOIN Products p ON p.ID = pp.Product_ID
JOIN Categories c ON c.ID = p.Category_ID
JOIN Status s ON s.ID = pp.Status_ID;
go

CREATE VIEW vw_Sales_Report
AS
SELECT
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    DATEPART(WEEK, o.OrderDate) AS Week,
    c.Name AS CategoryName,
    p.Name AS ProductName,
    SUM(od.Quantity) AS SoldQuantity,
    SUM(od.Quantity * od.UnitPrice * (1 - o.Discount)) AS Revenue
FROM Orders o
JOIN OrderDetails od ON od.Order_ID = o.ID
JOIN Products p ON p.ID = od.Product_ID
JOIN Categories c ON c.ID = p.Category_ID
GROUP BY
    YEAR(o.OrderDate),
    MONTH(o.OrderDate),
    DATEPART(WEEK, o.OrderDate),
    c.Name,
    p.Name;
go

CREATE PROCEDURE dbo.AddCategory
    @Name nvarchar(50)
AS
    INSERT INTO dbo.Categories (Name)
    VALUES (@Name);
go

CREATE PROCEDURE dbo.AddClient
    @Name        nvarchar(50),
    @PhoneNumber varchar(15),
    @Address     nvarchar(50),
    @City        nvarchar(50),
    @Country     nvarchar(50),
    @Email       varchar(320) = NULL,
    @NIP         varchar(10)  = NULL,
    @PostalCode  varchar(15)  = NULL
AS
    INSERT INTO dbo.Clients (
        Name, Email, PhoneNumber, NIP, 
        Address, PostalCode, City, Country, ClientType
    )
    VALUES (
        @Name, 
        @Email, 
        @PhoneNumber, 
        @NIP,
        @Address, 
        @PostalCode, 
        @City, 
        @Country, 
        CASE
            WHEN @NIP IS NOT NULL AND LEN(@NIP) > 0 THEN 'F'--jesli klient podal nip to jest to firma
            ELSE 'I'--jesli nie to klient indywidualny
        END
    );
go

CREATE PROCEDURE dbo.AddDayOff
    @Name      NVARCHAR(100),
    @StartDate DATE,
    @EndDate   DATE = NULL
AS
BEGIN
    INSERT INTO dbo.DaysOff (StartDate, EndDate, Name)
    VALUES (@StartDate, ISNULL(@EndDate, @StartDate), @Name);
END
go

CREATE     PROCEDURE dbo.AddOrder
(
    @ClientName NVARCHAR(50),
    @Email VARCHAR(320) = NULL,
    @PhoneNumber VARCHAR(15) = NULL,
    @NIP VARCHAR(10) = NULL,
    @Address NVARCHAR(50) = NULL,
    @PostalCode NVARCHAR(50) = NULL,
    @City NVARCHAR(50) = NULL,
    @Country NVARCHAR(50) = NULL,
    @OrderDate DATE,
    @Products dbo.OrderProductType READONLY-- koszyk zdefiniowany przez klienta
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

    --0. WALIDACJA (sprawdzenie ewentualnych pomyłek użytkownika)
        IF NOT EXISTS (SELECT 1 FROM @Products)
        BEGIN
            THROW 50004, N'Koszyk jest pusty. Dodaj produkty przed złożeniem zamówienia.',
            1;
        END

        DECLARE 
            @BadProductID INT,
            @BadReason NVARCHAR(50);

        SELECT TOP 1
            @BadProductID = op.Product_ID,
            @BadReason =
                CASE
                    WHEN p.ID IS NULL THEN 'NOT_EXISTS'
                    WHEN p.Discontinued = 1 THEN 'DISCONTINUED'
                END
        FROM @Products op
        LEFT JOIN Products p ON p.ID = op.Product_ID
        WHERE p.ID IS NULL
        OR p.Discontinued = 1;
        IF @BadProductID IS NOT NULL
        BEGIN
            IF @BadReason = 'NOT_EXISTS'
                RAISERROR (
                    'Produkt o ID = %d nie istnieje.',
                    16,
                    1,
                    @BadProductID
                );
            ELSE
                RAISERROR (
                    'Produkt o ID = %d jest wycofany z oferty.',
                    16,
                    1,
                    @BadProductID
                );

        END


        BEGIN TRAN;

        DECLARE @ClientID INT;
        DECLARE @OrderID INT;
        DECLARE @TotalAmount DECIMAL(10,2);


        -- 1. Sprawdzenie, czy klient istnieje
        -- klient identyfikowany po nazwie i emailu
        SELECT @ClientID = ID
        FROM Clients
        WHERE Name = @ClientName
          AND (Email = @Email OR @Email IS NULL);

        IF @ClientID IS NULL--nie ma klienta u nas w bazie - trzeba dodac
        BEGIN
            INSERT INTO Clients
            (
                Name, Email, PhoneNumber, NIP,
                Address, PostalCode, City, Country, ClientType
            )
            VALUES
            (
                @ClientName,
                @Email,
                @PhoneNumber,
                @NIP,
                @Address,
                @PostalCode,
                @City,
                @Country,
                IIF(@Nip IS NOT NULL AND LEN(@Nip) > 0, 'F', 'I')
            );

            SET @ClientID = SCOPE_IDENTITY();--zwraca ostatnią wartość kolumny IDENTITY wygenerowana wczesniej
        END

        -- 2. Obliczenie wartości zamówienia (bez rabatu) na podstawie koszyka
        SELECT @TotalAmount = SUM(p.Price * op.Quantity)
        FROM @Products op
        JOIN Products p ON p.ID = op.Product_ID;

        -- 3. Wstawienie zamówienia
        -- Discount NIE JEST ustawiany (kolumna obliczana)
        INSERT INTO Orders (Client_ID, OrderDate, EndDate, Status_ID)
        VALUES (@ClientID, @OrderDate, @OrderDate, 1); -- 1 = During Production

        SET @OrderID = SCOPE_IDENTITY();

        -- 4. Wstawienie pozycji zamówienia
        INSERT INTO OrderDetails (Order_ID, Product_ID, Quantity, UnitPrice)
        SELECT
            @OrderID,--wszytsko idzie do tego samego zamowienia
            p.ID,
            op.Quantity,
            p.Price
        FROM @Products op
        JOIN Products p ON p.ID = op.Product_ID;

        -- 5. Obsługa magazynu i planowanie produkcji
        DECLARE
            @ProductID INT,
            @Qty INT,
            @Stock INT,
            @Remaining INT,
            @AssemblyCapacity INT,--ile sztuk mozna dziennie zlozyc
            @DaysProduction INT,
            @PlanID INT;

        DECLARE ProductCursor CURSOR FOR--cursor umozliwia iterowanie po wszystkich wierszach tabeli
            SELECT Product_ID, Quantity FROM @Products;

        OPEN ProductCursor;
        FETCH NEXT FROM ProductCursor INTO @ProductID, @Qty;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT
                @Stock = Quantity,
                @AssemblyCapacity = AssemblyCapacity
            FROM Products
            WHERE ID = @ProductID;

            -- jeśli magazyn wystarcza
            IF @Stock >= @Qty
            BEGIN
                UPDATE Products
                SET Quantity = Quantity - @Qty
                WHERE ID = @ProductID;

                UPDATE Orders
                SET EndDate = dbo.CalculateEndDate(@OrderDate, 1)--zakladamy ze czas realizacji to min 1 dzien
                WHERE ID = @OrderID;
            END
            ELSE
            BEGIN
                -- ile trzeba wyprodukować
                SET @Remaining = @Qty - ISNULL(@Stock, 0);

                -- zużycie magazynu
                IF @Stock > 0
                BEGIN
                    UPDATE Products
                    SET Quantity = 0
                    WHERE ID = @ProductID;
                END

                -- zabezpieczenie wydajności
                IF @AssemblyCapacity IS NULL OR @AssemblyCapacity = 0
                    SET @AssemblyCapacity = 1;

                -- ilość dni produkcji
                SET @DaysProduction =
                    CEILING(CAST(@Remaining AS FLOAT) / @AssemblyCapacity);

                -- plan produkcji
                INSERT INTO ProductionPlans
                (
                    Quantity,
                    EndDate,
                    Status_ID,
                    Product_ID,
                    ProductionType
                )
                VALUES
                (
                    @Remaining,
                    dbo.CalculateEndDate(@OrderDate, @DaysProduction),
                    1,      -- During Production
                    @ProductID,
                    'O'     -- produkcja pod zamówienie
                );

                SET @PlanID = SCOPE_IDENTITY();

                -- alokacja produkcji do zamówienia
                INSERT INTO ProductionAllocations
                (
                    ProductionPlans_ID,
                    QuantityAllocated,
                    OrderDetails_ID
                )
                SELECT
                    @PlanID,
                    @Remaining,
                    ID
                FROM OrderDetails
                WHERE Order_ID = @OrderID
                  AND Product_ID = @ProductID;

                -- EndDate zamówienia = max z planów produkcji
                UPDATE Orders
                SET EndDate =
                (
                    SELECT MAX(pp.EndDate)
                    FROM ProductionPlans pp
                    JOIN ProductionAllocations pa
                        ON pp.ID = pa.ProductionPlans_ID
                    WHERE pa.OrderDetails_ID IN
                        (SELECT ID FROM OrderDetails WHERE Order_ID = @OrderID)
                )
                WHERE ID = @OrderID;
            END

            FETCH NEXT FROM ProductCursor INTO @ProductID, @Qty;
        END

        CLOSE ProductCursor;
        DEALLOCATE ProductCursor;

        COMMIT TRAN;

        -- 6. Zwrócenie ID zamówienia i wartości po rabacie
        -- rabat liczony automatycznie przez kolumnę Discount
        SELECT
            o.ID AS Order_ID,
            SUM(od.Quantity * od.UnitPrice) * (1 - o.Discount) AS TotalAfterDiscount
        FROM Orders o
        JOIN OrderDetails od ON od.Order_ID = o.ID
        WHERE o.ID = @OrderID
        GROUP BY o.ID, o.Discount;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0--jesli transakcja dalej otwarta mimo ze powinna sie zakonczyc
            ROLLBACK TRAN;

        THROW;
    END CATCH
END
go

CREATE PROCEDURE dbo.AddProduct
    @Name             nvarchar(50),
    @CategoryID       int,
    @AssemblyCapacity int = 0,
    @Quantity         int = 0
AS
    INSERT INTO dbo.Products (Name, Category_ID, AssemblyCapacity, Quantity)
    VALUES (@Name, @CategoryID, @AssemblyCapacity, @Quantity);
go

CREATE PROCEDURE dbo.AddProductPart
    @ProductID int,
    @PartID    int,
    @Quantity  int
AS
    INSERT INTO dbo.ProductParts (Product_ID, Part_ID, Quantity)
    VALUES (@ProductID, @PartID, @Quantity);
go

CREATE   FUNCTION dbo.CalculateEndDate
(
    @StartDate DATE,
    @ProductionDays INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @CurrentDate DATE = @StartDate;
    DECLARE @DaysCounted INT = 0;

    WHILE @DaysCounted < @ProductionDays
    BEGIN
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

        -- sprawdzenie czy dzień jest wolny
        IF NOT EXISTS (
            SELECT 1
            FROM DaysOff
            WHERE @CurrentDate BETWEEN StartDate AND EndDate
        )
        BEGIN
            -- liczymy tylko dni robocze
            SET @DaysCounted = @DaysCounted + 1;
        END
    END

    RETURN @CurrentDate;
END
go

CREATE PROCEDURE dbo.CreateDailyLog
    @ProductionPlanID int,
    @DailyLog         nvarchar(100),
    @Quantity         int,
    @QualityStatus    char(1)
AS
    INSERT INTO dbo.ProductionDailyLog (ProductionPlan_ID, DailyLog, Quantity, QualityStatus)
    VALUES (@ProductionPlanID, @DailyLog, @Quantity, @QualityStatus);
go

CREATE PROCEDURE dbo.DiscontinueProduct
    @ProductID int
AS
    UPDATE dbo.Products
    SET Discontinued = 1
    WHERE ID = @ProductID;
go

CREATE   FUNCTION dbo.ObliczCeneSprzedazy (@ProductId INT)
    RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @KosztBazowy DECIMAL(10,2);
    DECLARE @Mnoznik DECIMAL(10,2);

    -- 1. Pobieramy czysty koszt z pierwszej funkcji
    SET @KosztBazowy = dbo.ObliczKosztProdukcji(@ProductId);

    -- 2. Pobieramy marżę z tabeli Parameters (np. 1.50)
    SELECT TOP 1 @Mnoznik = Margin FROM Parameters;

    -- Zabezpieczenie: Jeśli tabela pusta, użyj 1.5 na sztywno
    SET @Mnoznik = ISNULL(@Mnoznik, 1.50);

    -- 3. Zwracamy wynik mnożenia
    RETURN @KosztBazowy * @Mnoznik;
END
go

CREATE FUNCTION dbo.ObliczKosztProdukcji (@ProductId INT)
    RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Koszt DECIMAL(10,2);

    -- Sumujemy (Cena Części * Ilość Części w Produkcie)
    SELECT @Koszt = SUM(p.Price * pp.Quantity)
    FROM Parts p
             JOIN ProductParts pp ON p.ID = pp.Part_ID
    WHERE pp.Product_ID = @ProductId;

    -- Zwracamy 0 jeśli brak części, w przeciwnym razie wyliczoną sumę
    RETURN ISNULL(@Koszt, 0);
END
go

GRANT EXECUTE ON Obliczkosztprodukcji TO Rola_Planista
go

CREATE   FUNCTION dbo.ObliczZnizke (@WartoscZamowienia DECIMAL(18, 2))
    RETURNS DECIMAL(4, 2)
AS
BEGIN
    -- Zmienne zadeklarowane jako DECIMAL zamiast MONEY
    DECLARE @Prog DECIMAL(18, 2);
    DECLARE @SkokProcent DECIMAL(4, 2);
    DECLARE @MaxProcent DECIMAL(4, 2);
    DECLARE @KwotaSkoku DECIMAL(18, 2) = 100.00;
    DECLARE @WyliczonaZnizka DECIMAL(4, 2);

    -- 1. Pobieramy ustawienia z tabeli Parameters
    SELECT TOP 1
        @Prog = DiscountThreshold,
        @SkokProcent = DiscountStepValue,
        @MaxProcent = MaxDiscount
    FROM Parameters;

    -- Zabezpieczenia (gdyby tabela była pusta)
    SET @Prog = ISNULL(@Prog, 999999.00);
    SET @MaxProcent = ISNULL(@MaxProcent, 0.00);

    -- 2. Jeśli kwota <= 2500, brak zniżki
    IF @WartoscZamowienia <= @Prog
        RETURN 0.00;

    -- 3. Obliczenia
    -- Nadwyżka np. 2501 - 2500 = 1.00
    DECLARE @Nadwyzka DECIMAL(18, 2) = @WartoscZamowienia - @Prog;

    -- Używamy CEILING (Sufit), który zaokrągla w górę.
    -- 0.01 zamieni na 1. 100.00 zamieni na 1. 100.01 zamieni na 2.
    DECLARE @IloscKrokow INT = CAST(CEILING(@Nadwyzka / @KwotaSkoku) AS INT)

    -- Wyliczamy % (np. 1 * 0.05 = 0.05)
    SET @WyliczonaZnizka = @IloscKrokow * @SkokProcent;

    -- 4. Blokada MAX (nie więcej niż 30%)
    IF @WyliczonaZnizka > @MaxProcent
        SET @WyliczonaZnizka = @MaxProcent;

    RETURN @WyliczonaZnizka;
END
go

CREATE   FUNCTION dbo.PobierzWartoscKoszyka (@OrderId INT)
    RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Suma DECIMAL(18, 2);

    -- Sumujemy pozycje dla danego zamówienia
    SELECT @Suma = SUM(Quantity * UnitPrice)
    FROM OrderDetails
    WHERE Order_ID = @OrderId;

    -- Jeśli brak pozycji, zwracamy 0
    RETURN ISNULL(@Suma, 0.00);
END
go

CREATE PROCEDURE dbo.UpdateDiscountStepValue
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters SET DiscountStepValue = @Value;
go

CREATE PROCEDURE dbo.UpdateDiscountThreshold
    @Value decimal(10, 2)
AS
    UPDATE dbo.Parameters SET DiscountThreshold = @Value;
go

CREATE PROCEDURE dbo.UpdateMargin
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters SET Margin = @Value;
go

CREATE PROCEDURE dbo.UpdateMaxDiscount
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters SET MaxDiscount = @Value;
go

CREATE    PROCEDURE dbo.sp_ProcessQualityFailure
@DailyLogID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Trancount INT = @@TRANCOUNT;

    -- Zmienne operacyjne
    DECLARE @OldPlanID INT, @FailedQty INT, @ProductID INT,
        @OrderDetailID INT, @OrderID INT, @AssemblyCapacity INT,
        @OldEndDate DATE, @RemainingQty INT;

    DECLARE @StealPlan TABLE (PlanID INT, StealAmount INT);

    -- Zmienne do powiadomienia
    DECLARE @ClientName NVARCHAR(200), @ClientPhone NVARCHAR(50);
    DECLARE @AlertMessage NVARCHAR(2048);

    BEGIN TRY
        IF @Trancount = 0 BEGIN TRAN;

        -- 1. Pobranie kontekstu
        SELECT
            @OldPlanID = i.ProductionPlan_ID,
            @FailedQty = i.Quantity,
            @ProductID = pp.Product_ID,
            @OldEndDate = pp.EndDate,
            @AssemblyCapacity = ISNULL(p.AssemblyCapacity, 1),
            @OrderDetailID = pa.OrderDetails_ID,
            @OrderID = o.ID
        FROM dbo.ProductionDailyLog i WITH (UPDLOCK)
                 JOIN ProductionPlans pp ON i.ProductionPlan_ID = pp.ID
                 JOIN Products p ON pp.Product_ID = p.ID
                 LEFT JOIN ProductionAllocations pa ON pp.ID = pa.ProductionPlans_ID
                 LEFT JOIN OrderDetails od ON pa.OrderDetails_ID = od.ID
                 LEFT JOIN Orders o ON od.Order_ID = o.ID
        WHERE i.ID = @DailyLogID;

        -- Walidacja
        IF @OrderDetailID IS NULL OR @FailedQty <= 0
            BEGIN
                IF @Trancount = 0 COMMIT TRAN;
                RETURN;
            END

        SET @RemainingQty = @FailedQty;

        -- KROK 1. Ewentualne podkradanie
        ;WITH AvailablePlans AS (
            SELECT
                pp.ID,
                pp.EndDate,
                (pp.Quantity - ISNULL(Allocated.UsedQty, 0)) AS AvailableQty
            FROM ProductionPlans pp WITH (UPDLOCK, ROWLOCK, READPAST)
                     LEFT JOIN (
                SELECT ProductionPlans_ID, SUM(QuantityAllocated) AS UsedQty
                FROM ProductionAllocations
                GROUP BY ProductionPlans_ID
            ) Allocated ON pp.ID = Allocated.ProductionPlans_ID
            WHERE pp.Product_ID = @ProductID
              AND pp.ProductionType = 'C' -- Jest cykliczne to możemy ukraść
              AND pp.Status_ID = 1 -- W toku
              AND (pp.Quantity - ISNULL(Allocated.UsedQty, 0)) > 0
        ),
              RunningTotals AS (
                  SELECT
                      ID, AvailableQty,
                      SUM(AvailableQty) OVER (ORDER BY EndDate, ID) AS RunningTotal
                  FROM AvailablePlans
              )
         INSERT INTO @StealPlan (PlanID, StealAmount)
         SELECT ID,
                IIF(Runningtotal <= @Remainingqty, Availableqty, @Remainingqty - (Runningtotal - Availableqty))
         FROM RunningTotals
         WHERE (RunningTotal - AvailableQty) < @RemainingQty;

        IF EXISTS (SELECT 1 FROM @StealPlan)
            BEGIN
                INSERT INTO ProductionAllocations (ProductionPlans_ID, QuantityAllocated, OrderDetails_ID)
                SELECT PlanID, StealAmount, @OrderDetailID
                FROM @StealPlan;

                SELECT @RemainingQty = @RemainingQty - SUM(StealAmount) FROM @StealPlan;
            END

        -- KROK 2. Nowy plan jak ukradnięcie się nie powiodło/wystarczyło
        IF @RemainingQty > 0
            BEGIN
                DECLARE @NewPlanEndDate DATE, @NewPlanID INT;
                DECLARE @Today DATE = CAST(GETDATE() AS DATE);

                DECLARE @StartBaseDate DATE = IIF(@Oldenddate >= @Today, @Oldenddate, @Today);
                DECLARE @DurationDays INT = CEILING(CAST(@RemainingQty AS FLOAT) / NULLIF(@AssemblyCapacity, 0));

                SET @NewPlanEndDate = dbo.CalculateEndDate(@Startbasedate, @Durationdays);

                INSERT INTO ProductionPlans (Quantity, EndDate, Product_ID, ProductionType, Status_Id)
                VALUES (@RemainingQty, @NewPlanEndDate, @ProductID, 'O', 1);

                SET @NewPlanID = SCOPE_IDENTITY(); -- Pobranie ID

                INSERT INTO ProductionAllocations (ProductionPlans_ID, QuantityAllocated, OrderDetails_ID)
                VALUES (@NewPlanID, @RemainingQty, @OrderDetailID);
            END


        -- Aktualizacja zamówienia o nową datę końcową

        DECLARE @CalculatedNewEndDate DATE;

        ;WITH OrderMaxDate AS (
            SELECT o.ID, MAX(pp.EndDate) as MaxProductionDate
            FROM Orders o
                     JOIN OrderDetails od ON o.ID = od.Order_ID
                     JOIN ProductionAllocations pa ON od.ID = pa.OrderDetails_ID
                     JOIN ProductionPlans pp ON pa.ProductionPlans_ID = pp.ID
            WHERE o.ID = @OrderID
            GROUP BY o.ID
        )
         SELECT @CalculatedNewEndDate = MaxProductionDate
         FROM OrderMaxDate;

        UPDATE o
        SET EndDate = @CalculatedNewEndDate
        FROM Orders o
        WHERE o.ID = @OrderID
          AND (@CalculatedNewEndDate > o.EndDate);


        -- Alert
        IF @CalculatedNewEndDate > @OldEndDate
            BEGIN
                SELECT
                    @ClientName = c.Name,
                    @ClientPhone = c.PhoneNumber
                FROM Orders o
                         JOIN Clients c ON o.Client_ID = c.ID
                WHERE o.ID = @OrderID;

                -- JSON dla systemu (to dla programisty)
                SET @AlertMessage =
                  N'{"Type": "QualityDelay", "OrderId": ' + CAST(@OrderID AS NVARCHAR(20)) +
                  N', "Client": "' + ISNULL(@ClientName, 'N/A') +
                  N'", "NewDate": "' + CAST(@CalculatedNewEndDate AS NVARCHAR(20)) + '"}';

                -- Severity 10 = Info (Nie przerywa transakcji, widać w Output)
                RAISERROR(@Alertmessage, 10, 1) WITH NOWAIT;
            END

        IF @Trancount = 0 COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @Trancount = 0 ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 51000, @ErrMsg, 1;
    END CATCH
END;
go


