# Feed Visibility Implementation Summary

## 📋 Overview
Implemented proper post visibility rules for Discovery Feed and Following Feed with support for PUBLIC and FOLLOWERS_ONLY posts.

---

## 🎯 Requirements Implemented

### 1. Post Visibility Rules
- **PUBLIC posts**: Appear in BOTH Discovery Feed and Following Feed
- **FOLLOWERS_ONLY posts**: Appear ONLY in Following Feed (for followers and post creator)

### 2. Feed Behavior
- **Discovery Feed (🌍 Universal)**: Shows ONLY PUBLIC posts from all users
- **Following Feed (👥)**: Shows ALL posts (PUBLIC + FOLLOWERS_ONLY) from:
  - Users you follow
  - Your own posts

---

## 📝 Files Modified

### Backend Changes

#### 1. PostService.java
**File**: `backend-services/post-service/src/main/java/com/revhub/postservice/service/PostService.java`

**Changes Made:**

**a) Discovery Feed (Universal) - Line ~107**
```java
public Page<Post> getUniversalPosts(Pageable pageable, String currentUsername) {
    System.out.println("[DISCOVERY FEED] Getting only PUBLIC posts");
    Page<Post> publicPosts = postRepository.findPublicPosts(pageable);
    System.out.println("[DISCOVERY FEED] Returning " + publicPosts.getTotalElements() + " public posts");
    return publicPosts;
}
```
- Changed from returning ALL posts to returning ONLY PUBLIC posts
- Uses `findPublicPosts()` repository method

**b) Following Feed - Line ~114**
```java
public Page<Post> getFollowingFeed(Pageable pageable, String currentUsername) {
    System.out.println("[FOLLOWING FEED] Getting posts from followed users for: " + currentUsername);
    List<String> followingUsernames = getFollowingUsernames(currentUsername);
    
    // Add current user to see their own posts
    if (!followingUsernames.contains(currentUsername)) {
        followingUsernames.add(currentUsername);
    }
    
    System.out.println("[FOLLOWING FEED] User follows (including self): " + followingUsernames);
    
    if (followingUsernames.isEmpty()) {
        System.out.println("[FOLLOWING FEED] No users, returning empty page");
        return Page.empty(pageable);
    }
    
    Page<Post> followingPosts = postRepository.findByUsernameInOrderByCreatedAtDesc(followingUsernames, pageable);
    System.out.println("[FOLLOWING FEED] Returning " + followingPosts.getTotalElements() + " posts");
    return followingPosts;
}
```
- Fetches list of users that current user follows
- **Adds current user to the list** (to see own posts)
- Returns posts from followed users + own posts
- Includes both PUBLIC and FOLLOWERS_ONLY posts

#### 2. PostRepository.java
**File**: `backend-services/post-service/src/main/java/com/revhub/postservice/repository/PostRepository.java`

**Changes Made:**
```java
@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findByUsernameOrderByCreatedAtDesc(String username);
    List<Post> findAllByOrderByCreatedAtDesc();
    Page<Post> findAllByOrderByCreatedAtDesc(Pageable pageable);
    
    // NEW: Find posts by list of usernames (for Following Feed)
    Page<Post> findByUsernameInOrderByCreatedAtDesc(List<String> usernames, Pageable pageable);
    
    // EXISTING: Find only PUBLIC posts (for Discovery Feed)
    @Query("SELECT p FROM Post p WHERE p.visibility = 'PUBLIC' ORDER BY p.createdAt DESC")
    Page<Post> findPublicPosts(Pageable pageable);
}
```
- Added `findByUsernameInOrderByCreatedAtDesc()` method to filter posts by multiple usernames
- Uses existing `findPublicPosts()` for Discovery Feed

### Frontend (Already Working)

#### CreatePostComponent
**File**: `frontend-services/feed-microfrontend/src/app/create-post/create-post.component.ts`

**Existing Implementation:**
- Form includes visibility dropdown with options: PUBLIC, FOLLOWERS_ONLY
- Sends visibility value to backend when creating post
- No changes needed ✅

---

## 🔄 How It Works

### Creating a Post

1. User selects visibility: "Public" or "Followers Only"
2. Frontend sends post with visibility field
3. Backend saves post with correct visibility enum (PUBLIC or FOLLOWERS_ONLY)

### Discovery Feed Flow

1. User clicks "🌍 Universal Feed" button
2. Frontend sends request with `feedType=universal`
3. Backend calls `getUniversalPosts()`
4. Returns ONLY posts where `visibility = 'PUBLIC'`
5. Frontend displays public posts from all users

### Following Feed Flow

1. User clicks "👥 Following Feed" button
2. Frontend sends request with `feedType=followers`
3. Backend calls `getFollowingFeed()`
4. Backend fetches list of users that current user follows from Social Service
5. Backend adds current user to the list
6. Returns ALL posts (PUBLIC + FOLLOWERS_ONLY) from those users
7. Frontend displays posts from followed users + own posts

---

## 🧪 Testing Scenarios

### Scenario 1: PUBLIC Post
**User**: abhi_123 creates PUBLIC post "Hello World"

| Feed Type | User | Should See Post? |
|-----------|------|------------------|
| Discovery | abhi_123 | ✅ Yes |
| Discovery | karthik_123 | ✅ Yes |
| Discovery | harsh_123 | ✅ Yes |
| Following | abhi_123 | ✅ Yes (own post) |
| Following | karthik_123 | ✅ Yes (follows abhi) |
| Following | harsh_123 | ✅ Yes (follows abhi) |

### Scenario 2: FOLLOWERS_ONLY Post
**User**: abhi_123 creates FOLLOWERS_ONLY post "Secret message"

| Feed Type | User | Should See Post? |
|-----------|------|------------------|
| Discovery | abhi_123 | ❌ No |
| Discovery | karthik_123 | ❌ No |
| Discovery | harsh_123 | ❌ No |
| Following | abhi_123 | ✅ Yes (own post) |
| Following | karthik_123 | ✅ Yes (follows abhi) |
| Following | harsh_123 | ✅ Yes (follows abhi) |
| Following | random_user | ❌ No (doesn't follow abhi) |

---

## 🗄️ Database Schema

### Posts Table
```sql
CREATE TABLE posts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255),
    content TEXT,
    image_url TEXT,
    media_type VARCHAR(50),
    visibility VARCHAR(50),  -- 'PUBLIC' or 'FOLLOWERS_ONLY'
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    shares_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Follow Table (Social Service)
```sql
CREATE TABLE follow (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    follower_username VARCHAR(255),
    following_username VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🚀 Deployment Steps

### 1. Build Post Service
```bash
cd backend-services/post-service
mvn clean package -DskipTests
```

### 2. Rebuild Docker Image
```bash
cd ../..
docker-compose build post-service
```

### 3. Restart Container
```bash
docker-compose up -d post-service
```

### 4. Verify Service is Running
```bash
docker logs revhub-post-service --tail 20
```

---

## 📊 Current Database State (Example)

### Users
- `abhi_123`
- `karthik_123`
- `harsh_123`

### Follow Relationships
- `abhi_123` follows `karthik_123`
- `karthik_123` follows `abhi_123`
- `harsh_123` follows `abhi_123`
- `harsh_123` follows `karthik_123`

### Sample Posts
| ID | Username | Content | Visibility |
|----|----------|---------|------------|
| 100 | abhi_123 | are u there | FOLLOWERS_ONLY |
| 99 | abhi_123 | hello | PUBLIC |
| 98 | abhi_123 | hello | FOLLOWERS_ONLY |
| 94 | harsh_123 | hello guys | PUBLIC |
| 84 | karthik_123 | byee gud night | FOLLOWERS_ONLY |

---

## 🐛 Troubleshooting

### Issue: Posts not appearing in Following Feed
**Solution**: 
1. Check if user has follow relationships: `SELECT * FROM follow WHERE follower_username='username';`
2. Check post-service logs: `docker logs revhub-post-service | findstr FEED`
3. Verify post visibility in database: `SELECT id, username, content, visibility FROM posts ORDER BY id DESC LIMIT 10;`

### Issue: FOLLOWERS_ONLY posts appearing in Discovery Feed
**Solution**:
1. Verify `getUniversalPosts()` uses `findPublicPosts()` method
2. Check database: Posts should have `visibility='PUBLIC'` or `visibility='FOLLOWERS_ONLY'`
3. Rebuild and restart post-service

### Issue: Can't see own posts in Following Feed
**Solution**:
1. Verify `getFollowingFeed()` adds current username to the list
2. Check logs for: `[FOLLOWING FEED] User follows (including self): [...]`
3. Current username should be in the list

---

## ✅ Implementation Checklist

- [x] Discovery Feed shows ONLY PUBLIC posts
- [x] Following Feed shows posts from followed users
- [x] Following Feed includes user's own posts
- [x] FOLLOWERS_ONLY posts don't appear in Discovery Feed
- [x] FOLLOWERS_ONLY posts appear in Following Feed for followers
- [x] PUBLIC posts appear in both feeds
- [x] Frontend sends correct visibility value
- [x] Backend saves visibility correctly
- [x] Repository methods filter by visibility
- [x] Docker deployment working
- [x] All services running correctly

---

## 📚 Related Documentation

- `VISIBILITY_RULES.md` - Detailed visibility rules explanation
- `FEED_CLARIFICATION.md` - Feed behavior clarification
- `FINAL_FEED_BEHAVIOR.md` - Final implementation details
- `FEED_TEST_RESULTS.md` - Test results and verification

---

## 🎉 Status

**Implementation**: ✅ COMPLETE
**Deployment**: ✅ DEPLOYED
**Testing**: ✅ VERIFIED

All feed visibility features are working as expected!

---

**Last Updated**: 2025-12-09
**Version**: 1.0.0
**Status**: Production Ready
