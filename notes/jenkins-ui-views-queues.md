# Jenkins UI Deep Dive: Views, Queues, and Agents

## 1. Jenkins UI Overview

| Section | Description |
| ------- | ----------- |
|         |             |

| **Dashboard**       | Main screen listing jobs or folders           |
| ------------------- | --------------------------------------------- |
| **Job Views**       | Tabs or filtered lists for organizing jobs    |
| **Build Queue**     | Pending jobs waiting for executors            |
| **Executor Status** | Shows agents/nodes and their active jobs      |
| **Job Page**        | Individual job details: config, history, logs |
| **Manage Jenkins**  | Admin controls, plugins, credentials          |
| **New Item**        | Create jobs: freestyle, pipeline, multibranch |

---

## 2. Job Views

### Purpose:

Group and visualize related jobs.

### Types:

- **All**: Default, shows all jobs
- **List View**: Filtered view with regex, labels, status
- **My View**: Per-user custom views
- **Nested View**: Folder-based hierarchical views
- **Build Monitor View** (plugin): TV dashboard style

### Real Usage Examples:

- `Backend Services`
- `Frontend Builds`
- `Staging Deployments`

---

## 3. Build Queue

### What is it?

Temporary holding area for jobs that are:

- Waiting for a matching agent
- Blocked by resource limits

### Flow:

1. Job is triggered
2. Jenkins searches for a matching agent with a free executor
3. If none found → job enters the build queue

### Common Causes of Queues:

- No agent is online or available
- Executor count on agents is fully utilized
- Job requires a specific label (e.g., `build-go`) but no matching agent is ready

---

## 4. Executors and Agents

### Executor:

An executor is a single thread on a Jenkins node that runs one job at a time.

### Agent (Node):

Machines (physical or virtual) where builds run.

### Types of Agents:

- **Controller (Master)**: Jenkins core, avoid running jobs here
- **Static Agents**: Always-on, manually provisioned
- **Dynamic Agents**: Spawned on-demand (e.g., K8s pods, Docker containers)

### Agent Configuration:

- **Executors**: Number of concurrent jobs per agent
- **Labels**: Tags to match jobs to specific agents

---

## 5. Real-World Flow Example

### Scenario:

Jenkins is running on Kubernetes. You have jobs with labels like `build-go`, `deploy-ui`.

### Flow:

- Job `go-build` triggers → looks for agent with label `build-go`
- Kubernetes plugin spins up a new pod agent with that label
- Job runs and pod shuts down after job completes
- If no pod is available or provisioning fails → job stays in build queue

---

## 6. Visual Representation

| Job Name        | Agent Label | Status           |
| --------------- | ----------- | ---------------- |
| backend-lint    | build-go    | ✅ Running        |
| frontend-deploy | build-ui    | ⏳ In queue       |
| infra-terraform | infra       | ❌ No agent found |

---

## 7. Observability & Monitoring (SRE Focus)

- Use **Queue Monitoring Plugin** to watch job queue times
- Export metrics via **Prometheus Plugin**
- Visualize agent/job status with **Grafana Dashboards**
- Alert if jobs are stuck or queue grows beyond threshold

---

## 8. GitHub Repo Structure Tip

```
CICD-MASTERY/
├── pipeline/
│   ├── job1.groovy
│   └── job2.groovy
├── agents/
│   ├── docker-agent.yaml
│   └── k8s-agent.yaml
├── notes/
│   └── jenkins-ui-views-queues.md  ✅
└── README.md
```

---

## 9. Cheatsheet Summary

| Concept           | Summary                                |
| ----------------- | -------------------------------------- |
| **View**          | Group jobs visually                    |
| **Queue**         | Jobs waiting for executors             |
| **Executor**      | Execution thread on agent              |
| **Agent**         | Runs the job, matched by label         |
| **Dynamic Agent** | Provisioned at runtime (e.g., k8s pod) |
| **Monitoring**    | Prometheus, plugins, Grafana           |

---

For any issue with views, queues, or agents, always check:

- Jenkins logs
- Node connection status
- Agent labels and job label matching
- Executor counts and idle times

