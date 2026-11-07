# CherryPicker 🍒

Ultralekki, natywny launcher aplikacji i menedżer okien dla systemu macOS, napisany w **czystym Swift / SwiftUI / AppKit** bez żadnych zewnętrznych zależności.

---

## Funkcjonalności

### 1. Zarządzanie Oknami (Window Management)
- Natychmiastowe skalowanie i przesuwanie aktywnego okna:
  - **Połówki**: Lewa (`Left Half`), Prawa (`Right Half`), Górna (`Top Half`), Dolna (`Bottom Half`)
  - **Maksymalizacja**: `Maximize` (pełne dopasowanie bez tworzenia nowego macOS Space)
  - **Centrowanie**: `Center`
  - **Ćwiartki**: 4 narożniki ekranu
- **Obejście dla aplikacji Electron/Chromium**: Automatyczne tymczasowe wyłączanie `AXEnhancedUserInterface`, zapobiegające zamrażaniu manipulacji oknem w aplikacjach takich jak Slack, Discord czy VS Code.
- **Odwrócenie osi współrzędnych**: Dokładna konwersja ramki roboczej z Cocoa (`NSScreen.visibleFrame`, punkt (0,0) na dole) do układu Accessibility (punkt (0,0) na górze), omijając pasek menu i Dock.
- **Sekwencja trójkroku**: Zastosowanie `Pozycja -> Rozmiar -> Pozycja` eliminuje błędy blokowania geometrii przez WindowServer na krawędziach wyświetlacza.

### 2. Wyszukiwanie Aplikacji i Plików (Spotlight Search)
- **Podsystem zapytań CoreServices `MDQuery`**: Wywołanie synchroniczne `MDQueryCreate` z predykatem `kMDItemContentTypeTree == 'com.apple.application-bundle'`.
- Błyskawiczny czas odpowiedzi (~2-5 ms) zamiast wolnego przeszukiwania dysku przez `FileManager`.
- Filtrowanie katalogu `/System/Library/` (eliminacja zbędnych procesów pomocniczych macOS).
- Sortowanie według daty ostatniego otwarcia (`kMDItemLastUsedDate` / MRU).
- Wyszukiwanie plików systemowych w czasie rzeczywistym.

### 3. Pływający Panel HUD
- Działa jako proces pomocniczy (`.accessory` / odpowiednik `LSUIElement = true`) – brak ikony w Docku i `Cmd+Tab`.
- Klasa `NSPanel` z `.nonactivatingPanel`, `level = .floating` oraz `.canJoinAllSpaces, .fullScreenAuxiliary`.
- Globalny skrót: **`Option + Spacja`** (`⌥ + Space`) rejestrowany przez Carbon `RegisterEventHotKey` (brak potrzeby ciągłego podsłuchiwania klawiatury).
- Zamykanie klawiszem `ESC`.

---

## Wymagania

- macOS 13.0 (Ventura) lub nowszy
- Swift 5.9+ / Swift 6+
- Uprawnienia **Dostępności** (Accessibility) w systemie macOS

---

## Uruchomienie

1. Sklonuj repozytorium i przejdź do katalogu projektu:
   ```bash
   git clone https://github.com/Wyroczen/CherryPicker.git
   cd CherryPicker
   ```

2. Zbuduj i uruchom aplikację:
   ```bash
   swift run
   ```

3. Przy pierwszym uruchomieniu nadaj uprawnienia **Dostępności**:
   - `Ustawienia systemowe -> Prywatność i bezpieczeństwo -> Dostępność`.
   - Zezwól na dostęp dla aplikacji lub Twojego terminala.

4. Wciśnij **`Option + Spacja`**, aby wywołać HUD.
