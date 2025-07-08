# Microservices API & Kubernetes Deployment Guide

This document provides:
- **Step-by-step instructions** for deploying each microservice on Kubernetes (with YAML examples)
- **All REST API endpoints** for each service, including URL, method, and example request bodies for Postman

---
## Project Structure Overview

```mermaid
graph TD
    A[Final Project - Microservices Architecture] --> B[Registration_Microservice]
    A --> C[Coach_Player_Microservice]
    A --> D[Ticket_Microservice]
    
    B --> B1[Node.js + Express]
    B --> B2[MongoDB + Mongoose]
    B --> B3[JWT Authentication]
    B --> B4[Docker]
    B --> B5[Kubernetes]
    
    C --> C1[Node.js + Express]
    C --> C2[MongoDB + Mongoose]
    C --> C3[JWT Authentication]
    C --> C4[Docker]
    C --> C5[Kubernetes]
    
    D --> D1[Node.js + Express]
    D --> D2[MongoDB + Mongoose]
    D --> D3[JWT Authentication]
    D --> D4[CORS]
    D --> D5[Docker]
    D --> D6[Kubernetes]
    
    style A fill:#f9f,stroke:#333,stroke-width:3px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style C fill:#bbf,stroke:#333,stroke-width:2px
    style D fill:#bbf,stroke:#333,stroke-width:2px
```



## 1. Kubernetes Deployment & Service Instructions

### Prerequisites
- Kubernetes cluster (local or cloud)
- `kubectl` CLI installed and configured
- Docker images are available on Docker Hub (see YAMLs for image names)

### Quick Start
For the fastest deployment, use the provided scripts:
- **Windows**: `apply-services.ps1`
- **Linux/Mac**: `apply-services.sh`

These scripts will deploy all three microservices automatically.

### Deployment Steps

#### Option 1: Deploy All Services (Recommended)
Use the provided deployment scripts to deploy all microservices at once:

**For Windows (PowerShell):**
```powershell
.\apply-services.ps1
```

**For Linux/Mac:**
```bash
./apply-services.sh
```

#### Option 2: Deploy Individual Services
1. **Navigate to the microservice's directory**
   ```sh
   cd <Microservice_Dir>
   ```
2. **Apply the deployment and service YAMLs**
   ```sh
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```
3. **Verify pods and services**
   ```sh
   kubectl get pods
   kubectl get svc
   ```
4. **Access services**
   - Use the NodePort or ClusterIP as defined in the YAMLs.
   - Example: `http://<NodeIP>:<NodePort>`

### Service Access
After deployment, services are accessible via NodePort:
- **Registration Service**: `http://<NodeIP>:30001`
- **Coach-Player Service**: `http://<NodeIP>:30004`
- **Ticket Service**: `http://<NodeIP>:30005`

### Example: Coach-Player Microservice
- Deployment: `Coach_Player_Microservice/deployment.yaml`
- Service: `Coach_Player_Microservice/service.yaml`

---

## 2. API Endpoints & Postman Examples

### Coach-Player Microservice (Port 5004)

#### Coach Endpoints
- **POST /coach/schedule**
  - Create a match
  - Body:
    ```json
    {
      "opponent": "Team Alpha",
      "matchDate": "2025-07-10T18:00:00Z",
      "game": "Valorant"
    }
    ```
- **POST /coach/assignvod**
  - Assign VOD
  - Body:
    ```json
    {
      "matchId": 1234,
      "playerEmail": "player.user@vainglory.com"
    }
    ```
- **PUT /coach/update-password**
  - Body:
    ```json
    {
      "email": "coach.user@vainglory.com",
      "oldPassword": "oldpass",
      "newPassword": "newpass123"
    }
    ```
- **PUT /coach/reset-password**
  - Body:
    ```json
    {
      "email": "coach.user@vainglory.com",
      "mobile": "+1234567890",
      "newPassword": "newpass123"
    }
    ```

#### Player Endpoints
- **PUT /player/reviewvod/:vodId**
  - Body:
    ```json
    {
      "notes": "Great performance, need to improve defense."
    }
    ```
- **PUT /player/reset-password**
  - Body:
    ```json
    {
      "email": "player.user@vainglory.com",
      "mobile": "+1234567890",
      "newPassword": "newpass123"
    }
    ```
- **PUT /player/update-password**
  - Body:
    ```json
    {
      "email": "player.user@vainglory.com",
      "oldPassword": "oldpass",
      "newPassword": "newpass123"
    }
    ```

#### Shared
- **GET /schedules**
- **GET /health**

---

### Registration Microservice (Port 5001)

#### Registration
- **POST /coach**
  - Body:
    ```json
    {
      "firstname": "Coach Name",
      "password": "password123",
      "mobile": "+1234567890"
    }
    ```
- **POST /player**
  - Body:
    ```json
    {
      "firstname": "Player Name",
      "password": "password123",
      "mobile": "+1234567890"
    }
    ```
- **POST /admin**
  - Body:
    ```json
    {
      "firstname": "Admin Name",
      "password": "password123",
      "mobile": "+1234567890"
    }
    ```
- **POST /login**
  - Body:
    ```json
    {
      "email": "coach.user@vainglory.com",
      "password": "password123"
    }
    ```
- **PUT /update-password**
  - Body:
    ```json
    {
      "oldPassword": "oldpass",
      "newPassword": "newpass123"
    }
    ```
- **GET /health**

---

### Ticket Microservice (Port 5005)

#### User
- **POST /register**
  - Body:
    ```json
    {
      "name": "User Name",
      "password": "password123",
      "mobile": "+1234567890"
    }
    ```
- **POST /login**
  - Body:
    ```json
    {
      "email": "user.user@ticketbooking.com",
      "password": "password123"
    }
    ```
- **GET /api/matches**
- **GET /user/schedules**

#### Ticket (JWT required)
- **POST /api/tickets**
  - Body:
    ```json
    {
      "matchId": 1234,
      "seatSection": "VIP",
      "seatNumber": 1,
      "price": 100.0,
      "currency": "USD",
      "specialRequests": "Near the stage"
    }
    ```
- **PUT /api/tickets/:id**
  - Body:
    ```json
    {
      "seatSection": "Premium",
      "seatNumber": 2,
      "price": 120.0
    }
    ```
- **PATCH /api/tickets/:id/status**
  - Body:
    ```json
    {
      "status": "confirmed"
    }
    ```
- **PATCH /api/tickets/:id/payment**
  - Body:
    ```json
    {
      "paymentStatus": "completed"
    }
    ```
- **DELETE /api/tickets/:id**
- **GET /api/matches/:matchId/tickets**
- **GET /api/matches/:matchId/availability**
- **GET /api/stats**
- **GET /health**

---

## 3. Kubernetes YAML Examples

### Coach-Player Microservice
#### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coach-player-service
  labels:
    app: coach-player-service
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: coach-player-service
  template:
    metadata:
      labels:
        app: coach-player-service
        tier: backend
    spec:
      containers:
      - name: coach-player-service
        image: kingczin/coach_player-service:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 5004
        env:
        - name: MONGODB_URI
          value: "mongodb+srv://username:123@dead-drop-db.shfcaup.mongodb.net/Esport?retryWrites=true&w=majority&appName=dead-drop-db"
        - name: JWT_SECRET
          value: "347186591486#^%%ABCF*##GHE"
        - name: PORT
          value: "5004"
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5004
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 5004
```
#### service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: coach-player-service
  labels:
    app: coach-player-service
spec:
  selector:
    app: coach-player-service
  ports:
  - name: http
    port: 80
    targetPort: 5004
    protocol: TCP
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  name: coach-player-service-nodeport
  labels:
    app: coach-player-service
spec:
  selector:
    app: coach-player-service
  ports:
  - name: http
    port: 5004
    targetPort: 5004
    nodePort: 30004
    protocol: TCP
  type: NodePort
```

### Registration Microservice
#### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: registration-service
  labels:
    app: registration-service
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: registration-service
  template:
    metadata:
      labels:
        app: registration-service
        tier: backend
    spec:
      containers:
      - name: registration-service
        image: kingczin/register-authentication:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 5001
        env:
        - name: MONGODB_URI
          value: "mongodb+srv://username:123@dead-drop-db.shfcaup.mongodb.net/Esport?retryWrites=true&w=majority&appName=dead-drop-db"
        - name: JWT_SECRET
          value: "347186591486#^%%ABCF*##GHE"
        - name: PORT
          value: "5001"
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5001
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 5001
```
#### service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: registration-service
  labels:
    app: registration-service
spec:
  selector:
    app: registration-service
  ports:
  - name: http
    port: 80
    targetPort: 5001
    protocol: TCP
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  name: registration-service-nodeport
  labels:
    app: registration-service
spec:
  selector:
    app: registration-service
  ports:
  - name: http
    port: 5001
    targetPort: 5001
    nodePort: 30001
    protocol: TCP
  type: NodePort
```

### Ticket Microservice
#### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ticket-service
  labels:
    app: ticket-service
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ticket-service
  template:
    metadata:
      labels:
        app: ticket-service
        tier: backend
    spec:
      containers:
      - name: ticket-service
        image: kingczin/ticket-service:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 5005
        env:
        - name: MONGODB_URI
          value: "mongodb+srv://username:123@dead-drop-db.shfcaup.mongodb.net/Esport?retryWrites=true&w=majority&appName=dead-drop-db"
        - name: JWT_SECRET
          value: "347186591486#^%%ABCF*##GHE"
        - name: PORT
          value: "5005"
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5005
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 5005
```
#### service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: ticket-service
  labels:
    app: ticket-service
spec:
  selector:
    app: ticket-service
  ports:
  - name: http
    port: 80
    targetPort: 5005
    protocol: TCP
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  name: ticket-service-nodeport
  labels:
    app: ticket-service
spec:
  selector:
    app: ticket-service
  ports:
  - name: http
    port: 5005
    targetPort: 5005
    nodePort: 30005
    protocol: TCP
  type: NodePort
```

---

**Tip:** All protected endpoints require a valid JWT in the `Authorization` header.

---

**For more details, see the YAML files in each microservice's directory (deployment.yaml and service.yaml).**
