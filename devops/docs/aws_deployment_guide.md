# AWS EC2 Production Deployment Guide

This guide describes how to provision, configure, and deploy the **SkillHive MERN-DevOps** application onto an AWS EC2 instance.

---

## 1. AWS EC2 Setup & Security Groups

### Step A: Launch EC2 Instance
1. Log in to the **AWS Management Console**.
2. Navigate to **EC2 Dashboard** and click **Launch Instance**.
3. Configure the following options:
   * **Name**: `skillhive-devops-server`
   * **AMI**: `Ubuntu Server 22.04 LTS` (64-bit x86)
   * **Instance Type**: `t3.medium` (Recommended: Jenkins + Docker running together require at least 2 vCPUs and 4GB RAM).
   * **Key Pair**: Select or create a `.pem` file for SSH access.
4. Keep the storage default (at least 20 GB to accommodate Docker images).

### Step B: Configure Security Groups
Add the following Inbound Security Group Rules to allow public/development traffic:

| Type | Port Range | Source | Purpose |
| :--- | :--- | :--- | :--- |
| **SSH** | `22` | My IP (or `0.0.0.0/0`) | Secure Remote Server access |
| **HTTP** | `80` | `0.0.0.0/0` | Single Public entry-point (Nginx reverse proxy) |
| **Custom TCP** | `8080` | `0.0.0.0/0` | Jenkins Dashboard |
| **Custom TCP** | `9090` | `0.0.0.0/0` | Prometheus Panel |

---

## 2. Server Installation & Configuration

Connect to your EC2 instance via SSH:
```bash
ssh -i "your-key.pem" ubuntu@your-ec2-public-ip
```

### Install Docker Engine
Update system packages and install Docker:
```bash
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker service is running
sudo systemctl status docker
```

### Configure Docker Permissions
To run docker commands without `sudo` (required for Jenkins pipelines):
```bash
sudo usermod -aG docker ubuntu
# Apply group changes
newgrp docker
```

---

## 3. Install Jenkins CI/CD Server

### Install Java (Requirement)
Jenkins requires Java to execute:
```bash
sudo apt update
sudo apt install -y openjdk-17-jre
```

### Install Jenkins
```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

### Authorize Jenkins for Docker Commands
Add the `jenkins` system user to the `docker` group so that the Jenkinsfile runner can execute commands:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## 4. Setup Jenkins Dashboard

1. Access Jenkins in your browser: `http://<your-ec2-public-ip>:8080`
2. Fetch the initial Administrator password:
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```
3. Copy-paste the printed token into Jenkins, choose **Install suggested plugins**, and create your Admin user.
4. Set up DockerHub Credentials:
   * Navigate to **Manage Jenkins** -> **Credentials** -> **System** -> **Global credentials**.
   * Add a new credential of type **Username with password**:
     * **ID**: `dockerhub-credentials`
     * **Username**: `<Your DockerHub username>`
     * **Password**: `<Your DockerHub Personal Access Token>`

---

## 5. First Deploy & CD Automation

Clone your `skillhive-devops` configuration repository on your EC2 host at `/home/ubuntu/skillhive-devops`:
```bash
cd /home/ubuntu
git clone https://github.com/SakshiMalik565/skillhive-devops.git
cd skillhive-devops
```

Give script execution permission:
```bash
chmod +x ./scripts/deploy.sh
chmod +x ./scripts/rollback.sh
```

Run Docker Compose locally on the server for the first time:
```bash
docker compose up -d
```

Your system is now online! 
* Public Site: `http://<your-ec2-public-ip>/`
* Prometheus: `http://<your-ec2-public-ip>:9090/`
* Jenkins: `http://<your-ec2-public-ip>:8080/`
