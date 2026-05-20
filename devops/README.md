# SkillHive – Cloud-Based CI/CD DevOps Platform

This repository contains the configuration, automation scripts, CI/CD pipelines, and monitoring setups that transform the **SkillHive** MERN-stack project into a production-grade, cloud-native DevOps ecosystem.

---

## 🏗️ Architecture Design

```
                     +---------------------------------------+
                     |         Developer Workspace           |
                     |  - Pushes code to GitHub dev/main     |
                     +-------------------+-------------------+
                                         |
                                         v
                     +-------------------+-------------------+
                     |         GitHub Repository             |
                     |  - Triggers GHA CI Workflow           |
                     +-------------------+-------------------+
                                         |
                                         v
                     +-------------------+-------------------+
                     |       GitHub Actions (CI)             |
                     |  - Runs dependencies & test checks    |
                     |  - Compiles Vite / Node assets        |
                     |  - Pushes images to DockerHub         |
                     +-------------------+-------------------+
                                         |
                                         v
                     +-------------------+-------------------+
                     |          Jenkins (CD)                 |
                     |  - Webhook triggers pull & deploy     |
                     |  - Runs deploy.sh health verify       |
                     |  - Rolls back if healthcheck fails    |
                     +-------------------+-------------------+
                                         |
                                         v
                     +-------------------+-------------------+
                     |         AWS EC2 Server                |
                     |  - Hosts Docker Compose Topology      |
                     |  - Public Nginx gateway on Port 80    |
                     |  - Prometheus monitoring on Port 9090 |
                     +---------------------------------------+
```

---

## 📂 Repository Directory Structure

```
skillhive-devops/
├── docker-compose.yml       # Production/local docker-compose topology
├── nginx/
│   └── default.conf         # Reverse proxy mapping ports & Socket.io
├── monitoring/
│   └── prometheus.yml       # Prometheus scrape configurations
├── jenkins/
│   └── Jenkinsfile          # Jenkins pipeline orchestration (CD)
├── scripts/
│   ├── deploy.sh            # Pull, deploy, and health verification script
│   └── rollback.sh          # Auto-rollback recovery script
├── docs/
│   ├── aws_deployment_guide.md  # Detailed AWS setup instruction set
│   └── viva_prep_guide.md       # Q&A guide for college project presentation
└── README.md                # This manual
```

---

## ⚙️ Local Development Quickstart

To run the entire ecosystem locally:

### 1. Requirements
Ensure you have **Docker** and **Docker Compose** installed on your machine.

### 2. Configure Environment variables
Ensure you have the required variables configured in your services or compose settings. The default configuration connects to a local MongoDB instance defined in the compose network.

### 3. Launch Services
From the root of this `skillhive-devops` directory, execute:
```bash
docker compose up -d --build
```
This command builds the frontend & backend images locally, and spins up MongoDB, cAdvisor, Nginx, and Prometheus.

### 4. Verification
Once running, check your services:
* **Frontend Application**: [http://localhost/](http://localhost/)
* **Backend API Health Check**: [http://localhost/api/health](http://localhost/api/health)
* **Prometheus Metrics Dashboard**: [http://localhost:9090/](http://localhost:9090/)

### 5. Shutdown Services
```bash
docker compose down -v
```

---

## 📈 Monitoring Stack (Prometheus)

Prometheus tracks the health of:
1. **Container Metrics**: CPU, Memory, Disk, and Network stats for each microservice using Google **cAdvisor**.
2. **Backend Services**: Direct availability queries via the `/api/health` HTTP endpoint.

To view target status in Prometheus, navigate to:
`http://localhost:9090/targets`
