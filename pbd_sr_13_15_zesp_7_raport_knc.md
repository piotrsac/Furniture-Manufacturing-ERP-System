# Podstawy Baz danych

Dzień i godzina zajęć: **środa 13:15**

Nr zespołu: **7**

Autorzy:

- **Patrycja Zborowska**
- **Alicja Czeleń**
- **Piotr Sączawa**

---

## Spis treści

- [1. Wymagania i funkcje systemu](#1-wymagania-i-funkcje-systemu)
  - [Zarządzanie produktami](#zarządzanie-produktami)
  - [Zarządzanie magazynem](#zarządzanie-magazynem)
  - [Planowanie produkcji](#planowanie-produkcji)
  - [Zarządzanie zamówieniami](#zarządzanie-zamówieniami)
  - [Raportowanie (analityka danych)](#raportowanie-analityka-danych)
  - [Narzędzia bazy danych](#narzędzia-bazy-danych)
  - [Use cases](#use-cases)
    - [UC1: Rejestracja produktu](#uc1-rejestracja-produktu)
    - [UC2: Obliczenie kosztu produkcji](#uc2-obliczenie-kosztu-produkcji)
    - [UC3: Sprawdzenie dostępności magazynowej](#uc3-sprawdzenie-dostępności-magazynowej)
    - [UC4: Złożenie zamówienia](#uc4-złożenie-zamówienia)
    - [UC5: Planowanie produkcji](#uc5-planowanie-produkcji)
    - [UC6: Realizacja produkcji](#uc6-realizacja-produkcji)
    - [UC7: Generowanie raportów](#uc7-generowanie-raportów)
  - [Diagram przypadków użycia](#diagram-przypadków-użycia)
- [2. Baza danych](#2-baza-danych)
  - [Schemat bazy danych](#schemat-bazy-danych)
    - [Opis relacji (ERD)](#opis-relacji-erd)
  - [Opis poszczególnych tabel](#opis-poszczególnych-tabel)
    - [Kategorie produktów](#kategorie-produktów)
    - [Klienci](#klienci)
    - [Dni bez pracy/produkcji](#dni-bez-pracyprodukcji)
    - [Szczegóły zamówienia](#szczegóły-zamówienia)
    - [Zamówienia](#zamówienia)
    - [Kategorie części](#kategorie-części)
    - [Części](#części)
    - [Globalne parametry](#globalne-parametry)
    - [Części danego produktu (łącznikowa)](#części-danego-produktu-łącznikowa)
    - [Zarezerwowanie produkowanych rzeczy do konkretnego zamówienia](#zarezerwowanie-produkowanych-rzeczy-do-konkretnego-zamówienia)
    - [Dzienne sprawozdanie z wykonywania planu produkcyjnego](#dzienne-sprawozdanie-z-wykonywania-planu-produkcyjnego)
    - [Plany produkcyjne (cykliczne bądź wymuszone popytem)](#plany-produkcyjne-cykliczne-bądź-wymuszone-popytem)
    - [Produkty](#produkty)
    - [Statusy zamówień](#statusy-zamówień)
- [3. Widoki, procedury, funkcje i triggery](#3-widoki-procedury-funkcje-i-triggery)
  - [Widoki](#widoki)
    - [Podsumowanie finansowe zamówień](#podsumowanie-finansowe-zamówień)
    - [Raport bestsellerów](#raport-bestsellerów)
    - [Historia zamówień klientów](#historia-zamówień-klientów)
    - [Stan magazynowy produktów](#stan-magazynowy-produktów)
    - [Stan magazynowy części](#stan-magazynowy-części)
    - [Koszty produkcji - Widok Bazowy](#koszty-produkcji---widok-bazowy)
    - [Raporty kosztów produkcji (Agregacje czasowe)](#raporty-kosztów-produkcji-agregacje-czasowe)
    - [Raport planów produkcyjnych](#raport-planów-produkcyjnych)
    - [Raport sprzedaży](#raport-sprzedaży)
  - [Procedury/funkcje](#proceduryfunkcje)
    - [Typ tabelaryczny: OrderProductType](#typ-tabelaryczny-orderproducttype)
    - [Funkcja: Koszt produkcji](#funkcja-koszt-produkcji)
    - [Funkcja: Cena sprzedaży](#funkcja-cena-sprzedaży)
    - [Funkcja: Wartość koszyka](#funkcja-wartość-koszyka)
    - [Funkcja: Algorytm rabatowy](#funkcja-algorytm-rabatowy)
    - [Procedura: Dodaj kategorię](#procedura-dodaj-kategorię)
    - [Procedura: Rejestracja klienta](#procedura-rejestracja-klienta)
    - [Procedura: Zarządzanie dniami wolnymi](#procedura-zarządzanie-dniami-wolnymi)
    - [Procedura: Definicja składu produktu](#procedura-definicja-składu-produktu)
    - [Procedura: Złóż zamówienie](#procedura-złóż-zamówienie)
    - [Funkcja: Oblicz datę zakończenia](#funkcja-oblicz-datę-zakończenia)
    - [Procedura: Dziennik produkcji](#procedura-dziennik-produkcji)
    - [Procedura: Wycofanie produktu](#procedura-wycofanie-produktu)
    - [Procedury: Konfiguracja parametrów globalnych](#procedury-konfiguracja-parametrów-globalnych)
    - [Procedura: Obsługa awarii jakościowej](#procedura-obsługa-awarii-jakościowej)
  - [Triggery](#triggery)
    - [Walidacja przejść statusów planu produkcyjnego](#walidacja-przejść-statusów-planu-produkcyjnego)
    - [Automatyczna reakcja na błędy jakościowe](#automatyczna-reakcja-na-błędy-jakościowe)
- [4. Role i Uprawnienia](#4-role-i-uprawnienia)
  - [Model uprawnień](#model-uprawnień)
  - [Utworzenie ról i przypisanie uprawnień](#utworzenie-ról-i-przypisanie-uprawnień)
  - [Przykładowi użytkownicy](#przykładowi-użytkownicy)
- [5. Indeksy](#5-indeksy)
  - [Indeksy na klucze obce](#indeksy-na-klucze-obce)
  - [Indeksy na kolumny w klauzulach WHERE i JOIN](#indeksy-na-kolumny-w-klauzulach-where-i-join)
  - [Indeksy na daty dla raportów](#indeksy-na-daty-dla-raportów)

---

# 1. Wymagania i funkcje systemu

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
  <img src="Projekt_bazy_v0-2026-01-20_20-56.png" alt="Diagram" width="800">
</p>

### Opis relacji (ERD)

System opiera się na modelu relacyjnym składającym się z 14 tabel połączonych kluczami obcymi. Poniżej przedstawiono kluczowe relacje między encjami:

#### 1. Relacje związane z zamówieniami

**Clients → Orders** (1:N)

- Jeden klient może złożyć wiele zamówień
- Każde zamówienie musi być przypisane do dokładnie jednego klienta
- Klucz obcy: `Orders.Client_ID` → `Clients.ID`

**Orders → OrderDetails** (1:N)

- Jedno zamówienie składa się z wielu pozycji (produktów)
- Każda pozycja należy do dokładnie jednego zamówienia
- Klucz obcy: `OrderDetails.Order_ID` → `Orders.ID`

**Products → OrderDetails** (1:N)

- Jeden produkt może występować w wielu zamówieniach
- Każda pozycja zamówienia dotyczy dokładnie jednego produktu
- Klucz obcy: `OrderDetails.Product_ID` → `Products.ID`

**Status → Orders** (1:N)

- Status może być przypisany do wielu zamówień
- Każde zamówienie ma dokładnie jeden status
- Klucz obcy: `Orders.Status_ID` → `Status.ID`

#### 2. Relacje produktów i części

**Categories → Products** (1:N)

- Jedna kategoria grupuje wiele produktów
- Każdy produkt należy do dokładnie jednej kategorii
- Klucz obcy: `Products.Category_ID` → `Categories.ID`

**Products ↔ Parts** (M:N poprzez ProductParts)

- Jeden produkt składa się z wielu części
- Jedna część może być wykorzystana w wielu produktach
- Tabela łącznikowa: `ProductParts`
  - Klucz obcy: `ProductParts.Product_ID` → `Products.ID`
  - Klucz obcy: `ProductParts.Part_ID` → `Parts.ID`

**PartTypes → Parts** (1:N)

- Jeden typ części klasyfikuje wiele konkretnych części
- Każda część należy do dokładnie jednego typu
- Klucz obcy: `Parts.PartType_ID` → `PartTypes.ID`

#### 3. Relacje produkcyjne

**Products → ProductionPlans** (1:N)

- Dla jednego produktu może istnieć wiele planów produkcyjnych
- Każdy plan dotyczy dokładnie jednego produktu
- Klucz obcy: `ProductionPlans.Product_ID` → `Products.ID`

**Status → ProductionPlans** (1:N)

- Status może być przypisany do wielu planów produkcyjnych
- Każdy plan ma dokładnie jeden status
- Klucz obcy: `ProductionPlans.Status_ID` → `Status.ID`

**ProductionPlans → ProductionDailyLog** (1:N)

- Jeden plan produkcyjny ma wiele wpisów dziennych
- Każdy wpis dziennika dotyczy dokładnie jednego planu
- Klucz obcy: `ProductionDailyLog.ProductionPlan_ID` → `ProductionPlans.ID`

#### 4. Relacje alokacji produkcji do zamówień

**ProductionPlans ↔ OrderDetails** (M:N poprzez ProductionAllocations)

- Jeden plan produkcji może być alokowany do wielu pozycji zamówień
- Jedna pozycja zamówienia może być realizowana z wielu planów produkcji
- Tabela łącznikowa: `ProductionAllocations`
  - Klucz obcy: `ProductionAllocations.ProductionPlans_ID` → `ProductionPlans.ID`
  - Klucz obcy: `ProductionAllocations.OrderDetails_ID` → `OrderDetails.ID`
  - Dodatkowy atrybut: `QuantityAllocated` (ile sztuk z tego planu jest zarezerwowane)

#### 5. Relacje konfiguracyjne

**Parameters** (singleton)

- Tabela jednowierszowa (bez relacji z innymi tabelami)
- Przechowuje globalne parametry biznesowe (marże, progi rabatowe)
- Wykorzystywana przez funkcje obliczeniowe

**DaysOff** (słownik)

- Niezależna tabela przechowująca dni wolne od pracy
- Wykorzystywana przez funkcję `CalculateEndDate` do pomijania dni nieroboczych

## Opis poszczególnych tabel

### Kategorie produktów

```SQL
CREATE TABLE dbo.Categories (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY CLUSTERED (ID)
);
```

- **Opis tabeli:** Tabela słownikowa służąca do kategoryzacji asortymentu (np. meble, akcesoria). Umożliwia logiczne grupowanie produktów w raportach i analizach sprzedaży.

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

- **Opis tabeli:** Centralna baza kontrahentów zawierająca dane klientów indywidualnych oraz firmowych. Przechowuje informacje kontaktowe, adresowe oraz identyfikatory podatkowe (NIP).
- **Więzy integralności (Constraints):**
  - `CK_Clients_ClientType`: Ogranicza typ klienta do dwóch wartości: `'F'` (Firma) lub `'I'` (Indywidualny).
  - `CK_Clients_AtLeastOneContact`: Realizuje regułę biznesową wymagającą co najmniej jednej formy kontaktu. Rekord nie zostanie zapisany, jeśli zarówno `Email`, jak i `PhoneNumber` są puste (NULL).
  - `CK_Clients_EmailValid`: Złożony warunek sprawdzający poprawność adresu e-mail bez użycia RegEx (ograniczenie silnika SQL Server w standardowych constraintach). Weryfikuje:
    1. Brak spacji w adresie (`NOT LIKE '% %'`).
    2. Obecność dokładnie jednego znaku `@` (poprzez porównanie długości ciągu przed i po usunięciu znaku).
    3. Poprawną strukturę znaków (wymaga sekwencji: ciąg -> `@` -> ciąg -> `.` -> ciąg).
    4. Długość domeny (np. .pl, .com) wynoszącą minimum 2 znaki.

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

- **Opis tabeli:** Ewidencja przerw w harmonogramie pracy zakładu. Służy do rejestrowania dni wolnych, świąt oraz przestojów technicznych, co jest kluczowe dla poprawnego planowania mocy przerobowych.
- **Więzy integralności (Constraints):**
  - `CK_DaysOff_StartDateBeforeEndDate`: Zabezpiecza spójność logiczną dat – data rozpoczęcia przerwy musi być wcześniejsza lub równa dacie jej zakończenia.

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

- **Opis tabeli:** Tabela asocjacyjna łącząca zamówienia z produktami. Przechowuje informacje o historycznym stanie transakcji – konkretną ilość zamówionego towaru oraz cenę jednostkową obowiązującą w momencie zakupu (niezależną od późniejszych zmian w cenniku).
- **Więzy integralności (Constraints):**
  - `CK_OrderDetails_QuantityNotNegative`: Blokuje wprowadzenie ujemnej ilości towaru.
  - `CK_OrderDetails_UnitPriceOverZero`: Cena sprzedaży musi być większa od zera.

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

- **Opis tabeli:** Tabela nagłówkowa zamówień, przechowująca informacje o kliencie, datach realizacji, statusie oraz przyznanym rabacie.
- **Więzy integralności (Constraints):**
  - `CK_Orders_EndDateAfterOrderDate`: Data zakończenia (realizacji) zamówienia nie może być wcześniejsza niż data jego złożenia.

### Kategorie części

```SQL
CREATE TABLE dbo.PartTypes (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_PartTypes PRIMARY KEY CLUSTERED (ID)
);
```

- **Opis tabeli:** Tabela słownikowa klasyfikująca rodzaje materiałów i półproduktów (np. metal, drewno, plastik). Ułatwia zarządzanie magazynem surowców.

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

- **Opis tabeli:** Magazyn surowców i półproduktów. Tabela przechowuje aktualny stan magazynowy, cenę zakupu części oraz informacje o mocach przerobowych.
- **Więzy integralności (Constraints):**
  - `CK_Parts_QuantityNotNegative`: Stan magazynowy nie może być ujemny.
  - `CK_Parts_PriceOverZero`: Cena zakupu części musi być dodatnia.

### Globalne parametry

```SQL
CREATE TABLE dbo.Parameters (
    ID int DEFAULT 1 NOT NULL,
    Margin decimal(3,2)  NOT NULL,
    DiscountStepValue decimal(3,2)  NULL,
    DiscountThreshold decimal(10,2)  NULL,
    MaxDiscount decimal(3,2)  NULL
    CONSTRAINT PK_Parameters PRIMARY KEY (ID),
    CONSTRAINT CK_Parameters_Singleton CHECK (ID = 1),
    CONSTRAINT CK_Parameters_Values
        CHECK (Margin >= 0 AND DiscountStepValue >= 0);
```

- **Opis tabeli:** Tabela jedno-wierszowa (singleton) pełniąca rolę globalnej konfiguracji systemu. Przechowuje kluczowe zmienne sterujące logiką biznesową, wykorzystywane przez funkcje obliczające ceny i rabaty.
- **Więzy integralności (Constraints):**
  - `CK_Parameters_Values`: Pełni rolę bezpiecznika dla logiki biznesowej. Blokuje możliwość wprowadzenia ujemnej marży (`Margin`) oraz ujemnego skoku rabatowego. Zapobiega to błędom w wyliczeniach cen sprzedaży i naliczaniu "odwrotnych" rabatów.

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

- **Opis tabeli:** Tabela definiująca strukturę materiałową produktu. Określa, jakie części i w jakiej ilości są niezbędne do wytworzenia jednej sztuki produktu gotowego.
- **Więzy integralności (Constraints):**
  - `CK_ProductParts_QuantityNotNegative`: Ilość wymaganych części nie może być ujemna.

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

- **Opis tabeli:** Tabela łącząca plany produkcyjne z konkretnymi pozycjami zamówień. Pozwala na rezerwację towaru będącego jeszcze w procesie produkcji pod konkretne zamówienie klienta.
- **Więzy integralności (Constraints):**
  - `CK_ProductionAllocations_QuantityAllocatedNotNegative`: Ilość alokowanego towaru musi być nieujemna.

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

- **Opis tabeli:** Rejestr postępów prac, służący do monitorowania wykonania planu. Przechowuje informacje o ilości wyprodukowanej w danym dniu oraz o kontroli jakości.
- **Więzy integralności (Constraints):**
  - `CK_ProductionDailyLog_QualityStatus`: Pole przyjmuje tylko dwie wartości: `'K'` (Kompletne/Dobra jakość) lub `'F'` (Fail/Odrzut produkcyjny).
  - `CK_ProductionDailyLog_QuantityNotNegative`: Ilość wyprodukowana nie może być ujemna.

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

- **Opis tabeli:** Harmonogram zleceń produkcyjnych. Określa co, ile i na kiedy ma zostać wyprodukowane, wraz z oznaczeniem typu zlecenia.
- **Więzy integralności (Constraints):**
  - `CK_ProductionPlans_ProductionType`: Rozróżnia dwa tryby produkcji: `'C'` (Cykliczna/Na magazyn) oraz `'O'` (On-demand/Pod konkretne zamówienie, gdy brakuje towaru).
  - `CK_ProductionPlans_QuantityNotNegative`: Planowana ilość musi być nieujemna.

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

- **Opis tabeli:** Główna tabela gotowych produktów. Zawiera dane o cenach, kosztach produkcji (wyliczanych), stanach magazynowych oraz maksymalnych mocach przerobowych montażu.
- **Więzy integralności (Constraints):**
  - `QuantityNotNegative`: Stan magazynowy produktu nie może spaść poniżej zera.
  - `AssemblyCapacityNotNegative`: Moc przerobowa (limit produkcyjny) musi być wartością nieujemną.

### Statusy zamówień

```SQL
CREATE TABLE dbo.Status (
    ID int  NOT NULL IDENTITY,
    Name nvarchar(50)  NOT NULL,
    CONSTRAINT PK_Status PRIMARY KEY CLUSTERED (ID)
);
```

- **Opis tabeli:** Słownik definiujący możliwe statusy zamówienia lub planu produkcyjnego (np. "w trakcie", "zakończone").
<!-- - Opis:

| Nazwa atrybutu | Typ | Opis/Uwagi |
| :------------: | :-: | :--------: | --- |
|   Atrybut 1    |     |            |
|   Atrybut 2    |     |            |
|   Atrybut 3    |     |            | --> |

# 3. Widoki, procedury, funkcje i triggery

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

- **Opis:** Widok agregujący pełne dane finansowe każdego zamówienia. Służy do raportowania sprzedaży i wystawiania dokumentów końcowych.
- **Logika:** Widok realizuje przetwarzanie danych w trzech etapach (CTE):
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

- **Opis:** Widok analityczny identyfikujący najlepiej sprzedające się towary. Zwraca listę "Top 3" produktów o największym wolumenie sprzedaży.
- **Logika:** Agreguje dane ze szczegółów zamówień (`OrderDetails`), sumuje sprzedane sztuki dla każdego produktu i sortuje wynik malejąco, ograniczając go do trzech pierwszych rekordów. Służy do planowania produkcji i działań marketingowych.

### Historia zamówień klientów

```SQL
CREATE OR ALTER VIEW vw_ClientOrdersHistory
AS
SELECT
    o.ID AS OrderID,
    o.OrderDate,
    o.EndDate,
    c.ID AS ClientID,
    c.Name AS ClientName,
    p.ID AS ProductID,
    p.Name AS ProductName,
    od.Quantity,
    od.UnitPrice,
    o.Discount,
    (od.Quantity * od.UnitPrice) * (1 - o.Discount) AS FinalValue,
    status.name as status -- jaki status zamowienia
FROM Orders o
JOIN Clients c ON c.ID = o.Client_ID
JOIN OrderDetails od ON od.Order_ID = o.ID
JOIN Products p ON p.ID = od.Product_ID
Join status on status.id=o.status_id;
```

- **Opis:** Szczegółowy rejestr historyczny transakcji z perspektywy klienta. Prezentuje pełne dane o zamówionych produktach, ich cenach jednostkowych oraz zastosowanych rabatach.
- **Logika:** Wykonuje wyliczenie "w locie" ostatecznej wartości pozycji (`FinalValue`), uwzględniając ilość, cenę jednostkową oraz przypisany do zamówienia rabat (wzór: `Ilość * Cena * (1 - Rabat)`).

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

- **Opis:** Widok operacyjny prezentujący aktualną dostępność wyrobów gotowych. Łączy dane o produktach z ich kategoriami, ułatwiając przegląd asortymentu.
- **Logika:** Zwraca kluczowe informacje dla działu sprzedaży: nazwę produktu, kategorię, bieżącą ilość w magazynie, cenę oraz status wycofania ze sprzedaży (`Discontinued`).

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

- **Opis:** Raport inwentaryzacyjny dla surowców i półproduktów. Służy do monitorowania zapasów niezbędnych do produkcji.
- **Logika:** Prezentuje listę części wraz z ich typem (np. metal, plastik) oraz aktualną ilością i ceną zakupu. Jest podstawą do generowania zamówień u dostawców.

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

- **Opis:** Techniczny widok pomocniczy (warstwa pośrednia), stanowiący fundament dla wszystkich raportów kosztowych. Nie jest przeznaczony do bezpośredniego raportowania, lecz do zasilania innych widoków.
- **Logika:**
  - Wykorzystuje funkcję skalarną `dbo.ObliczKosztProdukcji` do ustalenia jednostkowego kosztu wytworzenia.
  - Oblicza całkowity koszt dla danej partii produkcyjnej (`Ilość * Koszt Jednostkowy`).
  - Dokonuje dekompozycji daty zakończenia produkcji na rok, miesiąc i kwartał, co upraszcza późniejsze grupowanie danych.

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

- **Opis:** Pokazuje spis wszystkich zaplanowanych produkcji i informacji o nich wraz ze statusem wykonania.
- **Logika:** Umożliwia filtrowanie historii produkcji po okresach oraz typie zlecenia (Cykliczne vs Na żądanie).

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

- **Opis:** Zaawansowany widok analityczny służący do monitorowania przychodów firmy.
- **Logika:**
  - Agreguje dane sprzedażowe do poziomu Tygodnia, Miesiąca i Roku.
  - Oblicza rzeczywisty przychód (`Revenue`), uwzględniając udzielone rabaty.
  - Grupuje wyniki według kategorii i produktów, co pozwala na badanie sezonowości sprzedaży oraz efektywności poszczególnych grup towarowych.

## Procedury/funkcje

### Typ tabelaryczny: OrderProductType

```SQL
CREATE TYPE dbo.OrderProductType AS TABLE
(
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL
);
```

- **Opis:** User-defined table type umożliwiający przekazanie listy produktów jako parametr do procedury.
- **Zastosowanie:** Używany w procedurze `AddOrder` do obsługi całego koszyka zakupowego w jednym wywołaniu. Pozwala na przekazanie wielu produktów jednocześnie zamiast wywoływania procedury osobno dla każdego produktu.
- **Korzyści:**
  - **Atomowość transakcji:** Całe zamówienie (wszystkie produkty) jest przetwarzane w jednej transakcji.
  - **Wydajność:** Znacząco szybsze niż wielokrotne wywołania procedury w pętli.
  - **Prostota kodu klienta:** Aplikacja może przekazać tablicę produktów bez konieczności iteracji.
  - **Spójność danych:** Gwarancja, że albo wszystkie produkty zostaną dodane do zamówienia, albo żadne (w przypadku błędu).

**Przykład użycia:**

```SQL
-- Deklaracja zmiennej typu tabelarycznego
DECLARE @Koszyk dbo.OrderProductType;

-- Wypełnienie koszyka produktami
INSERT INTO @Koszyk (Product_ID, Quantity)
VALUES
    (1, 2),   -- Produkt ID=1, ilość=2
    (3, 1),   -- Produkt ID=3, ilość=1
    (7, 5);   -- Produkt ID=7, ilość=5

-- Wywołanie procedury z całym koszykiem
EXEC dbo.AddOrder
    @ClientName = 'Jan Kowalski',
    @Email = 'jan.kowalski@example.com',
    @PhoneNumber = '+48123456789',
    @Address = 'ul. Testowa 1',
    @City = 'Warszawa',
    @Country = 'Polska',
    @OrderDate = '2026-01-18',
    @Products = @Koszyk;  -- Przekazanie całej tabeli
```

### Funkcja: Koszt produkcji

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

- **Opis:** Oblicza całkowity koszt materiałowy potrzebny do wytworzenia jednej sztuki produktu.
- **Logika biznesowa:** Funkcja iteruje po strukturze produktu, sumując iloczyny cen zakupu części i ich wymaganej ilości. Wynik stanowi bazę do ustalania ceny sprzedaży. Zabezpieczona przed wartościami `NULL` (zwraca 0 w przypadku braku zdefiniowanych części).

### Funkcja: Cena sprzedaży

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

- **Opis:** Automatycznie generuje sugerowaną cenę detaliczną produktu, zapewniając spójność marży w całym asortymencie.
- **Logika biznesowa:** Pobiera wyliczony wcześniej koszt produkcji i narzuca na niego globalną marżę zdefiniowaną w tabeli konfiguracyjnej `Parameters`. Dzięki temu zmiana marży w jednym miejscu w systemie automatycznie aktualizuje sugerowane ceny wszystkich produktów.

### Funkcja: Wartość koszyka

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

- **Opis:** Szybkie obliczenie wartości brutto pozycji znajdujących się w danym zamówieniu.
- **Logika biznesowa:** Sumuje iloczyn `Ilość * Cena Jednostkowa` dla wszystkich linii danego zamówienia. Stanowi punkt wyjścia do obliczeń rabatowych.

### Funkcja: Algorytm rabatowy

```SQL
CREATE FUNCTION dbo.ObliczZnizke (@WartoscZamowienia DECIMAL(18, 2))
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

- **Opis:** Mechanizm wyliczania dynamicznego rabatu w zależności od wartości zamówienia.
- **Logika biznesowa:** Implementuje progresywny system zniżek oparty na parametrach globalnych:
  - Sprawdza, czy wartość zamówienia przekracza próg minimalny (`DiscountThreshold`).
  - Za każde pełne 100zł powyżej progu dolicza określony procent rabatu (`DiscountStepValue`).
  - Pilnuje, aby wyliczona zniżka nie przekroczyła ustalonego odgórnie limitu (`MaxDiscount`), chroniąc rentowność sprzedaży.

### Procedura: Dodaj kategorię

```SQL
CREATE PROCEDURE dbo.AddCategory
    @Name nvarchar(50)
AS
    INSERT INTO dbo.Categories (Name)
    VALUES (@Name);
```

- **Opis:** Prosta procedura administracyjna służąca do rozbudowy słownika kategorii produktów.
- **Działanie:** Wstawia nowy rekord do tabeli `Categories`, przyjmując jako parametr nazwę kategorii.

### Procedura: Rejestracja klienta

```SQL
CREATE PROCEDURE dbo.AddClient
    @ClientID    INT OUTPUT,
    @Name        NVARCHAR(50),
    @PhoneNumber VARCHAR(15),
    @Address     NVARCHAR(50),
    @City        NVARCHAR(50),
    @Country     NVARCHAR(50),
    @Email       VARCHAR(320) = NULL,
    @NIP         VARCHAR(10)  = NULL,
    @PostalCode  VARCHAR(15)  = NULL
AS
BEGIN
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
            WHEN @NIP IS NOT NULL AND LEN(@NIP) > 0 THEN 'F'
            ELSE 'I'
        END
    );
END
```

- **Opis:** Procedura służąca do wprowadzania nowych kontrahentów do systemu. Obsługuje zarówno klientów indywidualnych, jak i firmy.
- **Logika biznesowa:** Przyjmuje zestaw danych teleadresowych. Pola opcjonalne (takie jak NIP czy Email) mogą przyjmować wartość `NULL`. Procedura jest wykorzystywana zarówno manualnie przez dział sprzedaży, jak i automatycznie przez procedurę składania zamówienia (`AddOrder`), gdy wykryty zostanie nowy klient.

### Procedura: Zarządzanie dniami wolnymi

```SQL
CREATE PROCEDURE dbo.AddDayOff
    @Name      NVARCHAR(100),
    @StartDate DATE,
    @EndDate   DATE = NULL
AS
BEGIN
    INSERT INTO dbo.DaysOff (StartDate, EndDate, Name)
    VALUES (@StartDate, ISNULL(@EndDate, @StartDate), @Name);
END
```

- **Opis:** Narzędzie do zarządzania kalendarzem produkcyjnym firmy. Definiuje okresy przestoju (święta, awarie, przerwy techniczne).
- **Logika:** Wstawia rekord do tabeli `DaysOff`. Posiada mechanizm domyślnej wartości – jeśli nie podano daty końcowej (`EndDate`), system przyjmuje, że przerwa trwa jeden dzień (równa się dacie początkowej).

### Procedura: Definicja składu produktu

```SQL
CREATE PROCEDURE dbo.AddProductPart
    @ProductID int,
    @PartID    int,
    @Quantity  int
AS
    INSERT INTO dbo.ProductParts (Product_ID, Part_ID, Quantity)
    VALUES (@ProductID, @PartID, @Quantity);
```

- **Opis:** Procedura techniczna służąca do definiowania struktury materiałowej produktu. Umożliwia przypisanie konkretnych komponentów do wyrobu gotowego.
- **Działanie:** Wstawia rekord do tabeli łącznikowej `ProductParts`. Określa, jaki surowiec (identyfikowany przez `PartID`) i w jakiej ilości (`Quantity`) jest niezbędny do wytworzenia jednej sztuki danego produktu (`ProductID`). Wielokrotne wywołanie tej procedury dla jednego produktu pozwala zbudować jego kompletną listę części.

### Procedura: Złóż zamówienie

```SQL
CREATE OR ALTER   PROCEDURE dbo.AddOrder
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
    @Products dbo.OrderProductType READONLY -- koszyk zdefiniowany przez klienta
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

        --jesli bysmy chcieli zwracac id produktu ktorego nie mozna zamowic
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

            SET @ClientID = SCOPE_IDENTITY(); --zwraca ostatnią wartość kolumny IDENTITY wygenerowana wczesniej
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
                SET EndDate = dbo.CalculateEndDate(@OrderDate, 1) --zakladamy ze czas realizacji to min 1 dzien
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
        IF @@TRANCOUNT > 0 --jesli transakcja dalej otwarta mimo ze powinna sie zakonczyc
            ROLLBACK TRAN;

        THROW;
    END CATCH
END

GO
```

- **Opis:** Procedura transakcyjna realizująca proces sprzedaży oraz integrująca sprzedaż z magazynem i produkcją.
- **Parametry:** Przyjmuje dane klienta oraz listę produktów (jako typ tabelaryczny `OrderProductType`), co pozwala na obsłużenie całego koszyka w jednym wywołaniu.
- **Logika biznesowa:**
  1. **Walidacja wstępna:** Zanim rozpocznie się transakcja, system weryfikuje poprawność koszyka. Blokuje próbę złożenia pustego zamówienia, zamówienia produktu nieistniejącego lub produktu wycofanego.
  2. **Identyfikacja klienta:** Sprawdza, czy klient istnieje w bazie. Jeśli nie – automatycznie tworzy rekord z danymi nowego klienta.
  3. **Rejestracja zamówienia:** Tworzy nagłówek zamówienia i wpisuje pozycje do `OrderDetails`, pobierając aktualne ceny z tabeli `Products`.
  4. **Weryfikacja magazynu (Pętla):** Dla każdego produktu sprawdza dostępność (`Quantity`):
     - **Towar dostępny:** Rezerwuje towar (zmniejsza stan magazynowy) i ustawia szybką datę realizacji.
     - **Brak towaru:**
       1. Konsumuje resztki z magazynu (jeśli są).
       2. Oblicza brakującą ilość.
       3. Na podstawie mocy przerobowej (`AssemblyCapacity`) wylicza potrzebny czas produkcji.
       4. Tworzy dedykowany **Plan Produkcji** (typ `'O'` - On-demand).
       5. Tworzy **Alokację**, przypisując przyszłą produkcję do tego konkretnego zamówienia.
  5. **Wyliczanie terminu:** Aktualizuje datę zakończenia zamówienia (`EndDate`), przyjmując najdalszy termin z wygenerowanych planów produkcyjnych.
  6. **Finalizacja:** Zatwierdza transakcję i zwraca ID zamówienia oraz ostateczną kwotę do zapłaty (po uwzględnieniu automatycznych rabatów).

### Funkcja: Oblicz datę zakończenia

```SQL
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
```

- **Opis:** Funkcja pomocnicza służąca do precyzyjnego planowania terminów.
- **Logika:** Oblicza datę zakończenia prac, dodając do daty startowej określoną liczbę dni roboczych. Algorytm w pętli sprawdza każdy kolejny dzień w tabeli `DaysOff` – jeśli dzień jest wolny, nie jest wliczany do czasu realizacji. Zapewnia to realne terminy wykonania zleceń.

### Procedura: Dziennik produkcji

```SQL
CREATE PROCEDURE dbo.CreateDailyLog
    @ProductionPlanID int,
    @DailyLog         nvarchar(100),
    @Quantity         int,
    @QualityStatus    char(1)
AS
    INSERT INTO dbo.ProductionDailyLog (ProductionPlan_ID, DailyLog, Quantity, QualityStatus)
    VALUES (@ProductionPlanID, @DailyLog, @Quantity, @QualityStatus);
```

- **Opis:** Procedura operacyjna dla pracowników produkcji/magazynu.
- **Działanie:** Rejestruje postęp prac nad konkretnym planem produkcyjnym. Zapisuje ilość wyprodukowaną w danym dniu, notatkę (log) oraz status kontroli jakości (`'K'` - OK, `'F'` - Błąd).

### Procedura: Wycofanie produktu

```SQL
CREATE PROCEDURE dbo.DiscontinueProduct
    @ProductID int
AS
    UPDATE dbo.Products
    SET Discontinued = 1
    WHERE ID = @ProductID;
```

- **Opis:** Procedura realizująca tzw. "miękkie usuwanie" (soft delete).
- **Działanie:** Zamiast fizycznie usuwać rekord (co naruszyłoby więzy integralności historycznych zamówień), ustawia flagę `Discontinued` na 1. Produkt przestaje być widoczny w ofercie, ale pozostaje w historii.

### Procedury: Konfiguracja parametrów globalnych

```SQL
CREATE PROCEDURE dbo.UpdateDiscountStepValue
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters
    SET DiscountStepValue = @Value
    WHERE ID = 1;
```

```SQL
CREATE PROCEDURE dbo.UpdateDiscountThreshold
    @Value decimal(10, 2)
AS
    UPDATE dbo.Parameters
    SET DiscountThreshold = @Value
    WHERE ID = 1;
```

```SQL
CREATE PROCEDURE dbo.UpdateMargin
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters
    SET Margin = @Value
    WHERE ID = 1;
```

```SQL
CREATE PROCEDURE dbo.UpdateMaxDiscount
    @Value decimal(3, 2)
AS
    UPDATE dbo.Parameters
    SET MaxDiscount = @Value
    WHERE ID = 1;
```

Zestaw procedur administracyjnych służących do zarządzania tabelą `Parameters` (singletonem konfiguracyjnym). Umożliwiają zmianę polityki cenowej "na żywo", bez konieczności modyfikacji kodu systemu:

- **`dbo.UpdateMargin`:** Zmienia globalny narzut (marżę) na produkty, co wpływa na sugerowane ceny sprzedaży.
- **`dbo.UpdateDiscountThreshold`:** Ustawia minimalną kwotę zamówienia, od której naliczany jest rabat.
- **`dbo.UpdateDiscountStepValue`:** Określa, o ile procent rośnie rabat za każde przekroczenie progu kwotowego.
- **`dbo.UpdateMaxDiscount`:** Definiuje górny limit możliwego do uzyskania rabatu (bezpiecznik finansowy).

### Procedura: Obsługa awarii jakościowej

```SQL
CREATE OR ALTER PROCEDURE dbo.sp_ProcessQualityFailure
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

        -- KROK 1. Ewentualne podkradanie (Kanibalizacja planów cyklicznych)
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
```

- **Opis:** Zaawansowana procedura naprawcza uruchamiana w momencie zgłoszenia odrzutu produkcyjnego (QualityStatus = 'F'). Jej celem jest zminimalizowanie opóźnienia zamówienia klienta poprzez inteligentną realokację zasobów.
- **Logika biznesowa:**
    1. **"Podkradanie":** System sprawdza, czy istnieją inne plany produkcyjne dla tego samego produktu, które są typu cyklicznego ('C') (czyli robione na magazyn, a nie pod klienta). Jeśli tak, procedura "zabiera" z nich wyprodukowane sztuki i przesuwa je do zagrożonego zamówienia.
    2. **Plan awaryjny:** Jeśli nie można pokryć braku z planów cyklicznych, procedura tworzy nowy plan produkcyjny typu On-demand ('O') na brakującą ilość.
    3. **Rekalkulacja terminów:** Oblicza nowy termin zakończenia zamówienia i aktualizuje go w tabeli Orders.
    4. **Powiadomienia:** Jeśli data realizacji uległa przesunięciu, generuje komunikat w formacie JSON (symulacja wysyłki maila/SMS do klienta).

## Triggery

### Walidacja przejść statusów planu produkcyjnego

**Cel:** Zapobieganie nieprawidłowym zmianom statusu (np. z 'Zakończony' na 'W trakcie').

**Dlaczego trigger?** Constraint CHECK nie może sprawdzać poprzedniej wartości, a procedury nie zadziałają przy bezpośrednim UPDATE.

```sql
CREATE   TRIGGER trg_ProductionPlans_ValidateStatus
    ON dbo.ProductionPlans
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

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
```

### Automatyczna reakcja na błędy jakościowe

```SQL
CREATE OR ALTER TRIGGER trg_ProductionDailyLog_QualityCheck
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
```

- **Opis:** Trigger łączący wprowadzanie danych przez pracowników z logiką naprawczą systemu.
- **Działanie:** Monitoruje tabelę `ProductionDailyLog`. W momencie pojawienia się wpisu o statusie 'F' (Fail) automatycznie wywołuje procedurę `sp_ProcessQualityFailure`.
- **Bezpieczeństwo danych:** Wykorzystuje mechanizm SAVE TRANSACTION. Jeśli procedura naprawcza zawiedzie z powodu błędu, trigger wycofuje tylko tę procedurę, ale pozwala na zapisanie raportu pracownika. Dzięki temu informacja o błędzie nie ginie, nawet jeśli system nie potrafi automatycznie naprawić harmonogramu.

# 4. Role i Uprawnienia

### Model uprawnień

W systemie wdrożono model bezpieczeństwa oparty na rolach, co zapewnia separację obowiązków i minimalizację ryzyka nieuprawnionego dostępu do danych wrażliwych.

1. **Rola Zarządcza (`Rola_Zarzad`)**
   - **Przeznaczenie:** Dla kadry kierowniczej i analityków biznesowych.
   - **Uprawnienia:** Wyłącznie odczyt (`SELECT`) wszystkich danych w schemacie. Umożliwia generowanie raportów bez ryzyka przypadkowej modyfikacji danych operacyjnych.

2. **Rola Sprzedażowa (`Rola_Sprzedaz`)**
   - **Przeznaczenie:** Dla pracowników obsługi klienta.
   - **Uprawnienia:** Pełna edycja danych klientów i zamówień. Dostęp do katalogu produktów jest ograniczony do odczytu (sprawdzanie dostępności i cen), co uniemożliwia sprzedawcom manipulację cenami bazowymi.

3. **Rola Planistyczna (`Rola_Planista`)**
   - **Przeznaczenie:** Dla managerów produkcji.
   - **Uprawnienia:** Pełna kontrola nad definicjami produktów, recepturami (BOM), planami produkcyjnymi oraz globalnymi parametrami systemu (marże, progi rabatowe). Jest to rola o najwyższym wpływie na logikę biznesową systemu.

4. **Rola Magazynowa (`Rola_Magazyn`)**
   - **Przeznaczenie:** Dla pracowników magazynu i hali produkcyjnej.
   - **Uprawnienia:** Zarządzanie stanami surowców (`Parts`) oraz raportowanie postępów produkcji (`ProductionDailyLog`). Rola posiada specyficzne uprawnienie do aktualizacji _tylko_ stanu magazynowego produktów gotowych (`UPDATE ON Products (Quantity)`), bez możliwości zmiany ich nazw czy cen.

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

# 5. Indeksy

## Indeksy na klucze obce

```SQL
-- Tabela: OrderDetails
CREATE INDEX IX_OrderDetails_OrderID
    ON dbo.OrderDetails(Order_ID);

CREATE INDEX IX_OrderDetails_ProductID
    ON dbo.OrderDetails(Product_ID);

-- Tabela: Orders
CREATE INDEX IX_Orders_ClientID
    ON dbo.Orders(Client_ID);

CREATE INDEX IX_Orders_StatusID
    ON dbo.Orders(Status_ID);

-- Tabela: Products
CREATE INDEX IX_Products_CategoryID
    ON dbo.Products(Category_ID);

-- Tabela: ProductParts
CREATE INDEX IX_ProductParts_PartID
    ON dbo.ProductParts(Part_ID);
-- Uwaga: Product_ID już ma indeks jako część klucza złożonego PK

-- Tabela: Parts
CREATE INDEX IX_Parts_PartTypeID
    ON dbo.Parts(PartType_ID);

-- Tabela: ProductionPlans
CREATE INDEX IX_ProductionPlans_ProductID
    ON dbo.ProductionPlans(Product_ID);

CREATE INDEX IX_ProductionPlans_StatusID
    ON dbo.ProductionPlans(Status_ID);

-- Tabela: ProductionAllocations
CREATE INDEX IX_ProductionAllocations_ProductionPlansID
    ON dbo.ProductionAllocations(ProductionPlans_ID);

CREATE INDEX IX_ProductionAllocations_OrderDetailsID
    ON dbo.ProductionAllocations(OrderDetails_ID);

-- Tabela: ProductionDailyLog
CREATE INDEX IX_ProductionDailyLog_ProductionPlanID
    ON dbo.ProductionDailyLog(ProductionPlan_ID);
```

**Uzasadnienie:** Indeksy na kluczach obcych przyspieszają operacje JOIN, które stanowią podstawę większości zapytań analitycznych i raportowych w systemie.

## Indeksy na kolumny w klauzulach WHERE i JOIN

Kolumny często używane do filtrowania danych wymagają dedykowanych indeksów dla optymalnej wydajności.

```SQL
-- Nazwa klienta - często wyszukiwana podczas składania zamówień
CREATE INDEX IX_Clients_Name
    ON dbo.Clients(Name);

-- Email klienta - używany do identyfikacji w procedurze AddOrder
CREATE INDEX IX_Clients_Email
    ON dbo.Clients(Email);

-- NIP - wyszukiwanie klientów firmowych
CREATE INDEX IX_Clients_NIP
    ON dbo.Clients(NIP)
    WHERE NIP IS NOT NULL;  -- indeks filtrowany (oszczędność miejsca)

-- Typ klienta - segregacja raportów
CREATE INDEX IX_Clients_ClientType
    ON dbo.Clients(ClientType);

-- Status produktu (wycofany/aktywny) - filtrowanie oferty
CREATE INDEX IX_Products_Discontinued
    ON dbo.Products(Discontinued);

-- Typ produkcji - rozróżnienie produkcji cyklicznej i na zamówienie
CREATE INDEX IX_ProductionPlans_ProductionType
    ON dbo.ProductionPlans(ProductionType);

-- Status kontroli jakości w logach produkcyjnych
CREATE INDEX IX_ProductionDailyLog_QualityStatus
    ON dbo.ProductionDailyLog(QualityStatus);
```

**Uzasadnienie:** Kolumny używane w warunkach WHERE są naturalnymi kandydatami na indeksy. Indeks filtrowany na `NIP` (tylko dla wartości NOT NULL) oszczędza miejsce, ponieważ nie wszyscy klienci są firmami.

## Indeksy na daty dla raportów

System raportowy intensywnie wykorzystuje kolumny dat do agregacji i filtrowania w różnych przedziałach czasowych (dzień, tydzień, miesiąc, kwartał, rok).

```SQL
-- Data zamówienia - podstawa raportów sprzedaży
CREATE INDEX IX_Orders_OrderDate
    ON dbo.Orders(OrderDate);

-- Data zakończenia zamówienia - monitoring terminowości
CREATE INDEX IX_Orders_EndDate
    ON dbo.Orders(EndDate);

-- Data zakończenia planu produkcji - planowanie harmonogramów
CREATE INDEX IX_ProductionPlans_EndDate
    ON dbo.ProductionPlans(EndDate);

-- Data wpisu w dzienniku produkcji - monitoring postępów
CREATE INDEX IX_ProductionDailyLog_Date
    ON dbo.ProductionDailyLog(Date);

-- Zakres dni wolnych - weryfikacja dostępności w funkcji CalculateEndDate
CREATE INDEX IX_DaysOff_DateRange
    ON dbo.DaysOff(StartDate, EndDate);
```

**Uzasadnienie:** Widoki raportowe (`vw_Sales_Report`, `vw_ProductionCost_Monthly`, itp.) zawierają funkcje `YEAR()`, `MONTH()`, `DATEPART(QUARTER, ...)` oraz warunki filtrujące po zakresach dat.

3. **Koszt indeksów**: Każdy indeks przyspiesza odczyt, ale spowalnia operacje `INSERT`, `UPDATE` i `DELETE`. Należy znaleźć równowagę między wydajnością odczytu a zapisem.

---
