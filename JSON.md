## User Profile APIs
### 2.1 Get User Profile
   Endpoint: `GET /api/user/profile`
   Headers: `Authorization: Bearer {accessToken}`
   Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Profile retrieved successfully",
  "code": "USER_301",
  "data": {
    "id": "user_123",
    "name": "John Doe",
    "email": "user@example.com",
    "phoneNumber": "+1234567890",
    "profilePictureUrl": "https://api.example.com/images/user_123.jpg",
    "bio": "Software Developer",
    "dateOfBirth": "1995-05-15",
    "gender": "male",
    "role": "customer",
    "accountStatus": "active",
    "isEmailVerified": true,
    "isPhoneVerified": true,
    "twoFactorEnabled": false,
    "createdAt": "2026-05-20T08:00:00Z",
    "updatedAt": "2026-05-24T11:00:00Z",
    "lastLogin": "2026-05-24T10:30:00Z",
    "preferences": {
      "notificationsEnabled": true,
      "newsletterSubscribed": true,
      "categoryInterest": "Technology",
      "language": "en",
      "timezone": "UTC+0"
    }
  }
}
```
---
2.2 Update User Profile
Endpoint: `PUT /api/user/profile`
Headers: `Authorization: Bearer {accessToken}`
Request:
```json
{
  "name": "John Doe Updated",
  "phoneNumber": "+1234567890",
  "bio": "Senior Software Developer",
  "dateOfBirth": "1995-05-15",
  "gender": "male"
}
```
Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Profile updated successfully",
  "code": "USER_302",
  "data": {
    "id": "user_123",
    "name": "John Doe Updated",
    "email": "user@example.com",
    "phoneNumber": "+1234567890",
    "bio": "Senior Software Developer",
    "updatedAt": "2026-05-24T11:05:00Z"
  }
}
```
---
2.3 Update Profile Picture
Endpoint: `POST /api/user/profile-picture`
Headers: `Authorization: Bearer {accessToken}`, `Content-Type: multipart/form-data`
Request:
```
FormData:
  - file: <binary_image_data>
  - mimeType: "image/jpeg"
```
Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Profile picture updated",
  "code": "USER_303",
  "data": {
    "userId": "user_123",
    "profilePictureUrl": "https://api.example.com/images/user_123.jpg",
    "thumbnailUrl": "https://api.example.com/images/user_123_thumb.jpg",
    "uploadedAt": "2026-05-24T11:10:00Z"
  }
}
```
---
3 . Setup APIs
   3.1 Get Setup Status
   Endpoint: `GET /api/user/setup-status`
   Headers: `Authorization: Bearer {accessToken}`
   Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Setup status retrieved",
  "code": "SETUP_401",
  "data": {
    "userId": "user_456",
    "isSetupComplete": false,
    "completedSteps": [1],
    "totalSteps": 3,
    "currentStep": 2,
    "setupStartedAt": "2026-05-24T10:35:00Z",
    "lastModifiedAt": "2026-05-24T10:40:00Z",
    "stepStatus": {
      "step1": {
        "name": "Profile Information",
        "completed": true,
        "completedAt": "2026-05-24T10:40:00Z"
      },
      "step2": {
        "name": "User Preferences",
        "completed": false,
        "completedAt": null
      },
      "step3": {
        "name": "Summary & Complete",
        "completed": false,
        "completedAt": null
      }
    }
  }
}
```
---
3.2 Setup Step 1 - Profile Information
Endpoint: `POST /api/user/setup/step1`
Headers: `Authorization: Bearer {accessToken}`
Request:
```json
{
  "bio": "I am a software engineer",
  "phoneNumber": "+1234567890",
  "profilePhotoUrl": "https://api.example.com/images/user_456.jpg"
}
```
Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Step 1 completed successfully",
  "code": "SETUP_402",
  "data": {
    "stepNumber": 1,
    "stepName": "Profile Information",
    "userId": "user_456",
    "completedAt": "2026-05-24T10:40:00Z",
    "data": {
      "bio": "I am a software engineer",
      "phoneNumber": "+1234567890",
      "profilePhotoUrl": "https://api.example.com/images/user_456.jpg"
    },
    "nextStep": 2,
    "progress": 33
  }
}
```
---
3.3 Setup Step 2 - User Preferences
Endpoint: `POST /api/user/setup/step2`
Headers: `Authorization: Bearer {accessToken}`
Request:
```json
{
  "notificationsEnabled": true,
  "emailNotificationsEnabled": true,
  "pushNotificationsEnabled": true,
  "newsletterSubscribed": true,
  "categoryInterest": "Technology",
  "marketingEmails": false
}
```
Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Step 2 completed successfully",
  "code": "SETUP_403",
  "data": {
    "stepNumber": 2,
    "stepName": "User Preferences",
    "userId": "user_456",
    "completedAt": "2026-05-24T10:45:00Z",
    "data": {
      "notificationsEnabled": true,
      "emailNotificationsEnabled": true,
      "pushNotificationsEnabled": true,
      "newsletterSubscribed": true,
      "categoryInterest": "Technology",
      "marketingEmails": false
    },
    "nextStep": 3,
    "progress": 66
  }
}
```
---
3.4 Setup Step 3 - Summary & Complete
Endpoint: `POST /api/user/setup/complete`
Headers: `Authorization: Bearer {accessToken}`
Request:
```json
{
  "confirmAll": true,
  "acceptedTerms": true
}
```
Success Response (200 OK):
```json
{
  "status": "success",
  "message": "Setup completed successfully",
  "code": "SETUP_404",
  "data": {
    "userId": "user_456",
    "setupComplete": true,
    "completedAt": "2026-05-24T10:50:00Z",
    "totalStepsCompleted": 3,
    "setupSummary": {
      "profile": {
        "bio": "I am a software engineer",
        "phoneNumber": "+1234567890",
        "profilePhoto": true
      },
      "preferences": {
        "notifications": true,
        "newsletter": true,
        "category": "Technology"
      }
    },
    "nextAction": "/home",
    "progress": 100
  }
}
```
---
## Home Screen APIs
###  Get Home Dashboard Data
**Endpoint**: `GET /api/home/dashboard`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Dashboard data retrieved",
  "data": {
    "user": {
      "name": "Jhonathan",
      "status": "YOU ARE\nSTRONG ✨"
    },
    "timer": {
      "days": 32,
      "hours": 14,
      "mins": 45,
      "secs": 30,
      "progress": 0.8,
      "startDate": "2026-04-22T08:30:00Z"
    },
    "dailyWisdom": {
      "id": "quote_789",
      "quote": "Progress isn't a straight line. Every small step back is just preparation for a giant leap forward.",
      "author": "Coach Pearl 🍃",
      "category": "Motivation"
    },
    "journal": {
      "hasEntryToday": false,
      "prompt": "Tap to write about your day...",
      "actionText": "Write →"
    },
    "notifications": {
      "unreadCount": 2
    }
  }
}
```
---
## Circle Screen APIs

### Circle Data Models

#### CirclePostModel
```json
{
  "id": "post_001",
  "userName": "Sarah M.",
  "userAvatar": "https://api.example.com/avatars/sarah_m.jpg",
  "timeAgo": "2 min ago",
  "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
  "images": [
    "https://api.example.com/images/post_001_1.jpg",
    "https://api.example.com/images/post_001_2.jpg"
  ],
  "likes": 47,
  "claps": 12,
  "isLiked": false,
  "isClapped": true,
  "isOwnPost": false,
  "commentsCount": 5,
  "comments": [
    {
      "id": "comment_001",
      "userName": "Mike Tyson",
      "userAvatar": "https://api.example.com/avatars/mike.jpg",
      "content": "Keep going! You got this."
    }
  ]
}
```

#### CircleComment
```json
{
  "id": "comment_001",
  "userName": "Mike Tyson",
  "userAvatar": "https://api.example.com/avatars/mike.jpg",
  "content": "Keep going! You got this."
}
```

#### SuggestionModel
```json
{
  "id": "sug_001",
  "name": "Sarah",
  "avatar": "https://api.example.com/avatars/sarah.jpg",
  "mutualFriends": 2
}
```

---

### 4.1 Get Circle Posts
**Endpoint**: `GET /api/circle/posts`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Posts retrieved successfully",
  "data": {
    "posts": [
      {
        "id": "post_001",
        "userName": "Sarah M.",
        "userAvatar": "https://api.example.com/avatars/sarah_m.jpg",
        "timeAgo": "2 min ago",
        "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
        "images": [
          "https://api.example.com/images/post_001_1.jpg",
          "https://api.example.com/images/post_001_2.jpg"
        ],
        "likes": 47,
        "claps": 12,
        "isLiked": false,
        "isClapped": true,
        "isOwnPost": false,
        "commentsCount": 1,
        "comments": [
          {
            "id": "comment_001",
            "userName": "Mike Tyson",
            "userAvatar": "https://api.example.com/avatars/mike.jpg",
            "content": "Keep going! You got this."
          }
        ]
      },
      {
        "id": "post_002",
        "userName": "Alex R.",
        "userAvatar": "https://api.example.com/avatars/alex.jpg",
        "timeAgo": "15 min ago",
        "content": "Just finished a great workout. Feeling refreshed! 🧘‍♂️",
        "images": [
          "https://api.example.com/images/post_002_1.jpg"
        ],
        "likes": 23,
        "claps": 5,
        "isLiked": true,
        "isClapped": false,
        "isOwnPost": false,
        "commentsCount": 0,
        "comments": null
      }
    ],
    "members": [
      {
        "id": "sug_0",
        "name": "You",
        "avatar": "https://api.example.com/avatars/you.jpg",
        "mutualFriends": 0
      },
      {
        "id": "sug_1",
        "name": "Sarah",
        "avatar": "https://api.example.com/avatars/sarah.jpg",
        "mutualFriends": 2
      },
      {
        "id": "sug_2",
        "name": "Alex",
        "avatar": "https://api.example.com/avatars/alex.jpg",
        "mutualFriends": 1
      },
      {
        "id": "sug_3",
        "name": "Jordan",
        "avatar": "https://api.example.com/avatars/jordan.jpg",
        "mutualFriends": 3
      },
      {
        "id": "sug_4",
        "name": "Maya",
        "avatar": "https://api.example.com/avatars/maya.jpg",
        "mutualFriends": 2
      }
    ]
  }
}
```
---
### 4.2 Create Circle Post
**Endpoint**: `POST /api/circle/posts`
**Headers**: `Authorization: Bearer {accessToken}`, `Content-Type: application/json`
**Request**:
```json
{
  "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
  "images": [
    "https://api.example.com/images/uploaded_1.jpg",
    "https://api.example.com/images/uploaded_2.jpg"
  ]
}
```
**Success Response** (201 Created):
```json
{
  "status": "success",
  "message": "Post created successfully",
  "data": {
    "id": "post_123",
    "userName": "joshua_l",
    "userAvatar": "https://api.example.com/avatars/you.jpg",
    "timeAgo": "Just now",
    "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
    "images": [
      "https://api.example.com/images/post_123_1.jpg",
      "https://api.example.com/images/post_123_2.jpg"
    ],
    "likes": 0,
    "claps": 0,
    "isLiked": false,
    "isClapped": false,
    "isOwnPost": true,
    "commentsCount": 0,
    "comments": null
  }
}
```
---
### 4.3 Update Circle Post
**Endpoint**: `PUT /api/circle/posts/{postId}`
**Headers**: `Authorization: Bearer {accessToken}`, `Content-Type: application/json`
**Request**:
```json
{
  "content": "Updated: Day 14. Feeling even prouder now! 💪🌟",
  "images": [
    "https://api.example.com/images/updated_1.jpg"
  ]
}
```
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Post updated successfully",
  "data": {
    "id": "post_123",
    "userName": "joshua_l",
    "userAvatar": "https://api.example.com/avatars/you.jpg",
    "timeAgo": "Just now",
    "content": "Updated: Day 14. Feeling even prouder now! 💪🌟",
    "images": [
      "https://api.example.com/images/updated_1.jpg"
    ],
    "likes": 5,
    "claps": 2,
    "isLiked": false,
    "isClapped": false,
    "isOwnPost": true,
    "commentsCount": 0,
    "comments": null
  }
}
```
---
4 . Error Responses
   4.1 Authentication Errors
   401 Unauthorized - Invalid Token:
```json
{
  "status": "error",
  "message": "Invalid or expired token",
  "code": "AUTH_401",
  "timestamp": "2026-05-24T11:15:00Z"
}
```
401 Unauthorized - Token Missing:
```json
{
  "status": "error",
  "message": "Authorization header missing",
  "code": "AUTH_402",
  "timestamp": "2026-05-24T11:15:00Z"
}
```
---
4.2 Validation Errors
400 Bad Request - Validation Failed:
```json
{
  "status": "error",
  "message": "Validation failed",
  "code": "VALIDATION_001",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format",
      "type": "format"
    },
    {
      "field": "password",
      "message": "Password must be at least 8 characters",
      "type": "minLength"
    }
  ],
  "timestamp": "2026-05-24T11:15:00Z"
}
```
---
4.3 Server Errors
500 Internal Server Error:
```json
{
  "status": "error",
  "message": "Internal server error",
  "code": "SERVER_500",
  "error": {
    "type": "InternalServerError",
    "message": "Database connection failed",
    "timestamp": "2026-05-24T11:15:00Z"
  }
}
```
---

## Groups Screen APIs

### Groups Data Models

#### GroupModel
```json
{
  "id": "group_001",
  "name": "No Contact Warriors",
  "icon": "https://api.example.com/icons/group_001.png",
  "memberCount": 1243,
  "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
  "isJoined": true,
  "status": "active"
}
```

---

### 5.1 Get My Groups
**Endpoint**: `GET /api/groups/my`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Joined groups retrieved",
  "data": {
    "groups": [
      {
        "id": "group_001",
        "name": "No Contact Warriors",
        "icon": "https://api.example.com/icons/group_001.png",
        "memberCount": 1243,
        "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
        "isJoined": true
      },
      {
        "id": "group_002",
        "name": "Healing Hearts",
        "icon": "https://api.example.com/icons/group_002.png",
        "memberCount": 856,
        "description": "A safe space for those healing from heartbreak. We support each other through the journey.",
        "isJoined": true
      }
    ]
  }
}
```

---

### 5.2 Find/Suggest Groups
**Endpoint**: `GET /api/groups/find`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Suggested groups retrieved",
  "data": {
    "isFirstGroupFree": true,
    "suggestions": [
      {
        "id": "group_003",
        "name": "Self Love Club",
        "icon": "https://api.example.com/icons/group_003.png",
        "memberCount": 3201,
        "description": "Focusing on self-growth and appreciation. You are enough.",
        "isJoined": false
      },
      {
        "id": "group_004",
        "name": "Mindful Living",
        "icon": "https://api.example.com/icons/group_004.png",
        "memberCount": 1540,
        "description": "Daily mindfulness practices and support for a peaceful mind.",
        "isJoined": false
      }
    ]
  }
}
```

---

### 5.3 Get Group Invitations
**Endpoint**: `GET /api/groups/invitations`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Invitations retrieved",
  "data": {
    "invitations": [
      {
        "id": "inv_001",
        "group": {
          "id": "group_001",
          "name": "No Contact Warriors",
          "icon": "https://api.example.com/icons/group_001.png",
          "memberCount": 1243,
          "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!"
        },
        "invitedBy": "Sarah M.",
        "invitedAt": "2026-06-05T10:00:00Z"
      }
    ]
  }
}
```

---

### 5.4 Join Group
**Endpoint**: `POST /api/groups/join/{groupId}`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Joined group successfully",
  "data": {
    "groupId": "group_123",
    "isPremiumRequired": false
  }
}
```
**Error Response** (403 Forbidden - Premium Required):
```json
{
  "status": "error",
  "message": "Premium subscription required to join more groups",
  "code": "PREMIUM_REQUIRED",
  "data": {
    "upgradeUrl": "/premium/upgrade"
  }
}
```

---

## Group Management APIs

### 6.1 Get Group Details
**Endpoint**: `GET /api/groups/{groupId}`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Group details retrieved",
  "data": {
    "group": {
      "id": "group_001",
      "name": "No Contact Warriors",
      "icon": "https://api.example.com/icons/group_001.png",
      "memberCount": 1243,
      "isAdmin": true,
      "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
      "posts": [
         {
          "id": "post_101",
          "userName": "Sarah M.",
          "userAvatar": "https://api.example.com/avatars/sarah.jpg",
          "timeAgo": "2 min ago",
          "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
          "likes": 47,
          "commentsCount": 12,
          "isAnonymous": false
        },
        {
          "id": "post_102",
          "userName": "Annomyously",
          "userAvatar": "https://api.example.com/avatars/anon.jpg",
          "timeAgo": "2 min ago",
          "content": "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
          "likes": 47,
          "commentsCount": 12,
          "isAnonymous": true
        }
      ]
    }
  }
}
```

---

### 6.2 Create Group
**Endpoint**: `POST /api/groups`
**Headers**: `Authorization: Bearer {accessToken}`, `Content-Type: application/json`
**Request**:
```json
{
  "name": "Healing Hearts",
  "logoUrl": "https://api.example.com/temp/logo_123.jpg",
  "instruction": "A safe space for those healing from heartbreak..."
}
```
**Success Response** (201 Created):
```json
{
  "status": "success",
  "message": "Group created successfully",
  "data": {
    "id": "group_999",
    "name": "Healing Hearts"
  }
}
```

---

### 6.3 Group Actions (Admin/User)
**Endpoints**:
- `DELETE /api/groups/{groupId}` (Delete Group - Admin)
- `POST /api/groups/{groupId}/leave` (Leave Group - User)
- `POST /api/groups/{groupId}/report` (Report Group)
- `PUT /api/groups/{groupId}` (Edit Group - Admin)

---

## Group Moderation & Social APIs

### 8.1 Invite Friends
**Endpoint**: `GET /api/groups/{groupId}/friends-to-invite`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "friends": [
      { "id": "f_1", "name": "Miles Esther", "avatar": "..." },
      { "id": "f_2", "name": "Sarah Jenkins", "avatar": "..." }
    ]
  }
}
```

---

### 8.2 Get Group Reports (Admin Only)
**Endpoint**: `GET /api/groups/{groupId}/reports`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "reports": [
      {
        "id": "rep_1",
        "reporterName": "Miles Esther",
        "reportedUserName": "Coach Pearl",
        "category": "Harassment",
        "content": "Amazon Alexa Shopping is seeking a talented...",
        "status": "pending"
      }
    ]
  }
}
```

---

## Social & Relationship APIs

### 9.1 Get Social Lists
**Endpoint**: `GET /api/social/lists`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "friends": [
      { "id": "u1", "name": "Miles Esther", "avatar": "...", "isOnline": true, "lastActive": "09:30 PM", "unreadCount": 2 }
    ],
    "requests": [
      { "id": "req1", "userId": "u2", "userName": "Mike Lee", "avatar": "...", "mutualFriends": 2 }
    ],
    "followers": [
      { "id": "u3", "name": "Miles Esther", "avatar": "..." }
    ],
    "following": [
      { "id": "u4", "name": "Miles Esther", "avatar": "...", "isOnline": true }
    ]
  }
}
```

---

## User Profile & Relationship Management APIs

### 10.1 Get User Profile
**Endpoint**: `GET /api/users/{userId}/profile`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "u123",
      "name": "Mike Tyson",
      "avatar": "...",
      "bio": "Amazon Alexa Shopping is seeking a talented...",
      "stats": {
        "posts": 7,
        "friends": 128,
        "followers": 220,
        "following": 14
      },
      "relationshipStatus": "none", 
      "media": ["url1", "url2", "url3", "url4", "url5"]
    }
  }
}
```
*Note: `relationshipStatus` can be `none`, `friend`, `request_sent`, or `request_received`.*

---

## Friend Discovery & Suggestions APIs

### 11.1 Get Discover Suggestions
**Endpoint**: `GET /api/social/discover`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "suggestions": [
      {
        "id": "u567",
        "name": "Mike Lee",
        "avatar": "...",
        "mutualFriends": 2
      }
    ]
  }
}
```

---

## Coaching Marketplace & Booking APIs

### 12.1 Discover Coaches
**Endpoint**: `GET /api/coaches/discover`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "heroCoach": { "id": "c1", "name": "Coach Pearl", "title": "Relationship Specialist", "rating": 5.0, "reviews": 310 },
    "featured": [ { "id": "c2", "name": "Coach Sarah", "title": "Mindset Coach", "rating": 4.9, "reviews": 187 } ],
    "topRated": [ { "id": "c3", "name": "Coach Sarah", "title": "Mindset Coach", "rating": 4.9, "reviews": 187 } ]
  }
}
```

---

### 12.2 Coach Schedule & Slots
**Endpoint**: `GET /api/coaches/{coachId}/slots?date={YYYY-MM-DD}`
**Success Response**:
```json
{
  "status": "success",
  "data": {
    "sessions": [ { "duration": "30 Min", "price": 75 }, { "duration": "60 Minutes", "price": 150 } ],
    "availableSlots": [ "09:00 AM - 09:30 AM", "10:00 AM - 10:30 AM" ]
  }
}
```

---

## Personal Profile & Identity Management APIs

### 13.1 Get My Profile
**Endpoint**: `GET /api/me/profile`
**Headers**: `Authorization: Bearer {accessToken}`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "me_1",
      "name": "Rahim Rehman",
      "avatar": "...",
      "bio": "Healing Journey Day 14",
      "stats": { "posts": 7, "friends": 128, "followers": 220, "following": 14 },
      "journals": [
        { "id": "j1", "title": "Journal", "content": "Day 14. Didn't reach out...", "date": "12 April 2026", "isPrivate": true }
      ]
    }
  }
}
```

---

### 13.2 Update Profile
**Endpoint**: `POST /api/me/update`
**Payload**: `{ "name": "...", "bio": "...", "avatar": "..." }`

---

### 13.3 Security
**Endpoint**: `POST /api/me/reset-password`
**Payload**: `{ "oldPassword": "...", "newPassword": "..." }`

---

### 13.4 Story & Content
**Endpoint**: `POST /api/me/stories`
**Payload**: `{ "content": "My Story", "textColor": "#FF0000", "bgColor": "#FFD700", "image": "..." }`

---

## Inbox & Chat APIs

### 14.1 Get Inbox Chats
**Endpoint**: `GET /api/inbox/chats`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "stories": [
      { "name": "Your Story", "avatar": "https://i.pravatar.cc/150?u=me", "isMine": true },
      { "name": "Mike", "avatar": "https://i.pravatar.cc/150?u=mike1" },
      { "name": "Sarah", "avatar": "https://i.pravatar.cc/150?u=sarah" }
    ],
    "chats": [
      {
        "id": "chat_001",
        "name": "Miles Esther",
        "avatar": "https://i.pravatar.cc/150?u=miles",
        "lastMessage": "How are you doing today?",
        "time": "09:30 PM",
        "unreadCount": 2,
        "isOnline": true,
        "isCoach": true
      },
      {
        "id": "chat_002",
        "name": "Thomas stieve",
        "avatar": "https://i.pravatar.cc/150?u=thomas",
        "lastMessage": "Let's catch up later.",
        "time": "08:15 PM",
        "unreadCount": 0,
        "isOnline": false,
        "isCoach": false
      }
    ]
  }
}
```

---

### 14.2 Get Chat Messages
**Endpoint**: `GET /api/inbox/chats/{chatId}/messages`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "messages": [
      {
        "sender": "Miles Esther",
        "avatar": "https://i.pravatar.cc/150?u=miles",
        "text": "Hey, how are you?",
        "isMe": false,
        "time": "Wednesday"
      },
      {
        "sender": "Me",
        "avatar": "",
        "text": "I am doing great, thanks!",
        "isMe": true,
        "time": "Wednesday"
      }
    ]
  }
}
```

---

## Booking APIs

### 15.1 Get Bookings
**Endpoint**: `GET /api/bookings`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "current": [
      {
        "id": "b_1",
        "sessionName": "Session 1",
        "coachName": "Coach Pearl",
        "date": "Mon, Mar 27",
        "time": "01:00 PM- 01:03PM (30Min)",
        "amount": "20$"
      }
    ],
    "history": [
      {
        "id": "b_2",
        "sessionName": "Session 2",
        "coachName": "Miles Esther",
        "date": "Completed",
        "time": "12 April, 1:30AM",
        "amount": "20$"
      }
    ]
  }
}
```

---

## Coach Module APIs

### 16.1 Get Coach Home Dashboard
**Endpoint**: `GET /api/coach/home`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "isActive": true,
    "stats": {
      "callBackRequests": "08",
      "newMessages": "12",
      "missedCalls": "03",
      "netEarnings": "$2,847.50",
      "earningsPeriod": "This month"
    },
    "sessions": [
      {
        "id": "ses_001",
        "title": "Session 1",
        "date": "Mon, Mar 27",
        "time": "01:00 PM - 01:30 PM (30Min)",
        "clientName": "Miles Esther",
        "clientAvatar": "https://api.example.com/avatars/miles.jpg",
        "rate": "$20"
      }
    ],
    "messages": [
      {
        "senderName": "Miles Esther",
        "senderAvatar": "https://api.example.com/avatars/miles.jpg",
        "status": "Online",
        "time": "09:30 PM",
        "unreadCount": "2"
      }
    ]
  }
}
```

---

### 16.2 Get Coach Inbox
**Endpoint**: `GET /api/coach/inbox`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "credits": "05",
    "stories": [
      { "id": "s_1", "name": "Your Story", "avatar": "https://api.example.com/avatars/me.jpg", "isMine": true }
    ],
    "messages": [
      { "id": "m_1", "name": "Miles Esther", "avatar": "https://api.example.com/avatars/miles.jpg", "time": "09:30 PM", "unreadCount": 2, "isOnline": true }
    ],
    "missedCalls": [
      { "id": "mc_1", "name": "Miles Esther", "avatar": "https://api.example.com/avatars/miles.jpg", "timeRequested": "12 April, 1:30AM" }
    ],
    "callbacks": [
      { "id": "cb_1", "name": "Sarah Jenkins", "avatar": "https://api.example.com/avatars/sarah.jpg", "timeRequested": "Today at 3:00 PM" }
    ],
    "clients": [
      { "id": "cl_1", "name": "Client 1", "avatar": "https://api.example.com/avatars/client1.jpg", "status": "Active Session", "time": "12 April", "unreadCount": "0" }
    ]
  }
}
```

---

### 16.3 Get Coach Circles
**Endpoint**: `GET /api/coach/circles`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "circles": [
      {
        "id": "c_1",
        "name": "No Contact Warriors",
        "icon": "https://api.example.com/icons/group_001.png",
        "memberCount": 1243,
        "description": "Day 14 of No Contact...",
        "isJoined": true
      }
    ]
  }
}
```

---

### 16.4 Get Coach Bid Board
**Endpoint**: `GET /api/coach/bidboard`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "topBiddersInfo": {
      "title": "Top Bidders List",
      "description": "Day 14 of No Contact..."
    },
    "slots": [
      { "id": "slot_1", "rank": "1", "title": "Slot 1", "startingBid": "Starting Bid : $25", "topBid": "$400", "hexColor": "0xFFC19E5F" }
    ],
    "hasWon": false
  }
}
```

---

### 16.5 Get Coach Profile Info
**Endpoint**: `GET /api/coach/profile`
**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "balance": 150.0,
    "availability": [
      { "day": "Monday", "timeRange": "09:00 AM - 12:00 PM" }
    ],
    "services": [
      { "duration": "30 mins", "price": "$50", "isActive": true }
    ]
  }
}
```

