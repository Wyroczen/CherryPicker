### 🍒 CherryPicker Nightly Build (__SHORT_SHA__)
Automatyczny build deweloperski z najnowszego stanu gałęzi `main`.

* **Ostatni commit:** __COMMIT_MSG__ (`__SHORT_SHA__`)
* **Architektura:** Apple Silicon (`arm64`)

#### Jak zainstalować:
1. Pobierz plik `__DMG_NAME__` poniżej.
2. Otwórz pobrany obraz DMG i przeciągnij **CherryPicker** do folderu **Applications**.
3. Przy pierwszym uruchomieniu system macOS wyświetli ostrzeżenie Gatekeepera (ponieważ aplikacja jest darmowym projektem open-source bez płatnego certyfikatu deweloperskiego Apple):
   - Wejdź w **Ustawienia systemowe -> Prywatność i bezpieczeństwo**, przewiń na dół i kliknij **Otwórz mimo to**.
   - Albo uruchom w Terminalu:
     ```bash
     xattr -cr /Applications/CherryPicker.app
     ```
