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
---
5 . Dummy Data Collections
   5.1 Users Collection
```json
{
  "users": [
    {
      "id": "user_123",
      "name": "John Doe",
      "email": "user@example.com",
      "passwordHash": "$2b$10$hashed_password123",
      "phoneNumber": "+1234567890",
      "role": "customer",
      "profilePictureUrl": "https://api.example.com/images/user_123.jpg",
      "bio": "Software Developer",
      "dateOfBirth": "1995-05-15",
      "gender": "male",
      "isEmailVerified": true,
      "isPhoneVerified": true,
      "accountStatus": "active",
      "twoFactorEnabled": false,
      "createdAt": "2026-05-20T08:00:00Z",
      "updatedAt": "2026-05-24T11:00:00Z",
      "lastLogin": "2026-05-24T10:30:00Z",
      "loginAttempts": 0,
      "lockedUntil": null,
      "setupCompleted": true,
      "setupCompletedAt": "2026-05-22T14:30:00Z"
    },
    {
      "id": "user_456",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "passwordHash": "$2b$10$hashed_password456",
      "phoneNumber": null,
      "role": "customer",
      "profilePictureUrl": null,
      "bio": null,
      "dateOfBirth": null,
      "gender": null,
      "isEmailVerified": false,
      "isPhoneVerified": false,
      "accountStatus": "pending_verification",
      "twoFactorEnabled": false,
      "createdAt": "2026-05-24T10:35:00Z",
      "updatedAt": "2026-05-24T10:35:00Z",
      "lastLogin": null,
      "loginAttempts": 0,
      "lockedUntil": null,
      "setupCompleted": false,
      "setupCompletedAt": null
    }
  ]
}
```
---
5.2 User Preferences Collection
```json
{
  "preferences": [
    {
      "userId": "user_123",
      "notificationsEnabled": true,
      "emailNotificationsEnabled": true,
      "pushNotificationsEnabled": true,
      "smsNotificationsEnabled": false,
      "newsletterSubscribed": true,
      "categoryInterest": "Technology",
      "marketingEmails": true,
      "dataCollection": true,
      "language": "en",
      "timezone": "UTC+0",
      "theme": "light",
      "updatedAt": "2026-05-24T11:00:00Z"
    }
  ]
}
```
---
5.3 Setup Sessions Collection
```json
{
  "setupSessions": [
    {
      "sessionId": "setup_session_789",
      "userId": "user_456",
      "startedAt": "2026-05-24T10:35:00Z",
      "completedAt": null,
      "isComplete": false,
      "currentStep": 2,
      "totalSteps": 3,
      "completedSteps": [1],
      "stepData": {
        "step1": {
          "bio": "I am a software engineer",
          "phoneNumber": "+1234567890",
          "profilePhotoUrl": "https://api.example.com/images/user_456.jpg",
          "completedAt": "2026-05-24T10:40:00Z"
        },
        "step2": {
          "notificationsEnabled": true,
          "newsletterSubscribed": true,
          "categoryInterest": "Technology",
          "completedAt": null
        },
        "step3": {
          "confirmAll": null,
          "acceptedTerms": null,
          "completedAt": null
        }
      },
      "progress": 66
    }
  ]
}
```
---
5.4 Login Sessions Collection
```json
{
  "sessions": [
    {
      "sessionId": "session_456",
      "userId": "user_123",
      "deviceId": "device_789",
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "loginIp": "192.168.1.1",
      "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...",
      "loginAt": "2026-05-24T10:30:00Z",
      "expiresAt": "2026-05-24T14:30:00Z",
      "lastActivityAt": "2026-05-24T10:30:00Z",
      "isActive": true
    }
  ]
}
```
---
6 . Response Codes
   6.1 Success Codes .
   Code	Meaning	HTTP Status
   AUTH_001	Login successful	200
   AUTH_201	Signup successful	201
   AUTH_202	OTP verified	200
   AUTH_203	OTP sent	200
   AUTH_204	Reset link sent	200
   AUTH_205	Password reset success	200
   AUTH_206	Password changed	200
   AUTH_207	Social login success	200
   AUTH_208	Logout success	200
   AUTH_209	Token refreshed	200
   USER_301	Profile retrieved	200
   USER_302	Profile updated	200
   USER_303	Picture uploaded	200
   SETUP_401	Status retrieved	200
   SETUP_402	Step 1 complete	200
   SETUP_403	Step 2 complete	200
   SETUP_404	Setup complete	200
---
6.2
