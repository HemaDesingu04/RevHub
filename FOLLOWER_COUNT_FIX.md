# Follower/Following Count Fix

## Problem
The follower and following counts were showing 0 in the profile header because they were hardcoded in the backend.

## Solution Implemented

### Backend Changes
Updated `UserService.java` in user-service to fetch actual counts from social-service:

**File**: `backend-services/user-service/src/main/java/com/revhub/userservice/service/UserService.java`

Changed the `getUserByUsername()` method to:
- Call social-service API to get followers list
- Call social-service API to get following list
- Count the array lengths and set them in UserDTO

### How to Apply the Fix

1. **Start Infrastructure** (if not running):
   ```bash
   cd infrastructure
   docker-compose up -d
   ```

2. **Run the restart script**:
   ```bash
   RESTART_USER_SERVICE.bat
   ```

3. **Wait 15-20 seconds** for user-service to start

4. **Refresh your browser** - you should now see actual follower/following counts

## What Was Changed

- Removed hardcoded values (0 followers, 2 following)
- Added REST calls to social-service endpoints
- Added error handling if social-service is unavailable

## Testing

1. Login to the application
2. Go to Profile tab
3. You should see your actual follower and following counts
4. Click on the counts to view the lists
5. Follow/unfollow users - counts should update in real-time
