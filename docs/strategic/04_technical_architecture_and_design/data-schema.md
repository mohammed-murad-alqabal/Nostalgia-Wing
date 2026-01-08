# Data Schema: Encrypted Marital Memories

## 1. Overview

In accordance with the **"Privacy First"** protocol, all marital memories, emotional reflections, and AI-processed insights are stored locally on the device. This document defines the schema for Hive (NoSQL) and Drift (SQL) storage, utilizing AES-256 for field-level and database-level encryption.

## 2. Storage Strategy

- **Memories/Photos:** Encrypted blobs in the local filesystem, metadata in the database.
- **Relational Data (Tasks, Goals):** Drift (SQLite) with `sqlcipher`.
- **Key-Value Data (Preferences, AI Tokens):** Hive with encrypted boxes.

## 3. Drift SQL Schema (Memories & Interactions)

```dart
@DataClassName('Memory')
class Memories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get encryptedContent => text()(); // AES-256 encrypted
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get mediaPath => text().nullable()(); // Path to local encrypted file
  IntColumn get emotionalScore => integer().nullable()(); // -100 to 100
}

@DataClassName('SpiritualRefection')
class Reflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get memoryId => integer().references(Memories, #id)();
  TextColumn get ayahReference => text().nullable()();
  TextColumn get hadithReference => text().nullable()();
  TextColumn get aiInsight => text()(); // Prompt results from رفيق الروح
  DateTimeColumn get reflectedAt => dateTime().withDefault(currentDateAndTime)();
}
```

## 4. Hive Box Schema (AI Context & Sentiment Tokens)

- **Box Name:** `ai_context_vault`
  - `last_known_sentiment`: { 'score': double, 'timestamp': ISO8601 }
  - `user_identity_tokens`: { 'marital_archetype': String, 'receptivity_level': int }

## 5. Security Layer Protocols

1.  **Key Management:** Master key generated during first run, stored in **Android Keystore / iOS Keychain**.
2.  **Field-Level Encryption:** Sensitive strings in `Memories` are encrypted _before_ insertion.
3.  **Media Purity:** Photos are renamed to UUIDs and byte-encrypted before writing to the app's secure internal storage.

## 6. Success Criteria

- [ ] Database initialization fails if encryption key is missing or corrupted (Fail-Safe).
- [ ] Retrieval of a memory decrypts in <50ms.
- [ ] Zero clear-text sensitive data found in raw `.db` or `.hive` files.
