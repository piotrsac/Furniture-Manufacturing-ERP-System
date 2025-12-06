


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
Aktor: Administrator / Planista produkcji
Opis: Dodanie nowego produktu, kategorii, ceny itp.

### UC2: Obliczenie kosztu produkcji
Aktor: Planista produkcji
Dane wejściowe: ID produktu
System: sumuje koszty części, czas robocizny.
Wynik: koszt jednostkowy.

### UC3: Sprawdzenie dostępności magazynowej
Aktor: Magazynier / System produkcji
Dane: ID produktu
Wynik: status (dostępny / brak części / brak produktu).

### UC4: Złożenie zamówienia
Aktor: Klient / Dział sprzedaży
Kroki:
klient wybiera produkty,
system sprawdza stany,
dodaje rabaty,
przelicza koszt,
rejestruje zamówienie.
### UC5: Planowanie produkcji
Aktor: Planista
System:
sprawdza zamówienia wymagające produkcji,
analizuje stany części,
określa czas wykonania,
tworzy plan produkcji.
### UC6: Realizacja produkcji
Aktor: Produkcja
System:
pobiera części z magazynu,
aktualizuje stany,
dodaje produkt do magazynu.
### UC7: Generowanie raportów
Aktor: Zarząd / Analityk
Rodzaje raportów:
koszty produkcji (różne okresy),
stany magazynowe,
zamówienia klientów,
sprzedaż tygodniowa/miesięczna,
plany produkcji.



[TODO: #1 np. lista wymagań, doprecyzowanie wymagań, ,np. historyjki użytkownika, np. przypadki użycia itp.]: #

## 2. Baza danych

### Schemat bazy danych

[TODO: #2 diagram (rysunek) przedstawiający schemat bazy danych]: #

### Opis poszczególnych tabel

[TODO: #3 Dla każdej tabeli kod DDL wraz z zaimplementowanymi war. integralności, + ewentualnie opis, np. w formie tabelki]: #

```sql
create table tab1 (
   a int,
   b varchar(10)
);
```
- Opis:

| Nazwa atrybutu | Typ | Opis/Uwagi |
| :------------: | :-: | :--------: |
|    Atrybut 1   |     |            |
|    Atrybut 2   |     |            |
|    Atrybut 3   |     |            |

<!-- Jak ktos woli tabelke w html -->
<!-- <table style="border-collapse: collapse; width: 100%; text-align: center;">
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="border: 1px solid #dddddd; padding: 8px;">Nazwa atrybutu</th>
      <th style="border: 1px solid #dddddd; padding: 8px;">Typ</th>
      <th style="border: 1px solid #dddddd; padding: 8px;">Opis/Uwagi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #dddddd; padding: 8px;">Atrybut 1</td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
    </tr>
    <tr>
      <td style="border: 1px solid #dddddd; padding: 8px;">Atrybut 2</td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
    </tr>
    <tr>
      <td style="border: 1px solid #dddddd; padding: 8px;">Atrybut 3</td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
      <td style="border: 1px solid #dddddd; padding: 8px;"></td>
    </tr>
  </tbody>
</table> -->


[Chyba na razie nie potrzebne?]: #

<!-- # 3.  Widoki, procedury/funkcje, triggery


## Widoki

(dla każdego widoku należy wkleić kod polecenia definiującego widok wraz z komentarzem)

```sql
create or alter view vw_abc
as
select a from tab1
```


## Procedury/funkcje

(dla każdej procedury/funkcji należy wkleić kod polecenia definiującego procedurę wraz z komentarzem)

```sql
-- ...
```

## Triggery

(dla każdego triggera należy wkleić kod polecenia definiującego trigger wraz z komentarzem)

```sql
-- ...
```


# 4. Inne

(informacja o sposobie wygenerowania danych, uprawnienia …) -->

