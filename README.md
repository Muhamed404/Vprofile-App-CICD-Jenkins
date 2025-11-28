📘 Jenkins Pipeline Documentation: Vprofile Application

📑 Table of Contents
	1.	Overview and Purpose
	2.	Vprofile Application Overview
	3.	Pipeline Parameters
	4.	Architecture Diagram Placeholder
	5.	Pipeline Flow
	6.	CI (Continuous Integration)
	7.	CD (Continuous Deployment)
	8.	Deployment Targets
	9.	Folder Structure Overview
	10.	How to Run Locally
	11.	Why This Pipeline Architecture?
	12.	Security Considerations

⸻

This document provides a complete, standalone explanation of the parametrized Jenkins pipeline used for the Vprofile application’s Continuous Integration (CI) and Continuous Deployment (CD).

It is structured to be clear, professional, and easy to navigate.

⸻

🌐 1. Overview and Purpose

This pipeline fully automates the building, testing, quality analysis, artifact management, and deployment of the Vprofile Java application. It is designed to be dynamic and multi-user safe by leveraging runtime parameters for branching, versioning, and targeting various cloud deployment environments (EKS, ECS, EC2, Beanstalk, Lambda).

⸻

🏛️ 2. Vprofile Application Overview

This section provides a high-level overview of the Vprofile Application, which is the core application being built and deployed by this pipeline.
	•	🗄️ Database (MySQL): Used as the primary relational data store (typically deployed via RDS, Docker, or K8s StatefulSet).
	•	⚡ Cache (Memcached): Improves performance, reduces DB load, and supports session/application-level caching.
	•	📩 Messaging (RabbitMQ): Manages background tasks, event processing, and asynchronous communication.
	•	🌐 NGINX Reverse Proxy: Handles routing, traffic management, SSL termination, and proxies requests to the backend.
	•	🏗 Application Tier (Java): Core business logic built using Maven, packaged as a WAR file, and deployed via Tomcat.

⸻

🧩 3. Pipeline Parameters (Runtime Controls)

Below are the runtime parameters that make this pipeline dynamic and flexible, enabling control over the entire CI/CD flow:

Parameter	Type	Description
BRANCH	string	Git branch to build (supports dynamic branches like user-run-9ac5b1).
VERSION	string	Application version used for artifact, image, and release tagging.
RUN_ID	string	A unique ID for every run (critical for ensuring deployment isolation).
DEPLOY_TARGET	choice	Deployment destination: EKS, ECS, EC2, BEANSTALK, LAMBDA.
RUN_DEPLOY	boolean	Toggle to enable/disable the Continuous Deployment (CD) stages.


⸻

🧩 4. Architecture Diagram (Placeholder)

(Architecture image will be added later)

📊 Suggested CI/CD Flow Diagram (Mermaid Placeholder)

flowchart LR
    A[Trigger Jenkins] --> B[CI Stages]
    B --> C{RUN_DEPLOY?}
    C -->|No| Z[Stop]
    C -->|Yes| D[CD Stages]
    D --> E[EKS / ECS / EB / EC2]

— (Placeholder)

(Architecture image will be added later)

User → Jenkins API → Parametrized Pipeline → CI → CD → Target Environment


⸻

🔧 5. Pipeline Flow

A high-level flow of how the pipeline operates from start to finish.

User → Jenkins UI / API
      → Parameters (BRANCH, VERSION, RUN_ID, DEPLOY_TARGET)
          → Jenkinsfile Execution
                → CI Stages
                     → (If RUN_DEPLOY=true)
                     → CD Stages
                           → Deploy to EKS/ECS/EB/EC2

🧪 Example Pipeline Trigger (API)

Any backend or automation system can trigger this pipeline dynamically:

curl -X POST "http://jenkins/job/vprofile-app/buildWithParameters" \
  --data BRANCH=user-run-7ab921 \
  --data VERSION=2.0.1 \
  --data RUN_ID=7ab921 \
  --data DEPLOY_TARGET=EKS \
  --data RUN_DEPLOY=true


⸻

⚙️ 6. CI (Continuous Integration) Stages

This section focuses ONLY on the build, testing, quality analysis, and artifact/image creation stages.

1️⃣ Checkout – Source Control Access
	•	Checks out the selected branch using the BRANCH parameter.
	•	Supports dynamic platform-generated branches.

2️⃣ Build (Maven) – Artifact Generation
	•	Executes mvn -s settings.xml install.
	•	Produces the WAR artifact.
	•	Archives artifacts for traceability.

3️⃣ Testing & Quality (Conditional)

Executed only when RUN_DEPLOY=true.
Includes:
	•	Unit Tests
	•	Checkstyle
	•	SonarQube Analysis
	•	Sonar Quality Gate Verification

4️⃣ Artifact Upload – Nexus Integration

Uploads the WAR file to Nexus with a unique version:

<RUN_ID>-<BUILD_ID>-<TIMESTAMP>

5️⃣ Docker Image Build – Containerization

Builds a Docker image using dynamic tagging:

app:<RUN_ID>

6️⃣ Push to ECR – Image Registry

Authenticates with AWS ECR and pushes the newly built image.

⸻

🚀 7. CD (Continuous Deployment) Stages

This section covers the deployment logic executed after CI completes, driven by the DEPLOY_TARGET parameter.

⸻

🐳 A. ECS Deployment (Terraform-Driven)

When DEPLOY_TARGET = ECS, the pipeline uses Terraform for a fully automated, ephemeral deployment:

1️⃣ Dynamic Naming

ECS_CLUSTER_NAME = "vprofile-${RUN_ID}"

2️⃣ Terraform Variable Injection

Dynamic parameters are injected into Terraform via environment exports:

export TF_VAR_CLUSTER_NAME
export TF_VAR_CONTAINER_NAME
export TF_VAR_CONTAINER_IMAGE

3️⃣ Terraform Apply

Runs inside terraform/ECS:

terraform init
terraform apply -auto-approve

Provisions:
	•	ECS Cluster
	•	Task Definition
	•	ECS Service
	•	Networking (SGs, IAM roles, Load Balancer if enabled)

4️⃣ Endpoint Retrieval

A script retrieves the public-facing endpoint:

scripts/get-ip.sh <cluster> <service>

5️⃣ Automatic Cleanup (Ephemeral)

Deletes the entire ECS environment:

terraform destroy -auto-approve

🔐 Secrets

ECS Task Definitions load secrets securely from AWS Systems Manager Parameter Store.

⸻

🌿 B. Elastic Beanstalk Deployment (Terraform Automation)

When DEPLOY_TARGET = BEANSTALK, the pipeline automates Elastic Beanstalk environment management:

1️⃣ Dynamic EB Environment Name

vprofile-${RUN_ID}

2️⃣ Terraform Apply

Runs inside terraform/BEANSTALK:

terraform init
terraform apply -auto-approve

Provisions:
	•	EB Application
	•	Application Version
	•	Environment (ALB + Auto Scaling + EC2)

3️⃣ Endpoint Retrieval

terraform output -raw beanstalk_endpoint

Displays the public URL of the deployed environment.

🔐 Secrets

Beanstalk environment variables reference AWS Systems Manager Parameter Store for secure credential injection.

⸻

📁 Folder Structure Overview

Below is a high-level view of the repository layout for clarity:

Vprofile-App-CICD-Jenkins/
│
├── Jenkinsfile
├── settings.xml
├── Docker-files/
│     └── app/Dockerfile
├── scripts/
│     └── get-ip.sh
├── terraform/
│     ├── ECS/
│     └── BEANSTALK/
└── src/


⸻

🧪 How to Run Locally / For Testing

Prerequisites
	•	JDK 17+
	•	Maven 3.9+
	•	Docker installed
	•	AWS CLI configured
	•	Terraform 1.12+

Local Build

mvn -s settings.xml clean install

Build Docker Image Locally

docker build -t vprofile-app:local -f Docker-files/app/Dockerfile .

Run the App in Docker

docker run -p 8080:8080 vprofile-app:local


⸻

🧠 Why This Pipeline Architecture?

This pipeline is designed with the following goals:

✔ Multi-user Isolation

Each run generates a unique RUN_ID, branch, image tag, and environment → perfect for platforms and ephemeral testing.

✔ Repeatable & Deterministic Builds

Using Maven + Nexus + ECR ensures reproducible artifacts.

✔ Full Cloud Flexibility

One pipeline → deploy anywhere (EKS, ECS, EB, EC2, Lambda).

✔ Terraform Automation

All environments are created and destroyed automatically → zero manual intervention.

✔ Strong Quality Gates

SonarQube, Checkstyle, and testing ensure production-grade deployments.

⸻

🔐 Security Considerations

Security is a core design principle in this pipeline.

✔ Secrets Management via Parameter Store

No secrets are stored in Jenkins or in the codebase.

✔ IAM Least Privilege

Terraform & Jenkins credentials limited to only required resources.

✔ No Hardcoded Secrets

All credentials (DB, cache, message broker) injected at runtime.

✔ Clean Workspace

cleanWs() ensures no data or artifacts remain.

⸻

🎯 Final Notes

This pipeline is designed to be:
	•	Cloud-ready
	•	Multi-user safe
	•	Highly scalable
	•	Easy to integrate with external systems

⸻

🛠 Tools Used in the Pipeline
	•	Jenkins (Declarative Pipeline)
	•	Maven 3.9
	•	JDK 17 / JDK 11
	•	Terraform 1.12+
	•	Docker
	•	Amazon ECR / ECS / EB / EKS / Parameter Store
	•	SonarQube
	•	Checkstyle
	•	Nexus3