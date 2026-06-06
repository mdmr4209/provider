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
4.4 Resource Not Found
404 Not Found:
```json
{
  "status": "error",
  "message": "User not found",
  "code": "USER_404",
  "timestamp": "2026-05-24T11:15:00Z"
}
```
