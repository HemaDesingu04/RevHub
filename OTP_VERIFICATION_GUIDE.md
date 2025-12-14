# 📧 OTP Verification Implementation

## ✅ Implementation Complete

OTP-based email verification has been successfully implemented!

## 🔄 How It Works

### Step 1: User Registration
```http
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
  "username": "testuser",
  "email": "your-email@gmail.com",
  "password": "password123",
  "firstName": "Test",
  "lastName": "User"
}
```

**Response:**
```json
{
  "message": "OTP sent to your email. Please verify to complete registration."
}
```

**What happens:**
- User account created with `isVerified = false`
- 6-digit OTP generated (e.g., 123456)
- OTP sent to user's email
- OTP expires in 10 minutes

### Step 2: Check Email
User receives email with:
```
Subject: RevHub - Your OTP Code

Welcome to RevHub!

Your OTP code is: 123456

This code will expire in 10 minutes.

If you didn't request this code, please ignore this email.

Thanks,
RevHub Team
```

### Step 3: Verify OTP
```http
POST http://localhost:8080/api/auth/verify-otp
Content-Type: application/json

{
  "email": "your-email@gmail.com",
  "otp": "123456"
}
```

**Response (Success):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "your-email@gmail.com",
    "firstName": "Test",
    "lastName": "User"
  }
}
```

**Response (Error):**
```json
{
  "error": "Invalid OTP"
}
// or
{
  "error": "OTP has expired"
}
```

### Step 4: Login
After OTP verification, user can login normally:
```http
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "password123"
}
```

## 🔗 API Endpoints

### 1. Register (Sends OTP)
- **URL:** `POST /api/auth/register`
- **Body:** `{ username, email, password, firstName, lastName }`
- **Response:** `{ message: "OTP sent to your email..." }`

### 2. Verify OTP (Completes Registration)
- **URL:** `POST /api/auth/verify-otp`
- **Body:** `{ email, otp }`
- **Response:** `{ token, user }` (JWT token + user details)

### 3. Login (After Verification)
- **URL:** `POST /api/auth/login`
- **Body:** `{ username, password }`
- **Response:** `{ token, user }`

## 📊 Database Schema

**users table:**
- `is_verified` (BOOLEAN) - Default: false
- `otp` (VARCHAR) - 6-digit code
- `otp_expiry` (DATETIME) - Expiry time (10 minutes from generation)

## 🎯 Frontend Flow

1. **Registration Page:**
   - User fills form and clicks "Register"
   - Show message: "OTP sent to your email"
   - Redirect to OTP verification page

2. **OTP Verification Page:**
   - Show input field for 6-digit OTP
   - User enters OTP from email
   - Click "Verify"
   - On success: Auto-login and redirect to feed

3. **Login Page:**
   - Only works after OTP verification
   - If not verified: Show error message

## 🧪 Testing

### Test Complete Flow:
```bash
# 1. Register
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john123",
    "email": "your-email@gmail.com",
    "password": "pass123",
    "firstName": "John",
    "lastName": "Doe"
  }'

# 2. Check your email for OTP (e.g., 123456)

# 3. Verify OTP
curl -X POST http://localhost:8080/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your-email@gmail.com",
    "otp": "123456"
  }'

# 4. Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john123",
    "password": "pass123"
  }'
```

## 📧 Email Configuration

- **SMTP:** smtp.gmail.com:587
- **From:** doddakarthikreddy11122@gmail.com
- **App Password:** wbouwpxntjyohclu

## ⚠️ Error Messages

| Error | Meaning |
|-------|---------|
| "Username is already taken!" | Username exists |
| "Email is already in use!" | Email exists |
| "Invalid OTP" | Wrong OTP entered |
| "OTP has expired" | OTP older than 10 minutes |
| "User not found" | Email doesn't exist |
| "Email already verified" | Already verified |
| "Please verify your email before logging in" | Login without OTP verification |

## 🔒 Security Features

- ✅ 6-digit random OTP
- ✅ OTP expires in 10 minutes
- ✅ OTP cleared after verification
- ✅ Login blocked until verified
- ✅ Secure email delivery via Gmail SMTP

## 🎉 Status

**Service:** ✅ Running
**OTP Generation:** ✅ Working
**Email Sending:** ✅ Working
**Verification:** ✅ Working
**Login Protection:** ✅ Working

**OTP verification is now fully functional! 🚀**
