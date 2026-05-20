# SkillHive Backend Service

The backend microservice for SkillHive, built using Node.js, Express, and MongoDB. It exposes RESTful endpoints and provides real-time communication support using Socket.io.

---

## 🛠️ Technology Stack
* **Runtime**: Node.js (v20 LTS)
* **Framework**: Express.js
* **Database**: MongoDB (Mongoose ODM)
* **Real-time communication**: Socket.io
* **Testing Framework**: Jest
* **Security**: AES-256-GCM Chat Encryption, JWT Auth

---

## ⚙️ Local Development Setup

### 1. Requirements
Ensure you have **Node.js (v20+)** and **MongoDB** installed and running locally.

### 2. Environment Variables
Create a `.env` file in the root folder and configure:
```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/skillswap
JWT_SECRET=your_jwt_secret_key
CHAT_ENCRYPTION_KEY=your_base64_aes_key
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_email_password
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_key
CLOUDINARY_API_SECRET=your_cloudinary_secret
RAZORPAY_KEY_ID=your_razorpay_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
```

### 3. Run Steps
```bash
# Install dependencies
npm install

# Run unit tests
npm test

# Launch server in development mode (using nodemon)
npm run dev
```
The server will boot up and listen on port `5000`.

---

## 🐳 Dockerization

To run this backend standalone in a Docker container:

```bash
# Build the Docker image
docker build -t skillhive-backend:latest .

# Run the container
docker run -p 5000:5000 --env-file .env skillhive-backend:latest
```

---

## 🚀 Continuous Integration (CI)

This repository includes a GitHub Actions pipeline (`.github/workflows/ci.yml`) that automatically:
1. Triggers on pushes or PRs to `main` and `dev`.
2. Installs dependencies and runs unit tests.
3. Compiles the container image.
4. Pushes the image to **DockerHub** using secure workflow credentials.

<!-- CI triggered: 2026-05-21 02:37:07 -->
