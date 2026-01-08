# API Contract: Secure Synchronization

## 1. Architecture Overview

The back-end serves as a "Blind Relay" for encrypted marital data. Following the **Signal Protocol** integration, the server cannot read memory contents or emotional data.

## 2. Base Configuration

- **Base URL:** `https://api.wingofnostalgia.io/v1`
- **Auth:** `Bearer JWT` (Firebase Auth or Custom)
- **Encryption Header:** `X-Signal-Public-Key: [Base64]`

## 3. Endpoints

### 3.1 Authentication & Profile

- **POST `/auth/register`**: Register new marital couple (shared shard).
- **GET `/profile/sync-status`**: Check last successful sync timestamps.

### 3.2 Memory Synchronization (Encrypted)

- **POST `/sync/memories/push`**
  - **Body:** `List<EncryptedMemoryPacket>`
  - **Constraints:** Max 50 items per batch.
- **GET `/sync/memories/pull?since={timestamp}`**
  - **Response:** `List<EncryptedMemoryPacket>`

### 3.3 Media Blob Storage

- **POST `/media/upload-url`**: Generates a pre-signed URL for encrypted S3 upload.

## 4. Data Models (TypeScript/JSON)

```typescript
interface EncryptedMemoryPacket {
  id: string; // UUID
  encrypted_metadata: string; // AES-256 (Title, Desc, Date)
  encrypted_insight: string; // AI generated insights
  media_id: string?; // Link to encrypted S3 blob
  version: number;
  updated_at: string; // ISO8601
}
```

## 5. Security Protocols

- **Blind Sync:** Servers use `Content-Id` and `Version` for conflict resolution without decrypting the payload.
- **Rate Limiting:** 100 requests / 15 mins for sync endpoints.
- **Compliance:** GDPR/CCPA automated "Right to be Forgotten" implementation.

## 6. Error Codes

| Code             | Message           | Description                                |
| :--------------- | :---------------- | :----------------------------------------- |
| `Sync_Conflict`  | Conflict Detected | Local version is older than cloud version. |
| `Auth_Invalid`   | Unauthorized      | JWT expired or invalid.                    |
| `Quota_Exceeded` | Storage Full      | Encrypted blob storage limit reached.      |
