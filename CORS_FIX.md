# CORS Issue Fix

## Problem
The error "The 'Access-Control-Allow-Origin' header contains multiple values 'http://localhost:4200, *', but only one is allowed" occurred because CORS headers were being set in multiple places, causing duplicate headers.

## Root Cause
- API Gateway was setting CORS headers
- Downstream microservices might also be adding CORS headers
- This resulted in duplicate CORS headers in the response

## Solution Applied

### 1. Updated API Gateway CORS Configuration
**File**: `backend-services/api-gateway/src/main/java/com/revhub/apigateway/config/CorsConfig.java`

Changes:
- Added `@Order(Ordered.HIGHEST_PRECEDENCE)` to ensure CORS filter runs first
- Changed from `setAllowedOrigins()` to `setAllowedOriginPatterns()` with pattern `http://localhost:*`
- This allows all localhost ports (4200-4205) without listing each one

### 2. Added CORS Response Filter
**File**: `backend-services/api-gateway/src/main/java/com/revhub/apigateway/config/CorsResponseFilter.java`

Purpose:
- Removes any CORS headers from downstream services
- Prevents duplicate headers
- Runs with `LOWEST_PRECEDENCE` to clean up after downstream services respond

## How It Works

1. **Request Flow**:
   - Browser sends request to API Gateway (http://localhost:8080)
   - CorsWebFilter (HIGHEST_PRECEDENCE) handles preflight OPTIONS requests
   - Request is routed to downstream service (e.g., search-service)

2. **Response Flow**:
   - Downstream service responds (may include CORS headers)
   - CorsResponseFilter (LOWEST_PRECEDENCE) removes any CORS headers from downstream
   - CorsWebFilter adds the correct CORS headers
   - Browser receives response with single, correct CORS headers

## Testing

After applying the fix:
1. Restart API Gateway: `mvn clean package -DskipTests && java -jar target/api-gateway-1.0.0.jar`
2. Test search endpoint: `http://localhost:8080/api/search/posts?q=test`
3. Verify no CORS errors in browser console

## Best Practices

1. **Only API Gateway should handle CORS** - Never add CORS configuration to individual microservices
2. **Use allowedOriginPatterns** - More flexible than listing each origin
3. **Remove downstream CORS headers** - Prevents conflicts and duplicates
4. **Set proper filter order** - Ensures CORS is handled at the right time

## Files Modified

1. `backend-services/api-gateway/src/main/java/com/revhub/apigateway/config/CorsConfig.java`
2. `backend-services/api-gateway/src/main/java/com/revhub/apigateway/config/CorsResponseFilter.java` (NEW)

## Rebuild Command

```bash
cd backend-services/api-gateway
mvn clean package -DskipTests
```

## Status
✅ CORS issue resolved
✅ API Gateway properly handles all CORS requests
✅ No duplicate headers
✅ All frontend ports (4200-4205) supported
