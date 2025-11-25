# PROJEKT_BD_2025

**Products** – najważniejsza tabela, tu mamy wszystkie produkty:
- **Quantity** – aktualna ilość w magazynie
- **Cost** – koszt wyprodukowania
- **Assembly time** – czas złożenia produktu, gdy wszystkie części są dostępne

**Product parts** – tabela łącznikowa między Products a Parts:
- **Quantity** – np. ile śrubek potrzeba do złożenia krzesła

**Parts**:
- **Quantity** – ile danej części mamy w magazynie
- **Production time** – ile czasu zajmuje wyprodukowanie tej części

**Part types** – typ części (np. tworzywo, element łączący, metal), aby zamiast stringa używać ID
**Categories** w Products – zamiast wpisywać kategorię, używamy ID

**Clients** – obejmuje osoby indywidualne i firmy:
- **Name** – nazwa firmy lub imię i nazwisko osoby
- **NIP** – opcjonalny, bo klienci indywidualni go nie mają

**Orders**:
- **Order date** – data zamówienia
- **Required date** – data, kiedy klient chce, żeby zamówienie było gotowe

Status zamówień ustalany na podstawie **production time** części i **assembly time** produktów:
- Jeśli brak gotowego produktu w magazynie i **required date** jest zbyt szybkie, trigger ustawia status na **anulowane**
- Statusy mogą być też: **w trakcie** lub **zrealizowane**

**Price** i **Discount**:
- Discount może być automatycznie aktualizowany przez trigger np. przy większych zamówieniach

**Order details** – tu zapisujemy, ile i jakie produkty są w danym zamówieniu

**Production plans** – rekordy tylko wtedy, gdy trzeba wyprodukować brakujące produkty:
- Przykład: ktoś zamówił 6 krzeseł, w magazynie są 4, więc 2 trzeba wyprodukować
- **Quantity** – ilość do wyprodukowania
- **Status ID** – tylko **w trakcie** lub **zrealizowane**
- **End date** – data zakończenia produkcji, może być wcześniej niż **required date**
