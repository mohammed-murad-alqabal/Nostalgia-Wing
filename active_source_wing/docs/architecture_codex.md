# Architecture Codex: Wing of Nostalgia

This codex provides deep technical documentation for the "Life-Centric" intelligent engines that power the Wing of Nostalgia.

## 1. Emotional Gravity Engine (EGE)

The `EmotionalGravityEngine` is responsible for calculating the "Emotional Distance" between users based on their interactions, sentiment analysis, and shared history.

### Core Logic

The engine uses a weighted decay algorithm where:

- **Interaction Frequency**: Increases pull (gravity).
- **Sentiment Polarity**: Determines the "Atmosphere" of the gravity (positive/negative).
- **Temporal Decay**: Gravity weakens over time without interaction to encourage active participation.

### Key API Methods

- `calculateGravity(UserId user1, UserId user2)`: Returns a double representing the pull.
- `updateAtmosphere(Sentiment sentiment)`: Adjusts the emotional context.

## 2. Dual Truth Engine (DTE)

The `DualTruthEngine` manages the balance between "Objective Reality" (Logged Data) and "Perceived Reality" (User Sentiment).

### Architecture

- **Layer 1: The Ledger**: Immutable record of events.
- **Layer 2: The Interpretation**: How users felt about the events.
- **Synthesis Layer**: Merges both to provide "Bilingual" (Objective + Emotional) insights.

## 3. Psychological Analysis Engine (PAE)

The PAE monitors 500+ emotional expressions to classify the user's state into 8 core buckets (Happy, Sad, Excited, Calm, Anxious, Grateful, Nostalgic, Hopeful).

### Classification Flow

1. **Input**: Natural language or interaction patterns.
2. **Analysis**: Keyword matching + Semantic Analysis.
3. **Adaptation**: Triggers `PerformanceAdaptationService` and `EmotionalAdaptationSystem`.

---

> [!IMPORTANT]
> All engines MUST adhere to the **Islamic Purity Protocol**, ensuring that no automated decision violates Sharia-compliant relationship guidelines.
