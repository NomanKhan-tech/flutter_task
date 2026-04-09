# Fitness App — Flutter UI Implementation

Pixel-perfect Flutter implementation of the Figma design.  
Dark-themed fitness tracking app with 4 main screens.

---

## Screens Implemented

| Screen | File | Notes |
|--------|------|-------|
| **Home** | `features/home/presentation/home_screen.dart` | Week strip, Workout card, Insights |
| **Training Calendar** | `features/plan/presentation/plan_screen.dart` | Weekly schedule with workout tags |
| **Calendar Picker** | `features/home/presentation/widgets/calendar_bottom_sheet.dart` | Modal bottom sheet |
| **Mood Selector** | `features/mood/presentation/mood_screen.dart` | Interactive radial wheel |

---

## Project Structure

```
lib/
├── main.dart                         
├── core/
│   └── theme/
│       └── app_theme.dart             # AppColors, AppTheme
└── features/
    ├── home/
    │   └── presentation/
    │       ├── home_screen.dart
    │       └── widgets/
    │           ├── week_strip.dart            # M–Su day selector
    │           ├── workout_card.dart          # Teal-accented workout card
    │           ├── insights_section.dart      # Calories/Weight/Hydration cards
    │           └── calendar_bottom_sheet.dart # Month calendar modal
   
```

---

## Design Tokens


---

### Optional: Custom Font
The design uses **SF Pro Display**. To enable it:
1. Add the `.ttf` files to `assets/fonts/`
2. Uncomment the `fonts:` section in `pubspec.yaml`

---

## Key Implementation Details

### Mood Wheel
- Built with `CustomPainter` — 12 arc segments with per-segment colors
- Draggable handle using `GestureDetector.onPanUpdate` + `atan2`
- Emoji face drawn entirely in `CustomPainter` — no assets needed
- `AnimatedSwitcher` for smooth mood name & face transitions

### Home Insights
- Calories: `LinearProgressIndicator` with teal fill
- Hydration: `Cus![Mood - Content.png](..%2F..%2FMood%20-%20Content.png)tomPainter` dashed vertical line
- Weight: green circle arrow badge

### Training Calendar
- Drag handles rendered as 2×3 dot grid widgets
- Workout tags: colored `Container` chips with icons
- Gradient separator line using `LinearGradient`

### Calendar Bottom Sheet
- `showModalBottomSheet` with `isScrollControlled: true`
- Dynamic grid built from `DateTime` weekday offset
- Selected day shown with `accentTeal` circular border
