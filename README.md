# SkillHive — Cloud-Based CI/CD DevOps Platform

> A MERN-stack skill-swapping platform transformed into a production-grade DevOps monorepo featuring automated CI/CD, Docker containerization, Nginx reverse proxy, and Prometheus monitoring.

---

## 📁 Monorepo Structure

```
Skill-Hive/
├── .github/
│   └── workflows/
│       ├── backend-ci.yml    # Auto-builds backend Docker image on push
│       └── frontend-ci.yml   # Auto-builds frontend Docker image on push
├── backend/                  # Node.js + Express + Socket.io API
│   ├── Dockerfile
│   ├── src/
│   └── package.json
├── frontend/                 # React + Vite SPA
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── src/
│   └── package.json
└── devops/                   # All infrastructure configs
    ├── docker-compose.yml
    ├── nginx/default.conf
    ├── monitoring/prometheus.yml
    ├── jenkins/Jenkinsfile
    └── scripts/
        ├── deploy.sh
        └── rollback.sh
```

---

## 🚀 Quick Local Start (Docker Compose)

```bash
# Clone the repo
git clone https://github.com/SakshiMalik565/Skill-Hive.git
cd Skill-Hive/devops

# Start all services (builds images automatically)
docker compose up -d --build
```

| Service | URL |
|---|---|
| **Frontend + API** | http://localhost/ |
| **Prometheus** | http://localhost:9090/ |
| **Jenkins** | http://localhost:8080/ |

---

## ⚙️ CI/CD Pipeline

### GitHub Actions (CI)
Automatically triggered on every push:
- **Backend changes** → runs `npm test` → builds & pushes `skill-hive-backend` Docker image to DockerHub
- **Frontend changes** → runs `npm run build` → builds & pushes `skill-hive-frontend` Docker image to DockerHub

**Required GitHub Secrets** (set in repo Settings → Secrets → Actions):
```
DOCKER_USERNAME   → Your DockerHub username
DOCKER_PASSWORD   → Your DockerHub password or access token
```

### Jenkins (CD)
- Pulls the new Docker images from DockerHub
- Runs `devops/scripts/deploy.sh` to recreate containers with zero-downtime
- Verifies health via `/api/health`
- Auto-rollbacks using `devops/scripts/rollback.sh` if health check fails

---

## 🔒 Security

- `.env` files are in `.gitignore` and never committed
- All secrets are configured via GitHub Secrets and Jenkins Credentials
- Nginx adds security headers on all responses

---

## ☁️ AWS Deployment

See the full step-by-step guide in [`devops/docs/aws_deployment_guide.md`](devops/docs/aws_deployment_guide.md).
