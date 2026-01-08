# Design System Tokens: Premium & Nostalgic

## 1. Vision & Tone

The visual identity of "Wing of Nostalgia" must be **Premium, Calm, and Timeless**. It should evoke a sense of deep spiritual connection and "Mawaddah" (affection) through soft gradients and elegant typography.

## 2. Color Palette (Harmonious Spiritual Tones)

| Token           | Hex       | Usage                       | Emotion               |
| :-------------- | :-------- | :-------------------------- | :-------------------- |
| `primary_gold`  | `#D4AF37` | Accents, Primary Buttons    | Value, Sacredness     |
| `midnight_calm` | `#1A237E` | Dark Theme Backgrounds      | Peace, Depth          |
| `antique_ivory` | `#FDF5E6` | Light Theme Backgrounds     | Nostalgia, Purity     |
| `mouda_rose`    | `#E57373` | Love/Affection Indicators   | Warmth, Heart         |
| `sakinah_teal`  | `#26A69A` | AI Insights, Spiritual Tips | Tranquility, Wellness |

## 3. Typography (Google Fonts)

- **English:** `Outfit` (Modern, clean, elegant)
- **Arabic:** `Cairo` (Balanced, readable, professional)
- **Quranic Scripture:** `Uthmanic Hafs` (For sacred texts)

| Level             | Size | Weight     | Line Height |
| :---------------- | :--- | :--------- | :---------- |
| `Display_1`       | 32pt | Semi-bold  | 1.2         |
| `Headline`        | 24pt | Medium     | 1.4         |
| `Body_Arabic`     | 18pt | Regular    | 1.8         |
| `Spiritual_Quote` | 20pt | Italic/Med | 1.6         |

## 4. Premium Visual Effects

- **Glassmorphism:** Use `BackdropFilter` with 80% opacity for memory cards to create depth.
- **Cognitive Gradients:** Subtle 45-degree linear gradients (e.g., `midnight_calm` to `deep_purple`).
- **Shadows:** Soft, diffused shadows (`blurRadius: 20`, `offset: (0, 10)`, `alpha: 0.1`).

## 5. Micro-Animations (Cognitive Identity)

- **The Heartbeat:** Subtle scale pulse (1.0 to 1.02) for the "Refinement" button.
- **Page Transitions:** Gentle fade-and-slide up (Curved animation: `Curves.easeOutCirc`).
- **Memory Reveal:** Scale-in animation with a slight bounce to evoke joy when opening a memory.

## 6. Implementation Checklist (Flutter)

- [ ] Initialize `AppColors` class with these tokens.
- [ ] Setup `ThemeData` for Light and Dark modes.
- [ ] Create specialized `GlassCard` widget.
