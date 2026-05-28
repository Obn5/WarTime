# Fields & Quarks

> *Explore the fundamental universe.*

A Flutter quiz app for mastering technical topics through a streak-based learning system with level progression, analytics, and adaptive theming.

---

## Screenshots

| Home | Topics | Quiz | Level Complete | Stats |
|------|--------|------|---------------|-------|
| Import a quiz, pick a topic | Full grid with difficulty filters | Streak bar + explanations | Badge + next level | Circular gauge + XP |

---

## Features

### Learning System
- **Streak-based progression** — answer 10 in a row correctly to complete a topic
- **Level system** — topics with 100+ questions are split into levels of 20 questions each; topics with fewer than 20 questions play as a single session
- **Quintet checkpoints** — every 5 questions a mini round-summary is shown before continuing
- **XP & levelling** — earn 10 XP per correct answer; accumulate XP to level up across sessions

### Content
- **Next.js** — 110 questions across App Router, RSC, caching, routing, metadata, streaming, Server Actions, ISR, Turbopack, and Next.js 15
- **Node.js** — 100 questions on the event loop, libuv, streams, cluster, worker threads, crypto, Express, PM2, AsyncLocalStorage, and HTTP/2
- **Docker** — 50 questions on Dockerfiles, multi-stage builds, Compose, networking, volumes, BuildKit, and security best practices
- **Custom quizzes** — load any compatible JSON file via the file picker

### UI
- Two themes — **Slate & Ember** (dark) and **Terra** (light green/earth), switchable at any time
- Animated gradient topic cards with gloss overlay, dot-grid texture, and press-scale feedback
- Import card with state-reactive gradient (glows green when a quiz is loaded)
- Full-screen **Topics Grid** with Easy / Medium / Hard filter chips
- Animated circular accuracy gauge on the stats screen
- Achievement cards with tier-based icons and gradients (Curious Learner → Quantum Master)
- Quintet history bar chart on the stats screen

---

## Project Structure

```
lib/
├── core/
│   ├── app.dart              # Root widget, MaterialApp, providers
│   ├── app_colors.dart       # ThemeExtension with all colour tokens (Terra + Slate & Ember)
│   ├── constants.dart        # App-wide constants (streak goal, XP, quiz paths)
│   └── theme.dart            # AppTheme.build() — constructs ThemeData from AppColors
│
├── data/
│   ├── models/
│   │   ├── question.dart     # Question model (question, options, correctIndex, explanation, tags)
│   │   ├── quiz_set.dart     # QuizSet model (name, topics)
│   │   └── topic.dart        # Topic model (id, name, description, difficulty, questions)
│   └── services/
│       └── json_service.dart # File picker + asset loader, parses JSON → QuizSet
│
├── state/
│   ├── quiz_provider.dart    # All quiz logic: phases, level system, streaks, XP, stats
│   └── theme_provider.dart   # ColorMode (terra / slateEmber) with toggle
│
└── ui/
    ├── home/
    │   ├── home_screen.dart        # Welcome screen, import card, horizontal topic list
    │   ├── topics_screen.dart      # Full-screen 2-column topic grid with filter chips
    │   └── widgets/
    │       ├── import_card.dart    # Animated gradient import/load card
    │       └── topic_card.dart     # Gradient card with gloss, orb, index badge
    │
    ├── quiz/
    │   ├── quiz_screen.dart        # Phase router: answering → quintet → level → complete
    │   ├── level_complete_view.dart# Level X complete screen with badge, stats, next button
    │   ├── quintet_view.dart       # Every-5-questions checkpoint screen
    │   └── widgets/
    │       ├── answer_option_tile.dart  # Animated correct/wrong/idle answer tile
    │       ├── explanation_panel.dart   # Explanation shown after answering
    │       ├── question_card.dart       # Question text + optional formula block
    │       ├── streak_bar.dart          # Streak + level + questions-seen progress bars
    │       └── tag_chip.dart            # Coloured tag pill
    │
    ├── stats/
    │   ├── stats_screen.dart            # Circular gauge, XP card, stat grid, history chart
    │   └── widgets/
    │       ├── achievement_card.dart    # Tier-based achievement (5 tiers)
    │       └── stat_card.dart          # Reusable labelled stat container
    │
    └── shared/
        ├── pressable.dart      # Spring-scale press animation wrapper
        └── theme_dropdown.dart # Theme switcher widget
```

---

## Quiz JSON Format

Load your own quiz by creating a JSON file with this structure and tapping **Browse Files**:

```json
{
  "name": "My Quiz Set",
  "topics": [
    {
      "id": "unique-id",
      "name": "Topic Name",
      "description": "Short description",
      "difficulty": "Easy | Medium | Hard",
      "questions": [
        {
          "question": "What does X do?",
          "options": ["A", "B", "C", "D"],
          "correct": 2,
          "explanation": "C is correct because...",
          "tags": ["optional", "tags"],
          "formula": "optional code or formula block"
        }
      ]
    }
  ]
}
```

**Level system rules:**
| Questions in topic | Behaviour |
|---|---|
| < 20 | All questions, no levels |
| 20 – 99 | All questions, no levels |
| ≥ 100 | Split into levels of 20 questions |

The bundled `quiz_webdev.json` (Next.js 110 q, Node.js 100 q, Docker 50 q) is loaded by the **Sample Quiz** button.

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.7.2
- Dart SDK ≥ 3.7.2

### Run

```bash
git clone <repo-url>
cd WarTime
flutter pub get
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Tech Stack

| | |
|---|---|
| Framework | Flutter 3.x |
| State management | Provider |
| Fonts | Google Fonts (Inter) |
| File picker | file_picker |
| Theming | `ThemeExtension<AppColors>` with two palettes |
| Rendering | Material 3 |

---

## Quiz Phases

```
idle → answering → revealing → answering → ...
                                    ↓ every 5 questions
                              quintetStats → answering
                                    ↓ all level questions seen (if ≥100 q topic)
                              levelComplete → answering (next level)
                                    ↓ streak goal reached OR last level done
                                 complete (stats screen)
```

---

## Scoring

| Event | XP |
|---|---|
| Correct answer | +10 XP |
| Wrong answer | 0 XP, streak resets |
| Level complete | Carry XP to next level |
| XP per level | 100 XP |

---

## Themes

| Token | Slate & Ember (dark) | Terra (light) |
|---|---|---|
| Background | `#16181F` | `#EFF1EB` |
| Primary (gold/green) | `#C4A66A` | `#4A7C59` |
| Green CTA | `#4A7C59` | `#4A7C59` |
| Surface | `#1E2029` | `#FFFFFF` |
| Text primary | `#E8EAF0` | `#1C2B1E` |

All colours are defined in `lib/core/app_colors.dart` as a `ThemeExtension<AppColors>`. Access them in any widget with:

```dart
final c = Theme.of(context).extension<AppColors>()!;
```

---

## License

MIT
