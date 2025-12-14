# Feed Update - Show All Posts

## What Changed
Updated the feed logic to show ALL posts from ALL users in both "Discover" and "Following" feeds.

## Changes Made

### Backend - PostService.java
**File**: `backend-services/post-service/src/main/java/com/revhub/postservice/service/PostService.java`

**Before**: Feeds filtered posts based on visibility and following relationships
**After**: Both feeds return all posts from all users

```java
// Universal Feed - Now shows ALL posts
public Page<Post> getUniversalPosts(Pageable pageable, String currentUsername) {
    System.out.println("[UNIVERSAL FEED] Getting all posts");
    Page<Post> allPosts = postRepository.findAllByOrderByCreatedAtDesc(pageable);
    System.out.println("[UNIVERSAL FEED] Returning " + allPosts.getTotalElements() + " posts");
    return allPosts;
}

// Following Feed - Now shows ALL posts
public Page<Post> getFollowingFeed(Pageable pageable, String currentUsername) {
    System.out.println("[FOLLOWING FEED] Getting all posts");
    Page<Post> allPosts = postRepository.findAllByOrderByCreatedAtDesc(pageable);
    System.out.println("[FOLLOWING FEED] Returning " + allPosts.getTotalElements() + " posts");
    return allPosts;
}
```

## What This Means

### ✅ Feed Display
- **Discover Feed**: Shows ALL posts from ALL users
- **Following Feed**: Shows ALL posts from ALL users
- Both feeds show the same posts (for now)
- Posts are sorted by creation date (newest first)

### ✅ Post Creation
- Visibility settings (PUBLIC, FOLLOWERS_ONLY, PRIVATE) still work
- Posts are saved with the correct visibility setting
- You can still create posts with different visibility levels

### 📝 Note
The visibility settings are stored in the database but currently don't affect what shows in the feed. All posts are visible to everyone in the feed regardless of their visibility setting.

## How to Test

1. **Restart post-service**:
   ```bash
   # Stop the service (Ctrl+C in the terminal)
   # Then restart
   cd backend-services\post-service
   mvn spring-boot:run
   ```

2. **Test with multiple users**:
   - Login as User A, create posts
   - Login as User B, create posts
   - Both users should see ALL posts in their feeds
   - Toggle between "Discover" and "Following" - same posts appear

3. **Verify post creation**:
   - Create a post with "Public" visibility ✅
   - Create a post with "Followers" visibility ✅
   - Both should save successfully
   - Both should appear in everyone's feed

## Files Modified
- `backend-services/post-service/src/main/java/com/revhub/postservice/service/PostService.java`

## Build Status
✅ Backend rebuilt successfully
✅ Ready to test

## Next Steps
1. Restart the post-service
2. Refresh your browser
3. Check the feed - you should see all posts from all users
