# 🎉 Birthday Message Service

This service sends happy birthday emails to users at exactly 9 AM in their local time zone.

## 📦 Features

- Create and delete users via REST API
- Sends birthday message at 9 AM local time
- Recovers unsent messages if the service was down
- Resilient to temporary email API failures
- Dockerized and scalable

---

## 🚀 Getting Started

### 🔧 Prerequisites

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

---

### 🛠 Setup

1. Clone or download this repo
2. From the root directory, run:

```bash
docker-compose up --build
```

> This starts the server on `http://localhost:3000`

---

## 🧪 API Endpoints

### Create User

```
POST /user
Content-Type: application/json
```

**Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "birthday": "1990-06-19T00:00:00.000Z",
  "timezone": "America/New_York"
}
```

**Response:**
- `201 Created` with the created user object

---

### Delete User

```
DELETE /user/:id
```

**Response:**
- `204 No Content` if deleted successfully

---

## 📖 API Usage Guide

### 1. Create a User

Send a POST request to `/user` with the following JSON body:

```json
{
  "firstName": "Jane",
  "lastName": "Smith",
  "birthday": "1985-12-25T00:00:00.000Z",
  "timezone": "Europe/London"
}
```

Example using `curl`:
```bash
curl -X POST http://localhost:3000/user \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Jane","lastName":"Smith","birthday":"1985-12-25T00:00:00.000Z","timezone":"Europe/London"}'
```

### 2. Delete a User

Send a DELETE request to `/user/:id` (replace `:id` with the user's ID):

Example using `curl`:
```bash
curl -X DELETE http://localhost:3000/user/1
```

---

## 🐳 Docker Notes

- Runs on Node.js 18 (Alpine)
- Uses SQLite with Prisma ORM
- Applies DB schema using `npx prisma migrate deploy`
- Sends email via: https://email-service.digitalenvision.com.au

---

## ⏱ Scheduling

- Every minute: checks for birthdays to send messages
- Daily (00:00 UTC): retries unsent birthday messages from the day before

---

## 📁 Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── prisma
│   └── schema.prisma
├── src
│   └── index.ts
├── package.json
└── README.md
```

---

## 📬 Example Message

> Hey, John Doe it’s your birthday

---

## 📃 License

MIT
