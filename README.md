# BobApp

Welcome to **BobApp**, a full-stack application divided into two core parts:
- An Angular-based front-end
- A Spring Boot-based back-end

This project integrates Docker for containerization and GitHub Actions for CI/CD automation.

---

## 🧰 Prerequisites

### 🖥️ Front-End
- Angular
- Node.js & npm

### 🖥️ Back-End
- Java 17
- Spring Boot
- Maven

### 🚀 Front-end 

1. Navigate to the front-end folder:
```bash
cd front
```

2. Install dependencies:
```bash
npm install
```

3. Run the development server:
```bash
npm run start
```

### 🚀 Back-End Setup

1. Navigate to the back-end folder:
```bash
cd back
```

2. Build and run:
```bash
mvn clean install
mvn spring-boot:run
```

### 🐳 Docker

#### 🔄 Pull the latest images (if needed)

```bash
docker pull hoaktuah/bobapp-back
docker pull hoaktuah/bobapp-front
```

#### 🚀 Launch containers using Docker Compose

```bash
docker-compose up -d
```

✅ Access the application: [http://localhost](http://localhost)