# RevHub Shared Modules

## Modules

### common-dto
Shared Data Transfer Objects used across microservices.

**Classes**:
- `UserDTO` - User information
- `PostDTO` - Post information
- `NotificationDTO` - Notification information

**Build**: `mvn clean install`

### event-schemas
Event schemas for Kafka messaging.

**Classes**:
- `UserEvent` - User-related events (registration, update, deletion)
- `PostEvent` - Post-related events (creation, update, deletion)
- `SocialEvent` - Social events (follow, like, comment)

**Build**: `mvn clean install`

### utilities
Common utility classes.

**Classes**:
- `JwtUtil` - JWT token generation and validation
- `DateUtil` - Date/time formatting utilities

**Build**: `mvn clean install`

## Usage

1. Build all shared modules first:
   ```bash
   cd scripts
   build-shared-modules.bat
   ```

2. Add dependencies to microservices pom.xml:
   ```xml
   <dependency>
       <groupId>com.revhub</groupId>
       <artifactId>common-dto</artifactId>
       <version>1.0.0</version>
   </dependency>
   ```

## Build Order

Always build shared modules before backend services:
1. common-dto
2. event-schemas
3. utilities
4. Backend services
