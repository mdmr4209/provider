# 📄 API Schemas & JSON Responses - Complete Guide

## Table of Contents

1. [Authentication APIs](#1-authentication-apis)
2. [User Profile APIs](#2-user-profile-apis)
3. [Setup APIs](#3-setup-apis)
4. [Error Responses](#4-error-responses)
5. [Dummy Data Collections](#5-dummy-data-collections)
6. [Response Codes](#6-response-codes)
7. [API Endpoint Summary](#7-api-endpoint-summary)

---

## 1. Authentication APIs

### 1.1 Login API

**Endpoint**: `POST /api/auth/login`

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "rememberMe": true
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Login successful",
  "code": "AUTH_001",
  "data": {
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "user@example.com",
      "phoneNumber": "+1234567890",
      "role": "customer",
      "profilePictureUrl": "https://api.example.com/images/user_123.jpg",
      "isEmailVerified": true,
      "isPhoneVerified": false,
      "accountStatus": "active",
      "createdAt": "2026-05-20T08:00:00Z",
      "lastLogin": "2026-05-24T10:30:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600,
      "tokenType": "Bearer"
    },
    "session": {
      "sessionId": "session_456",
      "deviceId": "device_789",
      "loginIp": "192.168.1.1",
      "userAgent": "Mozilla/5.0...",
      "lastActivity": "2026-05-24T10:30:00Z"
    }
  }
}
```

**Error Response** (401 Unauthorized):
```json
{
  "status": "error",
  "message": "Invalid email or password",
  "code": "AUTH_101",
  "data": null,
  "timestamp": "2026-05-24T10:30:00Z"
}
```

---

### 1.2 Sign Up API

**Endpoint**: `POST /api/auth/signup`

**Request**:
```json
{
  "name": "Jane Smith",
  "email": "jane@example.com",
  "password": "SecurePass123!",
  "confirmPassword": "SecurePass123!",
  "acceptTerms": true
}
```

**Success Response** (201 Created):
```json
{
  "status": "success",
  "message": "Account created successfully",
  "code": "AUTH_201",
  "data": {
    "user": {
      "id": "user_456",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "phoneNumber": null,
      "role": "customer",
      "profilePictureUrl": null,
      "isEmailVerified": false,
      "isPhoneVerified": false,
      "accountStatus": "pending_verification",
      "createdAt": "2026-05-24T10:35:00Z",
      "lastLogin": null
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600,
      "tokenType": "Bearer"
    },
    "verificationRequired": {
      "email": true,
      "phone": false,
      "otp": "123456"
    }
  }
}
```

**Error Response** (400 Bad Request):
```json
{
  "status": "error",
  "message": "Email already registered",
  "code": "AUTH_102",
  "errors": [
    {
      "field": "email",
      "message": "Email already exists",
      "code": "FIELD_EXISTS"
    }
  ],
  "timestamp": "2026-05-24T10:35:00Z"
}
```

---

### 1.3 OTP Verification API

**Endpoint**: `POST /api/auth/verify-otp`

**Request**:
```json
{
  "email": "jane@example.com",
  "otp": "123456",
  "type": "email"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "OTP verified successfully",
  "code": "AUTH_202",
  "data": {
    "verified": true,
    "verificationType": "email",
    "email": "jane@example.com",
    "verifiedAt": "2026-05-24T10:40:00Z",
    "userId": "user_456"
  }
}
```

**Error Response** (400 Bad Request):
```json
{
  "status": "error",
  "message": "Invalid or expired OTP",
  "code": "AUTH_103",
  "data": {
    "attemptsRemaining": 2,
    "nextRetryAt": "2026-05-24T10:41:00Z"
  }
}
```

---

### 1.4 Resend OTP API

**Endpoint**: `POST /api/auth/resend-otp`

**Request**:
```json
{
  "email": "jane@example.com",
  "type": "email"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "OTP sent successfully",
  "code": "AUTH_203",
  "data": {
    "otpSentTo": "jane@example.com",
    "expiresIn": 300,
    "nextResendAfter": 60,
    "deliveryMethod": "email"
  }
}
```

---

### 1.5 Forgot Password API

**Endpoint**: `POST /api/auth/forgot-password`

**Request**:
```json
{
  "email": "user@example.com"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Password reset link sent to email",
  "code": "AUTH_204",
  "data": {
    "resetToken": "reset_token_xyz",
    "expiresIn": 1800,
    "email": "user@example.com",
    "resetLink": "https://app.example.com/reset?token=reset_token_xyz"
  }
}
```

---

### 1.6 Reset Password API

**Endpoint**: `POST /api/auth/reset-password`

**Request**:
```json
{
  "token": "reset_token_xyz",
  "newPassword": "NewSecurePass456!",
  "confirmPassword": "NewSecurePass456!"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Password reset successfully",
  "code": "AUTH_205",
  "data": {
    "userId": "user_123",
    "resetAt": "2026-05-24T10:45:00Z",
    "message": "You can now login with your new password"
  }
}
```

---

### 1.7 Change Password API

**Endpoint**: `POST /api/auth/change-password`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
```json
{
  "currentPassword": "password123",
  "newPassword": "NewSecurePass456!",
  "confirmPassword": "NewSecurePass456!"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Password changed successfully",
  "code": "AUTH_206",
  "data": {
    "userId": "user_123",
    "changedAt": "2026-05-24T10:50:00Z"
  }
}
```

---

### 1.8 Social Login API

**Endpoint**: `POST /api/auth/social-login`

**Request**:
```json
{
  "provider": "google",
  "idToken": "google_id_token_xyz",
  "accessToken": "google_access_token_xyz"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Social login successful",
  "code": "AUTH_207",
  "data": {
    "user": {
      "id": "user_789",
      "name": "John Google",
      "email": "john.google@gmail.com",
      "profilePictureUrl": "https://google.com/avatar/john",
      "isNewUser": true,
      "accountStatus": "active"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600,
      "tokenType": "Bearer"
    },
    "isSetupComplete": false
  }
}
```

---

### 1.9 Logout API

**Endpoint**: `POST /api/auth/logout`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
```json
{
  "deviceId": "device_789",
  "sessionId": "session_456"
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Logged out successfully",
  "code": "AUTH_208",
  "data": {
    "userId": "user_123",
    "logoutAt": "2026-05-24T11:00:00Z",
    "sessionCleared": true
  }
}
```

---

### 1.10 Refresh Token API

**Endpoint**: `POST /api/auth/refresh-token`

**Request**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Token refreshed successfully",
  "code": "AUTH_209",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600,
    "tokenType": "Bearer"
  }
}
```

---

## 2. User Profile APIs

### 2.1 Get User Profile

**Endpoint**: `GET /api/user/profile`

**Headers**: `Authorization: Bearer {accessToken}`

**Success Response** (200 OK):
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

### 2.2 Update User Profile

**Endpoint**: `PUT /api/user/profile`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
```json
{
  "name": "John Doe Updated",
  "phoneNumber": "+1234567890",
  "bio": "Senior Software Developer",
  "dateOfBirth": "1995-05-15",
  "gender": "male"
}
```

**Success Response** (200 OK):
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

### 2.3 Update Profile Picture

**Endpoint**: `POST /api/user/profile-picture`

**Headers**: `Authorization: Bearer {accessToken}`, `Content-Type: multipart/form-data`

**Request**:
```
FormData:
  - file: <binary_image_data>
  - mimeType: "image/jpeg"
```

**Success Response** (200 OK):
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

## 3. Setup APIs

### 3.1 Get Setup Status

**Endpoint**: `GET /api/user/setup-status`

**Headers**: `Authorization: Bearer {accessToken}`

**Success Response** (200 OK):
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

### 3.2 Setup Step 1 - Profile Information

**Endpoint**: `POST /api/user/setup/step1`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
```json
{
  "bio": "I am a software engineer",
  "phoneNumber": "+1234567890",
  "profilePhotoUrl": "https://api.example.com/images/user_456.jpg"
}
```

**Success Response** (200 OK):
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

### 3.3 Setup Step 2 - User Preferences

**Endpoint**: `POST /api/user/setup/step2`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
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

**Success Response** (200 OK):
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

### 3.4 Setup Step 3 - Summary & Complete

**Endpoint**: `POST /api/user/setup/complete`

**Headers**: `Authorization: Bearer {accessToken}`

**Request**:
```json
{
  "confirmAll": true,
  "acceptedTerms": true
}
```

**Success Response** (200 OK):
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

## 4. Error Responses

### 4.1 Authentication Errors

**401 Unauthorized - Invalid Token**:
```json
{
  "status": "error",
  "message": "Invalid or expired token",
  "code": "AUTH_401",
  "timestamp": "2026-05-24T11:15:00Z"
}
```

**401 Unauthorized - Token Missing**:
```json
{
  "status": "error",
  "message": "Authorization header missing",
  "code": "AUTH_402",
  "timestamp": "2026-05-24T11:15:00Z"
}
```

---

### 4.2 Validation Errors

**400 Bad Request - Validation Failed**:
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

### 4.3 Server Errors

**500 Internal Server Error**:
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

### 4.4 Resource Not Found

**404 Not Found**:
```json
{
  "status": "error",
  "message": "User not found",
  "code": "USER_404",
  "timestamp": "2026-05-24T11:15:00Z"
}
```

---

## 5. Dummy Data Collections

### 5.1 Users Collection

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

### 5.2 User Preferences Collection

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

### 5.3 Setup Sessions Collection

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

### 5.4 Login Sessions Collection

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

## 6. Response Codes

### 6.1 Success Codes

| Code | Meaning | HTTP Status |
|------|---------|-------------|
| AUTH_001 | Login successful | 200 |
| AUTH_201 | Signup successful | 201 |
| AUTH_202 | OTP verified | 200 |
| AUTH_203 | OTP sent | 200 |
| AUTH_204 | Reset link sent | 200 |
| AUTH_205 | Password reset success | 200 |
| AUTH_206 | Password changed | 200 |
| AUTH_207 | Social login success | 200 |
| AUTH_208 | Logout success | 200 |
| AUTH_209 | Token refreshed | 200 |
| USER_301 | Profile retrieved | 200 |
| USER_302 | Profile updated | 200 |
| USER_303 | Picture uploaded | 200 |
| SETUP_401 | Status retrieved | 200 |
| SETUP_402 | Step 1 complete | 200 |
| SETUP_403 | Step 2 complete | 200 |
| SETUP_404 | Setup complete | 200 |

---

### 6.2 Error Codes

| Code | Message | HTTP Status |
|------|---------|-------------|
| AUTH_101 | Invalid credentials | 401 |
| AUTH_102 | Email already exists | 400 |
| AUTH_103 | Invalid OTP | 400 |
| AUTH_104 | Email not verified | 403 |
| AUTH_105 | Account locked | 403 |
| AUTH_401 | Invalid token | 401 |
| AUTH_402 | Missing auth header | 401 |
| AUTH_403 | Insufficient permissions | 403 |
| VALIDATION_001 | Validation failed | 400 |
| USER_404 | User not found | 404 |
| SERVER_500 | Internal error | 500 |

---

## 7. API Endpoint Summary

### Authentication Endpoints

```
POST   /api/auth/login              Login with email/password
POST   /api/auth/signup             Create new account
POST   /api/auth/verify-otp         Verify OTP code
POST   /api/auth/resend-otp         Resend OTP
POST   /api/auth/forgot-password    Request password reset
POST   /api/auth/reset-password     Reset password with token
POST   /api/auth/change-password    Change existing password
POST   /api/auth/social-login       Social provider login
POST   /api/auth/logout             User logout
POST   /api/auth/refresh-token      Refresh access token
```

### User Endpoints

```
GET    /api/user/profile            Get user profile
PUT    /api/user/profile            Update user profile
POST   /api/user/profile-picture    Upload profile picture
```

### Setup Endpoints

```
GET    /api/user/setup-status       Get current setup status
POST   /api/user/setup/step1        Complete profile step
POST   /api/user/setup/step2        Complete preferences step
POST   /api/user/setup/complete     Complete entire setup
```

---

## Request/Response Timeline Example

```
User Action                Time    API Endpoint                   Status
────────────────────────────────────────────────────────────────────────
1. Tap Login button        0ms     -                              Ready
2. Enter email/password    0ms     -                              Waiting
3. Tap Login               0ms     -                              Request
4. Submit                  15ms    POST /api/auth/login           Sending
5. Network delay           150ms   -                              In transit
6. Server processing       200ms   -                              Processing
7. Response waiting        100ms   -                              Pending
8. Receive response        500ms   POST /api/auth/login           Success
9. Parse JSON              30ms    -                              Parsing
10. Update UI              20ms    -                              Rendering
11. Navigate               30ms    -                              Navigation
Total Response Time        500ms

```

---

## Testing Checklist

- [ ] Test login with valid credentials
- [ ] Test login with invalid email
- [ ] Test login with wrong password
- [ ] Test signup with new email
- [ ] Test signup with existing email
- [ ] Test OTP verification
- [ ] Test OTP resend
- [ ] Test password reset flow
- [ ] Test password change
- [ ] Test profile update
- [ ] Test profile picture upload
- [ ] Test setup flow (all 3 steps)
- [ ] Test logout
- [ ] Test token refresh
- [ ] Test social login (Google, Facebook)

---

**Last Updated**: May 24, 2026
**API Version**: 1.0
**Status**: ✅ Complete
