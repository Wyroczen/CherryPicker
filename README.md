# CherryPicker 🍒

Ultralekki, natywny launcher aplikacji i menedżer okien dla systemu macOS, napisany w **czystym Swift / SwiftUI / AppKit** bez żadnych zewnętrznych zależności.

---

## Funkcjonalności

### 1. Nowoczesny Wygląd Liquid Glass & Architektura Pływającego Szkła
- **Materiały szklane macOS (Liquid Glass)**: Półprzezroczyste tło `NSVisualEffectView` z miękkim gradientem zwierciadlanym (specular highlight) o grubości 1px.
- **Organiczne zaokrąglenia**: Łagodne krawędzie głównego panelu HUD z promieniem 26px (`continuous style`).
- **Pływające szkło o wysokiej gęstości (Full-Bleed Floating Glass)**: Lista wyników rozciąga się pod spodem na pełną wysokość okna, eliminując jakiekolwiek sztuczne linie podziału czy pasy na środku okna.
- **Łagodna rampa krycia (Soft Entry Ramp)**:
  - W strefie wpisywania tekstu obowiązuje pełne 90% krycia i głębokie rozmycie, dzięki czemu tekst wyszukiwarki jest w 100% czytelny, a przewijane wiersze stają się niewidoczne w tle.
  - Pomiędzy polem tekstowym a listą zastosowano łagodną rampę (płynny wzrost krycia z 0% do 90%), dzięki czemu elementy miękko wsuwają się pod nagłówek bez nagłego skoku optycznego.
- **Subtelny pasek akcji**: Dyskretna pływająca stopka ze statusem bieżącego zaznaczenia oraz czytelnym keycapem `↵ Wykonaj`.

### 2. Dynamiczne Ikony Podglądu Okna (Window Preview Icons)
- Zamiast statycznych, niedokładnych symboli, każde polecenie zmiany geometrii posiada dedykowaną, wektorową miniaturę monitora (`WindowPreviewIcon`):
  - Błękitny gradient ekranu macOS (`#38bdf8` -> `#2563eb`).
  - Ciemna matryca z precyzyjnie wyliczonym białym oknem, odpowiadającym rzeczywistemu ułamkowi i położeniu na ekranie (`0.0 ... 1.0`).
  - Pełne odwzorowanie dla wszystkich 47 dostępnych układów.

### 3. Zarządzanie Oknami (Window Management)
- Natychmiastowe skalowanie i przesuwanie aktywnego okna z obsługą ponad 40 geometrii:
  - **Połówki**: Lewa (`Left Half`), Prawa (`Right Half`), Górna (`Top Half`), Dolna (`Bottom Half`), Środkowa (`Center Half`).
  - **Jedna trzecia (1/3)**: `First Third`, `Center Third`, `Last Third`, `Top Third`, `Middle Third`, `Bottom Third`.
  - **Dwie trzecie (2/3)**: `First Two Thirds`, `Center Two Thirds`, `Last Two Thirds`, `Top Two Thirds`, `Bottom Two Thirds`, `Top/Bottom Center Two Thirds`.
  - **Ćwiartki i Trzy czwarte (1/4 & 3/4)**: 4 narożne ćwiartki, 4 pionowe kolumny, 4 poziome pasy oraz układy 75% szerokości/wysokości.
  - **Szóstki (1/6)**: Siatka 3 kolumny x 2 rzędy (`Top/Bottom Left, Center, Right Sixth`).
  - **Maksymalizacja i Skalowanie**: `Maximize` (100%), `Almost Maximize` (90%), `Maximize Height`, `Maximize Width`, `Reasonable Size` (60%, max 1024x900) oraz `Center`.
- **Obejście dla aplikacji Electron/Chromium**: Automatyczne tymczasowe wyłączanie `AXEnhancedUserInterface`, zapobiegające zamrażaniu manipulacji oknem w aplikacjach takich jak Slack, Discord czy VS Code.
- **Odwrócenie osi współrzędnych**: Dokładna konwersja ramki roboczej z Cocoa (`NSScreen.visibleFrame`, punkt (0,0) na dole) do układu Accessibility (punkt (0,0) na górze), omijając pasek menu i Dock.
- **Sekwencja trójkroku**: Zastosowanie `Pozycja -> Rozmiar -> Pozycja` eliminuje błędy blokowania geometrii przez WindowServer na krawędziach wyświetlacza.

### 4. Zunifikowana Wyszukiwarka (Spotlight & Polecenia)
- **Polecenia okien w głównej liście**: Sterowanie oknami jest pełnoprawnym elementem listy wyszukiwania (oznaczonym etykietą `Polecenie`).
- Wyszukiwanie z obsługą polskich i angielskich aliasów (np. *"lewo"*, *"left"*, *"trzecia"*, *"third"*, *"max"*, *"ćwiartka"*).
- **Podsystem zapytań CoreServices `MDQuery`**: Wywołanie synchroniczne `MDQueryCreate` z predykatem `kMDItemContentTypeTree == 'com.apple.application-bundle'`.
- Błyskawiczny czas odpowiedzi (~2-5 ms) zamiast wolnego przeszukiwania dysku przez `FileManager`.
- Filtrowanie katalogu `/System/Library/` (eliminacja zbędnych procesów pomocniczych macOS).
- Sortowanie według daty ostatniego otwarcia (`kMDItemLastUsedDate` / MRU).
- Wyszukiwanie plików systemowych w czasie rzeczywistym w tle.

### 5. Pływający Panel HUD
- Działa jako proces pomocniczy (`.accessory` / odpowiednik `LSUIElement = true`) – brak ikony w Docku i `Cmd+Tab`.
- Klasa `NSPanel` z `.nonactivatingPanel`, `level = .floating` oraz `.canJoinAllSpaces, .fullScreenAuxiliary`.
- **Śledzenie historii aktywacji (`FrontmostAppTracker`)**: Inteligentne przywracanie fokusu do właściwej docelowej aplikacji przed zmianą geometrii okna.
- Globalny skrót: **`Option + Spacja`** (`⌥ + Space`) rejestrowany przez Carbon `RegisterEventHotKey`.
- **Nawigacja strzałkami**: Klawisze `↑` / `↓` płynnie przewijają listę wyników, `Enter` wykonuje akcję, a `ESC` zamyka HUD.

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