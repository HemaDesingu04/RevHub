# Post Visibility Rules Implementation

## Requirements

When a user creates a post with visibility settings:

### 1. PUBLIC Posts
- ✅ Appear in **Discovery Feed** (Universal Feed - 🌍)
- ✅ Appear in **Following Feed** (👥) of their followers

### 2. FOLLOWERS_ONLY Posts
- ❌ Do NOT appear in **Discovery Feed**
- ✅ Appear ONLY in **Following Feed** of users who follow the creator

## Implementation

### PostService.java

**Discovery Feed (Universal):**
```java
public Page<Post> getUniversalPosts(Pageable pageable, String currentUsername) {
    // Returns ONLY PUBLIC posts
    return postRepository.findPublicPosts(pageable);
}
```

**Following Feed:**
```java
public Page<Post> getFollowingFeed(Pageable pageable, String currentUsername) {
    // Get list of users that current user follows
    List<String> followingUsernames = getFollowingUsernames(currentUsername);
    
    // Returns ALL posts (PUBLIC + FOLLOWERS_ONLY) from followed users
    return postRepository.findByUsernameInOrderByCreatedAtDesc(followingUsernames, pageable);
}
```

### PostRepository.java

```java
@Query("SELECT p FROM Post p WHERE p.visibility = 'PUBLIC' ORDER BY p.createdAt DESC")
Page<Post> findPublicPosts(Pageable pageable);

Page<Post> findByUsernameInOrderByCreatedAtDesc(List<String> usernames, Pageable pageable);
```

## How It Works

### Scenario 1: User A creates a PUBLIC post
1. Post is saved with `visibility = PUBLIC`
2. Post appears in **Discovery Feed** for everyone
3. Post appears in **Following Feed** for User A's followers

### Scenario 2: User A creates a FOLLOWERS_ONLY post
1. Post is saved with `visibility = FOLLOWERS_ONLY`
2. Post does NOT appear in **Discovery Feed**
3. Post appears ONLY in **Following Feed** for users who follow User A

## Feed Behavior

| Feed Type | Shows |
|-----------|-------|
| 🌍 Discovery (Universal) | Only PUBLIC posts from all users |
| 👥 Following | All posts (PUBLIC + FOLLOWERS_ONLY) from followed users |

## Testing Steps

1. **Login as User A**
2. **Create a PUBLIC post**
   - Check Discovery Feed → Should see the post
   - Login as User B (who follows User A)
   - Check Following Feed → Should see the post
   - Check Discovery Feed → Should see the post

3. **Create a FOLLOWERS_ONLY post**
   - Check Discovery Feed → Should NOT see the post
   - Login as User B (who follows User A)
   - Check Following Feed → Should see the post
   - Check Discovery Feed → Should NOT see the post
   - Login as User C (who does NOT follow User A)
   - Check Following Feed → Should NOT see the post
   - Check Discovery Feed → Should NOT see the post

## Status
✅ Implemented and deployed in Docker
