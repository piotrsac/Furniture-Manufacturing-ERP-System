


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
- System pobiera dane o czasie pracy.
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
- Klient lub dział sprzedaży potwierdza zamówienie.

---

### UC5: Planowanie produkcji
**Aktor:** Planista produkcji  
**Cel:** Utworzenie planu produkcji.  

#### Główny przebieg:
- System pobiera zamówienia wymagające produkcji.
- System analizuje dostępność części.
- System określa wymagany czas produkcji.
- System generuje propozycję planu produkcji.
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

