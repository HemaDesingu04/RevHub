# Fixes Applied - Chat and Follow Issues

## Issues Fixed

### 1. Chat Conversation 404 Error
**Problem**: Frontend was calling `/api/chat/conversation/karthik_123` but backend expects `/api/chat/conversation?user1=X&user2=Y`

**Solution**: Updated `chat.service.ts` to use correct endpoint with query parameters:
```typescript
getConversation(username: string): Observable<ChatMessage[]> {
  const currentUser = JSON.parse(localStorage.getItem('user') || '{}').username;
  return this.http.get<ChatMessage[]>(`${this.apiUrl}/conversation?user1=${currentUser}&user2=${username}`);
}
```

### 2. Follow/Following 500 Error
**Problem**: Kafka was misconfigured causing connection failures from Docker containers. Services couldn't publish events to Kafka.

**Solution**: Fixed Kafka configuration in `docker-compose.yml` to support dual listeners:
```yaml
KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092,PLAINTEXT_INTERNAL://kafka:29092
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_INTERNAL:PLAINTEXT
KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,PLAINTEXT_INTERNAL://0.0.0.0:29092
KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT_INTERNAL
```

Updated all services to use `kafka:29092` for internal Docker network communication.

## Services Restarted
- Zookeeper (removed and recreated)
- Kafka (removed and recreated with new config)
- Social-service (restarted to reconnect to Kafka)

## Testing Instructions
1. Refresh the browser at http://localhost:4200
2. Try following a user from search results - should work without 500 error
3. Try viewing followers/following lists - should work without 500 error
4. Try opening a chat conversation - should load messages without 404 error

## Files Modified
1. `frontend-services/shell-app/src/app/core/services/chat.service.ts`
2. `docker-compose.yml` (Kafka configuration and all service Kafka bootstrap servers)
