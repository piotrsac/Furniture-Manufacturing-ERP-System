# Podstawy Baz danych

Dzień i godzina zajęć: **środa 13:15**

Nr zespołu: **7**

Autorzy:

- **Patrycja Zborowska**
- **Alicja Czeleń**
- **Piotr Sączawa**

---

# 1. Wymagania i funkcje systemu

##

### Zarządzanie produktami

- Rejestracja produktów i ich kategorii.
- Definicja struktury produktu (lista części i robocizny).
- Obliczanie kosztu i mocy przerobowej.

### Zarządzanie magazynem

- Rejestracja części i stanów magazynowych.
- Rejestracja stanów magazynowych produktów gotowych.
- Aktualizacja stanów magazynowych przy sprzedaży i produkcji.
- Rejestracja planów produkcji.

### Planowanie produkcji

- Ustalanie zapotrzebowania na podstawie zamówień.
- Sprawdzanie dostępności surowców.
- Szacowanie czasu produkcji w oparciu o moce przerobowe.
- Tworzenie planu produkcji produktów brakujących w magazynie.

### Zarządzanie zamówieniami

- Składanie zamówień przez klientów indywidualnych i firmowych.
- Obsługa płatności.
- Możliwość dodania jednostkowego rabatu.
- Sprawdzenie dostępności produktów w magazynie.
- Obsługa zamówień wymagających produkcji.

### Raportowanie (analityka danych)

- Raporty kosztów produkcji: jednostkowe, grup produktowych; kwartalne/miesięczne/roczne.
- Raporty stanów magazynowych (produkty i surowce) oraz planów produkcji.
- Raporty zamówień klientów (także z rabatami) z opcją filtrowania po okresach czasu.
- Raporty sprzedaży grup produktów (miesiące i tygodnie).
- Raport kosztów produkcji w ujęciu tygodniowym i miesięcznym.
- Raporty planów wytwórczych w wybranych okresach.

### Narzędzia bazy danych

- Procedury, funkcje (np. obliczanie kosztów).
- Triggery aktualizujące stany.
- Widoki analityczne do raportów.

## Use cases:

### UC1: Rejestracja produktu

**Aktor:** Administrator / Planista produkcji
**Cel:** Dodanie nowego produktu do systemu.
**Wyzwalacz:** Potrzeba wprowadzenia nowego produktu.

#### Główny przebieg:

- Aktor wybiera opcję „Dodaj produkt”.
- Wprowadza dane: nazwę produktu, kategorię, cenę, parametry techniczne, listę części.
- System waliduje dane.
- System zapisuje produkt w bazie.

---

### UC2: Obliczenie kosztu produkcji

**Aktor:** Planista produkcji
**Cel:** Wyliczenie jednostkowego kosztu produktu.
**Dane wejściowe:** ID produktu.

#### Główny przebieg:

- Planista wybiera produkt.
- System pobiera listę części i ich koszty.
- System sumuje koszty materiałów i pracy.
- System wyświetla jednostkowy koszt produkcji.

---

### UC3: Sprawdzenie dostępności magazynowej

**Aktor:** Magazynier / System produkcji
**Cel:** Zweryfikowanie dostępności produktu lub jego części.
**Dane wejściowe:** ID produktu.

#### Główny przebieg:

- Aktor lub system inicjuje sprawdzenie stanu magazynowego.
- System pobiera stany magazynowe produktu oraz wymaganych części.
- System określa poziom dostępności.

#### Wynik:

- „dostępny”
- „brak części”
- „brak produktu”

---

### UC4: Złożenie zamówienia

**Aktor:** Klient / Dział sprzedaży
**Cel:** Zarejestrowanie zamówienia w systemie.

#### Główny przebieg:

- Klient wybiera produkty.
- System sprawdza dostępność magazynową.
- System nalicza rabaty, jeśli obowiązują.
- System wylicza całkowity koszt zamówienia.
- System zapisuje zamówienie.

---

### UC5: Planowanie produkcji

**Aktor:** Planista produkcji
**Cel:** Utworzenie planu produkcji.

#### Główny przebieg:

- System pobiera zamówienia wymagające produkcji.
- System analizuje dostępność części zamówienia.
- System określa wymagany czas produkcji.
- Planista zatwierdza plan.

---

### UC6: Realizacja produkcji

**Aktor:** Pracownik produkcji / System produkcji
**Cel:** Zrealizowanie procesu produkcyjnego.

#### Główny przebieg:

- System generuje zapotrzebowanie na części.
- Magazyn wydaje części i aktualizuje stany magazynowe.
- Produkcja wytwarza produkt.
- System rejestruje produkt gotowy w magazynie.

---

### UC7: Generowanie raportów

**Aktor:** Zarząd / Analityk
**Cel:** Analiza danych produkcyjnych, magazynowych i sprzedażowych.

#### Rodzaje raportów:

- koszty produkcji (wg okresów),
- stany magazynowe,
- zamówienia klientów,
- sprzedaż tygodniowa/miesięczna,
- plany i realizacja produkcji.

#### Główny przebieg:

- Aktor wybiera typ raportu oraz zakres dat.
- System pobiera wymagane dane.
- System generuje raport i udostępnia go do wglądu lub eksportu.

---

<br>

## Diagram przypadków użycia

<p align="center">
  <img src="use-case-diagram.png" alt="Diagram przypadków użycia" width="800">
</p>

# 2. Baza danych

## Schemat bazy danych

<p align="center">
  <img src="Projekt_bazy_v0-2026-01-18_17-53.png" alt="Diagram" width="800">
</p>

## Opis poszczególnych tabel

[TODO: #3 Dla każdej tabeli kod DDL wraz z zaimplementowanymi war. integralności, + ewentualnie opis, np. w formie tabelki]: #

### Kategorie produktów

```SQL
CREATE TABLE dbo.Categories (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY CLUSTERED (ID)
);
```

* **Opis tabeli:** Tabela słownikowa służąca do kategoryzacji asortymentu (np. meble, akcesoria). Umożliwia logiczne grupowanie produktów w raportach i analizach sprzedaży.
* **Klucz główny:** `ID` (klucz sztuczny/surrogate key).

### Klienci

```SQL
CREATE TABLE dbo.Clients (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    Email varchar(320)  NULL,
    PhoneNumber varchar(15)  NOT NULL,
    NIP varchar(10)  NULL,
    Address nvarchar(50)  NOT NULL,
    PostalCode nvarchar(50)  NULL,
    City nvarchar(50)  NOT NULL,
    Country nvarchar(50)  NOT NULL,
    ClientType char(1)  NOT NULL,
    CONSTRAINT CK_Clients_ClientType CHECK (ClientType in ('F', 'I')),
    CONSTRAINT PK_Clients PRIMARY KEY CLUSTERED (ID)
    CONSTRAINT CK_Clients_EmailValid
        CHECK (
            Email NOT LIKE '% %'
                AND LEN(Email) - LEN(REPLACE(Email, '@', '')) = 1
                AND PATINDEX('%_@_%._%', Email) > 0
                AND LEN(RIGHT(Email, CHARINDEX('.', REVERSE(Email)) - 1)) >= 2
            );
    CONSTRAINT CK_Clients_AtLeastOneContact
        CHECK (
            Email IS NOT NULL OR PhoneNumber IS NOT NULL
            );
);
```

* **Opis tabeli:** Centralna baza kontrahentów zawierająca dane klientów indywidualnych oraz firmowych. Przechowuje informacje kontaktowe, adresowe oraz identyfikatory podatkowe (NIP).
* **Więzy integralności (Constraints):**
  * `CK_Clients_ClientType`: Ogranicza typ klienta do dwóch wartości: `'F'` (Firma) lub `'I'` (Indywidualny).
  * `CK_Clients_AtLeastOneContact`: Realizuje regułę biznesową wymagającą co najmniej jednej formy kontaktu. Rekord nie zostanie zapisany, jeśli zarówno `Email`, jak i `PhoneNumber` są puste (NULL).
  * `CK_Clients_EmailValid`: Złożony warunek sprawdzający poprawność adresu e-mail bez użycia RegEx (ograniczenie silnika SQL Server w standardowych constraintach). Weryfikuje:
    1. Brak spacji w adresie (`NOT LIKE '% %'`).
    2. Obecność dokładnie jednego znaku `@` (poprzez porównanie długości ciągu przed i po usunięciu znaku).
    3. Poprawną strukturę znaków (wymaga sekwencji: ciąg -> `@` -> ciąg -> `.` -> ciąg).
    4. Długość domeny najwyższego poziomu (np. .pl, .com) wynoszącą minimum 2 znaki.

### Dni bez pracy/produkcji

```SQL
CREATE TABLE dbo.DaysOff (
    ID int  NOT NULL IDENTITY,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    Name nvarchar(100)  NOT NULL,
    CONSTRAINT CK_DaysOff_StartDateBeforeEndDate CHECK (StartDate <= EndDate),
    CONSTRAINT DaysOff_pk PRIMARY KEY  (ID)
);
```

* **Opis tabeli:** Ewidencja przerw w harmonogramie pracy zakładu. Służy do rejestrowania dni wolnych, świąt oraz przestojów technicznych, co jest kluczowe dla poprawnego planowania mocy przerobowych.
* **Więzy integralności (Constraints):**
  * `CK_DaysOff_StartDateBeforeEndDate`: Zabezpiecza spójność logiczną dat – data rozpoczęcia przerwy musi być wcześniejsza lub równa dacie jej zakończenia.

### Szczegóły zamówienia

```SQL
CREATE TABLE dbo.OrderDetails (
    ID int  NOT NULL IDENTITY,
    Order_ID int  NOT NULL,
    Product_ID int  NOT NULL,
    Quantity int  NOT NULL,
    UnitPrice decimal(10,2)  NOT NULL,
    CONSTRAINT CK_OrderDetails_QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT CK_OrderDetails_UnitPriceOverZero CHECK (UnitPrice > 0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY CLUSTERED (ID),

    CONSTRAINT FK_OrderDetails_Orders
      FOREIGN KEY (Order_ID)
      REFERENCES dbo.Orders (ID),
    CONSTRAINT FK_OrderDetails_Products
      FOREIGN KEY (Product_ID)
      REFERENCES dbo.Products (ID)
);
```

* **Opis tabeli:** Tabela asocjacyjna łącząca zamówienia z produktami. Przechowuje informacje o historycznym stanie transakcji – konkretną ilość zamówionego towaru oraz cenę jednostkową obowiązującą w momencie zakupu (niezależną od późniejszych zmian w cenniku).
* **Więzy integralności (Constraints):**
  * `CK_OrderDetails_QuantityNotNegative`: Blokuje wprowadzenie ujemnej ilości towaru.
  * `CK_OrderDetails_UnitPriceOverZero`: Cena sprzedaży musi być większa od zera.

### Zamówienia

```SQL
CREATE TABLE dbo.Orders (
    ID int  NOT NULL IDENTITY,
    Client_ID int  NOT NULL,
    OrderDate date  NOT NULL,
    EndDate date  NOT NULL,
    Status_ID int  NOT NULL,
    Discount  AS [dbo].[ObliczZnizke]([dbo].[PobierzWartoscKoszyka]([ID])),
    CONSTRAINT CK_Orders_EndDateAfterOrderDate CHECK (EndDate >= OrderDate),
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (ID),

    CONSTRAINT FK_Orders_Clients
        FOREIGN KEY (Client_ID)
        REFERENCES dbo.Clients (ID),
    CONSTRAINT Status_Orders
        FOREIGN KEY (Status_ID)
        REFERENCES dbo.Status (ID)
);
```

* **Opis tabeli:** Tabela nagłówkowa zamówień, przechowująca informacje o kliencie, datach realizacji, statusie oraz przyznanym rabacie.
* **Więzy integralności (Constraints):**
  * `CK_Orders_EndDateAfterOrderDate`: Data zakończenia (realizacji) zamówienia nie może być wcześniejsza niż data jego złożenia.

### Kategorie części

```SQL
CREATE TABLE dbo.PartTypes (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_PartTypes PRIMARY KEY CLUSTERED (ID)
);
```

* **Opis tabeli:** Tabela słownikowa klasyfikująca rodzaje materiałów i półproduktów (np. metal, drewno, plastik). Ułatwia zarządzanie magazynem surowców.

### Części

```SQL
CREATE TABLE dbo.Parts (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    PartType_ID int  NOT NULL,
    Price decimal(10,2)  NOT NULL,
    ProductionCapacity int  NULL,
    Quantity int  NOT NULL DEFAULT 0,
    CONSTRAINT CK_Parts_QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT CK_Parts_PriceOverZero CHECK (Price > 0),
    CONSTRAINT PK_Parts PRIMARY KEY CLUSTERED (ID),
    
    CONSTRAINT FK_Parts_PartTypes
        FOREIGN KEY (PartType_ID)
        REFERENCES dbo.PartTypes (ID)
);
```

* **Opis tabeli:** Magazyn surowców i półproduktów. Tabela przechowuje aktualny stan magazynowy, cenę zakupu części oraz informacje o mocach przerobowych (ile danych części można przetworzyć/przyjąć).
* **Więzy integralności (Constraints):**
  * `CK_Parts_QuantityNotNegative`: Stan magazynowy nie może być ujemny.
  * `CK_Parts_PriceOverZero`: Cena zakupu części musi być dodatnia.

### Globalne parametry
```SQL
CREATE TABLE dbo.Parameters (
    Margin decimal(3,2)  NOT NULL,
    DiscountStepValue decimal(3,2)  NULL,
    DiscountThreshold decimal(10,2)  NULL,
    MaxDiscount decimal(3,2)  NULL
    CONSTRAINT CK_Parameters_Values
        CHECK (Margin >= 0 AND DiscountStepValue >= 0);
);
```

* **Opis tabeli:** Tabela jedno-wierszowa (singleton) pełniąca rolę globalnej konfiguracji systemu. Przechowuje kluczowe zmienne sterujące logiką biznesową, wykorzystywane przez funkcje obliczające ceny i rabaty.
* **Więzy integralności (Constraints):**
  * `CK_Parameters_Values`: Pełni rolę bezpiecznika dla logiki biznesowej. Blokuje możliwość wprowadzenia ujemnej marży (`Margin`) oraz ujemnego skoku rabatowego. Zapobiega to błędom w wyliczeniach cen sprzedaży i naliczaniu "odwrotnych" rabatów.

### Części danego produktu (łącznikowa)

```SQL
CREATE TABLE dbo.ProductParts (
    Product_ID int  NOT NULL,
    Part_ID int  NOT NULL,
    Quantity int  NOT NULL,
    CONSTRAINT CK_ProductParts_QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT PK_ProductParts PRIMARY KEY CLUSTERED (Product_ID,Part_ID),

    CONSTRAINT FK_ProductParts_Parts
      FOREIGN KEY (Part_ID)
      REFERENCES dbo.Parts (ID),
    CONSTRAINT FK_ProductParts_Products
        FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (ID)
);
```

* **Opis tabeli:** Tabela definiująca strukturę materiałową produktu. Określa, jakie części i w jakiej ilości są niezbędne do wytworzenia jednej sztuki produktu gotowego.
* **Więzy integralności (Constraints):**
  * `CK_ProductParts_QuantityNotNegative`: Ilość wymaganych części nie może być ujemna.

### Zarezerwowanie produkowanych rzeczy do konkretnego zamówienia

```SQL
CREATE TABLE ProductionAllocations (
    ID int  NOT NULL IDENTITY,
    ProductionPlans_ID int  NOT NULL,
    QuantityAllocated int  NOT NULL,
    OrderDetails_ID int  NOT NULL,
    CONSTRAINT CK_ProductionAllocations_QuantityAllocatedNotNegative CHECK (QuantityAllocated >= 0),
    CONSTRAINT ProductionAllocations_pk PRIMARY KEY  (ID),

    CONSTRAINT OrderDetails_ProductionAllocations
        FOREIGN KEY (OrderDetails_ID)
        REFERENCES dbo.OrderDetails (ID),
    CONSTRAINT ProductionAllocations_ProductionPlans
        FOREIGN KEY (ProductionPlans_ID)
        REFERENCES dbo.ProductionPlans (ID)
);
```

* **Opis tabeli:** Tabela łącząca plany produkcyjne z konkretnymi pozycjami zamówień. Pozwala na "twardą rezerwację" towaru będącego jeszcze w procesie produkcji pod konkretne zamówienie klienta.
* **Więzy integralności (Constraints):**
  * `CK_ProductionAllocations_QuantityAllocatedNotNegative`: Ilość alokowanego towaru musi być nieujemna.

### Dzienne sprawozdanie z wykonywania planu produkcyjnego

```SQL
CREATE TABLE ProductionDailyLog (
    ID int  NOT NULL IDENTITY,
    ProductionPlan_ID int  NOT NULL,
    DailyLog nvarchar(100)  NOT NULL,
    Date date  NOT NULL DEFAULT GETDATE(),
    Quantity int  NOT NULL,
    QualityStatus char(1)  NOT NULL,
    CONSTRAINT CK_ProductionDailyLog_QualityStatus CHECK (QualityStatus in ('K', 'F')),
    CONSTRAINT CK_ProductionDailyLog_QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT ProductionDailyLog_pk PRIMARY KEY (ID),
    
    CONSTRAINT ProductionPlans_ProductionDailyLog
        FOREIGN KEY (ProductionPlan_ID)
        REFERENCES dbo.ProductionPlans (ID)
);
```

* **Opis tabeli:** Rejestr postępów prac, służący do monitorowania wykonania planu. Przechowuje informacje o ilości wyprodukowanej w danym dniu oraz o kontroli jakości.
* **Więzy integralności (Constraints):**
  * `CK_ProductionDailyLog_QualityStatus`: Pole przyjmuje tylko dwie wartości: `'K'` (Kompletne/Dobra jakość) lub `'F'` (Fail/Odrzut produkcyjny).
  * `CK_ProductionDailyLog_QuantityNotNegative`: Ilość wyprodukowana nie może być ujemna.

### Plany produkcyjne (cykliczne bądź wymuszone popytem)

```SQL
CREATE TABLE dbo.ProductionPlans (
    ID int  NOT NULL IDENTITY,
    Quantity int  NOT NULL,
    EndDate date  NOT NULL,
    Status_ID int  NOT NULL,
    Product_ID int  NOT NULL,
    ProductionType char(1)  NOT NULL,
    CONSTRAINT CK_ProductionPlans_ProductionType CHECK (ProductionType in ('C', 'O')),
    CONSTRAINT CK_ProductionPlans_QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT PK_ProductionPlans PRIMARY KEY CLUSTERED (ID),

    CONSTRAINT Products_ProductionPlans
        FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (ID),
    CONSTRAINT Status_ProductionPlans
        FOREIGN KEY (Status_ID)
        REFERENCES dbo.Status (ID)
);
```

* **Opis tabeli:** Harmonogram zleceń produkcyjnych. Określa co, ile i na kiedy ma zostać wyprodukowane, wraz z oznaczeniem typu zlecenia.
* **Więzy integralności (Constraints):**
  * `CK_ProductionPlans_ProductionType`: Rozróżnia dwa tryby produkcji: `'C'` (Cykliczna/Na magazyn) oraz `'O'` (On-demand/Pod konkretne zamówienie, gdy brakuje towaru).
  * `CK_ProductionPlans_QuantityNotNegative`: Planowana ilość musi być nieujemna.

### Produkty

```SQL
CREATE TABLE dbo.Products (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    Category_ID int  NOT NULL,
    Quantity int  NOT NULL DEFAULT 0,
    AssemblyCapacity int  NOT NULL DEFAULT 0,
    Discontinued bit  NOT NULL DEFAULT 0,
    Productioncost   AS [dbo].[ObliczKosztProdukcji]([ID]),
    Price            AS [dbo].[ObliczCeneSprzedazy]([ID]),
    CONSTRAINT QuantityNotNegative CHECK (Quantity >= 0),
    CONSTRAINT AssemblyCapacityNotNegative CHECK (AssemblyCapacity >= 0),
    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ID),

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (Category_ID)
        REFERENCES dbo.Categories (ID)
);
```

* **Opis tabeli:** Główna kartoteka wyrobów gotowych. Zawiera dane o cenach, kosztach produkcji (wyliczanych), stanach magazynowych oraz maksymalnych mocach przerobowych montażu.
* **Więzy integralności (Constraints):**
  * `QuantityNotNegative`: Stan magazynowy produktu nie może spaść poniżej zera.
  * `AssemblyCapacityNotNegative`: Moc przerobowa (limit produkcyjny) musi być wartością nieujemną.

### Statusy zamówień

```SQL
CREATE TABLE dbo.Status (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_Status PRIMARY KEY CLUSTERED (ID)
);
```

* **Opis tabeli:** Słownik definiujący możliwe etapy cyklu życia zamówienia lub planu produkcyjnego (np. "w trakcie", "zakończone").
<!-- - Opis:

| Nazwa atrybutu | Typ | Opis/Uwagi |
| :------------: | :-: | :--------: | --- |
|   Atrybut 1    |     |            |
|   Atrybut 2    |     |            |
|   Atrybut 3    |     |            | -->


# 3. Widoki, procedury i funkcje

## Widoki

### Podsumowanie finansowe zamówień

```SQL
CREATE VIEW vw_OrdersSummary AS
WITH CartValue AS (
    -- KROK 1: Pobranie wartości koszyka dla każdego zamówienia
    SELECT
        ID AS Order_ID,
        dbo.PobierzWartoscKoszyka(ID) AS SumValue
    FROM Orders
),
DiscountPercent AS (
    -- KROK 2: Wyliczenie procentu rabatu funkcją skalarną
    SELECT
        o.ID AS OrderID,
        o.Client_ID,
        o.OrderDate,
        ISNULL(cv.SumValue, 0.00) AS Base,
        dbo.ObliczZnizke(ISNULL(cv.SumValue, 0.00)) AS Discount
    FROM Orders o
    JOIN CartValue cv ON o.ID = cv.Order_ID
)
-- KROK 3: Ostateczne zestawienie finansowe
SELECT
    OrderID,
    Client_ID,
    OrderDate,
    CAST(Base AS DECIMAL(18,2)) AS BaseValue,
    Discount AS DiscountPercent,
    CAST(Base * Discount AS DECIMAL(18,2)) AS DiscountValue,
    CAST(Base * (1.00 - Discount) AS DECIMAL(18,2)) AS FinalValue
FROM DiscountPercent;
```

* **Opis:** Kompleksowy widok analityczny agregujący pełne dane finansowe każdego zamówienia. Służy do raportowania sprzedaży i wystawiania dokumentów końcowych.
* **Logika:** Widok realizuje przetwarzanie danych w trzech etapach (CTE):
  1. **Wycena koszyka:** Obliczenie surowej wartości zamówienia na podstawie cen jednostkowych i ilości (przed rabatami).
  2. **Naliczenie rabatu:** Wywołanie logiki biznesowej (funkcja `ObliczZnizke`) dla każdego koszyka w celu ustalenia należnego procentu zniżki.
  3. **Kalkulacja końcowa:** Zestawienie wartości bazowej, wartości udzielonego rabatu (kwotowo i procentowo) oraz ostatecznej kwoty do zapłaty.

### Raport bestsellerów

```SQL
CREATE VIEW vw_BestSellingProducts
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
```

* **Opis:** Widok analityczny identyfikujący najlepiej sprzedające się towary. Zwraca listę "Top 3" produktów o największym wolumenie sprzedaży.
* **Logika:** Agreguje dane ze szczegółów zamówień (`OrderDetails`), sumuje sprzedane sztuki dla każdego produktu i sortuje wynik malejąco, ograniczając go do trzech pierwszych rekordów. Służy do planowania produkcji i działań marketingowych.

### Historia zamówień klientów

```SQL
CREATE VIEW vw_ClientOrdersHistory
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
    (od.Quantity * od.UnitPrice) * (1 - o.Discount) AS FinalValue
FROM Orders o
JOIN Clients c ON c.ID = o.Client_ID
JOIN OrderDetails od ON od.Order_ID = o.ID
JOIN Products p ON p.ID = od.Product_ID;
```

* **Opis:** Szczegółowy rejestr historyczny transakcji z perspektywy klienta. Prezentuje pełne dane o zamówionych produktach, ich cenach jednostkowych oraz zastosowanych rabatach.
* **Logika:** Wykonuje wyliczenie "w locie" ostatecznej wartości pozycji (`FinalValue`), uwzględniając ilość, cenę jednostkową oraz przypisany do zamówienia rabat (wzór: `Ilość * Cena * (1 - Rabat)`).

### Stan magazynowy produktów

```SQL
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
```

* **Opis:** Widok operacyjny prezentujący aktualną dostępność wyrobów gotowych. Łączy dane o produktach z ich kategoriami, ułatwiając przegląd asortymentu.
* **Logika:** Zwraca kluczowe informacje dla działu sprzedaży: nazwę produktu, kategorię, bieżącą ilość w magazynie, cenę oraz status wycofania ze sprzedaży (`Discontinued`).

### Stan magazynowy części

```SQL
CREATE   VIEW vw_InventoryStatus
AS
SELECT
    p.ID AS PartID,
    p.Name AS PartName,
    pt.Name AS PartType,
    p.Quantity AS CurrentStock,
    p.Price
FROM Parts p
JOIN PartTypes pt ON p.PartType_ID = pt.ID;
```

* **Opis:** Raport inwentaryzacyjny dla surowców i półproduktów. Służy do monitorowania zapasów niezbędnych do produkcji.
* **Logika:** Prezentuje listę części wraz z ich typem (np. metal, plastik) oraz aktualną ilością i ceną zakupu. Jest podstawą do generowania zamówień u dostawców.

### Koszty produkcji - Widok Bazowy

```SQL
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
```

* **Opis:** Techniczny widok pomocniczy (warstwa pośrednia), stanowiący fundament dla wszystkich raportów kosztowych. Nie jest przeznaczony do bezpośredniego raportowania, lecz do zasilania innych widoków.
* **Logika:**
  * Wykorzystuje funkcję skalarną `dbo.ObliczKosztProdukcji` do ustalenia jednostkowego kosztu wytworzenia.
  * Oblicza całkowity koszt dla danej partii produkcyjnej (`Ilość * Koszt Jednostkowy`).
  * Dokonuje dekompozycji daty zakończenia produkcji na rok, miesiąc i kwartał, co upraszcza późniejsze grupowanie danych.

### Raporty kosztów produkcji (Agregacje czasowe)

```SQL
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
```

```SQL
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
```

```SQL
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
```

```SQL
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
```

Zestaw widoków analitycznych opartych na `vw_ProductionCost_Base`, służących do kontrolingu finansowego w różnych ujęciach czasowych:

1.  **`dbo.vw_ProductionCost_Annually` (Roczny):** Agreguje koszty i ilości wyprodukowanych dóbr w ujęciu rocznym. Pozwala na analizę trendów wieloletnich.
2.  **`dbo.vw_ProductionCost_Quarterly` (Kwartalny):** Grupuje dane produkcyjne w podziale na kwartały, co jest kluczowe dla okresowych rozliczeń finansowych firmy.
3.  **`dbo.vw_ProductionCost_Monthly` (Miesięczny):** Najbardziej szczegółowy widok kosztowy, sumujący wydatki produkcyjne dla każdego miesiąca.
4.  **`dbo.vw_Management_ProductionCosts` (Zarządczy):** Widok dedykowany dla kadry zarządzającej (Dashboard). Prezentuje skonsolidowane dane kosztowe w podziale na kategorie i produkty w ujęciu miesięcznym.

### Plan produkcji - operacyjny

```SQL
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
```

* **Opis:** Widok operacyjny dla kierowników zmiany. Prezentuje bieżącą kolejkę zadań produkcyjnych.
* **Logika:** Zestawia plany produkcyjne z nazwami produktów i czytelnymi statusami (np. "W trakcie", "Oczekujące"), pomijając zbędne dane analityczne.

### Raport planów produkcyjnych

```SQL
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
```

* **Opis:** Rozbudowana wersja widoku operacyjnego, wzbogacona o wymiary czasowe (rok, miesiąc, kwartał). Służy do analizy wydajności i terminowości działu produkcji.
* **Logika:** Umożliwia filtrowanie historii produkcji po okresach oraz typie zlecenia (Cykliczne vs Na żądanie).

### Raport sprzedaży

```SQL
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
```

* **Opis:** Zaawansowany widok analityczny służący do monitorowania przychodów firmy.
* **Logika:**
  * Agreguje dane sprzedażowe do poziomu Tygodnia, Miesiąca i Roku.
  * Oblicza rzeczywisty przychód (`Revenue`), uwzględniając udzielone rabaty.
  * Grupuje wyniki według kategorii i produktów, co pozwala na badanie sezonowości sprzedaży oraz efektywności poszczególnych grup towarowych.

## Procedury/funkcje

### Koszt produkcji

```sql
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
```


* **Typ:** Funkcja skalarna.
* **Opis:** Oblicza całkowity koszt materiałowy potrzebny do wytworzenia jednej sztuki produktu.
* **Logika biznesowa:** Funkcja iteruje po strukturze produktu (BOM - Bill of Materials), sumując iloczyny cen zakupu części i ich wymaganej ilości. Wynik stanowi bazę do ustalania ceny sprzedaży. Zabezpieczona przed wartościami `NULL` (zwraca 0 w przypadku braku zdefiniowanych części).

### Cena sprzedaży

```SQL
CREATE FUNCTION dbo.ObliczCeneSprzedazy (@ProductId INT)
    RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @KosztBazowy DECIMAL(10,2);
    DECLARE @Mnoznik DECIMAL(10,2);

    -- 1. Pobieramy czysty koszt
    SET @KosztBazowy = dbo.ObliczKosztProdukcji(@ProductId);

    -- 2. Pobieramy marżę z tabeli Parameters (np. 1.50)
    SELECT TOP 1 @Mnoznik = Margin FROM Parameters;
    SET @Mnoznik = ISNULL(@Mnoznik, 1.50);

    -- 3. Zwracamy wynik
    RETURN @KosztBazowy * @Mnoznik;
END
```

* **Typ:** Funkcja skalarna.
* **Opis:** Automatycznie generuje sugerowaną cenę detaliczną produktu, zapewniając spójność marży w całym asortymencie.
* **Logika biznesowa:** Pobiera wyliczony wcześniej koszt produkcji i narzuca na niego globalną marżę zdefiniowaną w tabeli konfiguracyjnej `Parameters`. Dzięki temu zmiana marży w jednym miejscu w systemie automatycznie aktualizuje sugerowane ceny wszystkich produktów.

### Wartość koszyka

```SQL
CREATE FUNCTION dbo.PobierzWartoscKoszyka (@OrderId INT)
    RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Suma DECIMAL(18, 2);

    SELECT @Suma = SUM(Quantity * UnitPrice)
    FROM OrderDetails
    WHERE Order_ID = @OrderId;

    RETURN ISNULL(@Suma, 0.00);
END
```

* **Typ:** Funkcja skalarna (pomocnicza).
* **Opis:** Szybkie obliczenie wartości brutto pozycji znajdujących się w danym zamówieniu.
* **Logika biznesowa:** Sumuje iloczyn `Ilość * Cena Jednostkowa` dla wszystkich linii danego zamówienia. Stanowi punkt wyjścia do obliczeń rabatowych.

### Algorytm rabatowy

```SQL
CREATE OR ALTER FUNCTION dbo.ObliczZnizke (@WartoscZamowienia DECIMAL(18, 2))
    RETURNS DECIMAL(4, 2)
AS
BEGIN
    DECLARE @Prog DECIMAL(18, 2);
    DECLARE @SkokProcent DECIMAL(4, 2);
    DECLARE @MaxProcent DECIMAL(4, 2);
    DECLARE @KwotaSkoku DECIMAL(18, 2) = 100.00;
    DECLARE @WyliczonaZnizka DECIMAL(4, 2);

    -- Pobieramy ustawienia z tabeli Parameters
    SELECT TOP 1
        @Prog = DiscountThreshold,
        @SkokProcent = DiscountStepValue,
        @MaxProcent = MaxDiscount
    FROM Parameters;

    SET @Prog = ISNULL(@Prog, 999999.00);
    SET @MaxProcent = ISNULL(@MaxProcent, 0.00);

    -- Jeśli kwota <= próg, brak zniżki
    IF @WartoscZamowienia <= @Prog
        RETURN 0.00;

    -- Obliczenia skokowe
    DECLARE @Nadwyzka DECIMAL(18, 2) = @WartoscZamowienia - @Prog;
    DECLARE @IloscKrokow INT = CAST(CEILING(@Nadwyzka / @KwotaSkoku) AS INT)
    SET @WyliczonaZnizka = @IloscKrokow * @SkokProcent;

    -- Blokada MAX
    IF @WyliczonaZnizka > @MaxProcent
        SET @WyliczonaZnizka = @MaxProcent;

    RETURN @WyliczonaZnizka;
END;
```

* **Typ:** Funkcja skalarna.
* **Opis:** Zaawansowany mechanizm wyliczania dynamicznego rabatu w zależności od wartości zamówienia.
* **Logika biznesowa:** Implementuje progresywny system zniżek oparty na parametrach globalnych:
  * Sprawdza, czy wartość zamówienia przekracza próg minimalny (`DiscountThreshold`).
  * Za każde pełne 100 jednostek walutowych powyżej progu dolicza określony procent rabatu (`DiscountStepValue`).
  * Pilnuje, aby wyliczona zniżka nie przekroczyła ustalonego odgórnie limitu (`MaxDiscount`), chroniąc rentowność sprzedaży.


# 4. Role i Uprawnienia

### Model uprawnień

W systemie wdrożono model bezpieczeństwa oparty na rolach (RBAC), co zapewnia separację obowiązków i minimalizację ryzyka nieuprawnionego dostępu do danych wrażliwych.

1. **Rola Zarządcza (`Rola_Zarzad`)**
   * **Przeznaczenie:** Dla kadry kierowniczej i analityków biznesowych.
   * **Uprawnienia:** Wyłącznie odczyt (`SELECT`) wszystkich danych w schemacie. Umożliwia generowanie raportów bez ryzyka przypadkowej modyfikacji danych operacyjnych.

2. **Rola Sprzedażowa (`Rola_Sprzedaz`)**
   * **Przeznaczenie:** Dla pracowników obsługi klienta.
   * **Uprawnienia:** Pełna edycja danych klientów i zamówień. Dostęp do katalogu produktów jest ograniczony do odczytu (sprawdzanie dostępności i cen), co uniemożliwia sprzedawcom manipulację cenami bazowymi.

3. **Rola Planistyczna (`Rola_Planista`)**
   * **Przeznaczenie:** Dla managerów produkcji.
   * **Uprawnienia:** Pełna kontrola nad definicjami produktów, recepturami (BOM), planami produkcyjnymi oraz globalnymi parametrami systemu (marże, progi rabatowe). Jest to rola o najwyższym wpływie na logikę biznesową systemu.

4. **Rola Magazynowa (`Rola_Magazyn`)**
   * **Przeznaczenie:** Dla pracowników magazynu i hali produkcyjnej.
   * **Uprawnienia:** Zarządzanie stanami surowców (`Parts`) oraz raportowanie postępów produkcji (`ProductionDailyLog`). Rola posiada specyficzne uprawnienie do aktualizacji *tylko* stanu magazynowego produktów gotowych (`UPDATE ON Products (Quantity)`), bez możliwości zmiany ich nazw czy cen.

### Utworzenie ról i przypisanie uprawnień

```SQL
-- 1. Zarząd
CREATE ROLE [Rola_Zarzad];
GRANT SELECT ON SCHEMA::dbo TO [Rola_Zarzad];

-- 2. Dział Sprzedaży
CREATE ROLE [Rola_Sprzedaz];
GRANT SELECT, INSERT, UPDATE, DELETE ON Clients TO [Rola_Sprzedaz];
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO [Rola_Sprzedaz];
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderDetails TO [Rola_Sprzedaz];
GRANT SELECT ON Status TO [Rola_Sprzedaz];
-- Podgląd produktów (żeby sprawdzić dostępność), ale bez edycji
GRANT SELECT ON Products TO [Rola_Sprzedaz];
GRANT SELECT ON Categories TO [Rola_Sprzedaz];

-- 3. Planista
CREATE ROLE [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON Categories TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON ProductParts TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON Parameters TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON ProductionPlans TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON ProductionAllocations TO [Rola_Planista];
GRANT SELECT, INSERT, UPDATE, DELETE ON DaysOff TO [Rola_Planista];
GRANT EXECUTE ON OBJECT::dbo.ObliczKosztProdukcji TO [Rola_Planista];

-- 4. Magazyn
CREATE ROLE [Rola_Magazyn];
GRANT SELECT, INSERT, UPDATE, DELETE ON Parts TO [Rola_Magazyn];
GRANT SELECT, INSERT, UPDATE, DELETE ON PartTypes TO [Rola_Magazyn];
GRANT SELECT, INSERT, UPDATE, DELETE ON ProductionDailyLog TO [Rola_Magazyn];
-- Aktualizacja stanu gotowych produktów (tylko ilość, bez zmiany cen/nazw)
GRANT UPDATE (Quantity) ON Products TO [Rola_Magazyn];
```

### Przykładowi użytkownicy
```SQL
-- 1. Użytkownik dla Zarządu
CREATE USER [User_Analityk] WITHOUT LOGIN;
ALTER ROLE [Rola_Zarzad] ADD MEMBER [User_Analityk];

-- 2. Użytkownik dla Sprzedaży
CREATE USER [User_Sprzedawca] WITHOUT LOGIN;
ALTER ROLE [Rola_Sprzedaz] ADD MEMBER [User_Sprzedawca];

-- 3. Użytkownik dla Planowania
CREATE USER [User_Planista] WITHOUT LOGIN;
ALTER ROLE [Rola_Planista] ADD MEMBER [User_Planista];

-- 4. Użytkownik dla Magazynu
CREATE USER [User_Magazynier] WITHOUT LOGIN;
ALTER ROLE [Rola_Magazyn] ADD MEMBER [User_Magazynier];
```


<!-- ## Triggery

(dla każdego triggera należy wkleić kod polecenia definiującego trigger wraz z komentarzem)

```sql
-- ...
```




(informacja o sposobie wygenerowania danych, uprawnienia …) -->
