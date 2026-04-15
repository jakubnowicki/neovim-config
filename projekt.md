# Neovim – Plan budowy przenośnej konfiguracji (krok po kroku)

## Cel

Zbudować **lekki, przenośny i zrozumiały setup Neovim**, który:
- działa w środowiskach klientów (często ograniczonych),
- nie wymaga specjalnych fontów ani GUI,
- wspiera: **R (Shiny), Python, JavaScript, CSS/Sass, SQL**,
- integruje się z narzędziami AI (Copilot, Claude Code),
- jest rozwijany **stopniowo, w pełni świadomie**.

---

## Główne założenia

### 1. Minimalizm > „pełne IDE”
Nie budujemy od razu rozbudowanego środowiska. Każdy element dodajemy świadomie.

### 2. Terminal-first
Terminal jest centralnym elementem workflow:
- uruchamianie R / Shiny
- git
- testy
- Claude Code

Bez polegania na pluginach – najpierw wbudowany terminal Neovim.

### 3. Brak zależności od Nerd Fonts
Setup musi działać w „biednych” środowiskach:
- brak ikon jako założenia
- brak fancy UI
- czytelność w zwykłym terminalu

### 4. Każdy krok jest zrozumiały i odwracalny
Po każdym etapie:
- wiesz co zostało dodane
- wiesz jak to wyłączyć
- wiesz jak debugować

### 5. Jedna zmiana = jeden commit
Config jako repozytorium:
- historia = dokumentacja
- łatwy rollback

---

## Architektura docelowa

Config powinien być:
- przenośny (`git clone ~/.config/nvim`)
- modularny (`lua/config`, `lua/plugins`)
- stabilny (lockfile pluginów)
- prosty (bez zbędnych warstw)

---

## Plan krok po kroku

## Etap 1 — Minimalny Neovim (bez pluginów)

**Cel:**
- własny `init.lua`
- podstawowe ustawienia
- pierwsze keymapy

**Zrozumienie:**
- jak ładuje się config
- czym jest `init.lua`
- jak działa Lua w Neovim

---

## Etap 2 — Terminal (kluczowy element)

**Cel:**
- korzystanie z `:terminal`
- własne skróty:
  - otwieranie terminala (split poziomy/pionowy)
  - przełączanie między trybami

**Dlaczego teraz:**
- fundament workflow
- działa wszędzie
- zero zależności

**Use case:**
- R / Shiny
- git
- Claude Code
- npm / python / SQL

---

## Etap 3 — Manager pluginów

**Narzędzie:**
- `lazy.nvim`

**Cel:**
- instalacja pluginów
- lazy loading
- kontrola wersji (lockfile)

**Zrozumienie:**
- gdzie są pluginy
- jak są ładowane
- jak wygląda konfiguracja pluginu

---

## Etap 4 — Pierwszy plugin użytkowy

**Propozycja:**
- `which-key.nvim` lub `telescope.nvim`

**Cel:**
- pierwszy realny boost ergonomii
- bez dużej złożoności

---

## Etap 5 — Treesitter

**Cel:**
- lepsze podświetlanie
- lepsza nawigacja po kodzie

**Zrozumienie:**
- parsery per język
- różnica vs klasyczne highlight

---

## Etap 6 — LSP (dla jednego języka)

**Narzędzia:**
- wbudowany `vim.lsp`
- `nvim-lspconfig`
- opcjonalnie `mason.nvim`

**Cel:**
- autouzupełnianie
- definicje
- rename
- diagnostics

**Ważne:**
- tylko jeden język na start (np. R lub Python)

---

## Etap 7 — Completion

**Narzędzie:**
- `blink.cmp`

**Cel:**
- UI do autouzupełniania

**Zrozumienie:**
- LSP ≠ completion
- źródła podpowiedzi

---

## Etap 8 — Formatowanie

**Narzędzie:**
- `conform.nvim`

**Cel:**
- formatowanie kodu

**Zasada:**
- najpierw jeden język
- bez globalnego format-on-save

---

## Etap 9 — Workflow R / Shiny

**Narzędzie:**
- `R.nvim`

**Cel:**
- integracja z R
- wysyłanie kodu
- praca z sesją

---

## Etap 10 — AI

**Kolejność:**
1. GitHub Copilot
2. Claude Code

**Zasada:**
- AI na końcu (nie maskuje braków w setupie)

**Podejście:**
- Copilot jako plugin
- Claude Code głównie przez terminal

---

## Minimalny stack (docelowy)

- `lazy.nvim`
- `which-key.nvim`
- `telescope.nvim`
- `oil.nvim` (opcjonalnie)
- `gitsigns.nvim`
- `nvim-treesitter`
- `nvim-lspconfig`
- `mason.nvim` (opcjonalnie)
- `blink.cmp`
- `conform.nvim`
- `R.nvim`
- `copilot.lua` / `copilot.vim`

---

## Czego unikać

- gotowe dystrybucje (LazyVim, AstroNvim)
- zależność od Nerd Fonts
- nadmiar pluginów
- konfiguracja „na raz”
- budowanie UI zamiast workflow

---

## Profile użycia

### Minimalny (awaryjny)
- bez LSP
- bez AI
- tylko podstawy + terminal

### Codzienny
- LSP
- completion
- R workflow
- Copilot

### Rozszerzony (pełna kontrola środowiska)
- Claude Code plugin
- dodatkowe automatyzacje

---

## Kluczowa zasada

**Budujesz narzędzie do pracy u klientów, nie „ładny config”.**

Najważniejsze:
- działa zawsze
- łatwo debugować
- łatwo przenieść
- rozumiesz każdy element

---

## Następny krok

👉 **Etap 1 + Etap 2**:
- minimalny `init.lua`
- struktura katalogów
- skróty do terminala

Z pełnym wyjaśnieniem każdej linijki.
