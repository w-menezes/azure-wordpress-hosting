# Azure WordPress Hosting

Production-ready WordPress hosting architecture on Microsoft Azure, designed with **simplicity (KISS)**, **operational control**, and **predictable cost** as first-class concerns.

This project intentionally avoids managed PaaS dependencies where they add cost or opacity, and instead favors a **single Azure VM running containerized services**.

---

## Goals
- Simple, understandable architecture
- Full operational control (no hidden platform behavior)
- Predictable and low Azure costs
- Easy backup, restore, and migration

## Non-Goals
- Multi-tenant WordPress SaaS
- Auto-scaling across multiple regions
- Plugin or theme development

---

## High-Level Architecture

All core services are containerized and hosted **on a single Azure VM**:

- WordPress (PHP-FPM)
- Web server (Nginx)
- MySQL database

The VM is fronted by **Cloudflare** for DNS, TLS, and WAF protection.

This design prioritizes:
- Fewer Azure resources
- Lower monthly cost
- Easier troubleshooting
- Clear ownership boundaries

---

## Core Design Principles

### 1. Single-VM, Multi-Container Model
- One Azure VM
- Docker and Docker Compose
- Containers communicate over a private bridge network

This avoids:
- App Service pricing overhead
- Managed database costs
- Cross-service latency
- Platform-imposed constraints

### 2. Containers Over Pets (But Still Practical)
- Containers are disposable
- Data is persistent
- VM is cattle *operationally*, but treated carefully *procedurally*

### 3. Cost Control First
- VM sizing is explicit
- Storage costs are transparent
- No per-request or per-connection billing surprises

---

## Components

### Compute
- **Azure Virtual Machine**
- Linux-based OS (Ubuntu LTS)
- Sized conservatively, vertically scalable

### Container Runtime
- Docker Engine
- Docker Compose for orchestration

### Application Stack
- WordPress container
- Web server container (Nginx)
- MySQL container

### Storage
- Azure Managed Disk
- Mounted to the VM
- Used for:
  - WordPress uploads
  - MySQL data directory

### Networking
- Public IP on VM
- NSG allowing only required ports
- Cloudflare in front for:
  - DNS
  - TLS termination
  - WAF

---

## Database Design (Important)

**MySQL runs as a container on the same VM as WordPress.**

Rationale:
- Eliminates managed MySQL cost
- Avoids network latency
- Simplifies backups (filesystem + logical dumps)
- Keeps the entire stack portable

Persistence:
- MySQL data stored on mounted Azure disk
- Container restarts do not affect data

This is a deliberate tradeoff favoring:
- Cost efficiency
- Simplicity
- Predictability

---

## Security Model

- No public database access
- Cloudflare WAF in front of the VM
- SSH restricted by IP
- Principle of least privilege inside containers
- Secrets managed via environment variables (not committed)

---

## CI/CD Strategy

- GitHub Actions
- Build and version containers
- Push images to a registry
- Pull and deploy containers on the VM

Deployment is:
- Deterministic
- Repeatable
- Script-driven

---

## Environments

Logical environments (not separate Azure subscriptions):
- `dev`
- `staging`
- `production`

Environment differences are driven by:
- Docker Compose overrides
- Environment variables
- Configuration files

---

## Repository Structure

```text
.
├── docs/            # Architecture notes, decisions, diagrams
├── infra/           # VM provisioning and OS configuration
├── wordpress/       # Dockerfiles and WordPress config
├── mysql/           # MySQL container configuration
├── ci/              # GitHub Actions workflows
├── docker-compose.yml
└── README.md
```

---

## Backups & Recovery

- Scheduled MySQL dumps
- Filesystem-level backups of mounted disk
- Restore process does not depend on Azure-specific services
